require 'test_helper'
require 'flexmock/test_unit'


class ImageUtilTest < ActiveSupport::TestCase

  TEST_REPO = File.join(Rails.root, "tmp")
  
  def setup
    @result_file1 = File.join(TEST_REPO,"thumb-testfile.jpg")
    @result_file2 = File.join(TEST_REPO,"hatified-testfile.jpg")
    @target_file = File.join(TEST_REPO, "testfile.jpg")
    if (!File.exists?(@target_file))
      FileUtils.cp(File.join(Rails.root,"test","fixtures","files","testfile.jpg"),
                   @target_file)
    end

    remove_result_files
  end

  def remove_result_files
    if (File.exists?(@result_file1))
      FileUtils.rm @result_file1 
    end
    if (File.exists?(@result_file2))
      FileUtils.rm @result_file2 
    end
  end
  
  def teardown
    remove_result_files
  end
  
  def test_add_hat_return_silenty_if_image_nil
      u = ImageUtil.new
      assert_not_nil u
      u.add_hat(nil, true)
  end

  def test_add_hat
    flexmock(ImageUtil).should_receive(:repo).and_return(TEST_REPO)
    
    image = images(:one)
    assert image
    assert image.face_features.size > 0
    assert_nil image.face_features[0].hat_box_top_left_x
    assert_nil image.face_features[0].hat_box_top_left_y
    assert_nil image.face_features[0].hat_box_top_right_x
    assert_nil image.face_features[0].hat_box_top_right_y
    assert_nil image.face_features[0].hat_box_bottom_left_x
    assert_nil image.face_features[0].hat_box_bottom_left_y
    assert_nil image.face_features[0].hat_box_bottom_right_x
    assert_nil image.face_features[0].hat_box_bottom_right_y

    u = ImageUtil.new
    u.add_hat(image, true)
    
    image.face_features.reload

    assert_not_nil image.face_features[0].hat_box_top_left_x
    assert_not_nil image.face_features[0].hat_box_top_left_y
    assert_not_nil image.face_features[0].hat_box_top_right_x
    assert_not_nil image.face_features[0].hat_box_top_right_y
    assert_not_nil image.face_features[0].hat_box_bottom_left_x
    assert_not_nil image.face_features[0].hat_box_bottom_left_y
    assert_not_nil image.face_features[0].hat_box_bottom_right_x
    assert_not_nil image.face_features[0].hat_box_bottom_right_y

    assert File.exists?(@result_file1)
    assert File.exists?(@result_file2)
  end

  def test_add_hat_with_corrupt_data
    flexmock(ImageUtil).should_receive(:repo).and_return(TEST_REPO)
    
    image = images(:one)
    assert image
    assert image.face_features.size > 0

    feature = image.face_features[0]
    feature.mouth_x = nil
    feature.save!

    puts feature.inspect
    
    u = ImageUtil.new
    u.add_hat(image, true)
    
    image.face_features.reload
  end

end
