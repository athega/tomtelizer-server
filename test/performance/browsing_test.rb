require 'test_helper'
require 'rails/performance_test_help'

class BrowsingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  def test_homepage
    get '/'
  end



  
  def test_post_image
    file = fixture_file_upload('files/testfile.jpg', 'image/jpeg')
    class << file
      #http://stackoverflow.com/questions/7793510/mocking-file-uploads-in-rails-3-1-controller-tests
      attr_reader :tempfile
    end
    
    post :new, :uploaded => file, :features => [ {:right_eye_x => 248, 
                                                  :mouth_x => 185,
                                                  :right_eye_y => 252,
                                                  :mouth_y => 138, 
                                                  :left_eye_x => 132, 
                                                  :left_eye_y =>  247 } ]
    
    assert_response :success
  
  end


end





