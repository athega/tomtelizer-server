require 'lib/image_util'

class FaceFeaturesController < ApplicationController

  def show
    @feature = FaceFeature.find_by_id(params[:id])

    #TODO: better test than this...
    return if @feature.nil? || @feature.hat_box_top_right_x.nil?

    @div_width = @feature.hat_box_top_right_x - @feature.hat_box_top_left_x
    @div_height = @feature.hat_box_bottom_left_y - @feature.hat_box_top_left_y
    @div_x = @feature.hat_box_top_left_x
    @div_y = @feature.image.height - @feature.hat_box_bottom_left_y 
  end

  def destroy
    if request.delete?
      @feature = FaceFeature.find_by_id(params[:id])
    
      img = @feature.image

      raise "no image" if img.nil?

      #to avoid cache in browser for 
      new_img_name = ImageUtil.generate_timestamp_image_name
      
      target_path = File.join(ImagesController::IMAGE_FILE_REPO, new_img_name)
      old_file_path = File.join(ImagesController::IMAGE_FILE_REPO, img.filename)
      
      old_thumb_path = File.join(ImagesController::IMAGE_FILE_REPO, "thumb-" + img.filename)
      old_hatified_path = File.join(ImagesController::IMAGE_FILE_REPO, "hatified-" + img.filename)

      logger.info "movind file #{old_file_path} to #{target_path}"
      FileUtils.mv(old_file_path, target_path)
      
      if (File.exist?(old_thumb_path)) 
          logger.info "removing old thumb file #{old_thumb_path}"
          FileUtils.rm(old_thumb_path)
      end
      if (File.exist?(old_hatified_path)) 
          logger.info "removing old hatified file #{old_hatified_path}"
          FileUtils.rm(old_hatified_path)
      end
      
      img.update_attributes(:filename => new_img_name)
      #end cache fix

      @feature.destroy

      Delayed::Job.enqueue ProcessImageJob.new(img.to_param, true), 0, 1.seconds.from_now 
      
      redirect_to :controller => :images, :action => :show
    end
  end

end
