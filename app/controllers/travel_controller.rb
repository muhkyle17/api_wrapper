class TravelController < ApplicationController

  def index
  end

  def search
    countries = find_country(params[:country])

    unless countries
      flash[:alert] = 'Country not found'
      return render action: :index
    end

    @country = countries.first
    @weather = find_weather(@country['capital'], @country['alpha2Code'])
  end

  def find_weather(city, country_code)
    query = URI.encode("#{city},#{country_code}")

    request_api(
      "https://community.open-weather-map.p.rapidapi.com/forecast?q=#{query}"
    )
  end

  private

  def request_api(url)
    response = Excon.get(
      url,
      headers: {
        'X-RapidAPI-Host' => URI.parse(url).host,
        'X-RapidAPI-Key' => "fab65d0ee0msh8d322a9ca130304p1c1c5ajsn3aaabc3ea1b0"
      }
    )

    return nil if response.status != 200

    JSON.parse(response.body)
  end

  def find_country(name)
    request_api(
      "https://restcountries-v1.p.rapidapi.com/name/#{URI.encode_www_form(["search", "name"])}"
    )
  end

end
