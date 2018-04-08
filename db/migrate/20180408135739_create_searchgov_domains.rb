class CreateSearchgovDomains < ActiveRecord::Migration
  def change
    create_table :searchgov_domains do |t|
      t.string :domain, null: false
      t.boolean :clean_urls, null: false, default: true
      t.integer :status, null: false

      t.timestamps null: false
    end

   # add_index :searchgov_domains, :domain, :unique => true
    # Mysql2::Error: Index column size too large. The maximum column size is 767 bytes
    add_index :searchgov_domains, :domain, length: 100#, :unique => true
  end
end
