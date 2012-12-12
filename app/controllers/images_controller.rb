require 'RMagick'

class ImagesController < ApplicationController

  protect_from_forgery :except => :new

  IMAGE_FILE_REPO = File.join(Rails.root, "public", "uploaded_images")

  def new
    unless request.post?
      logger.info "unsupported method."
      return
    end

    logger.info("got data:")
    puts params["uploaded"].inspect

    logger.info(params.inspect)
    if(params["uploaded"] && params["uploaded"].tempfile)
      f = params["uploaded"].tempfile

      add_hats = true
      if params["processFeatures"] && params["processFeatures"]=="false"
        add_hats = false
      end

      timestamp = Time.now.to_f.to_s.gsub('.','-')
      img_name = timestamp << ".jpg"

      target_path = File.join(IMAGE_FILE_REPO, img_name)
      logger.info "copying file #{f.path} to #{target_path}"
      FileUtils.cp(f.path, target_path)


      features = params["features"]
      if features.nil?
        features = []
      end
      puts features.inspect

      img = Image.create(:filename => img_name, 
                         :face_features_attributes => features, 
                         :orientation => params['orientation'])

      Delayed::Job.enqueue ProcessImageJob.new(img.to_param, add_hats)
    end
  end

  def show
  end

  def update_images
    all =  Dir.glob(File.join(IMAGE_FILE_REPO, "thumb-*.jpg")).sort.reverse
    @images = all.map do |x|
      img = File.basename(x)
      { :thumb => "/uploaded_images/" + img,
        :target => "/uploaded_images/hatified-" + img.gsub("thumb-","")}
    end

    if Delayed::Job.count > 0
      @images.insert 0, {:thumb => '/assets/working.gif' , :target => ""}
    end

    render :layout => false
  end

  def latest
    images = Image.find(:all, :order => "created_at asc", 
                        :conditions => "hatified_file_checksum IS NOT NULL", 
                        :limit => 100);
    #generated_files = Dir.glob(File.join(IMAGE_FILE_REPO, "thumb-*"))

    filtered = images.clone
    
    render :xml => filtered.to_xml, :layout => false
  end

  #FIXME: use image id now instead
  def metadata
    path = params['path']
    return if path.empty?
    path = path.gsub("hatified-", "")
    metadata = Image.find_by_filename(File.basename(path))
    render :json => metadata.to_json(:include => :face_features)
  end

end
