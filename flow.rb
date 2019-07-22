class FlowEdge
	def initialize(from, to, volume)
		@from = from
		@to = to
		@volume = volume
		@flow = 0
	end
	
	def empty?
		return @flow == 0
	end
	
	def full?
		return @flow == @volume
	end
	
	def residual(to)
		if to = @to then
			return @volume - @flow
		else
			return @flow
		end
	end
	
	def to_s
		return "#{from}->#{to}: #{flow}/#{volume}"
	end
	
	attr_reader :from, :to, :volume
	attr_accessor :flow
end

class FlowGraph
	def initialize(size)
		@graph = Array.new(size) { Array.new }
		@size = size
	end
	
	def add(edge)
		@graph[edge.to].push(edge)
		@graph[edge.from].push(edge)
	end
	
	def adj(v)
		return @graph[v]
	end
	
	def residual(from, to)
		@graph[from].each do |e|
			if e.to == to then
				return e.residual(to)
			elsif e.from == to then
				return e.residual(from)
			end
		end
	end
	
	def flow(from, to, volume)
		@graph[from].each do |e| 
			if e.to == to then
				e.flow -= volume
				break
			elsif e.from == to then
				e.flow += volume
				break
			end
		end
	end
	
	def show
		@graph.size.times do |x|
			@graph[x].each do |e|
				if e.from == x then
					puts e
				end
			end
		end
	end
	
	attr_reader :size, :graph
end

class FordFulkerson
	def initialize(graph, s, t)
		@graph = graph
		@s = s
		@t = t
		while hasPath?(@graph, @s, @t)		
			bottle = Float::INFINITY
			node = @t
			while node != s do
				if @graph.residual(node, pathTo[node]) < bottle then
					bottle = @graph.residual(node, pathTo[node])
				end
				node = pathTo[node]
			end
			node = @t
			while node != s do
				@graph.flow(node, pathTo[node], bottle)
				node = pathTo[node]
			end		
		end
	end
	
	def hasPath?(graph, s, t)
		@pathTo = [-1] * graph.size
		@visited = [false] * graph.size
		queue = [s]
		@visited[s] = true
		while ((queue.length > 0) && (!@visited[t])) do
			node = queue.shift
			graph.graph[node].each do |e|
				if ((e.from == node) && (e.flow < e.volume)) then
					if (!@visited[e.to]) then
						@visited[e.to] = true
						@pathTo[e.to] = e.from
						queue.push(e.to)
					end
				elsif ((e.to == node) && (e.flow > 0)) then
					if (!@visited[e.from]) then
						@visited[e.from] = true
						@pathTo[e.from] = e.to
						queue.push(e.from)
					end
				end
			end
		end
		return @visited[t]
	end
	
	attr_reader :pathTo, :visited
end

graph = FlowGraph.new(4)

graph.add(FlowEdge.new(0, 1, 10))
graph.add(FlowEdge.new(0, 2, 5))
graph.add(FlowEdge.new(1, 2, 15))
graph.add(FlowEdge.new(1, 3, 5))
graph.add(FlowEdge.new(2, 3, 10))

ff = FordFulkerson.new(graph, 0, 3)
graph.show












