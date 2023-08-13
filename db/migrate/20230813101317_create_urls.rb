class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.string :base_uri
      t.string :uri
      t.string :page_type
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
