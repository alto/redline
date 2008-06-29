class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :user_id
      t.integer :parent_id
      t.integer :size, :width, :height
      t.string :content_type, :filename, :thumbnail
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
