require 'nokogiri'

class NokogiriHtmlParser
  def find_elements_by_css(css:)
    return unless @content

    @content.css(css).map { |element| element }
  end

  def find_elements_by_xpath
  end

  def read_by_attr(elements:, attr:)
    elements.map { |element| element[attr] }
  end

  def read_by_content(elements:)
    elements.map { |element| element.content }
  end

  def parse_content(content:)
    @content = Nokogiri::HTML(content)
  end
end
