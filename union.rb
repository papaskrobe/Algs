class UnionFind
	def initialize(size)
		@sizes = [1] * size
		@node = (0...size).to_a
	end
	
	def root(n)
		if ((n < 0) || (n >= @sizes.length)) then
			raise "Index #{n} outside of range"
		end
		while @node[n] != n do
			@node[n] = @node[@node[n]]
			n = @node[n]
		end
		return n
	end
	
	def join(n, m)
	if (((n < 0) || (m < 0)) || ((n >= @sizes.length) || (m >= @sizes.length))) then
		raise "Index outside of range"
	end
		if @sizes[n] <= @sizes[m] then
			@node[root(n)] = root(m)
		else
			nodes[root(m)] = rood(n)
		end
	end
	
	def connected?(n, m)
		if (((n < 0) || (m < 0)) || ((n >= @sizes.length) || (m >= @sizes.length))) then
			raise "Index outside of range"
		end
		return root(n) == root(m)
	end
	
	def show()
		p @node
	end
end