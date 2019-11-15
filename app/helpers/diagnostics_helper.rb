module DiagnosticsHelper
	def getautos(diagnostic)
		Auto.where(diagcode_id: diagnostic.diagcode_id)
	end
end
