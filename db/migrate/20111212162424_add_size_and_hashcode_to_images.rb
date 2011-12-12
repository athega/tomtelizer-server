class AddSizeAndHashcodeToImages < ActiveRecord::Migration
  def change
    change_table :images do |t|
      t.integer :hatified_file_size
      t.string  :hatified_file_checksum
    end
  end
end
