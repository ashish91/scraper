require './app/services/html_parsers/nokogiri_html_parser'

class HtmlParser
  def initialize(parser_class: 'NokogiriHtmlParser')
    @parser = parser_class.constantize.new
  end

  def find_elements_by_css(css:)
    @parser.find_elements_by_css(css: css)
  end

  def find_elements_by_xpath
  end

  def read_by_attr(elements:, attr:)
    @parser.read_by_attr(elements: elements, attr: attr)
  end

  def read_by_content(elements:)
    @parser.read_by_content(elements: elements)
  end

  def parse_content(content:)
    @parser.parse_content(content: content)
  end
end
