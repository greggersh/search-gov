require 'rexml/document'

namespace :usasearch do
  namespace :faq do

    desc "Load an XML file of FAQs into the database"
    task :load, :faq_file_name, :locale, :needs => :environment do |t, args|
      if !args.faq_file_name
        RAILS_DEFAULT_LOGGER.error("usage: rake usasearch:faq:load[ faq_file_name ]")
      else
        locale = args.locale.present? ? args.locale : I18n.default_locale.to_s
        doc = REXML::Document.new(File.new(args.faq_file_name))
        Faq.delete_all(['locale=?', locale])
        counter = 0
        doc.root.elements.each('Row') do |row|
          if counter > 0
            items = row.elements.to_a('Item')
            Faq.create(:url => items[0].text,
                       :question => items[1].text.gsub(/<\/?[^>]*>/, ""),
                       :answer => items[2].text,
                       :ranking => items[3].text.to_i,
                       :locale => locale)
          end
          counter += 1
        end
        Faq.reindex
      end
    end
    
    desc "Delete all existing FAQs in the database"
    task :clean, :needs => :environment do |t, args|
      Faq.delete_all
    end  
  end
end
