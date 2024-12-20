class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :date
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
