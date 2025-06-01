import glob
import threading
from picamera import PiCamera
import time

lock = threading.Lock()


class CameraSensor:
    camera = PiCamera()
    def takePicture(self):
        lock.acquire()
        t = time.time()
        self.camera.capture("/home/pi/Desktop/project/22w-me-teamd/backend/python/pictures/"+ str(int(t)) +".jpg")
        lock.release()


    def getLastPicturePath(self):
        lock.acquire()
        extensionList = glob.glob("/home/pi/Desktop/project/22w-me-teamd/backend/python/pictures/*.jpg")
        noneExtensionList = []
        for n in extensionList:
            image_name = n.rsplit('/', 1)[-1]
            size = len(image_name)
            mod_string = image_name[:size - 4]
            noneExtensionList.append(int(mod_string))
        latestPicture = max(noneExtensionList)
        lock.release()
        return "/home/pi/Desktop/project/22w-me-teamd/backend/python/pictures/" + str(latestPicture) + ".jpg"