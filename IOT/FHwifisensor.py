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
serverAddress=('192.168.0.10', 10011)
print (sys.stderr, 'starting up on %s port %d' % serverAddress)
sock.bind(serverAddress)

while True:
    print (sys.stderr, '\nwaiting to recieve message')
    data, address =sock.recvfrom(30)
    print (data)
    print (sys.stderr, '\nrecieved %s bytes from %s' %(len(data), address))
    print (sys.stderr, data)
    temp, flame, mode= data.split(' ',2)
    cnx= mysql.connector.connect(user='root', password='mynewpassword', host='localhost', database='GROUPONE')
    cursor= cnx.cursor()


    deviceID='FHarduino'

    insertDate = datetime.now().strftime("%y-%m-%d-%H:%M")
        #define in or out of loop?


    addData=("INSERT INTO FHsensors(Device_ID, FLAME, TEMP, MODE, INSERT_DATE) VALUES (\'%s\',%f,%f,\'%s\',\'%s\') " % (deviceID, float(flame), float(temp), mode, insertDate) )

    cursor.execute(addData)
    cnx.commit()
    time.sleep(10)
    cursor.close()
cnx.close()
#mysql -u root -p
#password - mynewpassword
#168.27.118.249
