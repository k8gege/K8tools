package main
import (
  "github.com/masterzen/winrm"
  "fmt"
  "os"
  "strconv"
)
//Winrm Remote Shell by k8gege
//http://k8gege.org/Ladon/WinrmScan.html
#C:\Users\k8gege\Desktop\>winrmcmd.exe 192.168.1.116 5985 k8gege k8gege520 whoami
#k8gege

var help = func () {
    fmt.Println("Winrm Shell by k8gege")
    fmt.Println("====================================================")
    fmt.Println("winrmcmd host port user pass cmd")
}

func main() {

	    args := os.Args
    if len(args) < 5 || args == nil {
		help()
        return
    }
	host := args[1]
	port,err := strconv.Atoi(args[2])
	user := args[3]
	pass := args[4]
	cmd := args[5]
	
	endpoint := winrm.NewEndpoint(host, port, false, false, nil, nil, nil, 0)
	client, err := winrm.NewClient(endpoint, user, pass)
	if err != nil {
		panic(err)
	}
client.Run(cmd, os.Stdout, os.Stderr)
}