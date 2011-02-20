# Configure our Braintree connection
Braintree::Configuration.environment = ENV["BRAINTREE_ENV"].to_sym
Braintree::Configuration.merchant_id = ENV["BRAINTREE_MERCHANT"]
Braintree::Configuration.public_key = ENV["BRAINTREE_PUBLIC"]
Braintree::Configuration.private_key = ENV["BRAINTREE_PRIVATE"]