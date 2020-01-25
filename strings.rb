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

class BoyerMoore
	def initialize(pattern)
		@pattern = pattern
		@bcAry = Array.new(256) { -1 }
		pattern.length.times { |i| @bcAry[pattern[i].ord] = i }
	end
	
	def search(string)
		i = 0
		while (i <= (string.length - @pattern.length)) do
			j = @pattern.length - 1
			while ((j > 0) && (@pattern[j] == string[i + j]))
				j -= 1
			end
			if (j == 0) then
				return i
			else
				jump = j - @bcAry[string[i + j].ord]
				i += (jump > 1 ? jump : 1)
			end
		end
		
		return nil
	end
	
	def searchAll(string)
		out = []
		i = 0
		while (i <= (string.length - @pattern.length)) do
		p i
			j = @pattern.length - 1
			while ((j > 0) && (@pattern[j] == string[i + j]))
				j -= 1
			end
			if (j == 0) then
				out.push(i)
				i += 1
			else
				jump = j - @bcAry[string[i + j].ord]
				i += (jump > 1 ? jump : 1)
			end
		end
		
		return out
	end
	
	
end