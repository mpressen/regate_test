class AddUnionTableBetweenPokemonAndType < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemon_types_pokemons, id: false do |t|
      t.belongs_to :pokemon
      t.belongs_to :pokemon_type
    end
  end
end
