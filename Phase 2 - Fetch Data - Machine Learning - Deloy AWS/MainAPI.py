from flask import Flask, jsonify
import CalculatingParameters as myCal
import FetchData as myFetch

app = Flask(__name__)
app.config["DEBUG"] = True

@app.route('/', methods=['GET'])
def getCurrentTemperature():
    currentTemp = myFetch.FetchLastDataFromRealtimeDB("temperature",None)
    return jsonify({'Current_Temperature' : currentTemp})

@app.route('/iot/<float:temperature>', methods=['GET'])
def getNextOneVariable(temperature):
    dt_list,size_tran,slope,intercept,std_err = myCal.PredictTemperatureWithOneVariale("temperature")
    return jsonify({'Next_Temperature' : myCal.fx(temperature,slope,intercept)})

@app.route('/iot2/<float:temperature>/<float:humidity>', methods=['GET'])
def getNextTwoVariable(temperature,humidity):
    dt_firstList,dt_secondList,size_tran,a,b,c = myCal.PredictTemperatureWithTwoVariale("temperature","humidity")
    return jsonify({'Next_Temperature' : myCal.f(temperature,humidity,a,b,c)})

@app.route('/autoiot', methods=['GET'])
def getNextOneVariableAuto():
    currentTemperature = myFetch.FetchLastDataFromRealtimeDB("temperature",None)
    dt_list,size_tran,slope,intercept,std_err = myCal.PredictTemperatureWithOneVariale("temperature")
    return jsonify({'Current_Temperature' : currentTemperature, 'Next_Temperature' : myCal.fx(currentTemperature,slope,intercept)})

@app.route('/autoiot2', methods=['GET'])
def getNextTwoVariableAuto():
    currentTemperature,currentHumidity = myFetch.FetchLastDataFromRealtimeDB("temperature","humidity")
    dt_firstList,dt_secondList,size_tran,a,b,c = myCal.PredictTemperatureWithTwoVariale("temperature","humidity")
    return jsonify({"Current_Temperature":currentTemperature,"Current_Humidity":currentHumidity,'Next_Temperature' : myCal.f(currentTemperature,currentHumidity,a,b,c)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='8090')