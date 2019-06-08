import paramiko
import sys
print("sshcmd 1.0")
print("by k8gege")
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
stdin, stdout, stderr = ssh.exec_command(sys.argv[5])
print stdout.read()
ssh.close()