class Edge
	def initialize(from, to, weight)
		@from = from
		@to = to
		@weight = weight
	end
	
	attr_reader :from, :to, :weight
end

class Digraph
	def initialize(size)
		@size = size
		@graph = Array.new(size) { Array.new }
	end
	
	def add(edge)
		@graph[edge.from].delete_if { |x| x.to == edge.to }
		@graph[edge.from].push(edge)
	end
	
	def adj(edge)
		return @graph[edge]
	end
	
	attr_reader :size
end

class DijkstraSP
	def initialize(graph, source=0)
		@graph = graph
		@visited = [false] * graph.size
		@distTo = [Float::INFINITY] * graph.size
		@pathTo = [-1] * graph.size
		@distTo[source] = 0
		@pathTo[source] = source
		queue = [source] 
		node = nil
		while queue.size > 0 do
			queue.sort! { |x,y| @distTo[x] <=> @distTo[y] } # Hackish; should use proper priority queue
			loop do
				node = queue.shift
				if !(@visited[node]) then break end
			end
				@graph.adj(node).each do |edge|
				if !(@visited[edge.to]) then
					queue.push(edge.to)
				end
				if @distTo[node] + edge.weight < @distTo[edge.to] then
					@pathTo[edge.to] = node
					@distTo[edge.to] = @distTo[node] + edge.weight
				end
			end
			@visited[node] = true
		end
	end
	
	attr_reader :distTo, :pathTo
end

class BellmanFordSP
	def initialize(graph, source=0)
		@graph = graph
		@visited = [false] * graph.size
		@distTo = [Float::INFINITY] * graph.size
		@pathTo = [-1] * graph.size
		@distTo[source] = 0
		@pathTo[source] = source
		graph.size.times do
			graph.size.times do |v|
				graph.adj(v).each do |e|
					if @distTo[e.from] + e.weight < @distTo[e.to] then
						@distTo[e.to] = @distTo[e.from] + e.weight
						@pathTo[e.to] = e.from
					end
				end
			end
		end
	end
	
	attr_reader :distTo, :pathTo
end

=begin
graph = Digraph.new(7)
graph.add(Edge.new(1, 2, 7))
graph.add(Edge.new(1, 3, 9))
graph.add(Edge.new(1, 6, 14))
graph.add(Edge.new(2, 4, 15))
graph.add(Edge.new(2, 3, 10))
graph.add(Edge.new(3, 4, 11))
graph.add(Edge.new(3, 6, 2))
graph.add(Edge.new(6, 5, 9))
graph.add(Edge.new(4, 4, 6))
=end
graph = Digraph.new(5)
graph.add(Edge.new(0,1,2))
graph.add(Edge.new(0,3,6))
graph.add(Edge.new(1,2,1))
graph.add(Edge.new(2,3,1))
graph.add(Edge.new(3,4,2))

dij = DijkstraSP.new(graph, 0)
p dij.distTo
bf = BellmanFordSP.new(graph, 0)
p bf.distTo