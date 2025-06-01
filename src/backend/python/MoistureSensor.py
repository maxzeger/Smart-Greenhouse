import signal
import sys
import spidev
import RPi.GPIO as GPIO

spi_ch = 0

spi = spidev.SpiDev(0, spi_ch)
spi.max_speed_hz = 1200000

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

def get_adc(channel):
    if channel != 0:
        channel = 1

    msg = 0b11
    msg = ((msg << 1) + channel) << 5
    msg = [msg, 0b00000000]
    reply = spi.xfer2(msg)

    adc = 0
    for n in reply:
        adc = (adc << 8) + n

    adc = adc >> 1

    return adc

def valmap(value, istart, istop, ostart, ostop):
    value = ostart + (ostop - ostart) * ((value - istart) / (istop - istart) + ostart)
    if value > ostop:
        value = ostop
    return value

def close(signal, frame):
    sys.exit(0)

signal.signal(signal.SIGINT, close)

class MoistureSensor:

    def getSoilMoisture(self):
        try:
            adc_0 = get_adc(0)
            sensor1 = round(adc_0, 2)
            if sensor1 < 0.5:
                moisture1 = 0
                return moisture1
            else:
                moisture1 = round(valmap(sensor1, 475, 130, 0, 100), 0)
                return moisture1
        finally:
            pass