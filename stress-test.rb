#
# $> rails runner stress-test.rb
#
require 'rest_client'

image_file = File.join(File.dirname(__FILE__),'test','fixtures','files','testfile.jpg')

puts File.exists?(image_file)

(0..1000).each do |i|

  RestClient.post('http://localhost:3000/images/new', 
                  "features[]" =>  [{:right_eye_x => 248, :mouth_x => 185,
                                  :right_eye_y => 252, :mouth_y => 138, 
                                  :left_eye_x => 132, :left_eye_y =>  247}],
                  :orientation => 6, :processFeatures => true, 
                  :uploaded => File.new(image_file) )

end 

