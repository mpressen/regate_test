class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.integer :height
      t.integer :weight
      t.integer :order
      t.integer :base_experience
      t.boolean :is_default

      t.timestamps
    end
  end
end
