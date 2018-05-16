from __future__ import print_function
from datetime import date, datetime, timedelta
import mysql.connector
import time
from datetime import datetime
import socket
import sys

#create the socket
sock= socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#bind socket to port
serverAddress=('192.168.0.10', 40001)
print (sys.stderr, 'starting up on %s port %d' % serverAddress)
sock.bind(serverAddress)

while True:
    print (sys.stderr, '\nwaiting to recieve message')
    data, address =sock.recvfrom(20)
    print (sys.stderr, '\nrecieved %s bytes from %s' %(len(data), address))
    print (sys.stderr, data)

    cnx= mysql.connector.connect(user='root', password='mynewpassword', host='localhost', database='HUCKE_IOTDATABASE')
    cursor= cnx.cursor()


    deviceID='FHarduino'
    temperature, light= data.split(' ',1)
    insertDate = datetime.now().strftime("%y-%m-%d-%H:%M")
        #define in or out of loop?


    addData=("INSERT INTO FHsensors(Device_ID, SENSOR1_VAL, SENSOR2_VAL, INSERT_DATE) VALUES (\'%s\',%f,%f,\'%s\') " % (deviceID, float(light), float(temperature), insertDate) )

    cursor.execute(addData)
    cnx.commit()
    time.sleep(10)


cursor.close()
cnx.close()
#mysql -u root -p
#password - mynewpassword
#168.27.118.249
