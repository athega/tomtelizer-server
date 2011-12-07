require 'test_helper'
require 'flexmock/test_unit'

class FaceFeaturesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, :id => face_features(:one)
    assert_response :success
  end

  test "should destroy" do
    image_util = flexmock(ImageUtil)
    image_util.should_receive(:generate_timestamp_image_name).and_return("new-image-name.jpg").once

    file_utils = flexmock(FileUtils)
    file_utils.should_receive(:mv).once.with(File.join(ImagesController::IMAGE_FILE_REPO, "testfile.jpg"),
                                             File.join(ImagesController::IMAGE_FILE_REPO, "new-image-name.jpg"))

    delayed_job = flexmock(Delayed::Job)

    delayed_job.should_receive(:enqueue).once

    delete :destroy, :id => face_features(:one)
    assert_redirected_to :controller => :images , :action => :show

    assert_equal "new-image-name.jpg", images(:one).filename

  end

end
