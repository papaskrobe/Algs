require_relative "priority.rb"

class DiEdge
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
	
	def add_edge(f, t, w)
		if ((f < 0) || (t < 0)) || ((f >= @size) || (t >= @size)) then
			raise "Edge index out of range"
		else
			self.add(DiEdge.new(f, t, w))
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
		queue = PriorityQueue.new(Proc.new { |x, y| y[1] <=> x[1] })
		queue.insert([source, 0])
		node = nil
		while queue.size > 0 do
			while node = queue.delMax
p node
				if !(@visited[node[0]]) then break end
			end
			if node then
				@graph.adj(node[0]).each do |edge|
					if @distTo[node[0]] + edge.weight < @distTo[edge.to] then
						@pathTo[edge.to] = node[0]
						@distTo[edge.to] = @distTo[node[0]] + edge.weight
					end
					
					if !(@visited[edge.to]) then
						queue.insert([edge.to, edge.weight + @distTo[edge.from]])
					end
				end
				@visited[node[0]] = true
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

