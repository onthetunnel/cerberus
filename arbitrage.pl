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
      exchange = t[0]
      url = construct_url(exchange, t[1], t[2])
      r = requests.get(url)
      price = r.json()
      prices.append([exchange, float(price[sym2])])
	  
    # Sort and print
    prices.sort()
    i = 0
    while i < len(prices):
      print(prices[i][0], prices[i][1] / prices[len(prices) - 1][1])
      i = i + 1

except Exception as e:
    print("exception ", e)
