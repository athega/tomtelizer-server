class AddHatCoordsToFaceFeature < ActiveRecord::Migration
  def change
    change_table :face_features do |t|
      t.integer :hat_box_top_left_x
      t.integer :hat_box_top_left_y
      t.integer :hat_box_top_right_x
      t.integer :hat_box_top_right_y
      t.integer :hat_box_bottom_left_x
      t.integer :hat_box_bottom_left_y
      t.integer :hat_box_bottom_right_x
      t.integer :hat_box_bottom_right_y
    end
  end
end
