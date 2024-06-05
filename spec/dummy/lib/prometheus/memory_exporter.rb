module Prometheus
  class MemoryExporter
    def initialize
      @registry = Prometheus::Client.registry
      @memory_gauge = @registry.gauge(:ruby_memory_rss, docstring: 'Resident Set Size in bytes')
      @mem = GetProcessMem.new
    end

    def start
      Thread.new do
        loop do
          update_metrics
          sleep 5
        end
      end
    end

    private

    def update_metrics
      rss = @mem.bytes
      @memory_gauge.set(rss)
    end
  end
end
