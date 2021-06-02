require_relative '../lib/sorta/parallel.rb'

class IncrTask
  def call(num)
    num + 1
  end
end

r1 = Ractor.new(name: '1') do
  source = [1,2,3]
  Sorta::Parallel.map(source, IncrTask)
end

r2 = Ractor.new(name: '2') do
  source = [9,10,11]
  Sorta::Parallel.map(source, IncrTask)
end

workers = [r1, r2]

while workers.any?
  ractor, msg = Ractor.select(*workers)
  puts "ractor ##{ractor.name}, result: #{msg.inspect}"
  workers.delete(ractor)
end


