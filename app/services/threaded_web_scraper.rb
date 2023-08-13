class ThreadedWebScraper
  def invoke_threads
    count = Url.unprocessed.count
    if count > 0

      no_of_threads = [1, count/2].max
      no_of_threads = [20, no_of_threads].min

      threads = []
      puts
      puts
      puts
      puts
      puts
      puts
      puts "Invoking #{no_of_threads} threads"
      puts
      puts
      puts
      puts
      puts
      puts
      no_of_threads.times do

        threads << Thread.new do
          PersistedQueuedWebScraper.new.process
        end
      end
      threads.map(&:join)
    end
  end

  def call
    scraper = PersistedQueuedWebScraper.new
    urls = scraper.to_be_processed_urls
    scraper.process_urls(unprocessed_urls: urls)
  end
end
