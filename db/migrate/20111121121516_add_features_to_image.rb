class AddFeaturesToImage < ActiveRecord::Migration
  def change
    change_table :images do |t|
      
      t.remove :left_eye_x
      t.remove :left_eye_y
      t.remove :right_eye_x
      t.remove :right_eye_y
      t.remove :mouth_x
      t.remove :mouth_y

    end
  end
end
