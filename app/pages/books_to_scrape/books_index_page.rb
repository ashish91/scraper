class BooksToScrape::BooksIndexPage
  class << self

    def links
      [
        {
          css: '.product_pod h3 a',
          attr: 'href',
          decorate_uri: -> (uri) { uri.split('/')[0] == 'catalogue' ? uri : "catalogue/#{uri}" },
          next_page_type: 'books_to_scrape:books_show_page'
        },
        {
          css: 'section .next a',
          attr: 'href',
          decorate_uri: -> (uri) { uri.split('/')[0] == 'catalogue' ? uri : "catalogue/#{uri}" },
          next_page_type: 'books_to_scrape:books_index_page'
        }
      ]
    end

    def elements
      {}
    end

  end
end
