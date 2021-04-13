import sys
import socket
import subprocess
from datetime import datetime

# Clear the screen
subprocess.call('clear', shell=True)

#Define target

if len(sys.argv) == 2:
  	target = socket.gethostbyname(sys.argv[1]) #Translate hostname to IPV4
else:
	print("Invalid amount of arguments.")
	print("Syntax: python3 port_scanner.py <ip>")


#Add banner
print("-" * 50)
print("Scanning target " +target)
print("Time started: "+str(datetime.now()))
print("-" * 50)

# Check what time the scan started
t1 = datetime.now()

try:
	for port in range(50,6000):
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
		socket.setdefaulttimeout(1)
		result = s.connect_ex((target,port)) #return an error indicator
		if result == 0:
			print("Port {} is open".format(port))
		s.close()

except KeyboardInterrupt:
	print("\nExiting Program.")
	sys.exit()

except socket.error:
	print("Couldn't connect to server.")
	sys.exit()

except socket.gaierror:
	print("Hostname could not be resolved.")
	sys.exit()

# Checking the time again
t2 = datetime.now()

# Calculates the difference of time, to see how long it took to run the script
total =  t2 - t1

# Printing the information to screen
print ('Scanning Completed in:', total)
