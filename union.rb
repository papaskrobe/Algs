class UnionFind
	def initialize(size)
		@sizes = [1] * size
		@node = (0...size).to_a
	end
	
	def root(n)
		while @node[n] != n do
			@node[n] = @node[@node[n]]
			n = @node[n]
		end
		return n
	end
	
	def union(n, m)
		if @sizes[n] <= @sizes[m] then
			@node[root(n)] = root(m)
		else
			nodes[root(m)] = rood(n)
		end
	end
	
	def connected(n, m)
		return root(n) == root(m)
	end
	
	def show()
		p @node
	end
end

union = UnionFind.new(10)
union.union(0, 1)
union.union(1, 5)
union.union(5, 6)
union.union(2, 3)
union.union(4, 7)
puts union.connected(0, 5)
union.show