class PriorityQueue
	def initialize(comparitor=Proc.new { |x, y| x <=> y })
		@comparitor = comparitor
		@queue = [0]
	end

	def insert(x)
		@queue.push(x)
		@queue[0] += 1
		float(@queue[0])
	end

	def max
		if @queue[0] == 0 then
			return nil
		else
			return @queue[1]
		end
	end
	
	def delMax
		if @queue[0] == 0 then
			return nil
		else
			swap(1, @queue[0])
			out = @queue.pop
			sink(1)
			@queue[0] -= 1
			return out
		end
	end
	
	def size
		return @queue[0]
	end
	
	attr_reader :queue

	private
	
	def float(pointer)
		while @comparitor.call(@queue[pointer], @queue[pointer >> 1]) > 0  && pointer > 1 do
			swap(pointer, pointer >> 1)
			pointer = (pointer >> 1)
		end
	end
	
	def sink(pointer)
		while true do
			if ((pointer << 1) > @queue[0]) then
				break
			elsif ((pointer << 1) == @queue[0]) then
				if @comparitor.call(pointer, pointer << 1) < 1 then
					swap(pointer, pointer << 1)
				end
				break
			else
				if @comparitor.call(@queue[pointer], @queue[pointer << 1]) > 0 && 
					@comparitor.call(@queue[pointer << 1], @queue[(pointer << 1) + 1]) > 0 then
					swap(pointer, pointer << 1)
					pointer = pointer << 1
				elsif @comparitor.call(@queue[pointer], @queue[pointer << 1]) > 0 && 
					@comparitor.call(@queue[pointer << 1], @queue[(pointer << 1) + 1]) < 0 then
					swap(pointer, (pointer << 1) + 1)
					pointer = (pointer << 1 + 1)
				else
					break
				end	
			end
		end
		return
	end
	
	def swap(pointer1, pointer2)
		temp = @queue[pointer1]
		@queue[pointer1] = @queue[pointer2]
		@queue[pointer2] = temp
	end

end
