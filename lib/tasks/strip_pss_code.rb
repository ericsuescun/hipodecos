namespace :pss_code do
  task :strip => :environment do
    diagnostics = Diagnostic.all
    diagnostics.each do |diagnostic|
      diagnostic.pss_code = diagnostic.pss_code.strip
      diagnostic.save
    end

    scripts = Script.all
    scripts.each do |script|
      script.pss_code = script.pss_code.strip
      script.save
    end

    diagcodes = Diagcode.all
    diagcodes.each do |diagcode|
      diagcode.pss_code = diagcode.pss_code.strip
      diagcode.save
    end
  end
end
