from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from scipy import stats
from sklearn.preprocessing import StandardScaler 
from ml import TrainModel
from utils import loadFromJSON
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
 
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

####    load data  ######
allStates = loadFromJSON('D:\\Github\\Minor-Data-Science\\data\\allStates.json')
allData = loadFromJSON('D:\\Github\\Minor-Data-Science\\data\\parsedData.json')
allDataByStates = dict()
for i in range(0, len(allStates)):
    allDataByStates[allStates[i]] = pd.DataFrame(allData[i])


#allColumns = ['Amount of Homeless People', 'Average Income', 'Population', 'Rental vacancy rates', 'Rent prices', 'Housing Units', 'Unemployment', 'Federal Funding']
columnsToUse = ['Population', 'Federal Funding']
bigX = pd.DataFrame()
bigY = pd.DataFrame()
stateName = ""

def Logistic_Regression():
    for state in ["CA"]:
        stateName = state
        stateData = allDataByStates[state]
        bigX = stateData.drop('Amount of Homeless People', axis=1)
        bigY= stateData['Amount of Homeless People']

        x_train, x_test, y_train, y_test = train_test_split(bigX, bigY, test_size=0.2, random_state=1)

        logmodel = LogisticRegression()
        logmodel.fit(x_train, y_train)
        
        predictions = logmodel.predict(x_test)
        print(classification_report(y_test, predictions))
        print(f"{stateName}: ")
        print(confusion_matrix(y_test, predictions))
        print(accuracy_score(y_test, predictions))

        # sns.heatmap(pd.DataFrame(confusion_matrix(y_test,predictions)))
        # plt.show()


def K_neigbour():
    for state in allStates:
        stateName = state
        stateData = allDataByStates[state]
        bigX = stateData.drop('Amount of Homeless People', axis=1)
        bigY= stateData['Amount of Homeless People']

    # Split dataset into random train and test subsets:
    X_train, X_test, y_train, y_test = train_test_split(bigX, bigY, test_size=0.20, random_state=42) 

    # Standardize features by removing mean and scaling to unit variance:
    scaler = StandardScaler()
    scaler.fit(X_train)

    X_train = scaler.transform(X_train)
    X_test = scaler.transform(X_test) 

    # Use the KNN classifier to fit data:
    classifier = KNeighborsClassifier(n_neighbors=5)
    classifier.fit(X_train, y_train) 

    # Predict y data with classifier: 
    y_predict = classifier.predict(X_test)

    # Print results: 
    print(confusion_matrix(y_test, y_predict))
    print(classification_report(y_test, y_predict)) 
    print(f"{stateName}")


K_neigbour()