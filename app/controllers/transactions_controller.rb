class TransactionsController < ApplicationController
	def new
	  client_token = generate_client_token
	  @client_token = client_token
	  puts "CLIENT TOKEN " + client_token
	end

	# def create
	# 	#braintree generates user profile ID	 (token) -> saved to user profile in database
	# 	  @params = params
	# 	  puts "CONGRATS!"
	# 	  puts @params
	# 	  # render action: :new
	# 	# in future scenario, I can charge $5 to that user profile ID
	# end

	# def create

	#   nonce = params[:payment_method_nonce]
	#   render action: :new and return unless nonce
	#   result = Braintree::Transaction.sale(
	#     amount: "10.00",
	#     payment_method_nonce: nonce
	#   )

	#   flash[:notice] = "Sale successful. Head to Sizzler" if result.success?
	#   flash[:alert] = "Something is amiss. #{result.transaction.processor_response_text}" unless result.success?

	#   puts "RESULT IS HERE #{result}" 
	#   create_customer(nonce)

	#   redirect_to action: :new
	# end

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

	    charge_user(40.00)

	    redirect_to root_url, notice: "Congraulations! Your transaction has been successfully!"
	  else
	    flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
	    gon.client_token = generate_client_token
	    render :new
	  end
	end


	def create_customer(nonce)
		# Create a customer
		customer_create_result = Braintree::Customer.create(
 		 :first_name => "Jen",
		 :last_name => "Smith",
		 :company => "Braintree",
		  :email => "jen@example.com",
		  :phone => "312.555.1234",
		  :fax => "614.555.5678",
		  :website => "www.example.com"
		)

		if customer_create_result.success?
		  puts "YAY"
		  puts customer_create_result.customer.id
		  # Save to current user
		  puts "@current_user is #{ current_user }"
		  current_user.braintree_id = customer_create_result.customer.id
		  current_user.save
		  puts "WE JUST SAVED THE CURRENT_USER #{current_user}"

		  puts "SAVED THE CURRENT USER #{@current_user.braintree_id}"
		else
		  p customer_create_result.errors
		end

		#Create payment method
		create_payment_result = Braintree::PaymentMethod.create(
	  		:customer_id => customer_create_result.customer.id,
		  	:payment_method_nonce => nonce,
		 	:options => {
		    	:make_default => true
	  	})

	  	charge_user(400)
		
	end

	def charge_user(amount)
		puts "LETS CHARGE THEM $ #{amount}"
		puts "THE CURRENT USER IS #{current_user.braintree_id}"
		#payment method is stored in the vault
		result = Braintree::Transaction.sale(
		  :customer_id => current_user.braintree_id,
		  :amount => amount
		)
		if result.success?
			puts "WE JUST CHARGED THEM LOTS OF MONEY"
		else
			p result.errors
		end

	end

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
