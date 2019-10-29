require_relative "union.rb"

class Edge
	def initialize(v, w, weight)
		@v = v
		@w = w
		@weight = weight
	end
	
	def to_s
		return "#{@v} - #{@w}: #{@weight}"
	end
	
	attr_reader :v, :w, :weight
end

class Graph
	def initialize(size)
		if (size < 0) then
			raise "Verticies can not be negative"
		else
			@size = size
			@graph = Array.new(size) { Array.new }
		end
	end
	
	def add(edge)
		if (((edge.v < 0) || (edge.w < 0)) || ((edge.v >= @size) || (edge.w >= @size))) then
			raise "Edge index out of range"
		else
			@graph[edge.v].delete_if { |x| (x.v == edge.w) || (x.w == edge.w) }
			@graph[edge.w].delete_if { |x| (x.v == edge.v) || (x.w == edge.v) }
			@graph[edge.v].push(edge)
			@graph[edge.w].push(edge)
			@graph
		end
	end
	
	def add_edge(v, w, weight)
		if ((v < 0) || (w < 0)) || ((v >= @size) || (w >= @size)) then
			raise "Edge index out of range"
		else
			self.add(Edge.new(v, w, weight))
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