class CreateGrams < ActiveRecord::Migration
  def change
    create_table :grams do |t|
      t.text :caption

      t.timestamps
    end
  end
end
