#!/usr/bin/python3

import json
import requests

try:

    # Get all pairs from all exchanges
    url = 'https://min-api.cryptocompare.com/data/all/exchanges'
    r = requests.get(url)
    exchanges = r.json()

    results = []
    sym1 = "BTC"
    sym2 = "EUR"

    # Look for exchange that offer the pairs we're interested in
    for name in exchanges:
      for from_symbol in exchanges[name]:
        found1 = False
        found2 = False
        for to_symbol in exchanges[name][from_symbol]:
          if to_symbol == sym1: found1 = True
          if to_symbol == sym2: found2 = True

          # If we've found them all then jump to next pair
          if found1 and found2:
            results.append([name, from_symbol, sym1])
            results.append([name, from_symbol, sym2])
            break

    # Dump the results
    # print("Results " + str(len(results)))
    from_symbols = set()
    to_symbols = sym1 + "," + sym2
    for trade in results:
    # print (trade[0] + "\t" + trade[1] + "\t" + trade[2])
      from_symbols.add(trade[1])

    url = "https://min-api.cryptocompare.com/data/pricemulti?fsyms="
    for sym in from_symbols:
            url += sym + ","
            
    url += "&tsyms=" + to_symbols
    # print(url)
    r = requests.get(url)

    matrix = r.json();

    for coin in matrix:
      print(coin, end=" ")
      for price in matrix[coin]:
        print(matrix[coin][price], end=" ")
      print("")

except Exception as e:
    print("exception ", e)
