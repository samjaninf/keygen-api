# frozen_string_literal: true

desc 'clean up sidekiq stat keyspace'
task stat_cleanup: :environment do
  redis = Rails.cache.redis
  t1 = 1.week.ago.beginning_of_day.to_i

  puts "Threshold timestamp: #{t1}"

  redis.with do |conn|
    conn.scan_each(match: 'stat:*') do |key|
      parts = key.split(':')
      if parts.size == 3
        t2 = Time.parse(parts.last).to_i
        if t2 >= t1
          puts "Skipping: #{key}"

          next
        end
      end

      puts "Clearing: #{key}"

      conn.unlink key
    end
  end
end