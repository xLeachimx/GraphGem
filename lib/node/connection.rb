class Connection
	attr_accessor :weight
	attr_accessor :to

	def initialize to, weight
		@to = to
		@weight = weight
	end
end