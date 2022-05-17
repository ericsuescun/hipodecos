namespace :diagcodes do
  task :patch => :environment do
    diagnostics = Diagnostic.where(diagcode_id: nil)
    diagnostics.each do |diagnostic|
      diagnostic.diagcode_id = Diagcode.find_by(pss_code: diagnostic.pss_code).id
      diagnostic.save
    end
  end
end
