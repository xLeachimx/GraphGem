require_relative 'connection'

class GraphNode
	attr_accessor :name
	attr_accessor :content
	attr_accessor :marked
	attr_reader :connections

	def initialize name, content
		@name = name
		@content = content
		@connections = []
		@marked = false
	end

	def addConnection to, weight
		@connections.push(Connection.new(to, weight))
	end

	def getConnection name
		@connections.each do |c|
			return c if c.to.name == name
		end
		return nil
	end

	def connectedTo? name
		@connections.each do |c|
			return true if c.to.name == name
		end
		return false
	end
end