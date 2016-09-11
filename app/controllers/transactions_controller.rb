class TransactionsController < ApplicationController
	def new
	  client_token = generate_client_token
	  @client_token = client_token
	  puts "CLIENT TOKEN " + client_token
	end

	def create
	  unless current_user.has_payment_info?
	    @result = Braintree::Transaction.sale(
	                amount: 10.00,
	                payment_method_nonce: params[:payment_method_nonce],
	                customer: {
	                  first_name: params[:first_name],
	                  last_name: params[:last_name],
	                  company: params[:company],
	                  email: current_user.email,
	                  phone: params[:phone]
	                },
	                options: {
	                  store_in_vault: true
	                })
	  else
	    @result = Braintree::Transaction.sale(
	                amount: 10.00,
	                payment_method_nonce: params[:payment_method_nonce])
	  end

	  if @result.success?
	    current_user.update(braintree_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
	    # current_user.purchase_cart_movies!
	    # charge_user(40.00)

	    redirect_to root_url, notice: "Congraulations! Your transaction has been successfully!"
	  else
	    flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
	    gon.client_token = generate_client_token
	    render :new
	  end
	end

	# def charge_user(amount)
	# 	puts "LETS CHARGE THEM $ #{amount}"
	# 	puts "THE CURRENT USER IS #{current_user.braintree_id}"
	# 	#payment method is stored in the vault
	# 	result = Braintree::Transaction.sale(
	# 	  :customer_id => current_user.braintree_id,
	# 	  :amount => amount
	# 	)
	# 	if result.success?
	# 		puts "WE JUST CHARGED THEM LOTS OF MONEY"
	# 	else
	# 		p result.errors
	# 	end

	# end

	private
	def generate_client_token
	  # Braintree::ClientToken.generate

	  if current_user.has_payment_info?
	    Braintree::ClientToken.generate(customer_id: current_user.braintree_id)
	  else
	    Braintree::ClientToken.generate
	  end

	end
end
