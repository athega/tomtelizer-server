require 'test_helper'
require 'flexmock/test_unit'
require 'hat_calculator'

class HatCalculatorTest < ActiveSupport::TestCase

  def test_calculate_position

    feature = {:right_eye_x=>216, :mouth_x=>187, :right_eye_y=>254, 
              :mouth_y=>189, :left_eye_x=>161, :left_eye_y=>260}

    res = HatCalculator.calculate_position(feature)   

    puts res.inspect

    assert_not_nil res
    
    assert_not_nil res[:left]
    assert_not_nil res[:right]
    
    assert_equal 245, res[:right][:x].to_i
    assert_equal 319, res[:right][:y].to_i
    
    assert_equal 135, res[:left][:x].to_i
    assert_equal 331, res[:left][:y].to_i

    assert_equal 110, res[:len].to_i
    assert_equal -6,  res[:angle].to_i
  end

  def test_calculate_position_empty_input
    res = HatCalculator.calculate_position(nil)   
    assert_equal({}, res)
  end

end
