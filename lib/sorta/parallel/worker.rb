module Sorta
  module Parallel
    class Worker < Ractor
      def self.new(pipe)
        super(pipe) do |pipe|
          loop do
            task, result_pipe, data, index = pipe.take
            break if task.is_a?(Tasks::Quit)

            result_pipe.send([task.new.call(data), index], move: true)
          rescue
            result_pipe.send(Signals::Error.new, move: true)
            next
          end
        end
      end
    end
  end
end
