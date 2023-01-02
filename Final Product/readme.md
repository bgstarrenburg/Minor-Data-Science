# HOW TO RUN THIS PROJECT.

### This project consists of 3 folders.

#### 1. data

This folder contains all used data files + parsed data ouput from the R-project.

#### 2. R-Project

This folder contains our R-Project. In this project data is fetched (and processed) into a final list which is outputted in `~/data/parsedData.json`.

To run this project open the `.rproj` and run `main.R`.

#### 3. Python-Project

This folder contains our Python-Project. In this project data is fetched from `~/data/parsedData.json`, which is created by the R-Project. We use this data to train the model and make the end user able to predict new values.

The independent values the user will have to input are:

1. Average Income
2. Population
3. Rent prices
4. Housing Units
5. Unemployment
6. Federal Funding

To run this project open the python folder in an IDE using Anaconda and run `main.py`. Or run it directly using anaconda prompt in the current directory with `python main.py`.
