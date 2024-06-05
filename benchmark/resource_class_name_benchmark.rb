require "benchmark"
require "benchmark/ips"
require_relative "../spec/dummy/config/environment"

@resources = (1..24).map { Avo::Resources::User.new }

def call_class_name
  ENV["MEMOIZE_RESOURCE_CLASS_NAME"] = nil
  @resources.each(&:model_class)
  @resources.each(&:model_key)
  @resources.each(&:translation_key)
  @resources.each(&:name)
end

def call_class_name_memoized
  ENV["MEMOIZE_RESOURCE_CLASS_NAME"] = "true"
  @resources.each(&:model_class)
  @resources.each(&:model_key)
  @resources.each(&:translation_key)
  @resources.each(&:name)
end

puts "BMBM"
Benchmark.bmbm do |x|
  x.report("class_name:                ") { call_class_name }
  x.report("class_name_memoized:       ") { call_class_name_memoized }
end

puts "\n\n"

puts "IPS"
Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("class_name:                ") { call_class_name }
  x.report("class_name_memoized:       ") { call_class_name_memoized }

  x.compare!
end

puts ""
puts "MEMORY"
Benchmark.memory do |x|
  x.report("class_name:                ") { call_class_name }
  x.report("class_name_memoized:       ") { call_class_name_memoized }

  x.compare!
end
