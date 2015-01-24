module Caching
  module FileCache
    def cache_result(options = {})
      default_options = { :expires => :never, :raw => true }
      options = default_options.merge(options)

      return cached_result(options[:filename], options[:raw]) if cache_valid?(options[:filename], options[:expires])
      result = yield
      update_cached_result(options[:filename], result, options[:raw])
    end

  private
    def cache_valid?(filename, expires = :never)
      cache_file_path = cache_file_path(filename)
      return false unless File.exist?(cache_file_path)
      return true if expires == :never

      time_since_cache_updated = Time.now - File.mtime(cache_file_path)
      time_since_cache_updated <= expires
    end

    def cached_result(filename, store_raw)
      cached_data = cache_file(filename, :read).read
      store_raw ? cached_data : Marshal.load(cached_data)
    end

    def update_cached_result(filename, result, store_raw)
      cache_file(filename, :write) do |cache_file|
        cache_file << (store_raw ? result : Marshal.dump(result))
      end
      result
    end

    def cache_file(filename, mode, &block)
      file_mode = (mode == :read ? 'r' : 'w')
      File.open(cache_file_path(filename), file_mode + 'b', &block)
    end

    def cache_file_path(filename)
      cache_file_dir = File.join(Rails.root, 'tmp/cache/')
      FileUtils.mkdir_p(cache_file_dir)
      File.join(cache_file_dir, filename)
    end

  end
end