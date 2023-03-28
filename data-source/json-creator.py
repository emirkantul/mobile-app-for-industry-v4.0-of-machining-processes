import pandas as pd
import numpy as np
import json

with open('./sample/AL7075_chatter_sound_vibro_t_003.lvm', 'r') as f:
    d = f.readlines()
    data = [line.split('\t') for line in d]

data_array = []
for row in data:
    inner = []
    for d in row:
        inner.append(float(d.rstrip('\n')))
    data_array.append(inner)

np_array = np.array(data_array)

# enter data shrink factor. This takes the average of every n points and displays it in JSON.
data_shrink_factor = 1000

time = np_array[:, 0]
sound = np_array[:, 1]
vibration = np_array[:, 2]

for i in range(len(vibration)):
    vibration[i] = round(vibration[i]/1000, 4)

json_dict = []

soundSum = 0
vibrationSum = 0

for i in range(len(time)):
    if(i%data_shrink_factor == 0):
        soundSum = round((soundSum + sound[i]) / data_shrink_factor , 4)
        vibrationSum = round((vibrationSum + vibration[i]) / data_shrink_factor , 4)
        x = {
            "time": time[i],
            "sound": soundSum,
            "vibration": vibrationSum,
        }
        json_dict.append(x)
        soundSum = 0
        vibrationSum = 0
    else:
        soundSum += sound[i]
        vibrationSum += vibration[i]

json_result = json.dumps(json_dict, indent=2)

r = open('./results/chatter_sound_vibro_t_003.txt', "x")
r.write(json_result)
r.close
