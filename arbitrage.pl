#!/usr/bin/python3

import json
import requests

def construct_url(exchange, from_symbol, to_symbol):
  url = "https://min-api.cryptocompare.com/data/price?"
  url += "e=" + exchange
  url += "&fsym=" + sym1
  url += "&tsyms=" + sym2
  return url

try:

    # Get all pairs from all exchanges
    url = 'https://min-api.cryptocompare.com/data/all/exchanges'
    r = requests.get(url)
    all_coins = r.json()

    # Construct a list of URLs
    trades = []
    sym1 = "BTC"
    sym2 = "GBP"
    for exchange in all_coins:
      for from_symbol in all_coins[exchange]:
        if from_symbol in sym1:
          for to_symbol in all_coins[exchange][from_symbol]:
            if to_symbol in sym2:
              trades.append([exchange, from_symbol, to_symbol])

    # Get prices
    prices = []
    for t in trades:
      url = construct_url(t[0], t[1], t[2])
      r = requests.get(url)
      price = r.json()
      prices.append([t[0], price[sym2]])
	  
    # Sort and print
    # prices.sort()
    for p in prices:
      print(p[0], p[1])

except Exception as e:
    print("exception ", e)
