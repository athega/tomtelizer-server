class AddWidthHeightAttrToImage < ActiveRecord::Migration
  def change
    change_table :images do |t|
      t.integer :width
      t.integer :height
    end
  end
end
