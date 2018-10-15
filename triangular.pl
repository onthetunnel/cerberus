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

    # Get all currency pairs for all exchanges
    currency_pairs = []
    for exchange in all_coins:
      for from_symbol in all_coins[exchange]:
        for to_symbol in all_coins[exchange][from_symbol]:
          currency_pairs.append([exchange, from_symbol, to_symbol])

    print(len(currency_pairs), "currency pairs listed across all exchanges")

    # Extract the viable entry and exit points for our trade
    entry_currency = "GBP"
    exit_currency = "INR"
    entry_points = []
    exit_points = []
    for trade in currency_pairs:
      exchange = trade[0]
      from_symbol = trade[1]
      to_symbol = trade[2]

      # Store entry points and get spot
      if to_symbol == entry_currency:
        trade.append(get_spot(exchange, from_symbol, to_symbol))
        entry_points.append(trade)

      # Store exit points and get spot
      if to_symbol == exit_currency:
        trade.append(get_spot(exchange, from_symbol, to_symbol))
        exit_points.append(trade)

    print("got prices")
    print(len(entry_points), "entry points")
    print(len(exit_points), "exit points")

    # Arbitrage
    arbitrage = []
    for trade in entry_points:
      exchange = trade[0]
      from_symbol = trade[1]
      to_symbol = trade[2]
      for to_trade in exit_points:
      	if to_trade[1] == trade[1]:
          arbitrage.append([to_trade[3] / trade[3], exchange, to_symbol,
                          to_trade[0], to_trade[2]])

    # Sort and report
    print("\nARBITRAGE")
    arbitrage.sort()
    for trade in arbitrage:
      print(trade)

except Exception as e:
    print("exception ", e)
