#!/usr/bin/python3

import json
import requests

try:

    print("strict graph {")
    print("node [style=filled fillcolor=\"#008080\" color=white fontcolor=white fontname=helvetica]")

    # Get all pairs from all exchanges
    url = 'https://min-api.cryptocompare.com/data/all/exchanges'
    r = requests.get(url)
    exchanges = r.json();

    for name in exchanges:
      for from_symbol in exchanges[name]:
         for to_symbol in exchanges[name][from_symbol]:
           print (name + " -- \"" + from_symbol + "-" + to_symbol + "\"")

    print("}")

except Exception as e:
    print("exception ", e)
