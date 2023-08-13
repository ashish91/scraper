require 'httparty'

class QueuedWebScraper
  include HTTParty
  @@urls = [{ base_uri: 'https://books.toscrape.com', uri: '/', page_type: 'books_to_scrape:books_index_page' }]
  @@processed_urls = {}

  def initialize
    @html_parser = HtmlParser.new
  end

  def process
    while @@urls.length > 0
      curr_url_config = @@urls.pop

      curr_url = URI.join(curr_url_config[:base_uri], curr_url_config[:uri])
      curr_page = build_page_class(curr_url_config[:page_type])

      next if @@processed_urls.key?(curr_url)
      puts
      puts
      puts '#' * 100
      puts "Processing #{curr_url}"
      puts '#' * 100
      response = self.class.get(curr_url)
      if response.code == 200
        res = response.body
        @html_parser.parse_content(content: res)

        extract_and_save_links(page: curr_page, base_uri: curr_url_config[:base_uri])
        process_content(page: curr_page, url: curr_url)

        @@processed_urls[curr_url] = true
      end
    end
  end

  def extract_and_save_links(page:, base_uri:)
    return if page.links.empty?

    page.links.each do |link|
      link_elements = @html_parser.find_elements_by_css(css: link[:css])
      urls = @html_parser.read_by_attr(elements: link_elements, attr: link[:attr])

      link_configs = urls.map do |uri|
        uri = link[:decorate_uri].call(uri) if link.key?(:decorate_uri)
        { base_uri: link[:base_uri] || base_uri, uri: uri, page_type: link[:next_page_type] }
      end

      @@urls = link_configs + @@urls
      puts @@urls
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
    content
  end

  private
    def build_page_class(value)
      mod, klass = value.split(':')

      "#{mod.camelcase}::#{klass.camelcase}".constantize
    end
end
