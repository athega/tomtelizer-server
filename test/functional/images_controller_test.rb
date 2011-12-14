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

=begin
  test "latest" do
  
    i = Image.new(:filename => "asdasd.jpg", 
                  :hatified_file_checksum => "checksum123")

    image_mock = flexmock(Image)

    expected_find_args = []
    image_mock.should_receive(:find).once.
      
      with(:all, :order => "created_at desc",
           :conditions => "hatified_file_checksum IS NOT NULL",
           :limit => 100).
      
      and_return([i])

    get :latest 
    assert_response :success
    assert_select 'images' do |i|
      assert_select "image", 1
    end
    assert @response.body.include?("asdasd.jpg")
    assert @response.body.include?("checksum123")
  end
=end

  test "latest" do
    Image.delete_all

    (0..9).each do |i|
      t = FactoryGirl.build(:image)
      t.hatified_file_checksum = nil if i%2==0
      t.save!
    end

    assert_equal 10, Image.count, "expected 10 images in db"

    get :latest 
    assert_response :success
    assert_select 'images' do |i|
      assert_select "image", 5, "expected to receive only elements with checksums"
    end

    assert @response.body.include?("checksum2")
    assert @response.body.include?("checksum4")
    assert @response.body.include?("checksum6")
    assert @response.body.include?("checksum8")
    assert @response.body.include?("checksum10")

  end


end





