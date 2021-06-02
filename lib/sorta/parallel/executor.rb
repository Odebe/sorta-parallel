module Sorta
  module Parallel
    class Executor
      def initialize(source, task_klass)
        # Reactor.update_current_ractor!

        @source = source.dup
        @task_klass = task_klass
        @results = []
        @result_pipe = Ractor.new { loop { Ractor.yield(Ractor.receive) } }
      end

      def each!
        map!
        @source
      end

      def map!
        @source.each_with_index do |item, i|
          pipe.send([@task_klass, @result_pipe, item, i])
        end

        results = @source.size.times.map { @result_pipe.take }
        raise 'oh no no no' if results.include?(Signals::Error)

        # sort by index
        results.sort_by(&:last).transpose.first
      end

      def pipe
        # Ractor.current[:sorta_parallel_pipe]
        Reactor::PIPE
      end
    end
  end
end
