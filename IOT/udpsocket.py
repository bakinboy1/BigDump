import socket
import sys

#create the socket
sock= socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#bind socket to port
serverAddress=('192.168.0.10', 40001)
print >> sys.stderr, 'starting up on %s port %d' % serverAddress
sock.bind(serverAddress)

while True:
    print >> sys.stderr, '\nwaiting to recieve message'
    data, address =sock.recvfrom(20)
    print >> sys.stderr, '\nrecieved %s bytes from %s' %(len(data), address)
    print >> sys.stderr, data
