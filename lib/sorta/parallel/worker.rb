module Sorta
  module Parallel
    class Worker < Ractor
      def self.new(pipe)
        super(pipe) do |pipe|
          loop do
            (task, queue_id, data, index), result_pipe = pipe.take
            result_pipe.send([task.new.call(data), queue_id, index], move: true)
          rescue
            result_pipe.send(Signals::Error.new, move: true)
            next
          end
        end
      end
    end
  end
end
