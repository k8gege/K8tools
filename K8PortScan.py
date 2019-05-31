import socket, sys
import threading
import argparse
import time
##Code: https://github.com/k8gege/K8PortScan
##K8portScan 1.0
##Date: 20190530
##Author: K8gege
##Usage:
##IP (IP IP/24 IP/16 IP/8)
##
##python K8PortScan.py -ip 192.11.22.29
##python K8PortScan.py -ip 192.11.22.29 -p 80-89
##python K8PortScan.py -ip 192.11.22.29/24 -p 80,445,3306
##
##IPlist (ip.txt ip24.txt ip16.txt ip8.txt)
##python K8PortScan.py -f ip.txt
##python K8PortScan.py -f ip.txt -p 80-89
##python K8PortScan.py -f ip24.txt -p 80,445,3306
def getPortBanner(ip, p):
	try:
		port=int(p)
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		if port==3306 or port==22 or port==23 or port==1521:
			s.settimeout(5)
		else:
			s.settimeout(0.2)
		s.connect((ip, port))
		s.send('HELLO\r\n')
		#print ip+"\t"+p+" Open"
		print ip+"\t"+p+" Open\t"+s.recv(1024).split('\r\n')[0].strip('\r\n')
	except Exception as e:
		#print e
		pass
	finally:
		s.close()
def GetPortsBanner(ip,ports):
	for p in ports:
		#print p
		banner=getPortBanner(ip,str(p))
		# if banner!=None:
			# print ip+"\t"+banner
def CscanPortBanner(ip,ports): 
	if '/24' in ip:
		print 'ip/24: '+ip
		ipc = (ip.split('.')[:-1])
		for i in range(1,256):
			ip = ('.'.join(ipc)+'.'+str(i))
			threading._start_new_thread(GetPortsBanner,(ip,ports,))
			time.sleep(0.1)
	else:
		GetPortsBanner(ip,ports)
def BscanPortBanner(ip,ports): 
	if '/16' in ip:
		print 'ip/16: '+ip
		ipc = (ip.split('.')[:-2])
		for i in range(1,256):
			ip = ('.'.join(ipc)+'.'+str(i)+'.0/24')
			CscanPortBanner(ip,ports)
def AscanPortBanner(ip,ports): 
	if '/8' in ip:
		print 'ip/8: '+ip
		ipc = (ip.split('.')[:-3])
		for i in range(1,256):
			ip = ('.'.join(ipc)+'.'+str(i)+'.0/16')
			BscanPortBanner(ip,ports)
if __name__ == '__main__':
	print('K8PortScan 1.0')
	parser = argparse.ArgumentParser()
	parser.add_argument('-ip',help='IP or IP/24')
	parser.add_argument('-f', dest="ip_file", help="ip.txt ip24.txt ip16.txt ip8.txt")
	parser.add_argument('-p', dest='port', type=str, help="Example: 80 80-89 80,443,3306,8080")
	args = parser.parse_args()
	ip=args.ip
	tmpPorts = args.port
	ipfile=args.ip_file
	if ip==None and ipfile==None:
		print 'Error: ip or ipfile is Null!'
		print 'Help: -h or --help'
		sys.exit(1)
	if tmpPorts:
		if ',' in tmpPorts:
			ports = tmpPorts.split(',')
		elif '-' in tmpPorts:
			ports = tmpPorts.split('-')
			tmpports = []
			[tmpports.append(i) for i in range(int(ports[0]), int(ports[1]) + 1)]
			ports = tmpports
		else:
			ports = [tmpPorts]
	else:
		print 'Default Ports'
		ports = [21, 22, 23, 53, 80, 111, 139, 161, 389, 443, 445, 512, 513, 514,
					873, 1025, 1433, 1521, 3128, 3306, 3311, 3312, 3389, 5432, 5900,
					5984, 6082, 6379, 7001, 7002, 8000, 8080, 8081, 8090, 9000, 9090,
					8888, 9200, 9300, 10000, 11211, 27017, 27018, 50000, 50030, 50070]
	if ipfile!=None:
		iplist = []
		with open(str(ipfile)) as f:
			while True:
				line = str(f.readline()).strip()
				if line:
					iplist.append(line)
				else:
					break
		if ipfile=='ip24.txt':
			print 'Scan iplist/24'
			for ip in iplist:
				CscanPortBanner(ip+'/24',ports)
		elif ipfile=='ip16.txt':
			print 'Scan iplist/16'
			for ip in iplist:
				BscanPortBanner(ip+'/16',ports)
		elif ipfile=='ip8.txt':
			print 'Scan iplist/8'
			for ip in iplist:
				AscanPortBanner(ip+'/8',ports)
		# elif ipfile=='ip.txt':
			# print 'iplist'
		else:
			print 'Scan iplist (any txt file)'
			for ip in iplist:
				CscanPortBanner(ip,ports)
	elif ip!=None:
		if '/16' in ip:
			BscanPortBanner(ip,ports)
		elif '/8' in ip:
			AscanPortBanner(ip,ports)
		elif '/24' in ip:
			CscanPortBanner(ip,ports)
		else:
			CscanPortBanner(ip,ports)
