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
		return "#{from} -> #{to}: #{flow}/#{volume}"
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
		if (((edge.to < 0) || (edge.from < 0)) || ((edge.to >= @size) || (edge.from >= @size))) then
			raise "Edge index out of range"
		else
			@graph[edge.to].push(edge)
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
	
	def residual(from, to)
		if (((to < 0) || (from < 0)) || ((to >= @size) || (from >= @size))) then
			raise "Edge index out of range"
		end
		@graph[from].each do |e|
			if e.to == to then
				return e.residual(to)
			elsif e.from == to then
				return e.residual(from)
			end
		end
		return nil
	end
	
	def flow(from, to, volume)
		if (((to < 0) || (from < 0)) || ((to >= @size) || (from >= @size))) then
			raise "Edge index out of range"
		end
		@graph[from].each do |e| 
			if e.to == to then
				e.flow -= volume
				if e.flow < 0 then
					raise "Flow for edge can not be negative"
				end
				break
			elsif e.from == to then
				e.flow += volume
				if e.flow > e.volume then
					raise "Flow for edge can not be higher than volume"
				end
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
	
	attr_reader :pathTo
end
