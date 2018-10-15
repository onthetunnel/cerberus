#!/usr/bin/python3

import json
import requests

def construct_url(exchange, from_symbol, to_symbol):
  url = "https://min-api.cryptocompare.com/data/price?"
  url += "e=" + exchange
  url += "&fsym=" + from_symbol
  url += "&tsyms=" + to_symbol
  return url

try:

    # Get all pairs from all exchanges
    url = 'https://min-api.cryptocompare.com/data/all/exchanges'
    r = requests.get(url)
    all_coins = r.json()

    entry_currency = "HRK"
    exit_currency = "GBP"

    # Construct a list of URLs for the currency pair we're interested in
    currency_pairs = []
    for exchange in all_coins:
      for from_symbol in all_coins[exchange]:
        for to_symbol in all_coins[exchange][from_symbol]:
          currency_pairs.append([exchange, from_symbol, to_symbol])

    print(len(currency_pairs), "currency pairs")

    entry_points = []
    exit_points = []
    for pair in currency_pairs:
      if pair[2] == entry_currency:
        entry_points.append(pair)
      if pair[2] == exit_currency:
        exit_points.append(pair)

    print(len(entry_points), "entry points")
    for trade in entry_points:
      url = construct_url(trade[0], trade[1], trade[2])
      r = requests.get(url)
      price = r.json()
      print(trade, price)

    print(len(exit_points), "exit points")
    for trade in exit_points:
      url = construct_url(trade[0], trade[1], trade[2])
      r = requests.get(url)
      price = r.json()
      print(trade, price)

    # Get latest rates
    # prices = []
    # for t in trades:
    #   exchange = t[0]
    #   url = construct_url(exchange, t[1], t[2])
    #   r = requests.get(url)
    #   price = r.json()
    #   prices.append([exchange, float(price[sym2])])
    #       
    # # Calculate exchange ratios between exchanges
    # i = 0
    # ri = len(prices) - 1
    # rates = []
    # while i < len(prices):
    #   rates.append([prices[i][1] / prices[ri][1], prices[i][0]
    #                   + " > " + prices[ri][0]])
    #   i = i + 1
    #   ri = ri - 1

    # # Sort and report
    # rates.sort()
    # for r in rates:
    #   print(r[0], "\t", r[1])

except Exception as e:
    print("exception ", e)
