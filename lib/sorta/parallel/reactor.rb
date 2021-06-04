require 'etc'

module Sorta
  module Parallel
    module Reactor
      def self.request_pipe
        Ractor.current[:request_pipe] ||= Ractor.new { loop { Ractor.yield(Ractor.receive) } }
      end

      def self.result_pipe
        Ractor.current[:result_pipe] ||= Ractor.new { loop { Ractor.yield(Ractor.receive) } }
      end

      def self.workers
        Ractor.current[:workers] ||= Etc.nprocessors.times.map { Worker.new(request_pipe) }.freeze
      end

      def self.queues
        Ractor.current[:queues] ||= {}
      end

      def self.register(task)
        queues[task[1].object_id] = task[1]
        safe_task = task.dup
        safe_task[1] = task[1].object_id
        request_pipe << [safe_task, result_pipe]
      end

      def self.start!
        request_pipe
        result_pipe
        workers

        Ractor.current[:thread] ||=
          Thread.new do
            loop do
              msg = result_pipe.take
              result_queue = queues[msg[1]]
              result_queue.push(msg)
            rescue => e
              puts e.message
              puts e.backtrace.join("\n")
              next
            end
          end
      end
    end
  end
end
