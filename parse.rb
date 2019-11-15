# str = "MUCOSA ORAL: Epitelio con hiper y paraqueratosis severas con colonias bacterianas superficiales. Acantosis irregular con vascularización y fibrosis subyacente. No se observaron glandulas salivares ni evidencia de displasia ni malignidad."
str = "trauma"
str = str.downcase.gsub(/[^a-z0-9\s]/i, '')
a = str.split(" ")
b = []
a.each do |n|
	if n.length > 3
		b << n
	end
end
puts b