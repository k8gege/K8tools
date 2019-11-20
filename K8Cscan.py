#K8Cscan for python 2.0
#Author: K8gege
#Date: 20190530
#Platform: (Windows & Linux)
#Windows need to .net framework >= 4.0
#Linux not support load 'netscan40.dll' (Maybe Mono is support)
#Usage:
#python K8Cscan.py 192.11.22.40
#python K8Cscan.py 192.11.22.40/24
#python K8Cscan.py 192.11.22.40/24 -t ms17010
#python K8Cscan.py --type=dll 192.11.22.42
#python K8Cscan.py 192.11.22.40/24 -t dll

import platform
import socket
import os
import threading
import time
import telnetlib
import argparse
# import gevent
# from gevent import monkey; monkey.patch_all(); 
# import socket 
# from gevent.pool import Pool 

from mysmb import MYSMB
from impacket import smb, smbconnection, nt_errors
from impacket.uuid import uuidtup_to_bin
from impacket.dcerpc.v5.rpcrt import DCERPCException
from struct import pack
import sys

USERNAME = ''
PASSWORD = ''
NDR64Syntax = ('71710533-BEBA-4937-8319-B5DBEF9CCC36', '1.0')
MSRPC_UUID_BROWSER  = uuidtup_to_bin(('6BFFD098-A112-3610-9833-012892020162','0.0'))
MSRPC_UUID_SPOOLSS  = uuidtup_to_bin(('12345678-1234-ABCD-EF00-0123456789AB','1.0'))
MSRPC_UUID_NETLOGON = uuidtup_to_bin(('12345678-1234-ABCD-EF00-01234567CFFB','1.0'))
MSRPC_UUID_LSARPC   = uuidtup_to_bin(('12345778-1234-ABCD-EF00-0123456789AB','0.0'))
MSRPC_UUID_SAMR     = uuidtup_to_bin(('12345778-1234-ABCD-EF00-0123456789AC','1.0'))

pipes = {
    'browser'  : MSRPC_UUID_BROWSER,
    'spoolss'  : MSRPC_UUID_SPOOLSS,
    'netlogon' : MSRPC_UUID_NETLOGON,
    'lsarpc'   : MSRPC_UUID_LSARPC,
    'samr'     : MSRPC_UUID_SAMR,
}

def smbcheck(target):
    if checkPort(target,'445'):
        conn = MYSMB(target)
        try:
            conn.login(USERNAME, PASSWORD)
        except smb.SessionError as e:
            #print('Login failed: ' + nt_errors.ERROR_MESSAGES[e.error_code][0])
            sys.exit()
        finally:
            #print('OS: ' + conn.get_server_os())
            TragetOS = '(' + conn.get_server_os()+')'

        tid = conn.tree_connect_andx('\\\\'+target+'\\'+'IPC$')
        conn.set_default_tid(tid)

        # test if target is vulnerable
        TRANS_PEEK_NMPIPE = 0x23
        recvPkt = conn.send_trans(pack('<H', TRANS_PEEK_NMPIPE), maxParameterCount=0xffff, maxDataCount=0x800)
        status = recvPkt.getNTStatus()
        if status == 0xC0000205:  # STATUS_INSUFF_SERVER_RESOURCES
            #print('The target is not patched')
            CheckResult = 'MS17-010\t'+TragetOS

        return CheckResult

def GetSmbVul(ip): 
    # output = os.popen('ping -%s 1 %s'%(ptype,ip)).readlines()
    # for w in output:
        # if str(w).upper().find('TTL')>=0:
            #print "online "+ip
    try:
        SmbVul=smbcheck(ip)
        if SmbVul<>None:
            print('%s\t%s'%(ip,SmbVul))
    except:
        pass
def GetOSname(ip): 
    try:
        print('%s\t%s\t%s'%(ip,getHostName(ip)))
    except:
        pass
def ScanSmbVul(ip): 
    if '/24' in ip:
        ipc = (ip.split('.')[:-1])
        for i in range(1,256):
            add = ('.'.join(ipc)+'.'+str(i))
            threading._start_new_thread(GetSmbVul,(add,))
            time.sleep(0.1)
    else:
        GetSmbVul(ip)

def checkPort(ip,port):
    server = telnetlib.Telnet()
    try:
        server.open(ip,port)
        #print('{0} port {1} is open'.format(ip, port))
        return True
    except Exception as err:
        #print('{0} port {1} is not open'.format(ip,port))
        return False
    finally:
        server.close()

def getHostName(target):
    try:
      result = socket.gethostbyaddr(target)
      return result[0]
    except socket.herror, e:
      return ''
def getos():
    return platform.system()

try:
    import clr
except:
    pass

def netscan(ip):
	try:  
		clr.FindAssembly('netscan40.dll')
		clr.AddReference('netscan40')
		from CscanDLL import scan
		print(scan.run(ip)),
	except:
		pass

def Cscan(ip): 
    if '/24' in ip:
        ipc = (ip.split('.')[:-1])
        for i in range(1,256):
            add = ('.'.join(ipc)+'.'+str(i))
            threading._start_new_thread(netscan,(add,))
            # if type=='dll':
                # threading._start_new_thread(netscan,(add,))
            # elif type=='smb':
                # threading._start_new_thread(netscan,(add,))
            time.sleep(0.1)
    else:
        netscan(ip)

def CscanSMBver(ip): 
    if '/24' in ip:
        ipc = (ip.split('.')[:-1])
        for i in range(1,256):
            add = ('.'.join(ipc)+'.'+str(i))
            threading._start_new_thread(smbVersion,(add,))
            time.sleep(0.1)
    else:
        smbVersion(ip)
def CscanOSname(ip): 
    if '/24' in ip:
        ipc = (ip.split('.')[:-1])
        for i in range(1,256):
            add = ('.'.join(ipc)+'.'+str(i))
            threading._start_new_thread(GetOSname,(add,))
            time.sleep(0.1)
    else:
        GetOSname(ip)

def getip():                                           
    return socket.gethostbyname(socket.gethostname())
 
def pingIP(ip): 
    #print ip
    #gevent.sleep(0)
    output = os.popen('ping -%s 1 %s'%(ptype,ip)).readlines()
    for w in output:
        if str(w).upper().find('TTL')>=0:
            print ip
            # try:
                # SmbVul=smbcheck(ip)
                # if SmbVul==None:
                    # print('%s\t%s'%(ip,getHostName(ip)))
                # else:
                    # print('%s\t%s\t%s'%(ip,getHostName(ip),SmbVul))
            # except:
                # pass

def CpingIP(ip): 
    ip=ipc+str(ip)
    pingIP(ip)

def Cping(ip): 
    if '/24' in ip:
        ipc = (ip.split('.')[:-1])
        for i in range(1,256):
            add = ('.'.join(ipc)+'.'+str(i))
            threading._start_new_thread(pingIP,(add,))
            time.sleep(0.1)

        #ipcc = scanip.split('.')[:-1]
        #ipccc = ('.'.join(ipcc)+'.')
        #global ipc 
        #ipc = ipccc
        #ipc = scanip.split('.')[:-1]
        #print "ipc: "+ipc

        # pool = Pool(255) 
        # pool.map(CpingIP,xrange(1,254)) 
        # pool.join()
    else:
        pingIP(ip)
def PrintLine():
    print('=============================================')

from impacket.smbconnection import *
from impacket.nmb import NetBIOSError
import errno

def smbVersion(rhost):
    host = rhost
    port=445
    try:
        smb = SMBConnection(host, host, sess_port=port)
    except NetBIOSError:
        return
    except socket.error, v:
        error_code = v[0]
        if error_code == errno.ECONNREFUSED:
            return
        else:
            return
    dialect = smb.getDialect()
    if dialect == SMB_DIALECT:
        print(host + "\tSMBv1 ")
    elif dialect == SMB2_DIALECT_002:
        print(host + "\tSMBv2.0 ")
    elif dialect == SMB2_DIALECT_21:
        print(host + "\tSMBv2.1 ")
    else:
        print(host + "\tSMBv3.0 ")

ipc=""
if __name__ == '__main__':

    print('K8Cscan 2.0 by k8gege')
    parser = argparse.ArgumentParser()
    parser.add_argument('ip',help='IP or IP/24') 
    parser.add_argument('--type', '-t', type=str, choices=['ping', 'smbver', 'osname','ms17010','dll'], help='Scan Type',default='ping')
    args = parser.parse_args()
    if getos() == 'Windows':
        ptype = 'n'
    elif getos() == 'Linux':
        ptype = 'c'
    else:
        print('The system is not supported.')
        sys.exit()
    scanip=args.ip
    if args.type == 'ping':
        print "Scan Online"
        PrintLine()
        Cping(scanip)
    elif args.type == 'smbver':
        print "Scan Smb Version "
        CscanSMBver(scanip)
    elif args.type == 'dll':
        if ptype =='n':
            if(os.path.exists('netscan40.dll')):
                print('load netscan40.dll (.net >= 4.0)')
                PrintLine()
                Cscan(scanip)
            else:
                print('load netscan40.dll')
        else:
            print('The system is not supported.')
        sys.exit(1)
    elif args.type == 'ms17010':
        print "Scan MS17-010 VUL \n" + scanip
        ScanSmbVul(scanip)
    elif args.type == 'osname':
        print "Scan hostName \n" + scanip
        CscanOSname(scanip)
    PrintLine()
    print('Scan Finished!')