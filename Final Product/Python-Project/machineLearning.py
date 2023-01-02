###########
# Imports #
###########

import json
from sklearn.linear_model import ElasticNet
from sklearn.model_selection import train_test_split
import pandas as pd

##########################
# Initializing variables #
##########################

print("initializing variables...")

allStates = ['AL', 'AK', 'AZ', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS',
             'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'UT', 'TX', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY']
allData = json.load(open('../data/parsedData.json'))
allDataByStates = dict()
allCombinedData = pd.DataFrame()

for i in range(0, len(allStates)):
    allDataByStates[allStates[i]] = pd.DataFrame(allData[i])

for state in allStates:
    stateData = allDataByStates[state]
    allCombinedData = pd.concat([allCombinedData, stateData], axis=0)

X = allCombinedData.drop("Amount of Homeless People", axis=1)
y = allCombinedData["Amount of Homeless People"]

#########################
# Training of the model #
#########################

def ElasticNetModel() -> ElasticNet:
    print("training model...")
    EN = ElasticNet(alpha = 2.0, l1_ratio=0.1, max_iter=3000)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.1, random_state=5)

    EN = EN.fit(X_train, y_train)
    
    print("training model done")
    print(": ".join(["created elastic net model with a score of", str(EN.score(X_test, y_test))]))
    return EN

#####################
# Predicting values #
#####################

def PredictValue(EN: ElasticNet, X_prediction: pd.DataFrame) -> int:
    y_prediction = EN.predict(X_prediction)
    return round(y_prediction[0])


##############################
# Look at head of all values #
##############################

def ShowHead():
    print(allCombinedData.head())
    print()

