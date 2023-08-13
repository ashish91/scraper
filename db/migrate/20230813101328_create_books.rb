class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :product_type
      t.string :price_excluding_tax
      t.string :price_including_tax
      t.string :tax
      t.string :availability
      t.string :number_of_reviews
      t.string :url

      t.timestamps
    end
  end
end
