class PokemonsController < ApplicationController
  def index
  end

  def search
    pokemon = Pokemon.find_by(name: params[:name])

    unless pokemon
      response = PokeApi.get(pokemon: ERB::Util.url_encode(params[:name]))
      pokemon = Pokemon.create(name: response.name, number: response.id)
    end

    flash[:notice] = "#{pokemon.name}'s number is #{pokemon.number}"

    redirect_to root_path

  rescue JSON::ParserError
    flash[:error] = "No pokemon found"

    redirect_to root_path
  end
end
