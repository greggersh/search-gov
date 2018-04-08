class AddSearchgovDomainToSearchgovUrls < ActiveRecord::Migration
  def change
    #FIXME: after migration and update, set this column to null: false
    add_reference :searchgov_urls, :searchgov_domain, index: true, foreign_key: true
  end
end
