require_relative 'node/graph_node'
require_relative 'node/connection'

class Graph
	attr_reader :nodes

	# creates a blank graph
	def initialize
		@nodes = []
	end

	def addNode name, content
		@nodes.push(GraphNode.new(name, content))
	end

	# returns true if added
	def addEdge from, to, directed, weight=nil
		return false if !isNode?(to) || !isNode?(from)
		getNode(from).addConnection(to,weight)
		getNode(to).addConnection(from,weight) if(!directed)
	end

	def isNode? name
		@nodes.each do |n|
			return true if n.name == name
		end
		return false
	end

	def getNode name
		@nodes.each do |n|
			return n if n.name == name
		end
		return nil
	end

	def getConnectionWeight from, to
		return nil if !isNode?(from) || !isNode?(to)
		return getNode(from).getConnection(to).weight
	end

	def isConnected? from, to
		return nil if !isNode?(from) || !isNode?(to)
		return getNode(from).connectedTo?(to)
	end

	# marks the node mainly so that users can run own algs and know which have been activated
	def markNode name
		getNode(name).marked = true
	end

	# removes mark from a single node
	def unmarkNode name
		getNode(name).marked = false
	end

	def refreshNodes
		@nodes.each{|n| n.marked = false}
	end

	def convertToCSVString
		result = "From,FromContent,To,ToContent,Weight\n"
		@nodes.each do |n|
			n.connections.each do |c|
				result += n.name + ',' + n.content + ',' + c.to.name + ',' + c.to.content + ',' + c.weight + "\n"
			end
		end
		return result
	end

	def convertFromCSVString input
		lines = input.split("\n")
		lines.delete_if{|l| l=='From,FromContent,To,ToContent,Weight'}
		lines.map!{|l| l.split(',')}
		lines.each do |l|
			if(l.size == 5)
				if(/-{0,1}[1-9]\d*/.match(l[4]))
					weight = l[4].to_f
				else
					weight = l[4]
				end
			else
				weight = nil
			end
			if(!isNode(l[0]))
				addNode(l[0],l[1])
			end

			if(!isNode(l[2]))
				addNode(l[2],l[3])
			end

			addEdge(l[0],l[2],weight,true)
		end
	end
end