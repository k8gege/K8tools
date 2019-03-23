# -*- coding: UTF-8 -*-
#author: k8gege
#https://github.com/k8gege/K8tools
#https://www.cnblogs.com/k8gege
import sys
import queue
from scapy.all import *
from pprint import pprint

def search(data, key):
	#print "data:  " + data
	i=data.find(key)
	if i > -1:
		masterType = "617574686F723A206B3867656765"	
		masterType = data[i+len(key):i+len(key)+2]
		if masterType=="02":
		   return data[i+len(key)+4:i+len(key)+34],masterType,data[i+len(key)+44:i+len(key)+48]
		return data[i+len(key)+12:i+len(key)+42],masterType,data[i+len(key)+44:i+len(key)+48] 
	return ""

def getver(data):
	if data=="0500":
		return "Win2000"
	elif data=="0501":
		return "WinXP"
	elif data=="0502":
		return "Win2003"
	elif data=="0600":
		return "Vista"	
	elif data=="0601":
		return "Win7_2008"
	elif data=="0602":
		return "Win8_2012"	
	elif data=="0603":
		return "Win8.1"
	elif data=="0a00":
		return "Win10_2016"		
	return data
	
def packet_callbacke(packet):
    #print(packet.show())
	try:
		data=packet.load.encode('hex')
		osname,masterType,osver = search(data, "5c4d41494c534c4f545c42524f57534500")	
		if (osname!=""):
			if masterType=="0c":
				print packet.getlayer(IP).src+"\t"+packet.src+"\t"+osname.decode('hex')+"\t[Domain]"
			else:
				print packet.getlayer(IP).src+"\t"+packet.src+"\t"+osname.decode('hex')+"\t["+getver(osver)+"]"
	except:
		pass

print "IP\t\tMAC\t\t\tOSname\t\tOSver"

try:
	sniff(iface = sys.argv[1],filter="", prn=packet_callbacke)
except:
	pass
