import RPi.GPIO as GPIO
import pygame
from time import sleep

channels = [8, 10, 12, 16, 18, 22]

animals = ["trilobite", "hyracotherium", "mastodon", "pterosaur", "sabertoothcat", "cardinal"]

pygame.mixer.init()

pygame.mixer.music.set_volume(1)


def button_callback(channel):
    print(channel)
    if not pygame.mixer.music.get_busy():
        pygame.mixer.music.stop()
        pygame.mixer.music.load("/home/pi/great_parks/" + animals[channels.index(channel)] + ".mp3")        
        pygame.mixer.music.play()

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)

for i in channels:
    print("current channel", i)
    GPIO.setup(i, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    GPIO.add_event_detect(i, GPIO.RISING, callback=button_callback)

# message = input("press enter to quit\n\n")

while True:
    sleep(10)

GPIO.cleanup()
