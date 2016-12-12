class GiftcardMailer < ApplicationMailer
  default from: 'support@lesmillsondemand.com'

  def send_gift_card_email(email, gift_card_code, price_gift_card, first_name, last_name)
    @client = Client.new
    @client.email = email
    @client.gift_card_code = gift_card_code
    @client.price = price_gift_card
    @client.first_name = first_name

    file_name = Rails.root.join('pdfs', "#{email}-#{((Time.now).to_i).to_s}.pdf")

    pdf = WickedPdf.new.pdf_from_string(
        render_to_string(:pdf => 'gift_certificate',
                         :template => 'templates/gift_certificate',
                         :locals => { :price => price_gift_card,
                                      :gift_card_code => gift_card_code, :first_name => first_name}),
        :encoding => 'UTF-8',
        :orientation => 'Landscape',
        :page_size => 'A4',
        :margin =>  {top: 0, bottom: 0, left: 0, right: 0})

    save_path = file_name
    File.open(save_path, 'wb') do |file|
      file << pdf
    end

    attachments['gift_card_content.pdf'] = File.read(file_name)
    mail to: @client.email, subject: "Thanks for your buying gift card."
  end

  def send_notifies_gift_card_empty(email, gift_card_code, price_gift_card)
    @client = Client.new
    @client.email = email
    @client.gift_card_code = gift_card_code
    @client.price = price_gift_card

    mail to: @client.email, subject: "Gift card is going empty"
  end

  def send_notifies_purchase_maded(p_created_at, p_processed_at, p_created_from, name_quantities, total_line_items_price,
    customer_name, customer_address, customer_email, customer_phone)

    mail_to = 'quoc.nguyen@texodesign.com'
    @p_created_at = p_created_at
    @p_processed_at = p_processed_at
    @p_created_from = p_created_from
    @name_quantities = name_quantities
    @total_line_items_price = total_line_items_price
    @customer_name = customer_name
    @customer_address = customer_address
    @customer_email = customer_email
    @customer_phone = customer_phone

    mail to: mail_to, subject: "Notifies purchase has been maded"
  end
end
