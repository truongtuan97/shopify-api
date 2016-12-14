require 'base64'
require 'openssl'

class Api::ShopifyController < ApplicationController

  SHARED_SECRET = ['99fa0471893dc4cc110f731382e5bb77c686f13d367e57e260dd2b928880f9c8',
                   'd6cbfb83bf88f785964a62aeaceb98dbbecf404cd240cbea446a07ff54f3159d',
                   '725a78c19f2cd5b727d6c2cce91604d771e5337022dcd523805df197517a7089',
                   '8a0ec305419987e7543e594bf0549e4c989747870e15ca3cdfa7ab831228ab5e']

  def request_gift_card
    request.body.rewind
    data = request.body.read
    verified = verify_webhook(data, env["HTTP_X_SHOPIFY_HMAC_SHA256"])

    if verified
      shopify = Shopify.where({ :hmac_header => request.headers['X-Shopify-Order-Id'] }).first
      if shopify.nil?
        shopify = Shopify.new
        shopify.request_gift_card = YAML::dump(params.except(:action, :controller, :shopify))
        shopify.count_hmac_header = 1
        shopify.hmac_header = request.headers['X-Shopify-Order-Id']
        shopify.save

        price_gift_card = 0
        quantity = 0
        name_quantities = Array.new
        have_gift_card = false

        params[:line_items].each do |li|
          if li[:title].casecmp("LES MILLS ON DEMANDTM GIFT SUBSCRIPTION") == 0
            if have_gift_card == false
              have_gift_card = true
            end
            quantity = li[:quantity].to_i
            price_gift_card = li[:price].to_i

            #send email notify empty gift card
            arr_gift_cards = GiftCard.where({ :used => false, :price => price_gift_card })
            if arr_gift_cards.present? && arr_gift_cards.length < 50
              GiftcardMailer.send_notifies_gift_card_empty("quoc.nguyen@texodesign.com", arr_gift_cards.length,
                                                           price_gift_card).deliver_later
            end

            tax_rate = li[:tax_lines].length > 0 ? li[:tax_lines][0][:rate].to_f : 0

            (1..quantity).each do
              giftcard = GiftCard.where({ :used => false, :price => price_gift_card }).first
              if giftcard.present?
                first_name = params[:customer][:first_name]
                last_name = params[:customer][:last_name]

                order_id = params[:name]
                order_id = order_id[1..order_id.length]

                currency = params[:currency]
                currency_symbol = '$'
                case currency
                  when 'GBP'
                    currency_symbol = '£'
                  when 'EUR'
                    currency_symbol = '€'
                  else
                    currency_symbol = '$'
                end

                tax_included = params[:taxes_included]
                tax_string = ''
                if tax_included
                  tax_string = 'all taxes are inclusive' if currency == 'USD' || currency == 'EUR'
                  if currency == 'EUR' && tax_rate > 0
                    tax_value = price_gift_card.to_f * tax_rate.to_f / (1 + tax_rate.to_f)
                    tax_string = "includes #{currency_symbol}#{number_with_precision(tax_value, :precision => 2, :delimiter => ',')} in taxes"
                  end
                end

                formatted_price = tax_string.blank? ? "#{currency_symbol}#{price_gift_card}" : "#{currency_symbol}#{price_gift_card} (#{tax_string})"
                GiftcardMailer.send_gift_card_email(
                    params[:email], giftcard.gift_card_code, formatted_price, first_name, last_name, order_id).deliver_later

                giftcardused = GiftCardUsed.new
                giftcardused.email = params[:email]
                giftcardused.gift_card_code = giftcard.gift_card_code
                giftcardused.time_send_email = Time.now
                giftcardused.request_from = request.headers['X-Shopify-Shop-Domain']
                giftcardused.save

                giftcard.used = true
                giftcard.save
              else
                shopify.sent_email = false
                break
              end
            end
          end

          name_quantities << {:name => li[:name], :quantity => li[:quantity]}

          if shopify.sent_email == false
            break
          end
        end

        customer_name = "#{params[:customer][:first_name]} #{params[:customer][:last_name]}"
        customer_address = "#{params[:customer][:default_address][:address1]} #{params[:customer][:default_address][:city]} city"
        customer_email = "#{params[:customer][:email]}"
        customer_phone = "#{params[:customer][:default_address][:phone]}"
        p_created_at = params[:created_at]
        p_processed_at = params[:processed_at]
        p_created_from = request.headers['X-Shopify-Shop-Domain']
        total_line_items_price = params[:total_line_items_price]

        if have_gift_card
          GiftcardMailer.send_notifies_purchase_maded(p_created_at, p_processed_at, p_created_from, name_quantities,
                                                      total_line_items_price, customer_name, customer_address,
                                                      customer_email, customer_phone).deliver_later
        end

        if shopify.save
          render status: 200, json: { :return_val => "ok" } and return
        else
          render status: 304, json: { :return_val => "error" } and return
        end
      else
        shopify.count_hmac_header = shopify.count_hmac_header + 1
        shopify.save
        render status: 200, json: { :return_val => params.except(:action, :controller, :shopify) } and return
      end
    else
      render status: 200, json: { :return_val => "success but have error" } and return
    end
  end

  private

  def verify_webhook(data, hmac_header)
    digest  = OpenSSL::Digest::Digest.new('sha256')
    SHARED_SECRET.each do |ss|
      calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ss, data)).strip
      if calculated_hmac == hmac_header
        return true
      end
    end
    false
  end
end
