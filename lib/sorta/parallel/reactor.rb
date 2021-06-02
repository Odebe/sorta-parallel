require 'etc'

module Sorta
  module Parallel
    # globalstate, EEEW!!!
    module Reactor
      PIPE = Ractor.new { loop { Ractor.yield(Ractor.receive) } }
      # TODO: get count from env or from something else
      WORKERS = Etc.nprocessors.times.map { Worker.new(PIPE) }.freeze
    end
  end
end
