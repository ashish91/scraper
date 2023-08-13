require 'httparty'

class PersistedQueuedWebScraper
  include HTTParty

  def initialize
    @html_parser = HtmlParser.new
  end

  def process
    while Url.unprocessed.count > 0
      urls = to_be_processed_urls

      process_urls(unprocessed_urls: urls)
    end
  end

  def to_be_processed_urls
    urls = []
    Url.transaction do
      ActiveRecord::Base.connection.execute('LOCK urls IN ACCESS EXCLUSIVE MODE')
      urls = Url.unprocessed.limit(10)
      urls.update(status: :processing)
    end

    urls
  end

  def process_urls(unprocessed_urls:)
    urls = unprocessed_urls
    processed_urls = []
    begin
      Url.transaction do
        urls.each do |url|
          curr_url = URI.join(url.base_uri, url.uri)
          curr_page = build_page_class(url.page_type)

          puts
          puts
          puts '#' * 100
          puts "Processing #{curr_url}"
          puts '#' * 100
          response = self.class.get(curr_url)
          if response.code == 200
            res = response.body
            @html_parser.parse_content(content: res)

            extract_and_save_links(page: curr_page, base_uri: url.base_uri)
            process_content(page: curr_page, url: curr_url)

            processed_urls.push(url.id)
          end
        end
      end
    ensure
      urls = Url.where(id: urls.map(&:id))
      urls.where(id: processed_urls).update(status: :processed)
      urls.where.not(id: processed_urls).update(status: :failed)
    end
  end

  def extract_and_save_links(page:, base_uri:)
    return if page.links.empty?

    page.links.each do |link|
      link_elements = @html_parser.find_elements_by_css(css: link[:css])
      urls = @html_parser.read_by_attr(elements: link_elements, attr: link[:attr])

      url_configs = urls.map do |uri|
        uri = link[:decorate_uri].call(uri) if link.key?(:decorate_uri)
        { base_uri: link[:base_uri] || base_uri, uri: uri, page_type: link[:next_page_type] }
      end

      Url.create!(url_configs)
    end
  end

  def process_content(page:, url:)
    return if page.elements.empty?

    content = { url: url.to_s }
    page.elements.keys.each do |element_name|
      elements = @html_parser.find_elements_by_css(css: page.elements[element_name][:css])
      values = @html_parser.read_by_content(elements: elements)

      content[element_name] = values[0] if values.present?
    end

    puts content
    page.model.create!(content)
    content
  end

  private
    def build_page_class(value)
      mod, klass = value.split(':')

      "#{mod.camelcase}::#{klass.camelcase}".constantize
    end
end
