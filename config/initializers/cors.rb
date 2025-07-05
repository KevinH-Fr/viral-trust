# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Pour tests locaux. En prod, remplace par les domaines autorisés.

    resource '/api/*',
      headers: :any,
      methods: [:get, :post, :options]
  end
end
