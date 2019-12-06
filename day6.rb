#!/usr/bin/env ruby

input = DATA.read.split("\n").map { |line| line.split(")") }

def debug(s)
  puts s if ENV['DEBUG']
end

def count(orbits)
  counts = { 'COM' => 0 }
  missing = 1
  until missing == 0
    missing = 0
    orbits.each do |center, obj|
      #raise "Unknown count for #{center}" unless counts.key?(center)
      if counts.key?(center)
        counts[obj] = counts[center] + 1
      else
        missing += 1
      end
    end
  end
  counts.values.sum
end

orbits = <<~ORBITS.split("\n").map { |line| line.split(")") }
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
ORBITS

raise "Invalid example1" unless count(orbits) == 42

puts "First part: #{count(input)}"

orbits = <<~ORBITS.split("\n").map { |line| line.split(")") }
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
ORBITS

def traject(trajects, init)
  cur = trajects[init]
  path = [cur]
  while cur != 'COM'
    cur = trajects[cur]
    path << cur
  end
  debug "#{init}->COM: #{path.size}"
  path
end

def distance(orbits)
  traj = {}
  orbits.each do |center, obj|
    traj[obj] = center
  end
  you = traject(traj, 'YOU')
  san = traject(traj, 'SAN')
  debug "YOU: #{you.join(',')}"
  debug "SAN: #{san.join(',')}"
  ancestor = (you & san).first
  debug "Ancestor: #{ancestor}"
  c = you.take_while { |el| el != ancestor }.size
  c += san.take_while { |el| el != ancestor }.size
  c
end

raise "Invalid example2" unless distance(orbits) == 4
puts "Second part: #{distance(input)}"
  

__END__
YP6)HRL
5SN)Z3H
46K)CGP
PW2)SB6
NMH)673
36N)VHW
692)P3K
JCZ)ZM5
QMQ)KTT
NCT)K3G
YYB)155
MGN)272
MCC)6P8
3FT)X4C
YFC)1DL
5XK)839
VHJ)M9V
76Q)VRX
CGP)P3D
7Z5)GLK
C7X)LR1
F1Z)XK6
H94)VP6
5R9)C26
XLY)6B3
MQX)PYZ
SK4)6HK
WQV)PNN
Z7V)ZGZ
8YM)1QG
YR8)P91
B4V)52L
JRN)LRN
QWH)1GN
D8Y)H64
LWM)R33
C6G)CJD
7HK)D7M
TBX)JFZ
QG2)1BM
XP8)4C7
2WD)2PL
MHG)2SW
3YY)3CZ
8W4)DPV
9Q5)44R
5GW)339
KZB)H2P
WWP)RGG
D6P)PBJ
7MC)46Z
9RJ)T32
JQ7)MZ8
5NC)65D
TC2)VFB
7TX)Z7V
JCH)V88
C4F)FYX
G4C)CTM
47X)RT5
7T1)H9H
BQM)38T
YR9)XTY
DJJ)N1Y
8XB)QHN
GCG)6FJ
CT2)THZ
15G)BH2
Y18)JDT
TCS)X8T
YTM)KFT
QDT)665
HNM)RM8
SWQ)5GK
KKG)5JZ
RNZ)RZV
F9G)JF3
H5Y)1G6
F2P)DMS
F5S)H5G
1WH)XT3
RD6)522
1GS)9DD
N33)9RM
42H)P3F
2GS)28S
T9X)JPH
1VS)76Q
3RR)Q5R
6N7)J51
W2G)ZTN
FL4)84Q
W38)VXQ
F9G)ZFJ
MV4)R4R
Y7N)XXD
4Y7)3VB
T1F)63T
6TX)7LC
JXG)6HS
85G)4P9
94S)DYQ
YF3)MC5
WDZ)QZ3
NLN)3MG
NY9)HYY
SQR)HQB
FKZ)RRC
K52)T37
VY8)CTX
R4Q)QMF
R7S)FFV
BFF)WKQ
Z23)F1Q
WLB)7XJ
TYK)YRQ
4CM)YWT
M39)P6H
4XX)V6T
HTY)HMN
HMN)KJY
NCK)79H
5W3)DXH
VQK)7LM
GBS)YR2
7RY)LWS
1BM)2Y2
CM6)313
X8T)68C
Q6T)6B6
GSS)2G7
1K6)FKQ
V7T)PYC
6Y7)C1N
FZK)QVV
T16)3YY
TB4)5JL
7NX)WWX
H6P)YTY
Y5K)92P
WVH)15G
4BW)DB2
V47)PK9
K8M)9YL
M21)BYT
KCS)9Z4
JFN)P5S
RH7)BC5
RP1)PDM
XYW)YYR
KTY)MXD
X8J)FR9
X33)6C4
L97)9X3
GTF)NPK
6TG)1J8
XN3)M21
BZQ)44N
NRN)SAN
6X9)DBB
BPY)WMD
CK2)XQP
8Q1)S5P
63S)7HV
CYC)XY4
Q7P)M45
PW7)YS1
3MS)2MC
BXJ)7T1
H3J)PH9
D94)CKD
RZV)X3W
X7P)LQR
1N2)67Z
LPT)QHG
TT3)Q1H
52L)51B
RGG)5NC
DS9)TR4
HGF)98H
9QY)RB2
225)PVT
G6B)4DG
XGT)4WP
K2K)CG8
GW7)4MX
Y2T)7L7
LDZ)MPS
Z49)J7W
QFG)HPJ
VLY)HVG
6K4)KBY
NY1)6FX
R8P)P6R
NVR)CZ3
ZK9)YPY
Q3W)1R7
TNV)8S2
T32)XN3
PM7)543
KXL)NPG
6K1)MYV
JLW)BK8
S97)ST8
5FY)4HT
5HB)S28
FYR)BZQ
XRQ)K2K
MM2)B8W
X8T)JB2
DWB)VW4
F5P)178
X73)5FP
DX7)5N8
KFT)BFR
GM7)DZV
2BP)XH2
JZH)HPF
KN4)NJ1
GVT)XBS
1GX)R8W
1C2)MQH
Z8N)CYD
58L)2WQ
4LB)8RG
HW4)94S
W6B)9YS
FG8)8LX
NZ1)GFQ
22X)X8J
LMN)KZB
31C)W2P
RPD)JQY
616)T4G
N1Q)HX8
2G7)DPZ
GQ8)7Q7
XQP)2DH
Y14)K52
KB4)QT6
D94)225
G7Y)XMN
Q8N)QMR
GNF)F9N
KWY)R6K
2GL)QKS
VNQ)GTK
T2M)YJB
HQL)X4J
5DV)ZHV
R41)PQT
4K8)HJZ
YTG)3N5
5SH)RRY
R2R)K6B
QDN)3BQ
3ZV)WH4
R2Y)L3Q
3RL)P4H
YWT)WD7
BDF)NY1
Q3K)7H9
P6H)GDC
BCS)NY9
P3F)98K
QNZ)GJ7
FZN)644
ZZY)STT
SB6)TTM
3D9)6JK
44R)HZK
DRC)NSP
JQ4)9LK
KZ7)DCP
P32)MMG
7FD)S3H
1R7)HY3
1J8)VXZ
Z8D)7PD
KMX)33R
D7M)YTC
5JL)G98
SRH)291
HD9)R13
7MP)ZX4
L23)46D
N5L)HLN
Y69)8Q1
963)HD9
Z3K)5TG
3DQ)F49
KP4)9TJ
3BD)84C
99J)CCK
PB9)YN9
SGN)M5Y
RLP)HV6
48L)ZL3
P1W)NVF
Q6B)D89
YYP)1GS
SB6)2F3
36N)V3B
B98)VSQ
MHH)K58
65D)CK2
QDG)YWF
B5N)CV3
M2V)KM4
TW2)5C4
TG3)87H
Z6T)J1R
LGF)FGF
KGX)X9T
1JF)367
RH5)5VY
NGZ)7Z4
YYR)QTD
44Z)1RT
RRC)6FC
XGT)Z2C
5Z3)3WV
WL7)6GM
K2K)LTG
PDM)7TX
7WF)MTN
QVV)DR9
X99)XZL
5P3)8KK
4C7)YXB
B4J)ZY4
6B6)ZND
YXB)JLC
6FY)KRR
S41)1VS
PX1)DR7
L1Y)39G
L74)RH7
5FJ)2BF
7J3)LTS
QNB)MYZ
NJ5)NF9
313)7TC
JF7)4Y7
KY5)LMN
GMP)F2P
VHG)12L
DZR)R8X
GQB)CGZ
B6F)GXK
KKV)YXZ
ZHV)7J6
X4R)SK8
BFX)LZH
5RQ)Y5S
DXY)1N2
44N)6K4
QVV)4HF
2DZ)6N7
7WG)QBS
JND)JHP
8SR)YNX
J5N)HC5
X26)JSV
1JZ)2Q4
V6W)5YW
RV7)LGL
6B6)SMD
163)J6F
XZC)CW9
YV5)5FY
T32)YTH
78F)Q6H
R2X)H4Y
GXK)LRY
NSR)4D5
K65)2GS
R7J)DK7
CTP)3QV
NKD)1GQ
R33)1T1
2RZ)DPX
QG2)7FD
2R5)P88
C4Y)3BD
V1K)B23
LSL)XJ6
VDH)KQS
YMY)G9P
K59)18V
GLT)3C4
ZC3)NZ1
JHP)8RF
X33)V47
X65)VDW
FZZ)FT2
J49)PTG
89F)ZJ2
VGT)NJ5
XMN)HN2
RNL)56N
JLC)V57
D3L)HLF
KCS)MRJ
76F)XQS
PF9)LXR
PTN)THM
SKD)NCK
31N)8JY
7PD)HFV
5CY)SPB
7FG)T9V
FVR)DHX
VKP)W1M
F2L)YV5
KYP)VQK
CXL)PX1
95S)MYG
4SV)FGQ
8B5)H7F
TZS)P1Z
3R5)5RQ
1QG)YT6
BT2)VJZ
LZH)8DD
Q5R)GV1
5Q3)Z7N
7KY)XYW
KXZ)CMG
WKV)1D1
4J4)RNZ
BSC)YDP
839)2F1
MSS)BCB
7QS)PRL
FNJ)TC4
5V1)YR6
3CZ)JB4
YTH)BQ8
C29)31N
MZQ)7MX
T13)3BJ
DR7)8B5
KYY)S5Z
YSV)9T7
4PX)NPL
W3D)FKZ
P1Z)WQX
JTK)7TS
29T)VPG
KMJ)9SQ
FFV)WBB
ZBN)43F
LT4)V1F
5W9)6MY
PPK)C85
673)65H
RVL)2ZG
V5S)DP1
DPX)D1N
QYC)Q3K
RYC)J74
VZW)41H
DX7)PB9
46D)L26
35N)T9X
XKR)CC5
T9S)WKD
88N)627
N7B)4C2
VVM)RFK
X3T)L8N
5BT)GMM
LB5)M72
B6Z)HYC
ZDH)TS9
JWL)SYQ
LZJ)V1K
HYZ)R46
2Q9)MTV
FJ4)3D9
J8K)RPD
PPK)MPQ
8RG)L97
CXL)C7X
522)YL3
KDP)VV3
S8C)WDZ
NQ8)DV7
5J9)KP7
GLK)46K
2DW)2LV
YZ7)PPM
ZP3)7CD
9QY)MBD
XTD)BHR
T51)H6P
XJX)NCT
SV7)X65
RH7)P7M
F1Q)TW2
R2Z)T9T
HBF)F5G
8TK)DWT
DHZ)RP1
H7F)2DZ
YF1)W3W
PCH)48L
9D7)TJB
DK7)VVM
PYP)22N
V4H)VKP
YFL)JB1
V1F)2PR
89C)HNM
W2P)LQ6
CV4)8VD
9L6)KGN
KVB)PGD
F2C)893
5W9)J8J
J48)NLN
5C4)P32
4MZ)TV9
DJQ)XNM
78Q)31F
FMY)Z8N
HJF)P5V
MHG)VGR
SYM)4ZB
N1Y)SM8
VRX)Z8D
K7H)YF1
VN3)H21
4ZB)MHG
QC3)4S6
HVG)JZF
VXQ)DDL
CKD)H6N
VPG)PRP
NXL)2KY
2PW)T2X
2FB)RTW
3N5)M8M
Q9Z)89F
3S9)FDX
V9R)6SD
3QV)QNZ
ZJB)FJF
Z1J)N4G
BFX)NVT
2GC)RCF
H3F)SGN
W4V)1C2
GFQ)WZX
NPD)KXL
WJB)J35
1X9)TYF
D8N)FP3
B99)83T
3S5)13W
PQT)PDP
B8T)VHJ
9JN)Y2T
RFK)NVR
969)NPY
VVS)BFS
VP6)RXS
796)5ZM
YPY)4MS
93Y)DJN
BXJ)K9G
ZZF)MQ7
C73)16D
YHR)FBZ
DV7)RVL
6B1)J4F
YGT)5VF
9LG)LFX
8VD)TPS
NPG)WMJ
3WV)MLG
TRM)LPZ
Y2S)NDL
MC5)DDH
HY3)JTK
BVC)BN4
NR2)N9N
DLQ)RHR
MZ8)GGD
7CX)P84
YN9)H6J
BK2)5BT
XYP)FZ7
HPJ)LDZ
MW3)FXP
D5S)K24
25W)X7G
W2K)D4S
FBC)4RN
D8L)J33
44Z)3BT
TGV)YNY
SPB)T43
VKK)JLF
2F1)T1F
TS1)YGT
DTY)5XV
X4Q)1CF
D9D)XYP
MVR)3YL
RV6)PKT
24M)CNB
4FK)KYY
3W8)H4S
V2B)HW6
BKB)K8M
6DM)CLF
FLK)F78
54D)LQV
J1R)6DY
HQ3)N9D
SCL)BN7
KSK)1K6
S1G)WLW
L37)KP4
219)8SR
9PN)1CG
YYY)4JK
TCS)D6P
JFZ)RFM
LLC)7CX
MYM)KKW
P7L)P9R
RPW)YKV
XT2)YYQ
PFF)1NQ
YTC)532
Y57)5PC
TWZ)31C
8ZS)XP4
PDL)9WY
YWD)6K1
81T)CSX
JPH)YF3
HCL)L6M
CLF)ZKV
9N8)RD6
F78)PKJ
7J3)H84
SVH)BQS
H6N)TXJ
S4W)DXY
V6T)7WG
BHR)SCS
31C)L7D
YXZ)C41
6FC)7CF
C74)Q75
ZGZ)N95
HGN)B4J
B63)LB1
CGZ)KX9
S4J)D4F
TNG)4PD
Q1H)VP2
95Q)J14
JJL)W2K
ZQH)2R5
TTM)9Q5
VW1)7HK
FYX)P1W
DBB)CT2
DDL)N9X
7CJ)L8D
31Y)SJ4
TYF)DXR
13W)T16
FTT)VHG
VN5)1H5
XY9)TL4
5S3)K2L
S3T)KC3
BXY)1X9
FBZ)953
V66)7MW
WLW)XVK
B23)C8K
T9V)4CM
S1G)CM6
R89)KMJ
SWQ)66D
6GG)8DT
LRL)P4N
VGR)RV6
327)1S1
9JN)H51
N9N)M5Z
N9X)CFX
ZKV)XY9
J8J)B5N
HLN)1YQ
NSP)C4Y
7LC)KYP
M9V)XFH
DQ1)D9D
HBF)TFN
Z6T)9RJ
743)SCL
5FW)MZQ
RHY)45R
ZMT)T3P
C8F)93R
Z49)327
J25)C29
YNX)MDX
W2F)2GL
4DB)2GF
QT6)RDB
MDJ)WXK
NQK)GFM
D4S)9V1
67Q)PF9
FH9)P1V
VY8)ZZF
3Q1)SZM
FV2)QYC
DJV)TC2
GMM)H1T
CZ3)3RR
BTY)J5N
TCH)QHT
YSJ)G4G
VXZ)L34
BN4)M8N
V74)DRC
MYZ)FQJ
SG2)FJ9
2LV)LPB
4B3)KSH
PH9)21D
DCP)ZSC
KMW)ZG2
RFM)4YR
BCB)T13
P5S)LJP
FR9)GM7
SCF)S8C
MCV)VY8
W4F)7N5
BS9)2GM
8RF)NLF
WHB)TND
N95)RG9
26F)NPD
K8B)8XB
8VQ)88C
2L2)8LK
97H)24H
HF5)4P2
F9M)9DC
JMH)YRZ
WJX)69K
TWZ)SG2
JK7)H5Y
KWY)ZZ8
K23)LSL
VDQ)9CY
2VP)GJ3
FMY)L5P
M3P)1VF
LXR)WYY
8GR)L15
3C4)5PT
LXR)D4X
ZLN)SCF
51Y)FYR
QTD)WS1
J33)QDG
J6V)92G
GJ3)MKX
GHW)9R9
339)PW2
KYN)YP1
J22)94X
H4S)YOU
XH2)NMH
DJN)K65
TXJ)SKM
XTP)BFX
6C4)QRM
BKW)GSG
ZG2)C73
QMR)QR3
6JK)F5S
MQC)K3V
2QH)KNL
B8V)FSQ
P9R)QW9
D1G)6YM
DXR)1M4
YNY)LY3
MDX)Q4K
DFN)7ZQ
BZN)LV2
2F3)MVR
ZND)BK2
68C)VGD
RNJ)L74
S5P)LB5
ZL5)7WF
S1S)YFY
WX9)1XW
P7M)S5H
7HV)2KF
TSC)PSZ
178)JWL
JZ9)LR2
H6H)T6Q
5TG)FJ4
5VY)RNK
JYF)G7Y
LFX)6DM
GMW)59N
5PT)QNG
QRH)7YP
M6B)ZK9
7L7)Z3G
9T7)4HW
6C4)YYB
3PC)39V
F5G)TMX
VGT)FL4
HJF)51Y
7TC)C97
SMD)RH5
R8X)ZQH
QHG)VHS
73D)3PC
WKD)26F
2FK)SVQ
F77)Q8W
SLT)GTF
WGX)VRG
M72)YKM
S28)76F
X99)W4F
WY1)JYF
6GM)KXB
17Q)XMZ
T3P)N2G
QKS)P2Q
Z2C)KGX
GJ7)JPG
5VF)F2L
DW1)1TM
S49)5FW
YY4)BTY
YW1)3KY
4HF)BCS
4S6)84D
GLQ)NQ2
C7Q)8F7
Y59)6Y7
65H)WVH
8JY)4J4
DPV)KCS
D7W)W2S
6TY)TT3
CYD)XTD
21C)S3Y
PV7)HKF
XRL)PTN
JLF)66T
ZC1)F5P
VBD)3BH
QJF)YYY
GSG)KXZ
PTJ)1CS
J7G)Q7Y
83T)VLG
Q1W)FMJ
9QL)TWZ
T1C)ZC1
T3R)QDN
Z8R)74S
WWX)ZN9
7CH)M8K
8KK)4XL
VXK)8W4
6R3)Y7S
QNG)JZH
YJB)D5Q
DP7)HRY
843)TGV
1KV)DKJ
73D)6VL
RMM)4FK
D4X)YG5
H3K)PLF
KC3)SXN
XGL)4LB
2FG)5V2
M8N)JXG
FKN)W7P
1YC)ZHM
NKD)QJF
HKF)1YC
9XD)PV7
YP1)QP2
YNY)BVC
KQT)N7B
R2R)GQB
NDL)5W9
5YC)TZQ
WYY)FG8
1VF)GC7
Q8M)3Q1
K27)HBF
2V5)1YR
H7L)Q1P
L77)95Z
FDX)YYP
1CG)GNF
XQS)7J3
KRR)3XY
272)DZR
GGS)2RZ
YF3)FH9
BQS)ZBN
CFX)7KY
DVB)YTG
XNM)5PD
RYC)T6N
P6R)TZV
65G)GLD
TFN)LMS
ZJ2)L37
K58)3S5
NBN)14J
YDP)MV1
9QM)ZLB
S3Y)ZL5
6FY)LT4
Z1S)MCW
NSP)VBD
S2M)K1K
KGN)Z1J
T37)MGQ
MV1)2FB
RJG)6GG
93Y)VKS
NBJ)VV9
T6V)T2M
6SD)JRN
9SQ)2K9
155)Q9T
7XJ)N8D
PXF)4M2
JY8)MDW
J7Z)5GH
L26)J22
DRW)9JM
JZF)YBD
W1R)GJP
JQY)W7H
6HS)L1L
NPL)H4J
LQV)82S
5S3)KMW
HZS)9PN
H4Y)QBX
ST8)2KP
N9D)DFN
HSF)KYH
3RP)KQT
YMY)85G
SGT)FZQ
DR9)YQ8
FGQ)4BZ
KNL)91G
VM8)4K8
2RT)C9Z
TRQ)VKK
NLF)GJ2
WQX)TRM
DXH)7HN
B5B)GQ8
1HB)H6H
KQS)BS9
2KY)HNH
PV2)XZC
G7L)DJQ
HRX)ZB4
7J6)WXD
QDS)LWM
W2F)4PX
2WQ)L1Y
VJZ)QH5
GV1)TSL
FKS)V66
Z99)T7V
1J8)TMR
HQ3)Q6T
16D)817
CZ2)B8T
CTK)2Z5
WXD)NRN
HQB)TG3
MLG)B8J
JB1)3SC
F6M)BDF
ZWC)DJV
HV6)X26
NQ2)FZN
ZZR)7CH
L87)XLY
3GK)KT3
YMK)3W8
Q65)4NR
LB1)92F
M1L)K27
KT3)Z4P
SYQ)TV2
JVD)84M
L6M)YMY
K6B)QZF
7Q7)8RQ
Y5S)RLZ
GW1)DP7
LRN)47X
5PC)26L
ZWB)PJK
VC6)C75
MTV)P4D
P4H)SKD
QZS)D6S
7LM)7JD
XK6)1S7
LRY)T9S
4XN)DHZ
4D3)SN1
6FJ)XN9
9NX)YSJ
BN7)DP9
S4J)RGD
93R)HMW
SK8)B12
V18)7LQ
P42)LLC
C1N)L77
1QS)V18
Q8W)Q1W
TK8)T51
RCX)YX7
H6J)5FL
TZS)2KW
4C2)B63
LR2)ZNY
9YL)V94
W1H)TXT
NLP)273
GHG)61Y
DKJ)DW1
R46)9VB
S5Z)B8Y
KP7)XX6
V3B)MGN
7H9)G69
YD1)BXJ
G69)3NY
94X)7GP
NVT)4PR
4K5)7KM
KDS)RCB
QDT)VLY
S4C)24M
CTX)9N1
JDQ)743
XRT)BR1
1QS)V4H
TMR)42H
8WB)XRT
RT5)9QL
CGC)4D3
CQQ)78F
N2G)W5G
1RT)9JD
S3T)D6R
XX6)HW4
FT2)8VQ
9LK)35N
1TM)26B
T9T)NR2
98H)M39
4QZ)NBJ
9RM)NCV
FKQ)8YM
KGW)QNB
DP1)SWS
N3Y)GHW
VHW)8L8
1TS)FZZ
R4R)7RY
J35)9JN
P5V)SWQ
XHR)X1P
D89)1JF
D1N)KFL
JB2)VW1
PW7)MCV
T4G)4LD
BPY)N5L
WJK)K7H
N7C)CV4
KJD)2GC
9LK)X1D
J7W)ZK2
TND)YFC
HN2)V85
BPP)C7Q
VFY)3DH
DMS)YLJ
2FK)CZ2
C4Y)2JG
V9R)KN4
HJ1)VXK
RNY)PVG
5ZM)6R3
BYT)TRQ
1XW)T5G
41H)DT8
5CM)54D
7TS)VTT
1NQ)YY4
QHN)WD4
THM)2FW
ZL3)B98
4BP)YJC
1N2)F96
CW9)MHH
SVQ)9NX
M72)QVJ
SFX)CK1
8F7)QWH
9GP)F9G
B6G)4BP
Q4K)QRH
66D)969
JPG)SQR
T3R)67Q
ZX4)F77
X7G)X7P
3DH)PXF
ZTN)VM8
ZZ8)DRW
644)HKM
MYV)H38
M8V)DS9
291)9XJ
TC4)5GW
8TV)4XX
JMZ)D7R
WLK)BY3
3BT)5CM
R13)219
H6F)KC9
JFZ)R43
M23)88N
7P3)4BW
YQ8)8RH
84C)PTH
5XV)VZW
YWF)3RL
3FQ)YZX
QR3)DX7
VN3)3RP
FXM)RMM
PKJ)S97
2KP)RRF
LV2)WG7
G99)K8B
1YQ)7WQ
VXK)GMW
MDW)MYS
N11)KTY
48J)1Q5
B8W)V5S
FWR)4NJ
HZF)X37
F3D)S1S
GLD)7TL
T3M)F9M
V85)8N1
RP1)MDZ
9HF)MQX
Q1P)7ZV
NPK)17Q
KB2)RRN
5JZ)3FQ
H2P)LPT
2MC)DKR
KGN)KGW
7JD)Z6T
QMB)DQ1
J6F)8ZS
HX8)JQ7
78Z)5DV
TV9)QDT
TS9)97H
F49)YP6
8RH)22X
BXF)QMQ
L68)LSG
FLQ)4MC
RCF)L3N
F3F)VN5
7MW)DSS
8N1)8TK
BQ2)Q8M
PBJ)YS2
HMW)F6M
K1K)J6V
KDS)6KQ
ZL5)PDL
9N1)GLV
W9C)MW3
FTT)PW7
RRN)GM9
418)ZSH
1G6)B99
B8Y)2Q9
3MG)5J9
MXD)HRX
TXT)X6Z
FSM)3WJ
Z2G)S1F
3D9)V6W
D7R)M2V
PJK)LHJ
FXM)QRC
63T)GCG
P6K)LSR
HJZ)GLQ
Z3G)D8Y
VGD)ST2
CNB)GHG
RCB)GQV
C97)99J
YFY)RRX
COM)V2B
DGY)LLH
QRM)3S9
7CD)N2L
2KR)RRD
TZV)H3J
WYF)V74
ZHM)G99
QF5)DWB
LQ6)HM4
FKZ)KB4
Q56)SRH
PP5)3DQ
66T)JKB
LGF)ZJB
NZJ)73D
RTW)Z23
VYC)J8K
T2X)TM6
4P2)ZDH
5FP)2V5
CSX)SZ9
L1L)SVH
C85)81T
LWS)CXL
M8M)B6G
KRC)5XK
39G)ZBR
K9G)WV4
P73)KCM
521)M23
225)4RP
6YM)DGY
2Z5)521
M2V)N7C
TJB)X1X
1CS)BXY
ZK2)R4Q
FGF)9K9
XJ6)W1R
BTW)F3D
4LD)88M
BFY)DTY
7TL)N2J
FSQ)R2R
7CN)SYM
GQV)4M8
FB1)X6H
S89)QF5
1H5)PP2
VSQ)Q7P
T7V)D3L
627)FLK
Z7N)W7V
RB2)JF7
R2Y)N11
4PR)LZJ
P3K)16B
7N5)32H
TDZ)5YC
WG7)Q56
WS1)FKS
XZL)ZN2
YX7)TYK
2Z1)NSR
WJX)BPP
H38)KMX
Q1V)TB4
PT6)MYM
7TC)5FJ
4HW)M3P
RHR)JY8
K2L)KB2
4NR)SK4
VJL)XJX
33S)1TS
4RP)1V9
RKC)ZWB
7K4)8TV
NYF)2L2
JMZ)TS1
H7L)YD1
GGD)W4V
9WY)2QH
FVR)6TY
MRJ)XS3
PPW)YHR
45R)XP7
H51)TSC
W3W)MDJ
1M4)KLG
Q9T)WW8
ZNH)1GX
RMS)63S
CTM)GBS
Q5R)FB1
4JX)JZ9
R9F)XB9
PYC)S91
R36)MKB
CV3)YR8
461)6B1
GLQ)FPL
TMX)2KR
KGH)YLX
MKX)B4V
L7D)YP3
KX9)F3F
BK8)C74
LTS)461
9Z4)BYJ
KKW)RQD
GJ2)6RV
DPM)J7G
38T)5TQ
T43)KJD
QWH)LVT
JMR)V5L
V5L)ZMV
X9T)KKV
L3Q)S2M
MD6)68W
1V9)F7L
PKT)1HB
FMJ)5W3
YJC)PP5
WGZ)Q9Z
ZG1)G72
4HT)WL7
NBY)7WY
1QG)X33
WV4)TDV
32H)BG5
XY4)JF5
YT6)C6G
X6Z)BXF
J65)J49
BN4)358
RPD)35L
NQ2)NBM
VFB)JHS
ZF8)TCS
YLX)S1T
BG5)K59
GC7)6TX
33S)7NF
YR6)DJJ
74R)CTP
RTX)PM7
92G)VN3
16B)PPW
YP3)FBC
WH4)74R
88Z)GW1
HW6)TKM
XBS)JBR
F96)3FT
4YR)P6K
HB2)2WD
YTY)JCN
PDS)V8L
2DH)W6B
TV2)JKK
GYX)1JZ
2ZG)HB2
P5S)VFY
HFV)T93
RNZ)MXS
RNK)963
JTK)FY9
5J9)WQV
YBD)5SH
FQJ)2ZV
2XX)29T
RRY)TC1
PD7)MSS
RRF)418
VM6)6BS
V83)7P3
YL3)2FK
PCK)HSF
8Z5)BKB
RXS)4XD
NKZ)TMF
Z87)CQQ
F72)NGZ
P88)B5B
ST2)NBN
C26)R2Y
R43)PYP
NF9)JFN
SKM)WY1
BQ2)YW1
4RN)HYS
VGR)W3D
3BQ)R9F
CHM)8GR
HLF)YFL
K23)J7Z
7L7)N33
33R)SQL
28S)CGC
BHD)VNQ
XP4)RYS
CZD)BHD
X1D)J25
9XD)Z8R
SN1)PMY
STT)BXB
8S2)W9C
Q8W)CRK
XTY)7ZD
T4T)1LZ
BY3)GCV
QBX)VVS
HHG)BKW
CJD)79R
KML)21C
2JG)L68
G94)FH1
QZ3)ZTD
Q8N)Q3W
P4N)5V1
6HK)9GP
1JP)DS7
FY9)BPY
NZP)L87
2SW)ZNH
4JK)TDZ
532)4DB
5FL)X3T
DT8)ZS4
4BZ)31Y
133)T4T
KWG)F72
PVT)V9R
XP7)HSZ
9K9)5HB
1D1)SGT
FPL)YMK
2WQ)HJY
LY3)Y7N
GCV)DPM
4NJ)5S3
7WQ)RHY
5W1)KDP
JT7)VDQ
KTT)Q65
FZQ)FVR
CK1)D5S
H5G)FLQ
PNN)4K5
NVR)QYV
QYV)CTK
Z7V)WYF
V7G)7Z5
K3G)R41
P2Q)3CY
XB9)4CG
D4S)8WB
1S7)R7J
NVF)KGH
PDS)YX4
WYY)JJL
6BS)4MJ
7TL)Z4T
JHS)L4C
MY1)R2X
4CG)YWD
3NY)9D7
Q75)WGX
2Q9)Y57
ZSH)W2G
J14)PML
MBD)KDS
2ZV)3GK
P1V)TCH
J51)9S4
V88)692
8KK)X4R
MXS)9LG
71M)T5H
KBY)18D
Q6H)XRL
31F)5CY
DWT)D1G
B8J)SQH
9YS)G6B
L5P)H6F
NR2)5P3
G8N)PFF
T6N)BTW
FNP)ZG1
XT3)RNY
6SD)S1G
84Q)JT7
YHH)KZ7
L3N)616
5N8)QMB
JF3)36N
2VN)VS8
SJ4)7FG
HC5)SLT
68W)KKG
PRP)T6V
PTG)JF2
JB4)2RT
F9N)BQ2
X8J)6LW
R8W)R89
ZF8)YR9
1R7)HYZ
67Z)XGL
V85)KRC
G58)4FR
JPH)Z3K
L34)XB3
56N)DVB
YKM)RCX
6MV)Y2S
R6K)KY5
N8D)2MT
7HN)TZS
HMN)C5X
H4V)G58
TC1)BZN
F7L)KML
LGL)RTX
CP4)G7L
DDH)MX1
RRD)XKD
8RQ)RNJ
YSK)1WH
FJQ)CFB
GYG)HHG
ZMV)7NX
PCK)YSK
CG8)MY1
4BB)9L2
9X3)CWF
XB3)J65
7XJ)2FG
G9P)VDH
L8N)T3J
JDT)R36
5YW)PPK
7ZQ)M1L
HJY)6TG
WB8)MV4
Z3H)5TP
MJV)78Z
MHX)GYX
5HB)6FY
KFL)9HF
46Z)D8N
JCN)XTP
QYY)7MQ
C4F)95Q
BQ8)ZF8
DYQ)V7T
GMX)SFX
QRC)VC6
MV1)FV2
953)7SC
KJS)4BB
LR1)KJS
9CY)YSV
BR1)RJG
8DT)ZWH
DPZ)VNV
THZ)8WW
YLX)NKD
BJQ)JMH
LSR)PTJ
7ZD)2VN
M6B)Q1V
BYJ)S4C
P91)78Q
X4C)SG4
X3W)Q8N
4CS)ZWC
SXN)2WZ
YL3)2Z1
S3H)6Z2
NPY)NLP
FP3)W4Q
6TG)JSZ
6K1)JCH
J25)65G
WZ1)8G7
RLZ)95S
2PR)QYY
K24)211
XVK)WJK
4FR)5VV
HJN)7H8
ZFJ)WJX
LJP)1JP
9R9)NZT
5GK)V7G
KN4)XM4
NJ1)H3F
N2J)HJN
CTM)H7L
4DG)N1Q
273)29H
BXB)9ZT
2MT)9QY
SCS)T3M
PVG)9JJ
T93)1ZQ
M5Y)88Z
31G)B3H
HC5)HQL
YYQ)PT6
8WW)9TX
ZSC)P42
5FY)S89
DP9)D94
GJP)JVD
WW8)JCZ
YS1)HGF
L5G)BQM
H3J)KSK
JF3)KYN
W2S)XHR
KJY)FMY
1ZQ)B6F
Y5G)TBX
HPF)LML
T3J)TKR
LDZ)89C
84D)85B
7YP)3ZV
H51)RYC
KCM)T3R
TZM)RMS
GJ7)JLW
6GG)WSN
TGV)MCC
7NF)L5G
XQS)YHH
ZTD)Z87
6RV)XGT
QH5)TK8
3WC)CFZ
893)N1C
RQD)71M
98K)GBQ
DZV)2VP
95Z)SS7
HZK)C59
TKM)JDQ
QZF)7MC
J8K)HF5
XN9)8Z5
8LK)HJ1
665)ZLN
CFB)2BP
B8Y)NXL
PK9)FNJ
BX5)LGF
H84)VYC
6FX)S41
CG8)FWR
G98)FSM
DP7)Z99
X4J)4CS
KSH)B8V
LML)WWP
VM6)BFY
SG4)133
MCW)X73
H21)X99
GTK)R8P
3F3)Z7J
4PD)VGT
7CD)CZD
WWP)RNL
9S4)P73
HKM)5W1
RQD)NYF
GFM)31G
1Q5)HCL
WLK)712
DS7)QDS
9LG)7J1
V57)5R9
VVJ)BJQ
P3D)6X9
YWV)7MP
P84)9N8
ZNY)P7L
4WP)ZP4
DXY)WLB
KJD)C8F
6P8)M8V
3BH)FKY
H9H)BG7
2BF)5R2
4MS)VVJ
FJ9)7RX
7J1)QZS
7CF)T1C
MGQ)ZP3
T1F)2DW
NCV)FNP
9VB)H4V
VRG)Y5G
TPD)XVY
W7P)F1Z
GM9)WZ1
ZB4)4XN
ZY4)S4W
XF1)GW7
BG7)JMZ
9DD)H3K
74S)N92
YR2)BDN
L8D)GGS
7SC)33S
B3H)W1H
Y7S)2PW
79H)3MS
3KY)KWG
TPS)MHX
5PD)JQ4
N2L)8WD
B6F)K23
1S1)V83
6KQ)JV1
G4G)GSS
WD7)GLT
1X9)ZC3
BK2)QC3
S1F)Y5K
YRZ)HZF
35L)DLQ
JSZ)B6Z
7GP)XT2
8DD)5Z3
88C)FJQ
C75)CX1
T5H)W38
GW7)Y69
MQH)48J
KXB)TNV
ZWH)RV7
LPZ)NF8
GLK)NBY
92F)WB8
J74)4SV
YTH)VM6
HYC)XF1
JHP)7CJ
LLH)Y14
QVJ)Q5C
22N)JK7
T5G)4MZ
59N)4YV
DT8)KVB
XN7)Q6B
X1X)PCH
V8L)843
P4H)HDT
Z4T)MD6
69K)9XD
MQ7)ZMT
XXD)NZJ
18D)FSF
6DY)QFG
ZDZ)WLK
G72)D8L
W7V)DQ6
ZS4)Z1S
W4Q)MJV
PLF)GPQ
6VL)5SN
ZBR)D7W
ZP4)RKC
XJX)4JX
NPK)VJL
WZX)GVT
KLG)NKZ
7KM)4QZ
FJF)M1G
P6H)Y18
PV2)1KV
4YV)TGB
QP2)25W
GBS)2XX
7WY)BFF
92P)RPW
RGD)9L6
SQL)ZDZ
JCN)FKN
GBQ)PCK
JBR)XP8
YLJ)3F3
SZ9)LRL
T6Q)M6B
D4F)ZZR
G4C)163
BC5)BT2
8L8)Z2G
9XJ)NQK
3YL)W2F
4P9)L23
SZ9)HGN
BXF)7K4
ZN2)YZ7
3BJ)7QS
S91)HQ3
YX4)5Q3
9DC)FTT
PTH)H94
WSN)RLP
BDN)BX5
NLF)HTY
84M)4B3
N92)3WC
DSS)WX9
X6H)GYG
YS2)HJF
PSZ)JND
VP2)QG2
JV1)PV2
RM8)XN7
PML)6VK
S1T)FXM
29H)QV9
QHT)CHM
4XL)N3Y
VW4)WKV
S5H)7CN
K3V)Z49
YG5)S3T
9JD)796
ZN9)6MV
LVT)NQ8
2KF)WGZ
TKR)J48
LSG)WT5
MPS)JMR
6MV)HZS
2R5)BSC
MKB)WHB
B6G)G8N
P6R)MQC
6MY)GMX
R1L)RJX
85B)C4F
P4D)R2Z
26L)93Y
9JD)NZP
1GN)X4Q
GJ3)Y59
D6R)44Z
1YR)TZM
8LX)KWY
2Y2)YWV
21D)WJB
LVT)S4J
VTT)R7S
4RP)ZZY
4M2)5LJ
5TP)TPD
6TY)3R5
3VB)CYC
BCT)JJV
5GH)58L
RDB)PD7
NBM)9QM
MPQ)F2C
3CY)R1L
BH2)TNG
DB2)G94
XS3)SV7
4D5)XKR
358)S49
HM4)FZK
PK9)GMP
9Z4)G4C
91G)YTM
CCK)1QS
XFH)BCT
ZLB)XRQ
W1M)PDS
8WD)MM2
XKD)JFC
L4C)CP4
