Braintree::Configuration.environment  = ENV['BRAINTREE_ENV']         || :sandbox
Braintree::Configuration.merchant_id   = ENV['BRAINTREE_MERCHANT_ID'] || 'yf52n9rzpbxfsmnf'
Braintree::Configuration.public_key   = ENV['BRAINTREE_PUBLIC_KEY']  || 'dy2b3bn77hmym2hp'
Braintree::Configuration.private_key  = ENV['BRAINTREE_PRIVATE_KEY'] || 'b8d4d13ec716153ae75528400cfac905'