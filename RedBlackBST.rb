class RedBlackBST
	class Node
		def initialize(k, v)
			@key = k
			@value = v
			
			@left = nil
			@right = nil
			
			@red = true
		end
		
		attr_reader :key
		attr_accessor :value, :left, :right, :red
	end
	
	def initialize()
		@root = nil
	end
	
	def search(k)
		pointer = @root
		while pointer do
			if k == pointer.key then
				return pointer.value
			elsif k < pointer.key then
				pointer = pointer.left
			else
				pointer = pointer.right
			end
		end
		
		return nil
	end
	
	def insert(k, v)
		@root = insert_private(@root, k, v)
		@root.red = false
	end
	

	private
	
	def insert_private(node, k, v)
		if (node == nil) then
			return Node.new(k, v)
		end
		
		if (node.left && node.right) then
			if (node.left.red && node.right.red) then
				color_flip(node)
			end
		end
		
		if (node.key == k) then
			node.value = v
		elsif (k < node.key) then
			node.left = insert_private(node.left, k, v)
		else
			node.right = insert_private(node.right, k, v)
		end
		
		if (node.right && node.left) then
			if (node.right.red && !node.left.red) then
				node = rotate_left(node)
			end
		end
		
		if (node.left && node.left.left) then
			if (node.left.red && node.left.left.red) then
				node = rotate_right(node)
			end
		end
		
		return node
	end

	def rotate_left(node)
		temp = node.right
		node.right = temp.left
		temp.left = node
		temp.red = node.red
		node.red = true
		
		return temp
	end

	def rotate_right(node)
		temp = node.left
		node.left = temp.right
		temp.right = node
		temp.red = node.red
		node.red = true
		
		return temp
	end	
	
	def color_flip(node)
		if (node.left && node.right) then
			node.red = !node.red
			node.right.red = !node.right.red
			node.left.red = !node.left.red
		end
	end
	
end