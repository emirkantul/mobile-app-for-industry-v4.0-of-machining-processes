import pandas as pd
import numpy as np
import json

with open('./sample/AL7075_chatter_sound_vibro_t_001.dat', 'r') as f:
    d = f.readlines()
    data = [line.split('\t') for line in d]

data_array = []
for row in data:
    inner = []
    for d in row:
        inner.append(float(d.rstrip('\n')))
    data_array.append(inner)

np_array = np.array(data_array)

# first try of plotting
time = np_array[:, 0]
sound = np_array[:, 1]
vibration = np_array[:, 2]

for i in range(len(vibration)):
    vibration[i] = round(vibration[i]/1000, 4)

json_dict = []

for i in range(len(time)):
    if(i%1000 == 0):
        x = {
            "time": time[i],
            "sound": sound[i],
            "vibration": vibration[i],
        }
        json_dict.append(x)

json_result = json.dumps(json_dict, indent=2)

r = open('./results/chatter_sound_vibro_t_001.txt', "x")
r.write(json_result)
r.close
