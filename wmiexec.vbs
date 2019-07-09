On Error Resume Next
'################################ Temp Result File , Change it to where you like
Const Path = "C:\"
Const FileName = "wmi.dll" 
Const timeOut = 1200
'################################
file = Path & "\" & FileName
file = Replace(file,"\\","\")
Set fso = CreateObject("Scripting.FileSystemObject")
FilePath = fso.GetParentFolderName(file) 'for wmi create share
'WScript.Echo FilePath

WAITTIME = timeOut              'ms  time to execute command ,read result file after 1200ms

Set objArgs = WScript.Arguments
intArgCount = objArgs.Count 
If intArgCount < 2 Or intArgCount > 5 Then
	WScript.Echo 
	WScript.Echo "   $$\      $$\ $$\      $$\ $$$$$$\ $$$$$$$$\ $$\   $$\ $$$$$$$$\  $$$$$$\  "
	WScript.Echo "   $$ | $\  $$ |$$$\    $$$ |\_$$  _|$$  _____|$$ |  $$ |$$  _____|$$  __$$\ "
	WScript.Echo "   $$ |$$$\ $$ |$$$$\  $$$$ |  $$ |  $$ |      \$$\ $$  |$$ |      $$ /  \__|"
	WScript.Echo "   $$ $$ $$\$$ |$$\$$\$$ $$ |  $$ |  $$$$$\     \$$$$  / $$$$$\    $$ |      "
	WScript.Echo "   $$$$  _$$$$ |$$ \$$$  $$ |  $$ |  $$  __|    $$  $$<  $$  __|   $$ |      "
	WScript.Echo "   $$$  / \$$$ |$$ |\$  /$$ |  $$ |  $$ |      $$  /\$$\ $$ |      $$ |  $$\ "
	WScript.Echo "   $$  /   \$$ |$$ | \_/ $$ |$$$$$$\ $$$$$$$$\ $$ /  $$ |$$$$$$$$\ \$$$$$$  |"
	WScript.Echo "   \__/     \__|\__|     \__|\______|\________|\__|  \__|\________| \______/ "
	WScript.Echo "                                               v1.1dev        By. Twi1ight   "
	WScript.Echo " Usage:" & _
					vbTab & "wmiexec.vbs  /shell  host" & _
		vbNewLine & vbTab & "wmiexec.vbs  /shell  host  user  pass" & _
		vbNewLine & vbTab & "wmiexec.vbs  /cmd  host  command" & _
		vbNewLine & vbTab & "wmiexec.vbs  /cmd  host  user  pass  command" & vbNewLine & _
		vbNewLine & vbTab & "  /shell"  & vbTab & "half-interactive shell mode" & _
		vbNewLine & vbTab & "  /cmd" & vbTab & vbTab & "single command mode" & _
		vbNewLine & vbTab & "  host" & vbTab & vbTab & "hostname or IP address" & _
		vbNewLine & vbTab & "  command" & vbTab & "the command to execute on remote host" & _
		vbNewLine & vbNewLine & vbTab & "  -waitTIME" & vbTab & _
		 "[both mode] ,delay TIME to read result,"& vbNewLine & vbTab & _
		 vbTab & vbTab &"eg. 'systeminfo -wait5000' 'ping google.com -wait2000'" & _
		vbNewLine & vbTab & "  -persist" & vbTab & _
		 "[both mode] ,running command background and persistent" & vbNewLine & vbTab & _
		 vbTab & vbTab &"such as nc.exe or Trojan" 
	WScript.Quit()
End If

If LCase(objArgs.Item(0)) <> "/cmd" And LCase(objArgs.Item(0)) <> "/shell" Then 
	WScript.Echo "WMIEXEC ERROR: Wrong Mode Specified!"
	WScript.Quit
End If
boolShellMode = True
If LCase(objArgs.Item(0)) = "/cmd" Then boolShellMode = False
If boolShellMode = False Then command = objArgs.Item(intArgCount - 1)

host = objArgs.Item(1)
If intArgCount > 3 Then 
	user = objArgs.Item(2)
	pass = objArgs.Item(3)
	Set objShell = CreateObject("WScript.Shell")
	strNetUse = "cmd.exe /c net use \\" & host & " """ & pass & """ " & "/user:" & user
	'WScript.Echo strNetUse
	objShell.Run strNetUse,0
End If
'Output Status
WScript.Echo "WMIEXEC : Target -> " & host
WScript.Echo "WMIEXEC : Connecting..."

Set objLocator = CreateObject("wbemscripting.swbemlocator")
If intArgCount >2 Then
	set objWMIService = objLocator.connectserver(host,"root/cimv2",user,pass)
Else
	Set objWMIService = objLocator.ConnectServer(host,"root/cimv2")
End If
If Err.Number <> 0 Then
	WScript.Echo "WMIEXEC ERROR: " & Err.Description 
	WScript.Quit
End If
WScript.Echo "WMIEXEC : Login -> OK"
WScript.Echo "WMIEXEC : Result File -> " & file

boolPersist = False
'Create Share
CreateShare()
CurrentFolder = Null
'-----single Command mode------
If boolShellMode = False Then
	WAITTIME = 5000
	WScript.Echo vbNewLine & vbTab & host & "  >>  " & command
	boolGetFolder = False
	strResult = PhraseCmd( command )
	'WScript.Echo strResult
	If strResult = "persist" Then
		boolPersist = True
		Exec command,"nul"
	Else
		Exec command, file
		ReadResult()
	End If
	If intArgCount > 3 Then 
		Set objShell = CreateObject("WScript.Shell")
		strNetUse = "cmd.exe /c net use \\" & host & " /del"
		objShell.Run strNetUse,0
	End If
	DeleteShare()
	WScript.Quit
End If
'------------------------------

'++++++++shell mode++++++++++++
'get current working directory
boolGetFolder = True
CurrentFolder = Exec("cd", file)

'WScript.Echo CurrentFolder
Do While True
	boolPersist = False
	WAITTIME = timeOut
	wscript.stdout.write(CurrentFolder & ">")
	command = wscript.stdin.ReadLine
	'press 'Enter' directorly
	Do While command = ""
		wscript.stdout.write(CurrentFolder & ">")
		command = wscript.stdin.ReadLine
	Loop
	If LCase(Trim(command)) = "exit" Then Exit Do
	'If Not IsEmpty(command) Then 
	'process 'cd' command-------->>>>
	strResult = PhraseCmd( command )
	If strResult = "cd" Then 
		command = command & " & cd "
		boolGetFolder = True
		DestFolder = Exec(command, file)
		If CurrentFolder = DestFolder Then 
			WScript.Echo "The system cannot find the path specified."
		Else
			CurrentFolder = DestFolder
		End If
	ElseIf strResult = "persist" Then
		boolPersist = True
		'WScript.Echo "persist"
		Exec command,"nul"
		'##########################################toDo
	'-----------<<<<
	Else
		On Error Resume Next
		err.clear
		Exec command, file
		ReadResult()
	    If err.number <> 0 Then wscript.echo( "WMIEXEC ERROR: " & Err.Number & " " & err.description)
		Err.Clear
	    On Error Goto 0
	End If
loop

strDelFile = "del " & file & " /F"
Exec strDelFile,"nul"
If intArgCount > 3 Then 
	Set objShell = CreateObject("WScript.Shell")
	strNetUse = "cmd.exe /c net use \\" & host & " /del"
	objShell.Run strNetUse,0
End If
DeleteShare()

'#####################################
Function PhraseCmd(cmd)
	PhraseCmd = False ' not 'cd'
	arrCommand = Split(cmd)
	strExe = arrCommand(0)
	If LCase(Trim(strExe)) = "cd" Or LCase(Trim(strExe)) = "cd.exe" Then PhraseCmd = "cd"  ' is 'cd'
	Set regEx = New RegExp
	regEx.Pattern = "^[a-z]:$"
	regEx.IgnoreCase = True
	Set Matches = regEx.Execute(cmd)
	If Matches.Count <> 0 Then PhraseCmd = "cd" ' is 'd:'
	'phrase time command
	regEx.Pattern = "(.*?)-wait(\d+)"
	regEx.IgnoreCase = True
	Set Matches = regEx.Execute(cmd)
	If Matches.Count <> 0 Then 
		Set objMatch = Matches(0)
		command = objMatch.SubMatches(0)
		'WScript.Echo "Command :" & command
		WAITTIME = CInt(objMatch.SubMatches(1))
		WScript.Echo "WMIEXEC : Waiting " & WAITTIME & " ms..." & vbNewLine
	End If
	'phrase persist command
	regEx.Pattern = "(.*?)-persist"
	regEx.IgnoreCase = True
	Set Matches = regEx.Execute(cmd)
	If Matches.Count <> 0 Then 
		Set objMatch = Matches(0)
		command = objMatch.SubMatches(0)
		PhraseCmd = "persist"  ' is quiet
	End If
End Function

Function CreateShare()
	'create share
	Set objNewShare = objWMIService.Get("Win32_Share")
	intReturn = objNewShare.Create _
	    (FilePath, "WMI_SHARE", 0, 25, "")
	If intReturn <> 0 Then
		WScript.Echo "WMIEXEC ERROR: Share could not be created." & _
	        vbNewLine & "WMIEXEC ERROR: Return value -> " & intReturn
	    Select Case intReturn
	    	Case 2
	    		WScript.Echo "WMIEXEC ERROR: Access Denied!"
	    	Case 9
	    		WScript.Echo "WMIEXEC ERROR: Invalid File Path!"
	    	Case 22
	    		WScript.Echo "WMIEXEC ERROR: Share Name Already In Used!"
	    	Case 24
	    		WScript.Echo "WMIEXEC ERROR: Directory NOT exists!"
	    End Select
		If intReturn <> 22 Then WScript.Quit
	Else
	    WScript.Echo "WMIEXEC : Share created sucess."
		WScript.Echo "WMIEXEC : Share Name -> WMI_SHARE"
		WScript.Echo "WMIEXEC : Share Path -> " & FilePath
	End If
End Function

Function DeleteShare()
	Set colShares = objWMIService.ExecQuery _
		("Select * from Win32_Share Where Name = 'WMI_SHARE'")
	For Each objShare In colShares
		intReturn = objShare.Delete
	Next
	If intReturn <> 0 Then
		WScript.Echo "WMIEXEC ERROR: Delete Share failed." & _
	        vbNewLine & "WMIEXEC ERROR: Return value -> " & intReturn
	    Select Case intReturn
	    	Case 2
	    		WScript.Echo "WMIEXEC ERROR: Access Denied!"
	    	Case 25
	    		WScript.Echo "WMIEXEC ERROR: Share Not Exists!"
	    End Select
	Else
	    WScript.Echo "WMIEXEC : Share deleted sucess."
	End If
End Function

Function Exec(cmd, file)
	Set objStartup = objWMIService.Get("Win32_ProcessStartup")
	Set objConfig = objStartup.SpawnInstance_
	objConfig.ShowWindow = 12
	
	Set objProcess=objWMIService.get("Win32_Process")
	strExec = "cmd.exe /c " & cmd & " > " & file & " 2>&1"  '2>&1 err
	If boolPersist Then
		strExec = cmd
		intPath = InStr(cmd,"\")
		If intPath = 0 Then strExec = CurrentFolder & "\" & strExec
	End If
	'WScript.Echo strExec
	intReturn = objProcess.Create _
	    (strExec, CurrentFolder, objConfig, intProcessID)  'Add CurrentFolder (strExec, Null, objConfig, intProcessID)
	If intReturn <> 0 Then
		WScript.Echo "WMIEXEC ERROR: Process could not be created." & _
	        vbNewLine & "WMIEXEC ERROR: Command -> " & cmd & _
	        vbNewLine & "WMIEXEC ERROR: Return value -> " & intReturn
	    Select Case intReturn
	    	Case 2
	    		WScript.Echo "WMIEXEC ERROR: Access Denied!"
			Case 3
				WScript.Echo "WMIEXEC ERROR: Insufficient Privilege!"
	    	Case 9
	    		WScript.Echo "WMIEXEC ERROR: Path Not Found!"
	    End Select
	Else
'	    WScript.Echo "Process created." & _
'	        vbNewLine & "Command: " & cmd & _
'	        vbNewLine & "Process ID: " & intProcessID
		If boolPersist Then WScript.Echo "WMIEXEC : Process created. PID: "& intProcessID
	    If boolGetFolder = True Then 
	    	boolGetFolder = False
	    	Exec = GetCurrentFolder()
	    	Exit Function
	    End If
	    'ReadResult()
	End If
End Function

Function ReadResult()
	WScript.Sleep(WAITTIME)
	UNCFilePath = "\\" & host & "\" & "WMI_SHARE" & "\" & FileName
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set objFile = fso.OpenTextFile(UNCFilePath, 1)
	If Not objFile.AtEndOfStream Then strContents = objFile.ReadAll
	objFile.Close
	WScript.Echo strContents
	'fso.DeleteFile(UNCFilePath)   win2008 fso has no privilege to delete file on share folder
	strDelFile = "del " & file & " /F"
	Exec strDelFile,"nul"
End Function

Function GetCurrentFolder()
	WScript.Sleep(WAITTIME)
	UNCFilePath = "\\" & host & "\" & "WMI_SHARE" & "\" & FileName
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set objFile = fso.OpenTextFile(UNCFilePath, 1)
	GetCurrentFolder = objFile.ReadLine
	objFile.Close
	strDelFile = "del " & file & " /F"
	Exec strDelFile,"nul"
End Function