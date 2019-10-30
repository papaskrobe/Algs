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
			@queue[0] -= 1
			sink(1)
			return out
		end
	end
	
	def size
		return @queue[0]
	end
	
	attr_reader :queue

	private
	
	def float(pointer)
		while pointer > 1 && compare(pointer, pointer >> 1) > 0 do
			swap(pointer, pointer >> 1)
			pointer = (pointer >> 1)
		end
	end
	
	def sink(pointer)
		while true do
			if ((pointer << 1) > @queue[0]) then
				break
			elsif ((pointer << 1) == @queue[0]) then

				if compare(pointer, pointer << 1) < 0 then
					swap(pointer, pointer << 1)
				end
				break
			else
				if compare(pointer, pointer << 1) < 0 && compare(pointer << 1, (pointer << 1) + 1) > 0 then
					swap(pointer, pointer << 1)
					pointer = pointer << 1
				elsif compare(pointer, pointer << 1) < 0 && compare(pointer << 1, (pointer << 1) + 1) <= 0 then
					swap(pointer, (pointer << 1) + 1)
					pointer = (pointer << 1 + 1)
				else
					break
				end	
			end
		end
		return
	end
	
	def compare(pointer1, pointer2)
		return @comparitor.call(@queue[pointer1], @queue[pointer2])
	end
	
	def swap(pointer1, pointer2)
		temp = @queue[pointer1]
		@queue[pointer1] = @queue[pointer2]
		@queue[pointer2] = temp
	end

end
