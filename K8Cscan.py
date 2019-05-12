#Author: K8gege
#Date: 20190512
#.net framework >= 4.0
import platform
import socket
import os
import threading
import time
import sys
import clr

def netscan(ip):  
    clr.FindAssembly('netscan.dll')
    clr.AddReference('netscan')
    from CscanDLL import scan
    print(scan.run(ip))

def Cscan(ip): 
    ipc = (ip.split('.')[:-1])
    for i in range(1,256):
        add = ('.'.join(ipc)+'.'+str(i))
        threading._start_new_thread(netscan,(add,))
        time.sleep(0.1)

def getos():
    return platform.system()
 
def getip():                                           
    return socket.gethostbyname(socket.gethostname())
 
def pingIP(ip):                                         
    output = os.popen('ping -%s 1 %s'%(ptype,ip)).readlines()
    for w in output:
        if str(w).upper().find('TTL')>=0:
            print(ip)        
 
def Cping(ip): 
    ipc = (ip.split('.')[:-1])
    for i in range(1,256):
        add = ('.'.join(ipc)+'.'+str(i))
        threading._start_new_thread(pingIP,(add,))
        time.sleep(0.1)

if __name__ == '__main__':
    print('K8Cscan for python 1.0')
    if getos() == 'Windows':
        ptype = 'n'
    elif getos() == 'Linux':
        ptype = 'c'
    else:
        print('The system is not supported.')
        sys.exit()
    if(os.path.exists('netscan.dll')):
        print('load netscan.dll')
        Cscan(getip())
    else:
        print('not found netscan.dll')
        print('Default scan ip/24 online PC')
        Cping(getip())