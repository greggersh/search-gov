class SearchgovDomain < ActiveRecord::Base
  #readonly
  #validate domain format
  has_many :searchgov_urls, dependent: :destroy
end
