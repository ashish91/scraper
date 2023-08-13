class BooksToScrape::BooksShowPage
  class << self

    def links
      []
    end

    def model
      Book
    end

    def elements
      {
        title: {
          css: '.product_page h1'
        },
        product_type: {
          css: '.table-striped tr:nth-child(2) td'
        },
        price_excluding_tax: {
          css: '.table-striped tr:nth-child(3) td'
        },
        price_including_tax: {
          css: '.table-striped tr:nth-child(4) td'
        },
        tax: {
          css: '.table-striped tr:nth-child(5) td'
        },
        availability: {
          css: '.table-striped tr:nth-child(6) td'
        },
        number_of_reviews: {
          css: '.table-striped tr:nth-child(7) td'
        },
      }
    end

  end
end
