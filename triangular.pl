#!/usr/bin/python3

import json
import requests

def construct_url(exchange, from_symbol, to_symbol):
  url = "https://min-api.cryptocompare.com/data/price?"
  url += "e=" + exchange
  url += "&fsym=" + from_symbol
  url += "&tsyms=" + to_symbol
  print(".", end="", flush=True)
  return url

# Get the spot price for a trade
def get_spot(exchange, from_symbol, to_symbol):
      url = construct_url(exchange, from_symbol, to_symbol)
      r = requests.get(url)
      price = r.json()
      return float(price[to_symbol])

try:

    # Get all pairs from all exchanges
    url = 'https://min-api.cryptocompare.com/data/all/exchanges'
    r = requests.get(url)
    all_coins = r.json()

    # Construct a list of URLs for the currency pair we're interested in
    from_symbols = ["BTC", "ETH", "LTC", "ETC", "DASH"]
    currency_pairs = []
    for exchange in all_coins:
      for from_symbol in all_coins[exchange]:
        if from_symbol in from_symbols:
          for to_symbol in all_coins[exchange][from_symbol]:
            currency_pairs.append([exchange, from_symbol, to_symbol])

    print(len(currency_pairs), "currency pairs")

    entry_currency = "INR"
    exit_currency = "INR"
    entry_points = []
    exit_points = []
    for pair in currency_pairs:
      if pair[2] == entry_currency: entry_points.append(pair)
      if pair[2] == exit_currency: exit_points.append(pair)

    print("\nENTRY")
    for trade in entry_points: print(trade)

    print("\nEXIT")
    for trade in exit_points: print(trade)

    # Arbitrage
    arbitrage = []
    for trade in entry_points:
      exchange = trade[0]
      from_symbol = trade[1]
      to_symbol = trade[2]
      spot = get_spot(exchange, from_symbol, to_symbol)
      # print("ENTRY", trade, spot)
      for to_trade in exit_points:
      	if to_trade[1] == trade[1]:
          to_spot = get_spot(to_trade[0], to_trade[1], to_trade[2])
          # print("\t", to_trade, to_spot, spot / to_spot)
          arbitrage.append([spot / to_spot, exchange, to_symbol, to_trade[0],
                          to_trade[2]])

    # Sort and report
    print("\nARBITRAGE")
    arbitrage.sort()
    for trade in arbitrage:
      print(trade)

except Exception as e:
    print("exception ", e)
