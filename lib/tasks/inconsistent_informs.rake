namespace :informs do
  task :inconsistent => :environment do
    inconsistent = 0
    codes = []
    cancer = 0
    diagnostics = Diagnostic.all
    diagnostics.each do |diagnostic|
      diagcode = Diagcode.find_by(pss_code: diagnostic.pss_code)
      next if diagcode.blank?
      diagcode_id = diagcode.id
      if diagcode_id != diagnostic.diagcode_id
        inconsistent += 1
        cancer += 1 if Diagcode.find(diagcode_id).cancer
        # codes << diagnostic.inform.tag_code + ': diagnostic pss_code: ' + diagnostic.pss_code + " , pss_code from diagcode_id: " + Diagcode.find(diagnostic.diagcode_id).pss_code
        codes << "--#{diagnostic.inform.tag_code} - GOOD: pss_code #{diagnostic.pss_code}, diagcode.id(#{diagcode.id}). BAD: pss_code #{Diagcode.find(diagnostic.diagcode_id).pss_code} form diagnostic.diagcode_id(#{diagnostic.diagcode_id})--"
        diagnostic.diagcode_id = diagcode.id
        diagnostic.save
      end
    end
    puts "Inconsistencias: " + inconsistent.to_s
    puts "Códigos: " + codes.to_s
    puts "Cancer: " + cancer.to_s
  end
end
