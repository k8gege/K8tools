#WIN7: 1.20     fail win7-server
#2012: 1.116    isok 2020-server
$ip="192.168.1.116"
#$ip="192.168.1.20"
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $ip -Force
$securePassword = ConvertTo-SecureString -AsPlainText -Force 'k8gege520' 
$cred = New-Object System.Management.Automation.PSCredential 'k8gege', $securePassword
$cmd = {ls C:\users\public}
Invoke-Command -ComputerName $ip -Credential $cred -ScriptBlock $cmd