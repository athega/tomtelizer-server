class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :filename
      t.integer :left_eye_x
      t.integer :left_eye_y
      t.integer :right_eye_x
      t.integer :right_eye_y
      t.integer :mouth_x
      t.integer :mouth_y
      t.integer :orientation
      
      t.timestamps
    end
  end
end
