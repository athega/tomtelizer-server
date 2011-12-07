class CreateFaceFeatures < ActiveRecord::Migration
  def change
    create_table :face_features do |t|

      t.integer :left_eye_x
      t.integer :left_eye_y
      t.integer :right_eye_x
      t.integer :right_eye_y
      t.integer :mouth_x
      t.integer :mouth_y
      
      t.references :image 
        
      t.timestamps
    end
  end
end
