class PriorityQueue
	def initialize(comparitor=Proc.new { |x, y| x <=> y })
		@comparitor = comparitor
		@queue = [0]
	end

	def insert(x)
		
	end

	def max
		if @queue[0] == 0 then
			return nil
		else
			return @queue[1]
		end
	end
	
	def delMax
		if @queue[0] = 0 then
			return nil
		else
			#CODE
		end
	end
	
	def float(pointer)
		
	end
	
	def sink(pointer)
		
	end
	
	def swap(pointer1, pointer2)
	
	end

end