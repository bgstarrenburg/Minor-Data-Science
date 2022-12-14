from matplotlib import pyplot as plt
from pandas import DataFrame
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import statsmodels.formula.api as sm


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

    X.columns = ['Average_Income', 'Population', 'Rental_vacancy_rates', 'Rent_prices',
                 "Housing_Units", "Unemployment",  "Federal_Funding", "Federal_Funding_PH"]
    model = sm.ols(formula='Population ~ Federal_Funding_PH',
                   data=X).fit()
    print(model.summary())

    if (visualise == True):
        y_pred = LR.predict(X_test[columnsToUse])
        # plt.scatter(X_test["Federal Funding"], y_pred, color='b')
        plt.scatter(X["Federal Funding"], Y, color='k')
        plt.xlabel("Federal Funding")
        plt.ylabel("Amount of Homeless")
        plt.title("Correlation in State GA (Georgia)")
        plt.show()
    return LR.score(X_test[columnsToUse], y_test)
