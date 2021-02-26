# whatsapp-parser

Simple program to parse message logs exported from whatsapp using Haskell and Parsec

# Converting to JSON

```sh
stack run <WHATSAPP_LOG> >> output.json
```

# Import data in python

```python
import json
import pandas as pd

with open("output.json") as data_file:
    data = json.load(data_file)

df = pd.json_normalize(data)
df["date"] = pd.to_datetime(dict(year=df["date.year"],
                    month=df["date.month"],
                    day=df["date.day"],
                    hour=df["time.hour"],
                    minute=df["time.minute"]))
```
