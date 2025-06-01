import PumpActor as pumpActor
import AirTempHumSensor as airSensor
import MoistureSensor as moistureSensor
from DataSet import DataSet
from datetime import datetime

class SensorActorManager:

    def __init__(self, pumpActor: pumpActor, airSensor: airSensor, moistureSensor: moistureSensor):
        self.pumpActor = pumpActor
        self.airSensor = airSensor
        self.moistureSensor = moistureSensor
        

    def readSensors(self):
        controllFlag = True
        now = datetime.now()
        date_time = now.strftime("%Y-%m-%d %H:%M")
        while controllFlag:
            airTemp = self.airSensor.getTemperature()
            airHum = self.airSensor.getHumidity()
            moisture = self.moistureSensor.getSoilMoisture()
            if isinstance(airTemp, float) and isinstance(airHum, float) and (isinstance(moisture, float) or isinstance(moisture, int)):
                data = DataSet(date_time, airTemp, airHum, moisture)
                return data  