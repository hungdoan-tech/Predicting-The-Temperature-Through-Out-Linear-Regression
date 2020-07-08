import pandas as pd
from scipy import stats
import FetchData as lib
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

def PredictTemperatureWithOneVariale(firstColumn):
    # Fetch data from the realtime database as a matrix object
    df = lib.FetchData(firstColumn, None)
    # Get the column named temperature to a list 
    dt_list = df[firstColumn].tolist()
    #df_Humid = df[columnx].tolist()
    # Convert each value in that list to float type
    dt_list = [float(i) for i in dt_list]
    #dt_listx = [float(i) for i in df_Humid] 
    # Calulate the right value for 80% data we need to train
    size_tran = int((len(df) * 0.8))
    # Create a dataframe object
    df_model = pd.DataFrame()
    # Create a column's named x with values fetch from 0th to 80% of data th  
    df_model['x'] = dt_list[:size_tran-1] 
    # Create a column's named x with values fetch from 1th to 80% of data th   
    df_model['y'] = dt_list[1:size_tran]
    # Frint out the new model which is in matrix type
    # print(df_model)
    # Calculating a,b parameters through Linear Regression. The outputs are a and b params
    slope,intercept,r,p,std_err = stats.linregress(df_model['x'], df_model['y'])
    # That is a param
    print(slope)
    # That is b param
    print(intercept)
    # That is error % value 
    print(std_err)
    return (dt_list,size_tran,slope,intercept,std_err)

def PredictTemperatureWithTwoVariale(firstColumn, secondColumn):
    # Fetch data from the realtime database as a matrix object
    df = lib.FetchData(firstColumn, secondColumn)
    # Get the column named temperature to a list 
    dt_firstList = df[firstColumn].tolist()
    dt_secondList = df[secondColumn].tolist()
    # Convert each value in that list to float type
    dt_firstList = [float(i) for i in dt_firstList]
    dt_secondList = [float(i) for i in dt_secondList] 
    # Calulate the right value for 80% data we need to train
    size_tran = int((len(df) * 0.8))
    # Create a dataframe object
    df_model = pd.DataFrame()
    # Create a column's named x with values fetch from 0th to 80% of first column data 
    df_model['x'] = dt_firstList[:size_tran-1] 
    # Create a column's named y with values fetch from 1th to 80% of first column data  
    df_model['y'] = dt_firstList[1:size_tran]
    # Create a column's named z with values fetch from 0th to 80% of second column data
    df_model['z'] = dt_secondList[:size_tran-1]
    
    X = df_model.drop('y', axis = 1)
    Y = df_model['y']
    lm = LinearRegression()
    lm.fit(X, Y)   
    a,b = lm.coef_
    c = lm.intercept_
    # Frint out the new model which is in matrix type
    # print(df_model)
    print(a)
    print(b)
    print(c)
    return (dt_firstList,dt_secondList,size_tran,a,b,c)

def Testing(dt_list,a,b,size_tran):
    # Create a dataframe object
    df_test = pd.DataFrame()
    # Create a column's named x with values fetch from 20% data for testing   
    df_test['x'] = dt_list[size_tran-1:-1]
    # Create a column's named y with values fetch from 20% data for testing 
    df_test['y'] = dt_list[size_tran:]
    # Check manually what formula is right ?
    # Drawing each point in the coordinates with each x y value in each 20% data for testing 
    plt.scatter(df_test['x'],df_test['y'])
    # Drawing the line represent for many x y value in each x we can calculate the y through out a , b params that we fetch from CalculatingParameterForTheRightFormula module 
    plt.plot(df_test['x'],fx(df_test['x'],a,b))
    # Show out the scatter and the plot for user to estimatingz
    plt.show()    
    # If right we can output the scope,intercept we just calculated 

def fx(x,a,b):
    return ((a*x) + b)

def f(x,y,a,b,c):
    return  (c + ((a*x)+(b*y)))

# dt_list,size_tran,slope,intercept,std_err = PredictTemperatureWithOneVariale("temperature")
# Testing(dt_list,slope,intercept,size_tran)
# print(fx(31,slope,intercept))

# dt_firstList,dt_secondList,size_tran,a,b,c = PredictTemperatureWithTwoVariale("temperature","humidity")
# print ('Predicted Temperature: ', f(31,80,a,b,c))


