#!/usr/bin/python2
import requests
import datetime
import time

while True:
    if datetime.datetime.now().hour > 7:
        requests.get('https://biblion.se')
    time.sleep(60*29)