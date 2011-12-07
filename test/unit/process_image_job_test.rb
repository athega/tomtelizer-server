require 'test_helper'
require 'flexmock/test_unit'

class ProcessImageJobTest < ActiveSupport::TestCase
 
  TEST_REPO = File.join(Rails.root, "tmp")

  test "process" do
    img = images(:one)
    
    flexmock(ImageUtil).should_receive(:repo).and_return(TEST_REPO)
    
    job = ProcessImageJob.new(img.to_param, true)




    job.perform

    assert(File.exists?(@result_file))
  end

  def setup
    @result_file = File.join(TEST_REPO,"thumb-testfile.jpg")
    @target_file = File.join(TEST_REPO, "testfile.jpg")
    if (!File.exists?(@target_file))
      FileUtils.cp(File.join(Rails.root,"test","fixtures","files","testfile.jpg"),
                   @target_file)
    end

    remove_result_file
  end

  def remove_result_file
    if (File.exists?(@result_file))
      FileUtils.rm @result_file 
    end
  end
  
  def teardown
    remove_result_file
  end



end
