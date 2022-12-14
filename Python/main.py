import numpy as np
import pandas as pd
from scipy import stats
from sklearn.metrics import accuracy_score, r2_score
from ml import TrainModel
from utils import loadFromJSON
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt

allStates = loadFromJSON('../data/allStates.json')
allData = loadFromJSON('../data/parsedData.json')
allDataByStates = dict()
allScores = []

for i in range(0, len(allStates)):
    allDataByStates[allStates[i]] = pd.DataFrame(allData[i])

# try to create 1 model for all States
bigX = pd.DataFrame()
bigY = pd.DataFrame()
#allColumns = ['Amount of Homeless People', 'Average Income', 'Population', 'Rental vacancy rates', 'Rent prices', 'Housing Units', 'Unemployment', 'Federal Funding PH']
columnsToUse = ['Population', 'Federal Funding PH']
#columnsToUse  = ['Federal Funding PH']

for state in allStates:
    stateData = allDataByStates[state]
    sX = stateData.drop("Amount of Homeless People", axis=1)
    sY = stateData["Amount of Homeless People"]
    bigX = pd.concat([bigX, sX], axis=0)
    bigY = pd.concat([bigY, sY], axis=0)


if (True):
    TrainModel("All", bigX, bigY, 0.2, 5, False, columnsToUse)

# try to get a model for each state
if (True):
    for state in ["GA"]:  # allStates:
        X = allDataByStates[state][columnsToUse]
        y = allDataByStates[state]["Amount of Homeless People"]
        # remove outliers
        for c in columnsToUse:
            z = np.abs(stats.zscore(X[c]))
            threshold = 3  # (sd)
            outlierMask = (z < threshold)
            X = X[outlierMask]
            y = y[outlierMask]

        allScores.append(
            [state, TrainModel(state, X, y, 0.2, 5, True, columnsToUse)])

# create models where data is split by population range
if (False):
    ranges = [[0, 3000000], [3000000, 6000000],
              [6000000, 9000000], [9000000, 999999999999]]
    for range in ranges:
        mask = (bigX['Population'] > range[0]) & (
            bigX['Population'] <= range[1])
        X = bigX[mask]
        bigX[~mask]
        bigY[~mask]
        y = bigY[mask]

        # remove outliers
        for c in columnsToUse:
            z = np.abs(stats.zscore(X[c]))
            threshold = 3  # (sd)
            outlierMask = (z < threshold)
            X = X[outlierMask]
            y = y[outlierMask]

        s = str(range[0]) + " - " + str(range[1])
        allScores.append([s, TrainModel(s, X, y, 0.2, 5, False, columnsToUse)])

#[[0, 1000000], [1000000, 5000000], [5000000, 9000000], [9000000, 999999999999]]
# all factors
# All | 0.7503309718821245
# 0 - 1000000 | 0.9677394947994445
# 1000000 - 5000000 | 0.5162783444117274
# 5000000 - 9000000 | 0.6965535608057232
# 9000000 - 999999999999 | 0.8921366801874476

#[[0, 1000000], [1000000, 5000000], [5000000, 9000000], [9000000, 999999999999]]
# without removing z-scores > 3
# All | 0.7503309718821245
# 0 - 1000000 | 0.9677394947994445
# 1000000 - 5000000 | 0.20196828662503197
# 5000000 - 9000000 | 0.6457261959635396
# 9000000 - 999999999999 | 0.8470898477216017

#[[0, 1000000], [1000000, 3000000], [3000000, 6000000], [6000000, 9000000], [9000000, 999999999999]]
# All | 0.7503309718821245
# 0 - 1000000 | 0.9677394947994445
# 1000000 - 3000000 | 0.3734936563674738
# 3000000 - 6000000 | 0.5986859297453284
# 6000000 - 9000000 | 0.8745232707586041
# 9000000 - 999999999999 | 0.8921366801874476


print()
