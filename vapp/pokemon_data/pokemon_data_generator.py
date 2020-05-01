import json

poke_data_json = dict()

with open("pokemon.csv", "r") as poke:
    poke_data_json = dict()
    count = 0
    headings = list()
    records = dict()
    for line in poke:
        if count == 0:
            headings = line.strip().split(",")
        else:
            records[count] = line.strip().split(",")
        count += 1
    name_index = headings.index("name")
    for elem in records.values():
        poke_name = elem[name_index]
        poke_data_json[poke_name] = dict()
        for key, val in zip(headings, elem):
            poke_data_json[poke_name][key] = val

with open("pokemon.json", "w") as poke:
    poke.write(json.dumps(poke_data_json))