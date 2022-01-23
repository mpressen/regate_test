class Pokemon < ApplicationRecord
  has_and_belongs_to_many :types, class_name: 'PokemonType'
end
