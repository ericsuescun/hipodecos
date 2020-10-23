module OldrecordsHelper
	def fix_accent(descr)
		
		descr.gsub!("Ã\u009F","á")
		
		descr.gsub!("Ã\u009A","é")
		
		descr.gsub!("Ã\u009D","í")

		descr.gsub!("Â¾","ó")

		descr.gsub!("Ã\u008B","Ó")
		
		return descr
	end
end
