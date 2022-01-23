class AddExternalIdToPokemonType < ActiveRecord::Migration[6.1]
  def change
    add_column :pokemon_types, :external_id, :integer
  end
end
