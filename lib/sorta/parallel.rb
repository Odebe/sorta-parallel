require_relative "./parallel/version"
require_relative "./parallel/signals"
require_relative "./parallel/tasks"
require_relative "./parallel/worker"
require_relative "./parallel/executor"
require_relative "./parallel/reactor"

module Sorta
  module Parallel
    class Error < StandardError; end

    def self.map(source, task_klass)
      Executor.new(source, task_klass).map!
    end

    def self.each(source, task_klass)
      Executor.new(source, task_klass).each!
    end
  end
end
