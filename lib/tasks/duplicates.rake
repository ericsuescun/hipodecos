namespace :oldrecords do
  task :dup => :environment do
    data = Oldrecord.unscoped.select(:clave,:numero,:fecha,:cedula).group(:clave,:numero,:fecha,:cedula).having("count(*) > 1")
    puts "Total: " + data.size.count.to_s
  end

  task :rm_dup => :environment do
    data = Oldrecord.unscoped.select(:clave,:numero,:fecha,:cedula).group(:clave,:numero,:fecha,:cedula).having("count(*) > 1")
    puts "Total: " + data.size.count.to_s
    data.each_with_index do |record, n|
      Oldrecord.where(numero: record.numero, fecha: record.fecha, cedula: record.cedula).last.destroy
      puts "Record #{n}"
    end
  end
end

namespace :oldcitos do
  task :dup => :environment do
    data = Oldcito.unscoped.select(:clave,:numero,:fecha,:cedula).group(:clave,:numero,:fecha,:cedula).having("count(*) > 1")
    puts "Total: " + data.size.count.to_s
  end

  task :rm_dup => :environment do
    data = Oldcito.unscoped.select(:clave,:numero,:fecha,:cedula).group(:clave,:numero,:fecha,:cedula).having("count(*) > 1")
    puts "Total: " + data.size.count.to_s
    data.each_with_index do |record, n|
      Oldcito.where(numero: record.numero, fecha: record.fecha, cedula: record.cedula).last.destroy
      puts "Record #{n}"
    end
  end
end
