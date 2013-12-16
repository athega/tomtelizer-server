# encoding: UTF-8

require 'RMagick'
require 'hat_calculator'
require 'digest/md5'

class ImageUtil

  include Magick

  HAT_SCALE_FACTOR = 0.65

  #should not use persisted object as dto param...
  def add_hat(image, add_hats, rotate = false)
    return if image.nil?

    basename = image.filename
    target_path = File.join(ImageUtil.repo, image.filename)
    puts "target_path: #{target_path}"
    orientation = image.orientation

    img = Magick::ImageList.new(target_path)
    width = img[0].columns
    height = img[0].rows


    if image.face_features.size > 0 && add_hats


      puts "image has features.."
      image.face_features.each do |feature|

        next unless feature_is_valid?(feature)

        hat_position = HatCalculator.calculate_position(feature)
        puts "---"
        puts hat_position.inspect
        unless(hat_position.nil?)


          #add HAT!
          hat_file = ['lucia-hat.png', 'santa-hat.png', 'star-hat.png'].sample
          hat  = Image.read(File.join(Rails.root, 'public','images', hat_file))[0]

          hat.background_color = 'none'

          angle = -1 * hat_position[:angle]
          puts  "angle: #{angle}"

          hat.resize_to_fit!(hat_position[:len] + hat_position[:len] * HAT_SCALE_FACTOR)

          pre_rot_width = hat.columns
          hat.rotate!(angle)
          width_rotation_correction = (hat.columns-pre_rot_width)/2

          inner_image = img[0]

          center_x = hat_position[:left][:x] + (hat_position[:right][:x] - hat_position[:left][:x])/2
          center_y = hat_position[:left][:y] + (hat_position[:right][:y] - hat_position[:left][:y])/2

          coords = { :hat_box_top_left_x => center_x - hat.columns/2,
                     :hat_box_top_left_y => center_y - hat.rows/2,
                     :hat_box_top_right_x => center_x + hat.columns/2,
                     :hat_box_top_right_y => center_y - hat.rows/2,
                     :hat_box_bottom_left_x => center_x - hat.columns/2,
                     :hat_box_bottom_left_y => center_y + hat.rows/2,
                     :hat_box_bottom_right_x => center_x + hat.columns/2,
                     :hat_box_bottom_right_y => center_y + hat.rows/2 }

          feature.update_attributes(coords)

          inner_image.composite!(hat, ForgetGravity,
                                 center_x - hat.columns/2,
                                 height - center_y - hat.rows/2,
                                 OverCompositeOp)
        end
      end
    end

    # if image is posted from checkin app
    # we must rotate it
    if rotate
      img.rotate!(90)

      original = Magick::ImageList.new(target_path)
      original.rotate!(90)
      original.write(File.join(target_path))
    end

    #we must have a 'hatified' image even though we dont have any feature data..
    img.write(File.join(ImageUtil.repo, "hatified-#{basename}"))

    hatified_digest = Digest::MD5.hexdigest(img.to_blob)
    hatified_size = img.to_blob.size

    #UPDATE image data:
    image.update_attributes(:width => width, :height => height,
                            :hatified_file_checksum => hatified_digest,
                            :hatified_file_size => hatified_size)

    rez = img.resize_to_fit(200, 149)

    File.open( File.join(ImageUtil.repo, "thumb-#{basename}"), 'wb') do |f|
      f.write(rez.to_blob)
    end

  end

  def self.generate_timestamp_image_name
    timestamp = Time.now.to_f.to_s.gsub('.','-')
    img_name = timestamp << ".jpg"
    img_name
  end

  protected

  def feature_is_valid?(feature)
    return false if feature.left_eye_x.nil?
    return false if feature.left_eye_y.nil?
    return false if feature.right_eye_x.nil?
    return false if feature.right_eye_y.nil?
    return false if feature.mouth_x.nil?
    return false if feature.mouth_y.nil?
    true
  end

  def draw_triangle(img, height, feature)
    return unless AppConfig::WRITE_FACE_FEATURE_LINES

    puts "drawing feature triangle"
    tri = Magick::Draw.new
    tri.stroke('white').stroke_width(2)
    tri.fill('none')
    tri.polygon(feature.left_eye_x, height - feature.left_eye_y,
                feature.right_eye_x, height - feature.right_eye_y,
                feature.mouth_x, height - feature.mouth_y)
    tri.draw(img)
  end

  def draw_rim(img, height, hat_position)
    return unless AppConfig::WRITE_FACE_FEATURE_LINES

    rim = Magick::Draw.new
    rim.stroke('white').stroke_width(4)
    rim.fill('none')
    rim.line(hat_position[:left][:x].to_i , height - hat_position[:left][:y].to_i,
             hat_position[:right][:x].to_i, height - hat_position[:right][:y].to_i)
    rim.draw(img)
  end

  def draw_hat_frame(hat)
    return unless AppConfig::WRITE_FACE_FEATURE_LINES

    tmp_border = Magick::Draw.new
    tmp_border.stroke('white').stroke_width(4)
    tmp_border.fill('none')
    tmp_border.polygon(0,0, hat.columns, 0, hat.columns, hat.rows, 0, hat.rows, 0, 0)
    tmp_border.draw(hat)
  end

  def self.repo
    File.join(Rails.root, "public", "uploaded_images")
  end
end
