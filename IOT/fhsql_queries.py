from __future__ import print_function
from datetime import date, datetime, timedelta
import mysql.connector
import random
import time

cnx= mysql.connector.connect(user='root', password='mynewpassword', host='localhost', database='HUCKE_IOTDATABASE')
cursor= cnx.cursor()
for y in range(10):
    for x in range(20):
        farenheit= random.uniform(0.0, 200.0)
        celcius=(farenheit - 32)/1.8
        date=datetime
        #define in or out of loop?


        addData=("INSERT INTO TEMPERATURE_READINGS(Device_ID, TEMPERATURE_FAR, TEMPARATURE_CEL, INSERT_DATE) VALUES (\'%d\',%f,%f,\'%s\') " % (y, farenheit, celcius, 'datetime') )

        cursor.execute(addData)
        cnx.commit()
        time.sleep(10)


cursor.close()
cnx.close()
#mysql -u root -p
#password - mynewpassword
#168.27.118.249
