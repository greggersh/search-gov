class SearchgovDomain < ActiveRecord::Base
  #readonly
  #validate domain format
  validates_format_of :domain, with: /$(\A\z)|(\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?)?\z)/ix
  has_many :searchgov_urls, dependent: :destroy

  attr_readonly :domain
end
