task :get_consecutive => :environment do
  informs = Inform.all

  informs.each do |inform|
    consecutive = inform.tag_code[4..-1].to_i
    inform.update(consecutive: consecutive)
  end
end
