require 'image_util'

class ProcessImageJob < Struct.new(:image_id, :add_hats)

  def perform
    util = ImageUtil.new
    image = Image.find_by_id(image_id)
    util.add_hat(image, add_hats)
  end

end
