import RPi.GPIO as GPIO

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(4, GPIO.OUT)

class PumpActor:

    def startPump(self):
        GPIO.output(4, GPIO.HIGH)

    def stopPump(self):
        GPIO.output(4, GPIO.LOW)