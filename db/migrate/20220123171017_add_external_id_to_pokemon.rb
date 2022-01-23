class AddExternalIdToPokemon < ActiveRecord::Migration[6.1]
  def change
    add_column :pokemons, :external_id, :integer
  end
end
