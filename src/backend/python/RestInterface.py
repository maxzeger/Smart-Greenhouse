from datetime import datetime, timedelta
import threading
import time
from flask import Flask, jsonify, request
import base64 
from flask_restx import Api, Resource, reqparse

import CameraSensor as camera
from DatabaseAccessor import DatabaseAccessor
from PumpActor import PumpActor
from AirTempHumSensor import AirTempHumSensor
from SensorManager import SensorActorManager
from MoistureSensor import MoistureSensor
from DataSet import DataSet


app = Flask(__name__)
api = Api(app, doc='/', title='smart greenhouse API doc')

env_parser = reqparse.RequestParser()
env_parser.add_argument('Water Duration', type=int)
env_parser.add_argument('Interval time', type=int)

cameraSensor = camera.CameraSensor()
pump = PumpActor()
databaseAccessor = DatabaseAccessor()
airTempHumSensor = AirTempHumSensor()
moistureSensor = MoistureSensor() 
manager = SensorActorManager(pump, airTempHumSensor, moistureSensor)

water_duration = 3
control_interval = 60

@api.route('/getImage')
class Images(Resource):
    def get(self):
        cameraSensor.takePicture()
        filename = cameraSensor.getLastPicturePath()
        with open(filename, "rb") as image_file:
            encoded_img = base64.b64encode(image_file.read())
        final_b64_string = encoded_img.decode('utf-8')
        return final_b64_string
        

@api.route('/setEnv')
class Env(Resource):
    @api.doc(parser=env_parser)
    def post(self):
        global water_duration
        global control_interval
        water_duration_env = request.json["duration"]
        control_interval_env = request.json["interval"]
        water_duration = water_duration_env
        control_interval = control_interval_env
        return ('', 204)


@api.route('/getTSH')
class Tsh(Resource):
    def get(self):
        result = databaseAccessor.get_last_entry()
        data = {"humidity" : int(result.humidity),
                "soilMoisture" : int(result.moisture),
                "temperature" : int(result.temperature),
                }
        return jsonify(data)


@api.route('/getActions')
class Actions(Resource):
    def get(self):
        resultList = databaseAccessor.get_all_actions()
        dicList = []
        for x in resultList:
            dic = {"duration" : str(3),
                    "timeStamp" : x,}
            dicList.append(dic)
        return jsonify({"actions": dicList})

    
    def post(self):
        global water_duration
        pump.startPump()
        databaseAccessor.save_action()
        time.sleep(water_duration)
        pump.stopPump()


@api.route('/getMeasurements')
class Measurements(Resource):
    def get(self):
        resultList: list[DataSet] = databaseAccessor.get_all_entries()
        dicList = []
        for x in resultList:
            dic = {"temperature" : int(x.temperature),
                    "soilMoisture" : int(x.moisture),
                    "humidity" : int(x.humidity),
                    "timeStamp" : str(x.Timestamp),}
            dicList.append(dic)
        return jsonify({"measurements": dicList})


def controller():
    global water_duration
    global control_interval
    while True:
        timeInThreeMin = datetime.now() + timedelta(seconds=control_interval)
        while True:
            data = manager.readSensors()
            if data.moisture < 40 and datetime.now() < timeInThreeMin:
                pump.startPump()
                databaseAccessor.save_action()
                time.sleep(water_duration)
                pump.stopPump()
            elif data.moisture < 40 and datetime.now() >= timeInThreeMin:
                pump.startPump()
                databaseAccessor.save_action()
                time.sleep(water_duration)
                pump.stopPump()
                databaseAccessor.save_sensors(data)
                break
            elif data.moisture > 40 and datetime.now() >= timeInThreeMin:
                databaseAccessor.save_sensors(data)
                break
            

def api_runner():
    app.run(host="0.0.0.0", port=5050)


if __name__ == "__main__":
    pump.stopPump()
    api_thread = threading.Thread(target=api_runner)
    controller_thread = threading.Thread(target=controller)
    api_thread.start()
    controller_thread.start()