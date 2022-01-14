namespace :organs do
  task :load_keywords => :environment do
    organs = Organ.all

    organs.each do |organ|
        keyword = organ.organ.split(' ').first.downcase
        keyword = keyword[0..-2] unless keyword[-1].match(/[a-z]/)
        organ.keywords = [ keyword ]
        organ.save
        puts organ.keywords
    end
  end
end

