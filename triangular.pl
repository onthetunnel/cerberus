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

try:

    # Get all pairs from all exchanges
    url = 'https://min-api.cryptocompare.com/data/all/exchanges'
    r = requests.get(url)
    all_coins = r.json()

    entry_currency = "GBP"
    exit_currency = "EUR"
    entry_value = 1

    # Construct a list of URLs for the currency pair we're interested in
    currency_pairs = []
    for exchange in all_coins:
      for from_symbol in all_coins[exchange]:
        for to_symbol in all_coins[exchange][from_symbol]:
          currency_pairs.append([exchange, from_symbol, to_symbol])

    print(len(currency_pairs), "currency pairs")

    entry_points = []
    exit_points = []
    entry_coins = set()
    for pair in currency_pairs:
      if pair[2] == entry_currency:
        entry_points.append(pair)
        entry_coins.add(pair[1])
      if pair[2] == exit_currency:
        exit_points.append(pair)

    print(entry_coins, "entry coins")

    print(len(exit_points), "exit points")
    exchange_rates = []
    for trade in exit_points:
      if trade[1] in entry_coins:
        url = construct_url(trade[0], trade[1], trade[2])
        r = requests.get(url)
        price = r.json()
        exchange_value = entry_value / float(price[trade[2]])
        for entry in entry_points:
          if entry[1] == trade[1]:
            url = construct_url(entry[0], entry[1], entry[2])
            r = requests.get(url)
            price = r.json()
            exit_value = exchange_value * float(price[entry[2]])
            exchange_rates.append([exit_value,
                    str(entry_value) + " " + entry[2] + " > " + entry[0] + " > "
                    + entry[1] + " " +  str(entry_value / price[entry[2]]) + " " + 
                    " > " + trade[0] + " > " + trade[2]])

    print("got prices")

    exchange_rates.sort()
    for rate in exchange_rates:
      print(rate[0], "\t", rate[1])

except Exception as e:
    print("exception ", e)
