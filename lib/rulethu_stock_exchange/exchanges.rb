# frozen_string_literal: true

module RulethuStockExchange::Exchanges
  ALL = [
    LSE = {
      name: 'London Stock Exchange',
      url: 'https://www.londonstockexchange.com/indices?tab=ftse-indices',
      selector: 'section#indices-table-IntradayValues > table'
    },
    JSE = {
      name: 'Johannesburg Stock Exchange',
      url: 'https://www.jse.co.za/indices',
      selector: 'table'
    },
    ZSE = {
      name: 'Zimbabwe Stock Exchange',
      url: 'https://www.zse.co.zw/price-sheet/',
      selector: 'table'
    }
  ]
end
