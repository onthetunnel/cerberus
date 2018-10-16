#!/usr/bin/env python3

import json
import requests

# Create a CryptoCompare URL from an exchange and a pair of symbols
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

    # Exchanges we're not interested in
    exchange_blacklist = ["MonetaGo", "Lykke", "CCEDK", "Zecoex", "ExtStock",
            "EthexIndia", "Quoine", "Yacuna", "BTCE", "Cryptsy", "Abucoins",
            "WEX", "Cexio", "CCEX", "Coinsetter", "Bitlish", "BTER"]

    # Get all currency pairs for all exchanges
    currency_pairs = []
    for exchange in all_coins:
      if exchange not in exchange_blacklist:
        for from_symbol in all_coins[exchange]:
          for to_symbol in all_coins[exchange][from_symbol]:
            currency_pairs.append([exchange, from_symbol, to_symbol])

    print(len(currency_pairs), "currency pairs listed across all exchanges")
    entry_currency = "INR"
    exit_currency = "GBP"
    print("Calculating exchange rates from", entry_currency, "to", exit_currency,
            "via 1 crypto currency")

    # Extract the viable entry and exit points for our trade
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

    # Arbitrage - loop over each entry point
    arbitrage = []
    for trade1 in entry_points:
      exchange1 = trade1[0]
      from1 = trade1[1]
      to1 = trade1[2]
      spot1 = trade1[3]

      # And compare with each exit point
      for trade2 in exit_points:
        exchange2 = trade2[0]
        from2 = trade2[1]
        to2 = trade2[2]
        spot2 = trade2[3]

        # Store if the trades share a common currency
        if from1 == from2:
          arbitrage.append([spot2 / spot1, to1, exchange1, from1, exchange2, to2])

    # Sort and report
    print("\nENTRIES")
    for entry in entry_points: print(entry)

    print("\nEXITS")
    for entry in exit_points: print(entry)

    print("\nARBITRAGE")
    arbitrage.sort()
    for trade in arbitrage:
      for x in trade:
        print(x, end="\t")
      print()

except Exception as e:
    print("exception ", e)
