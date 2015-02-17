class CitiesController < ApplicationController
def index
  GeoNamesAPI.username = "windwdm@gmail.com"
  GeoNamesAPI.lang = :en

  t = GeoNamesAPI::Country.find("US")
  puts t.inspect.red

  render json: t.postal_code_export
end

end