#!/usr/bin/python2

""" Sends a get request to https://biblion.se every 29 minutes 
from 08:00-00:00 in order to prevent dyno sleeping.
"""
import requests
import datetime
import time

while True:
    if datetime.datetime.now().hour > 7:
        requests.get('https://biblion.se')
    time.sleep(60*29)