require "benchmark"
require "benchmark/ips"
require_relative "../spec/dummy/config/environment"

# @resources = (1..24).map { Avo::Resources::Post.new }
@resources = (1..24).map { Avo::Resources::User.new }

def calculate_file_hashes
  ENV["CACHE_FILE_HASH"] = nil
  @resources.each(&:file_hash)
end

def calculate_file_hashes_cached
  ENV["CACHE_FILE_HASH"] = "true"
  @resources.each(&:file_hash)
end

puts "BMBM"
Benchmark.bmbm do |x|
  x.report("file_hash:       ") { calculate_file_hashes }
  x.report("file_hash_cached:") { calculate_file_hashes_cached }
end

puts "\n\n"

puts "IPS"
Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("file_hash:       ") { calculate_file_hashes }
  x.report("file_hash_cached:") { calculate_file_hashes_cached }

  x.compare!
end

puts ""
puts "MEMORY"
Benchmark.memory do |x|
  x.report("file_hash:       ") { calculate_file_hashes }
  x.report("file_hash_cached:") { calculate_file_hashes_cached }

  x.compare!
end
