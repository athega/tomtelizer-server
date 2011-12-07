class HatCalculator

  def self.calculate_position(features)
    Rails.logger.info "calculating hat position" 
    begin
      puts features.inspect

      ml_angle = Math.atan2(features[:left_eye_y] - features[:mouth_y], 
                            features[:left_eye_x] - features[:mouth_x]) * 180 / Math::PI

      
      mr_angle = Math.atan2(features[:right_eye_y] - features[:mouth_y], 
                            features[:right_eye_x] - features[:mouth_x]) * 180 / Math::PI

      
      l_len = get_hypothenuse(features[:left_eye_y] - features[:mouth_y], 
                              features[:left_eye_x] - features[:mouth_x])
      
      r_len = get_hypothenuse(features[:right_eye_y] - features[:mouth_y],
                              features[:right_eye_x] - features[:mouth_x])
     
      left = get_point(ml_angle, l_len, features[:left_eye_x], features[:left_eye_y])
      right = get_point(mr_angle, r_len, features[:right_eye_x], features[:right_eye_y])

      hat_angle = Math.atan2(right[:y]-left[:y], right[:x] - left[:x]) * 180 / Math::PI
      hat_len = get_hypothenuse(right[:y]-left[:y], right[:x] - left[:x])
      
      { :left => left , :right => right, :angle => hat_angle, :len => hat_len}

    rescue Exception => e
      #we're failing silently for now- maybe not so good
      Rails.logger.fatal e
      e.backtrace.each {|x| Rails.logger.fatal x}
      {}
    end
  end

  private 

  def self.get_hypothenuse(ylen,xlen)
    Math.sqrt(ylen**2 + xlen**2)
  end

  def self.get_point(angle, distance, start_x, start_y)
    radians = angle * Math::PI / 180
    x = start_x + distance * Math.cos(radians);
    y = start_y + distance * Math.sin(radians);
    {:x => x, :y => y}
  end 

end
