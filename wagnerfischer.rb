def edit_distance(str1, str3)
	d = Array.new(str1.length() + 1) { Array.new(str3.length() + 1, 0) }
	(str1.length() + 1).times { |i| d[i][0] = i }
	(str3.length() + 1).times { |j| d[0][j] = j }
	
	str3.length.times do |j|
		str1.length.times do |i|
			if str1[i] == str3[j] then
				d[i + 1][j + 1] = d[i][j]
			else
				min = d[i][j] + 1 
				if (d[i + 1][j] + 1) < min then min = (d[i + 1][j] + 1) end
				if (d[i][j + 1] + 1) < min then min = (d[i][j + 1] + 1) end
				d[i + 1][j + 1] = min
			end
		end
	end
	return d[str1.length()][str3.length()]
end