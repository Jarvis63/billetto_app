class AddExternalIdToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :external_id, :string
    add_index :events, :external_id, unique: true
  end
end
