class User < ActiveRecord::Base

  has_secure_password

  def has_payment_info?
  	braintree_id
  end

end