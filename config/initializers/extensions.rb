Dir[Rails.root.join('lib/extensions/**/*.rb')].each { |extension| require extension }
