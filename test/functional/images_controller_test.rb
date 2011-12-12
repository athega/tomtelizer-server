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

  test "latest" do

    mocked_glob_dir_list = [
      File.join(ImagesController::IMAGE_FILE_REPO, "thumb-#{images(:one).filename}"), 
      File.join(ImagesController::IMAGE_FILE_REPO, "thumb-#{images(:two).filename}")]

    dir_mock = flexmock(Dir)
    dir_mock.should_receive(:glob).once.and_return(mocked_glob_dir_list)

    get :latest 
    assert_response :success
    assert_select 'images' do |i|
      assert_select "image", 2
    end
    
  end


end





