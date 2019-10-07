require_relative "priority.rb"
require_relative "union.rb"

class Edge
	def initialize(from, to, weight)
		@from = from
		@to = to
		@weight = weight
	end
	
	def to_s
		return "#{@from} -> #{@to}: #{@weight}"
	end
	
	attr_reader :from, :to, :weight
end

class Digraph
	def initialize(size)
		@size = size
		@graph = Array.new(size) { Array.new }
	end
	
	def add(edge)
		if (((edge.to < 0) || (edge.from < 0)) || ((edge.to >= @size) || (edge.from >= @size))) then
			raise "Edge index out of range"
		else
			@graph[edge.from].delete_if { |x| x.to == edge.to }
			@graph[edge.from].push(edge)
		end
	end
	
	def adj(v)
		if ((v >= @size) || (v < 0)) then
			raise "Index #{v} out of range"
		else
			return @graph[v]
		end
	end
	
	attr_reader :size
end

class DijkstraSP
	def initialize(graph, source=0)
		if ((source < 0) || (source >= graph.size)) then
			raise "Source #{source} out of range"
		end
		@graph = graph
		@visited = [false] * graph.size
		@distTo = [Float::INFINITY] * graph.size
		@pathTo = [-1] * graph.size
		@distTo[source] = 0
		@pathTo[source] = source
		queue = PriorityQueue.new(Proc.new { |x, y| @distTo[y] <=> @distTo[x] })
		queue.insert(source)
		node = nil
		while queue.size > 0 do
			while node = queue.delMax
				if !(@visited[node]) then break end
			end
			if node then
				@graph.adj(node).each do |edge|
					if !(@visited[edge.to]) then
						queue.insert(edge.to)
					end
					if @distTo[node] + edge.weight < @distTo[edge.to] then
						@pathTo[edge.to] = node
						@distTo[edge.to] = @distTo[node] + edge.weight
					end
				end
				@visited[node] = true
			end
		end
	end
	
	attr_reader :distTo, :pathTo
end

class BellmanFordSP
	def initialize(graph, source=0)
		if ((source < 0) || (source >= graph.size)) then
			raise "Source #{source} out of range"
		end
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

class KruskalMST
	def initialize(graph)
		@mst = []
		union = UnionFind.new(graph.size)
		edges = []
		graph.size.times do |v|
			graph.adj(v).each do |e|
				edges += [e]
			end
		end
		edges.sort! { |x, y| x.weight <=> y.weight }
		edges.each do |e|
			if !union.connected?(e.from, e.to) then
				@mst += [e]
				union.join(e.from, e.to)
			end
		end
		@sum = @mst.collect { |e| e.weight }.inject(:+)
	end
	attr_reader :mst, :sum
end
