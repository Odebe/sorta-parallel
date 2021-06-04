module Sorta
  module Parallel
    class Executor
      def initialize(source, task_klass)
        Reactor.start!

        @source = source.dup
        @task_klass = task_klass
        @results = []
        @response_queue = Queue.new
      end

      def each!
        map!
        @source
      end

      def map!
        @source.each_with_index do |item, i|
          Reactor.register([@task_klass, @response_queue, item, i])
        end

        @source.size.times do
          @results << @response_queue.pop
        end

        raise 'oh no no no' if @results.include?(Signals::Error)

        # sort by index
        @results.sort_by(&:last).transpose.first
      end
    end
  end
end
