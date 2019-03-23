import SimpleHTTPServer
import SocketServer
import sys
PORT = 80
if len(sys.argv) != 2:
	print("use: web.exe port")
else: 
	PORT = int(sys.argv[1])
	Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
	httpd = SocketServer.TCPServer(("", PORT), Handler)
	print "SimpleHTTPServer is ", PORT
	print "by k8gege"
	httpd.serve_forever()