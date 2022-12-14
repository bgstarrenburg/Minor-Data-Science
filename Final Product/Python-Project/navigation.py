import pandas as pd
import machineLearning
from sklearn.linear_model import ElasticNet

welcomeText = '''
###########################################
#                                         #
#        Welcome To Our Application       #
#    Project: War against homelessness    #
#               Team: Blue                #
#                                         #
###########################################
'''

description = 'In this application you will able to predict the amount of homeless people.'

requestedValues = {
    'Average Income': [0],
    'Population': [0],
    'Rental vacancy rates': [0],
    'Average Rent prices': [0],
    'Housing Units': [0],
    'Unemployment': [0],
    'Federal Funding': [0]
}

requestedValuesMetrics = {
    'Average Income': '$',
    'Rental vacancy rates': '%',
    'Average Rent prices': '$',
    'Federal Funding': '$'
}


def GetValues() -> pd.DataFrame:
    for s in requestedValues:
        if (requestedValuesMetrics.get(s) != None):
            c = requestedValuesMetrics[s]
            print("Please enter the value of [{0} (in {1})]: ".format(s, c))
        else:
            print("Please enter the value of [{0}]: ".format(s))
        vi = ValidateInput(input())
        while vi[0] == False:
            print(
                "Incorrect input, values have to be numeric and positive. Please try again.")
            vi = ValidateInput(input())
        requestedValues[s] = [vi[1]]
        print()
    return pd.DataFrame(requestedValues)


# return list will always be pair [bool, float]
def ValidateInput(i: str) -> list:
    try:
        if (float(i) >= 0):
            return [True, float(i)]
        return [False, -1]
    except:
        return [False, -1]


def MainNavigation(EN: ElasticNet):
    print(welcomeText)
    print()
    print(description)

    navigate = True
    while (navigate):
        print("Please select one of the following options.")
        print("Press <1> to predict new data.")
        print("Press <0> to exit.")

        vi = ValidateInput(input())
        while vi[0] == False or vi[1] not in [0, 1]:
            print(
                "Incorrect input, values have to be numeric, positive and either 0, 1 or 2. Please try again.")
            vi = ValidateInput(input())
        print()
        if (vi[1] == 0):
            navigate = False
        else:
            X_prediction = GetValues()
            y_prediction = machineLearning.PredictValue(EN, X_prediction)
            print(
                ": ".join(["The predicted amount of homeless people is", str(y_prediction)]))
            print()
