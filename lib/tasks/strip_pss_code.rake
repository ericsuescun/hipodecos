namespace :pss_code do
  task :strip => :environment do
    diagnostics = Diagnostic.all
    diagnostics.each do |diagnostic|
      if diagnostic.pss_code.present?
        diagnostic.pss_code = diagnostic.pss_code.strip
        diagnostic.save
      end
    end

    scripts = Script.all
    scripts.each do |script|
      if script.pss_code.present?
        script.pss_code = script.pss_code.strip
        script.save
      end
    end

    diagcodes = Diagcode.all
    diagcodes.each do |diagcode|
      if diagcode.pss_code.present?
        diagcode.pss_code = diagcode.pss_code.strip
        diagcode.save
      end
    end
  end
end
