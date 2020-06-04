
#C:\Users\null\Desktop\pywinrm>python test1.py
#win-\k8gege
import winrm
s=winrm.Session('http://192.168.1.116',auth=('k8gege','k8gege520'))#2012 ok
#s=winrm.Session('http://192.168.1.20',auth=('k8gege','k8gege520'))#win7 fail
r=s.run_ps('dir')
r=s.run_cmd('whoami') 
print r.std_out 
print  r.std_err