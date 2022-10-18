class CreatePokemons < ActiveRecord::Migration[7.0]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :image_front
      t.string :image_back
      t.integer :hit_point
      t.integer :attack
      t.integer :defense
      t.integer :special_attack
      t.integer :special_defense
      t.integer :speed
      t.integer :height
      t.integer :weight

      t.timestamps
    end
  end
end
