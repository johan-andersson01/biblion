#!/usr/bin/python3
import requests
import datetime
import time

while True:
    hour = datetime.datetime.now().hour
    if hour > 7:
        requests.get('https://biblion.se')
    time.sleep(60*29)