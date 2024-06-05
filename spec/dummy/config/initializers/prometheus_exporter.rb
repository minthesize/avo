require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

Rails.application.middleware.unshift Prometheus::Middleware::Collector
Rails.application.middleware.unshift Prometheus::Middleware::Exporter

require_relative '../../lib/prometheus/memory_exporter'

if Rails.env.development?
  memory_exporter = Prometheus::MemoryExporter.new
  memory_exporter.start

  # Start the Prometheus client HTTP server
  # Prometheus::Client::Rack::Exporter.start
end
