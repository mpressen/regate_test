module PokemonApi
  module_function

  BASE_URL = 'https://pokeapi.co/api/v2/'

  DICTIONNARY = {
    'Pokemon' => 'pokemon',
    'PokemonType' => 'type'
  }

  UNREACHABLE_LIMIT = 10000000000

  def get(url)
    # https://lostisland.github.io/faraday/middleware/raise-error
    response = Faraday.new(url) { |c| c.use Faraday::Response::RaiseError }.get

    JSON.parse(response.body, symbolize_names: true)
  end

  def get_all(resource)
    url = "#{BASE_URL}#{DICTIONNARY.fetch(resource)}/?limit=#{UNREACHABLE_LIMIT}"
    response = get(url)

    if response[:next]
      # should never happen
      raise UnreachableLimitReached, "resource: #{resource}"
    end

    response[:results]
  end

  private

  class UnreachableLimitReached < StandardError; end
end
