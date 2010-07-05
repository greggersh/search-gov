namespace :usasearch do
  namespace :reports do
    
    def establish_aws_connection
      AWS::S3::Base.establish_connection!(:access_key_id => AWS_ACCESS_KEY_ID, :secret_access_key => AWS_SECRET_ACCESS_KEY)
      AWS::S3::Bucket.find('usasearch-reports') rescue AWS::S3::Bucket.create(REPORTS_AWS_BUCKET_NAME)
    end
    
    def generate_report_filename(prefix, day, date_format)
      "#{prefix}_top_queries_#{day.strftime(date_format)}.csv"
    end
   
    def generate_report(top_queries, filename)
      csv_string = FasterCSV.generate do |csv|
        csv << ["Query", "Count"]
        top_queries.each do |top_query|
          csv << [top_query.query, top_query.total]
        end
      end
      AWS::S3::S3Object.store(filename, csv_string, REPORTS_AWS_BUCKET_NAME)
    end
    
    def list_affiliate_names(start_time, end_time)
      Query.find(:all, :select => "DISTINCT affiliate", :conditions => ["timestamp between ? and ? AND affiliate<>?", start_time, end_time, 'usasearch.gov']).collect{|query| query.affiliate}
    end

    desc "Generate Top Queries reports for the month of the date specified"
    task :generate_monthly_top_queries, :day, :generate_usasearch, :generate_affiliates, :needs => :environment do |t, args|
      args.with_defaults(:day => Date.yesterday.to_s(:number), :generate_usasearch => "true", :generate_affiliates => "true")
      day = Date.parse(args.day)
      establish_aws_connection
      %w{en es}.each do |locale|
        top_queries = Query.top_queries(day.beginning_of_month.beginning_of_day, day.end_of_month.end_of_day, locale, 'usasearch.gov', locale == 'en' ? 20000: 4000, true)
        generate_report(top_queries, generate_report_filename(locale, day, '%Y%m'))
      end if args.generate_usasearch
      list_affiliate_names(day.beginning_of_month.beginning_of_day, day.end_of_month.end_of_day).each do |affiliate_name|
        top_queries = Query.top_queries(day.beginning_of_month.beginning_of_day, day.end_of_month.end_of_day, I18n.default_locale.to_s, affiliate_name, 1000, true)
        generate_report(top_queries, generate_report_filename(affiliate_name, day, '%Y%m'))  
      end if args.generate_affiliates
    end
    
    desc "Generate Top Queries reports for the date specified"
    task :generate_daily_top_queries, :day, :generate_usasearch, :generate_affiliates, :needs => :environment do |t, args|
      args.with_defaults(:day => Date.yesterday.to_s(:number), :generate_usasearch => "true", :generate_affiliates => "true")
      day = Date.parse(args.day)
      establish_aws_connection
      %w{en es}.each do |locale|
        top_queries = Query.top_queries(day.beginning_of_day, day.end_of_day, locale, 'usasearch.gov', 1000, true)
        generate_report(top_queries, generate_report_filename(locale, day, '%Y%m%d'))
      end if args.generate_usasearch
      list_affiliate_names(day.beginning_of_day, day.end_of_day).each do |affiliate_name|
        top_queries = Query.top_queries(day.beginning_of_day, day.end_of_day, I18n.default_locale.to_s, affiliate_name, 1000, true)
        generate_report(top_queries, generate_report_filename(affiliate_name, day, '%Y%m%d'))
      end if args.generate_affiliates
    end
    
  end
end