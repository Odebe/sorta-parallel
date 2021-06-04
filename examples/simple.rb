require_relative '../lib/sorta/parallel.rb'

class IncrTask
  def call(num)
    num + 1
  end
end

source = (1..10).to_a
result = Sorta::Parallel.map(source, IncrTask)

puts "source: #{source.inspect}, result: #{result.inspect}"
