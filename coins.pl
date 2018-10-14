#!/usr/bin/python3

import json
import requests

try:

    # Get all pairs from all exchanges
    url = 'https://min-api.cryptocompare.com/data/all/exchanges'
    r = requests.get(url)
    exchanges = r.json()

    # Look for exchange that offer the pairs we're interested in
    for name in exchanges:
      for from_symbol in exchanges[name]:
        found1 = False
        found2 = False
        for to_symbol in exchanges[name][from_symbol]:
          if to_symbol == "BTC": found1 = True
          if to_symbol == "GBP": found2 = True

          # If we've found them all then jump to next pair
          if found1 and found2:
            print (name + "\t" + from_symbol)
            break

except Exception as e:
    print("exception ", e)
