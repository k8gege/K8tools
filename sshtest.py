# C:\Users\null\Desktop\ssh>python ssh.py 192.11.22.60 22 root k8gege
# 192.11.22.60 22 root k8gege LoginOK

import paramiko
import sys

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

def checkSSH():
	try:
		ssh.connect(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
		print sys.argv[1]+' '+sys.argv[2]+' '+sys.argv[3]+' '+sys.argv[4]+' LoginOK'
	except:
		pass
checkSSH()