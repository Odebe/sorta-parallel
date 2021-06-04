require_relative '../lib/sorta/parallel.rb'

class IncrTask
  def call(num)
    num + 1
  end
end

r1 = Ractor.new(name: '1') do
  5.times.map do |i|
    Thread.new do
      source = (i..10).to_a
      result = Sorta::Parallel.map(source, IncrTask)

      puts "ractor: #{Ractor.current.name}, thread: #{i}  source: #{source.inspect}, result: #{result.inspect}"
    end
  end.each(&:join)
end

r2 = Ractor.new(name: '2') do
  5.times.map do |i|
    Thread.new do
      source = ((100+i)..(100+10)).to_a
      result = Sorta::Parallel.map(source, IncrTask)

      puts "ractor: #{Ractor.current.name} thread: #{i} source: #{source.inspect}, result: #{result.inspect}"
    end
  end.each(&:join)
end

workers = [r1, r2]
loop do
  break if workers.empty?

  ractor, _ = Ractor.select(*workers)
  workers.delete(ractor)
end


