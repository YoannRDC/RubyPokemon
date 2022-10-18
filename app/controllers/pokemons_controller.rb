require 'open-uri'
require "#{Rails.root}/lib/poke.rb"

class PokemonsController < ApplicationController

    def index
    
        #get the pokemons from the web
        pm_array = []
        desc_array = []
        image_array = []
        @pokemons = []

        for pokemonIndex in 35..35
            # get data (including species, sprites, and base stats) about each of the first 151 pokemon
            data = URI.open("https://pokeapi.co/api/v2/pokemon/#{pokemonIndex}").read
            json_data = JSON.parse(data)

            #pm_array.push(json_data)
            #desc = open("https://pokeapi.co/api/v2/pokemon-species/#{i}").read
            #json_desc = JSON.parse(desc)
            #desc_array.push(json_desc)

            unless File.file?("#{Rails.root}/app/assets/images/pokemons/" + pokemonIndex.to_s + "_front.svg")
                URI.open("#{Rails.root}/app/assets/images/pokemons/" + pokemonIndex.to_s + "_front.svg", 'wb') do |file|
                    file << URI.open("https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/" + pokemonIndex.to_s + ".svg").read
                end
            end
            imageFrontPath = "#{Rails.root}/app/assets/images/pokemons/" + pokemonIndex.to_s + '_front.svg'

            unless File.file?("#{Rails.root}/app/assets/images/pokemons/" + pokemonIndex.to_s + "_back.png")
                URI.open("#{Rails.root}/app/assets/images/pokemons/" + pokemonIndex.to_s + "_back.png", 'wb') do |file|
                    file << URI.open("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/" + pokemonIndex.to_s + ".png").read
                end
            end
            imageBackPath = "#{Rails.root}/app/assets/images/pokemons/" + pokemonIndex.to_s + '_back.png'
            
            #temp 
            newPoke = Pokemon.find_by_id(pokemonIndex).try(:destroy)


            puts "imageFrontPath: " + imageFrontPath
            puts "imageBackPath: " + imageBackPath

            puts "line1: " + json_data["stats"][1].to_s
            puts "line2: " + json_data["stats"][1]["base_stat"].to_s
            puts "line3: " + json_data["stats"][1]["stat"].to_s
            puts "line4: " + json_data["stats"][1]["stat"]["name"].to_s



            for statIndex in json_data["stats"]
                puts "stat l1: " + statIndex["base_stat"].to_s
                puts "stat l2: " + statIndex["stat"]["name"].to_s

                statIndex["stat"]["name"] == "hp" ? hpValue = statIndex["base_stat"] : ""
                statIndex["stat"]["name"] == "attack" ? attack = statIndex["base_stat"] : ""
                statIndex["stat"]["name"] == "defense" ? defense = statIndex["base_stat"] : ""
                statIndex["stat"]["name"] == "special-attack" ? specialAttack = statIndex["base_stat"] : ""
                statIndex["stat"]["name"] == "special-defense" ? specialDefense = statIndex["base_stat"] : ""
                statIndex["stat"]["name"] == "speed" ? speed = statIndex["base_stat"] : ""

                puts "hpValue: " + hpValue.to_s
                #puts "stat.: " + json_data["stats"][statIndex]["base_stat"].to_s
            end 


            poke = Pokemon.where(
                id:pokemonIndex, 
                name:json_data["name"], 
                image_front:imageFrontPath, 
                image_back:imageBackPath, 
                height:json_data["height"], 
                weight:json_data["weight"],
                attack:json_data["attack"],
                hit_point:hpValue,
                attack:attack,
                defense:defense,
                special_attack:specialAttack,
                special_defense:specialDefense,
                speed:speed
            ).first_or_create

            puts "poke.id: " + poke.id.to_s
            puts "poke.name: " + poke.name.to_s
            puts "poke.image: " + poke.image_front.to_s
            puts "poke.image: " + poke.image_back.to_s
            
            @pokemons.push(poke) 

        end
    end

    def show
        @pokemon = Pokemon.find(params[:id])
    end

end
