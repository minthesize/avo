class Avo::ResourceRegistry
  include Singleton

  delegate_missing_to :@store

  def initialize
    super
    @store = ActiveSupport::Cache::MemoryStore.new(size: 2.megabytes)
  end

  def []=(key, value)
    @store.write(key, value)
  end

  def [](key)
    @store.read(key)
  end
end
