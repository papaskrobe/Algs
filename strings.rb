class KMP
	def initialize(pattern)
		@pattern = pattern
		buildDFA()
	end
	
	def buildDFA()
		@dfa = Array.new(256) { Array.new(@pattern.length + 1) {0} }
		@dfa[@pattern[0].ord][0] = 1
		
		error = 0
		i = 1
		1.upto(@pattern.length - 1) do |i|
			256.times { |ch| @dfa[ch][i] = @dfa[ch][error] }
			@dfa[@pattern[i].ord][i] = i + 1
			error = @dfa[@pattern[i].ord][error]
		end
		256.times { |ch| @dfa[ch][@pattern.length] = @dfa[ch][error] }
	end
	
	def newPattern(pattern)
		@pattern = pattern
		buildDFA()
	end
	
	def search(string)
		dfaPointer = 0
		string.length.times do |i|
			dfaPointer = @dfa[string[i].ord][dfaPointer]
			if (dfaPointer == @pattern.length) then return i - @pattern.length + 1 end
		end

		return nil
	end
	
	def searchAll(string)
		dfaPointer = 0
		out = []
		string.length.times do |i|
			dfaPointer = @dfa[string[i].ord][dfaPointer]
			if (dfaPointer == @pattern.length) then out.push(i - @pattern.length + 1) end
		end
		
		return out
	end
	
end

