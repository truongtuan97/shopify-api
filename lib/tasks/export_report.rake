require 'active_record'
require 'csv'

namespace :report do
  desc 'Export all information of gift cards which were sent to customers'
  task(:do_csv => :environment) do
    export_dir = "#{Rails.root}/public/exported_files"
    Dir.mkdir(export_dir) unless File.exist?(export_dir)
    used_cards = GiftCardUsed.where("request_from NOT LIKE 'staging%'").order('time_send_email desc')
    if used_cards.present? && used_cards.any?
      header_columns = ['Order #ID', 'Email', 'Activation code', 'Sent at (UTC)', 'Shopify store']
      csv_file = File.join(export_dir, "report_#{DateTime.now.strftime('%Y%m%d%H%M')}.csv")
      CSV.open(csv_file, 'wb') do |csv|
        csv << header_columns
        used_cards.each do |c|
          case c.request_from
            when 'les-mills-on-demand-uk.myshopify.com'
              currency = 'GBP'
            when 'les-mills-on-demand-eu.myshopify.com'
              currency = 'EUR'
            else
              currency = 'USD'
          end
          shopify_arr = Shopify.where("request_gift_card NOT LIKE '%(COD)%' and request_gift_card LIKE '%email: #{c.email}%' and request_gift_card LIKE '%currency: #{currency}%' and extract(epoch from (created_at::timestamp - '#{c.time_send_email}'::timestamp)) < 5").order('created_at desc')
          shopify_arr.each do |s|
            request_content = YAML::load(s.request_gift_card)
            csv << [request_content[:name].gsub('#',''), c.email, c.gift_card_code, c.time_send_email.strftime('%Y-%m-%d %H:%M:%S'), c.request_from]
          end if shopify_arr.present? && shopify_arr.any?
        end
      end
    end
  end
end