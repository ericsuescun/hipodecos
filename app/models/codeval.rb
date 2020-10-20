class Codeval < ApplicationRecord

	require 'csv'

	has_many :factors, dependent: :destroy	#Se harán dificiles de borrar para evitar catástrofes
	# has_many :factors

	has_many :values, dependent: :destroy
	# has_many :values

	# has_many :rates, through: :factors, dependent: :destroy
	has_many :rates, through: :factors

	# has_many :costs, through: :values, dependent: :destroy
	has_many :costs, through: :values

	validates :code, :name, :description, presence: true

	default_scope -> { order(code: :asc)}

	def self.import(file)
		@costs = Cost.all
		@rates = Rate.all
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			@codeval = Codeval.create!(row.to_hash.merge(admin_id: 0))
			@costs.each do |cost|
			  value = Value.new(codeval_id: @codeval.id, cost_id: cost.id, value: 0, description: cost.description, admin_id: 0)
			  value.save
			end
			if @rates.count != 0
			  @rates.each do |rate|
			    factor = Factor.new(codeval_id: @codeval.id, rate_id: rate.id, factor: rate.factor, description: rate.description, admin_id: 0, cost_id: rate.cost_id, price: 0 )
			    factor.save
			  end
			end
		end
	end
end
