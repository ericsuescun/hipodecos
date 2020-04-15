module DiagcodesHelper
	def load_txt(fileName)
	  if File.file?(fileName) == true
	    # file = File.read(fileName)
	    file = "Ok"
	    return file
	  else
	    return "No"
	  end
	end

	def openfile(fileName)
		if File.file?(fileName) == true
		  file = File.read(fileName)
		  # file = "Ok"
		  return file
		else
		  return []
		end
	end
end
