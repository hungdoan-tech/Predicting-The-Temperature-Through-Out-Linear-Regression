import pyrebase
from pandas import DataFrame

config = {
    "apiKey": "AIzaSyDTB2GhjB30hv3Tf_7pDu-N62UleYRSBaMx",
    "authDomain": "atest-581aa.firebaseapp.com",
    "databaseURL": "https://atest-581aa.firebaseio.com",
    "projectId": "atest-581aa",
    "storageBucket": "atest-581aa.appspot.com",
    "messagingSenderId": "574562633003",
    "appId": "1:574562633003:web:65bbe5af0cb7863634f16e",
    "measurementId": "G-8E2FMPQZ7Z",
    "serviceAccount": "./atest-581aa-firebase-adminsdk-brvvn-14dbf013e5.json"
    }

def FetchData(firstColumn, secondColumn):
    # initialize firebase object through out config variable and doing some authorization things
    firebase = pyrebase.initialize_app(config)
    firebase.auth()
    
    # Get data from folder Data from our database 
    db = firebase.database()
    data = db.child("Data").get()
    dataValue = data.val()
    # print(dataValue)
    
    # Convert data to a matrix type object
    dffirebase = DataFrame(dataValue)
    transpose = dffirebase.transpose()  
    #transpose.reset_index(drop=True, inplace=True)
    
     # Remove whatever row that has all values are Na
    transpose.dropna(how='all',inplace = True)
    #  Fill any each Na value with a average value in each column  
    transpose[firstColumn].fillna(transpose[firstColumn].mean(),inplace=True)
    if secondColumn != None:
        transpose[secondColumn].fillna(transpose[secondColumn].mean(),inplace=True)
    
    # Return a matrix object with "temperature" column is cleaned  
    return transpose


def FetchLastDataFromRealtimeDB(firstColumn,secondColumn):
    if secondColumn != None:
        df = FetchData(firstColumn, secondColumn)
        df[firstColumn] = [float(i) for i in df[firstColumn]]
        df[secondColumn] = [float(i) for i in df[secondColumn]]
        firstLastValue = df[firstColumn][-1:]
        secondLastValue = df[secondColumn][-1:]
        return firstLastValue[0],secondLastValue[0]
    else:
        df = FetchData(firstColumn, None)
        df[firstColumn] = [float(i) for i in df[firstColumn]]
        firstLastValue = df[firstColumn][-1:]
        return firstLastValue[0]




