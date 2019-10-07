class TSTNode
	def initialize(letter, value=nil)
		@letter = letter
		@left = nil
		@right = nil
		@mid = nil
		@value = value
	end
	
	attr_accessor :left, :right, :mid, :value
	attr_reader :letter
end

class TST
	def initialize
		@head = nil
	end
	
	def put(word, value)
		if @head == nil then @head = TSTNode.new(word[0]) end
		put_private(word, @head, value)
	end
	
	def count()
		count_private(@head)
	end
	
	
	
	private
	
	def put_private(word, node, value)
		i = 0
		while (i < word.length) do
			if (node == nil) then
				node = TSTNode.new(word[i])
			end
			if (word[i] < node.letter) then
				if node.left == nil then node.left = TSTNode.new(word[i]) end
				node = node.left
			elsif (word[i] > node.letter) then
				if node.right == nil then node.right = TSTNode.new(word[i]) end
				node = node.right
			else
				i += 1
				if node.mid == nil then node.mid = TSTNode.new(word[i]) end
				node = node.mid
			end
		end
		node.value = value
	end
	
	def count_private(node)
		if (node == nil) then
			return 0
		else
			return count_private(node.left) + count_private(node.right) + count_private(node.mid) + (node.value == nil ? 0 : 1)
		end
	end
end