from matplotlib import pyplot as plt
from pandas import DataFrame
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split


def TrainModel(
    state: str,
    X: DataFrame,
    Y: DataFrame,
    test_size: int,
    random_state: int,
    visualise: bool,
    columnsToUse: any
) -> int:
    LR = LinearRegression()
    X_train, X_test, y_train, y_test = train_test_split(
        X, Y, test_size=test_size, random_state=random_state)
    LR = LR.fit(X_train[columnsToUse], y_train)
    print(state + " | " + str(LR.score(X_test[columnsToUse], y_test)))

    if (visualise == True):
        y_pred = LR.predict(X_test[columnsToUse])
        # plt.scatter(X_test["Federal Funding PH"], y_pred, color='b')
        plt.scatter(y_test, y_pred, color='k')
        plt.show()
    return LR.score(X_test[columnsToUse], y_test)
