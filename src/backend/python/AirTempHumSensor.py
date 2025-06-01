import adafruit_dht
from board import *
import RPi.GPIO as GPIO

pin = D2

dht22 = adafruit_dht.DHT22(pin, use_pulseio=False)

class AirTempHumSensor:

    def getTemperature(self):
        try:
            return dht22.temperature
        except:
            return "false"

    def getHumidity(self):
        try:
            return dht22.humidity
        except:
            return "false"