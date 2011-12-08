require 'test_helper'
require 'flexmock/test_unit'

class ImagesControllerTest < ActionController::TestCase
  test "should get new" do
    delayed_job = flexmock(Delayed::Job)
    
    file = fixture_file_upload('files/testfile.jpg', 'image/jpeg')
    class << file
      #http://stackoverflow.com/questions/7793510/mocking-file-uploads-in-rails-3-1-controller-tests
      attr_reader :tempfile
    end
    
    delayed_job.should_receive(:enqueue).once

    assert_difference('Image.count', 1) do
      assert_difference('FaceFeature.count', 2) do
       
        #/images/new
        #post data format: features[][left_eye_x]=123 etc
        post :new, :uploaded => file, :features => [{ :left_eye_x => 12,
                                                     :left_eye_y => 13,
                                                     :right_eye_x => 14,
                                                     :right_eye_y => 15,
                                                     :mouth_x => 20,
                                                     :mouth_y => 30 },
                                                   { :left_eye_x => 12,
                                                     :left_eye_y => 13,
                                                     :right_eye_x => 14,
                                                     :right_eye_y => 15,
                                                     :mouth_x => 20,
                                                     :mouth_y => 30} ]

      
      end
    end
    
    assert_response :success
  
  end

end
