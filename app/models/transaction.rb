# Transaction Types
# Assessment
# New Group
# Group - for group tokens
# Gift - Gifting an assessment

class Transaction < ActiveRecord::Base
  include TokenGenerator
  before_create :set_token
  belongs_to :group
  belongs_to :user
  belongs_to :assessment

  serialize :params

  validates_presence_of :type

  #TODO: Add validations

  # From Railscasts #141
  # Encrypts paypal values
  def paypal_encrypted(item_name, amount, return_url, notify_url, quantity = 1, discount_rate = 0)
    values = {
      :business => APP_CONFIG[:paypal_email],
      :cmd => '_xclick',
      :item_name => item_name,
      :amount => amount,
      :quantity => quantity,
      :discount_rate => discount_rate,
      :no_shipping => 1,
      :currency_code => "CAD",
      :cert_id => APP_CONFIG[:paypal_cert_id],
      :cbt => 'Return to LAUNCH Tools',
      :return => return_url,
      #:cancel_return => transactions_url,
      :notify_url => notify_url
    }
#
#      line_items.each_with_index do |item, index|
#        values.merge!({
#          "amount_#{index + 1}" => item.unit_price,
#          "item_name_#{index + 1}" => item.product.name,
#          "item_number_#{index + 1}" => item.product.identifier,
#          "quantity_#{index + 1}" => item.quantity
#        })
#      end

    # To pass variables as a link:
    #"https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.map { |k,v| "#{k}=#{v}"  }.join("&")

    encrypt_for_paypal(values)
  end

  private

    PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert.pem")
    APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
    APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")
    def encrypt_for_paypal(values)
        signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)  
        OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
    end

end
