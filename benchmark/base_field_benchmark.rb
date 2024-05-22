require "benchmark"
require "benchmark/ips"
require_relative "../spec/dummy/config/environment"

@fields = (1..24).map { Avo::Fields::TextField.new("foo") }

def get_types
  ENV["MEMOIZE_TYPE"] = nil
  @fields.each(&:type)
end

def get_types_memoized
  ENV["MEMOIZE_TYPE"] = "true"
  @fields.each(&:type)
end

puts "BMBM"
Benchmark.bmbm do |x|
  x.report("type:         ") { get_types }
  x.report("type_memoized:") { get_types_memoized }
end

puts "\n\n"

puts "IPS"
Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("type:         ") { get_types }
  x.report("type_memoized:") { get_types_memoized }

  x.compare!
end

puts ""
puts "MEMORY"
Benchmark.memory do |x|
  x.report("type:         ") { get_types }
  x.report("type_memoized:") { get_types_memoized }

  x.compare!
end
