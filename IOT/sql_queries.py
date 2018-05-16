from __future__ import print_function
from datetime import date, datetime, timedelta
import mysql.connector
import random

cnx= mysql.connector.connect(user='root', password='mynewpassword', host='localhost', database='HUCKE_IOTDATABASE')
cursor= cnx.cursor()
for y in range(10):
    for x in range(20):
        farenheit= random.uniform(0.0, 200.0)
        celcius=(farenheit - 32)/1.8
        #define in or out of loop?
        addData="INSERT INTO IOT_DATASTORE(VARCHAR DEVICE_ID,FLOAT TEMPERATURE_FAR,FLOAT TEMPERATURE_CEL,DATETIME INSERT_DATE)"
        dataData=(y, farenheit, celcius, 'INSERT_DATE')
        cursor.execute(addData, dataData)
        cnx.commit()
        python.sleep(10)


cursor.close()
cnx.close()
