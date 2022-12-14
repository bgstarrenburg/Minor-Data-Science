import numpy as np
import pandas as pd
from scipy import stats
from ml import TrainModel
from utils import loadFromJSON
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
import seaborn as sns

allStates = loadFromJSON('D:\\Github\\Minor-Data-Science\\data\\allStates.json')
allData = loadFromJSON('D:\\Github\\Minor-Data-Science\\data\\parsedData.json')
allDataByStates = dict()
allScores = []

for i in range(0, len(allStates)):
    allDataByStates[allStates[i]] = pd.DataFrame(allData[i])

# try to create 1 model for all States
bigX = pd.DataFrame()
bigY = pd.DataFrame()

# allColumns = ['Amount of Homeless People', 'Average Income', 'Population', 'Rental vacancy rates',
#               'Rent prices', 'Housing Units', 'Unemployment', 'Federal Funding', 'Federal Funding PH']

columnsToUse = ['Population',  'Federal Funding PH']


columnsFor3dFigure = ['Population', 'Federal Funding PH',
                      'Amount of Homeless People']


allData = pd.DataFrame()
#columnsToUse  = ['Federal Funding PH']

for state in allStates:
    stateData = allDataByStates[state]
    allData = pd.concat([allData, stateData[columnsFor3dFigure]])
    sX = stateData.drop("Amount of Homeless People", axis=1)
    sY = stateData["Amount of Homeless People"]
    bigX = pd.concat([bigX, sX], axis=0)
    bigY = pd.concat([bigY, sY], axis=0)

# single variable plot + score
score = TrainModel("All", bigX, bigY, 0.2, 5, False, columnsToUse)


x1 = allData['Federal Funding PH']
y1 = allData['Amount of Homeless People']
z1 = allData['Population']
sns.set_style("darkgrid")
plt.figure(figsize=(5, 4))
plot_axes = plt.axes(projection="3d")
plot_axes.scatter(x1, y1, z1)
plot_axes.set_xlabel('Federal Funding PH')
plot_axes.set_ylabel('Amount of Homeless People')
plot_axes.set_zlabel('Population')
plot_axes.set_title(
    "Multivariate Linear Regression with an score of " + str(score))
plt.show()
# sns.pairplot(allData)

plt.scatter(z1, x1)
plt.show()
# 3D plot

print()
# State HI for
