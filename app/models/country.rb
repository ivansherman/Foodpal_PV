class Country < ActiveRecord::Base
  has_many :states
  attr_accessible :calling_code, :cctld, :iso2, :iso3, :long_name, :num_code, :short_name, :un_member
end
