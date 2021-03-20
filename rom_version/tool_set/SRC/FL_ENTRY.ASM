fl_entry_table_init_bank := 3
fl_entry_table_init_offset := 2920
fl_files := 93

fl_entry_table_init::
	; entry 0
	db	0x41, 0x4b, 0x55, 0x4d, 0x41, 0x30, 0x31, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	3			; +9 , 1byte : Bank number where the file resides
	dw	4408			; +10, 2bytes: Address in the bank where the file resides
	dw	1796			; +12, 2bytes: file size
	db	0			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 1
	db	0x41, 0x4b, 0x55, 0x4d, 0x42, 0x47, 0x4d, 0x31, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	3			; +9 , 1byte : Bank number where the file resides
	dw	6204			; +10, 2bytes: Address in the bank where the file resides
	dw	3200			; +12, 2bytes: file size
	db	1			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 2
	db	0x42, 0x47, 0x4d, 0x41, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	4			; +9 , 1byte : Bank number where the file resides
	dw	1212			; +10, 2bytes: Address in the bank where the file resides
	dw	3968			; +12, 2bytes: file size
	db	2			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 3
	db	0x42, 0x47, 0x4d, 0x42, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	4			; +9 , 1byte : Bank number where the file resides
	dw	5180			; +10, 2bytes: Address in the bank where the file resides
	dw	4096			; +12, 2bytes: file size
	db	3			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 4
	db	0x42, 0x47, 0x4d, 0x43, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	5			; +9 , 1byte : Bank number where the file resides
	dw	1084			; +10, 2bytes: Address in the bank where the file resides
	dw	4096			; +12, 2bytes: file size
	db	4			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 5
	db	0x42, 0x47, 0x4d, 0x44, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	5			; +9 , 1byte : Bank number where the file resides
	dw	5180			; +10, 2bytes: Address in the bank where the file resides
	dw	4096			; +12, 2bytes: file size
	db	5			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 6
	db	0x42, 0x47, 0x4d, 0x45, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	6			; +9 , 1byte : Bank number where the file resides
	dw	1084			; +10, 2bytes: Address in the bank where the file resides
	dw	640			; +12, 2bytes: file size
	db	6			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 7
	db	0x42, 0x47, 0x4d, 0x46, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	6			; +9 , 1byte : Bank number where the file resides
	dw	1724			; +10, 2bytes: Address in the bank where the file resides
	dw	3456			; +12, 2bytes: file size
	db	7			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 8
	db	0x42, 0x47, 0x4d, 0x47, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	6			; +9 , 1byte : Bank number where the file resides
	dw	5180			; +10, 2bytes: Address in the bank where the file resides
	dw	4096			; +12, 2bytes: file size
	db	8			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 9
	db	0x42, 0x47, 0x4d, 0x48, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	7			; +9 , 1byte : Bank number where the file resides
	dw	1084			; +10, 2bytes: Address in the bank where the file resides
	dw	4096			; +12, 2bytes: file size
	db	9			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 10
	db	0x42, 0x47, 0x4d, 0x49, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	7			; +9 , 1byte : Bank number where the file resides
	dw	5180			; +10, 2bytes: Address in the bank where the file resides
	dw	4096			; +12, 2bytes: file size
	db	10			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 11
	db	0x42, 0x47, 0x4d, 0x4a, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	8			; +9 , 1byte : Bank number where the file resides
	dw	1084			; +10, 2bytes: Address in the bank where the file resides
	dw	2304			; +12, 2bytes: file size
	db	11			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 12
	db	0x42, 0x47, 0x4d, 0x4b, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	8			; +9 , 1byte : Bank number where the file resides
	dw	3388			; +10, 2bytes: Address in the bank where the file resides
	dw	4096			; +12, 2bytes: file size
	db	12			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 13
	db	0x42, 0x47, 0x4d, 0x4c, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	8			; +9 , 1byte : Bank number where the file resides
	dw	7484			; +10, 2bytes: Address in the bank where the file resides
	dw	3968			; +12, 2bytes: file size
	db	13			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 14
	db	0x42, 0x4f, 0x53, 0x53, 0x0, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	9			; +9 , 1byte : Bank number where the file resides
	dw	3260			; +10, 2bytes: Address in the bank where the file resides
	dw	4096			; +12, 2bytes: file size
	db	14			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 15
	db	0x64, 0x78, 0x78, 0x2d, 0x62, 0x6f, 0x73, 0x73, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	9			; +9 , 1byte : Bank number where the file resides
	dw	7356			; +10, 2bytes: Address in the bank where the file resides
	dw	5376			; +12, 2bytes: file size
	db	15			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 16
	db	0x4b, 0x41, 0x54, 0x48, 0x41, 0x52, 0x49, 0x4e, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	10			; +9 , 1byte : Bank number where the file resides
	dw	4540			; +10, 2bytes: Address in the bank where the file resides
	dw	1152			; +12, 2bytes: file size
	db	16			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 17
	db	0x6d, 0x6e, 0x62, 0x2d, 0x31, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	10			; +9 , 1byte : Bank number where the file resides
	dw	5692			; +10, 2bytes: Address in the bank where the file resides
	dw	10368			; +12, 2bytes: file size
	db	17			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 18
	db	0x6d, 0x6e, 0x62, 0x2d, 0x31, 0x5f, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	11			; +9 , 1byte : Bank number where the file resides
	dw	7868			; +10, 2bytes: Address in the bank where the file resides
	dw	10368			; +12, 2bytes: file size
	db	18			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 19
	db	0x6d, 0x6e, 0x62, 0x2d, 0x32, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	13			; +9 , 1byte : Bank number where the file resides
	dw	1852			; +10, 2bytes: Address in the bank where the file resides
	dw	5248			; +12, 2bytes: file size
	db	19			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 20
	db	0x6d, 0x6e, 0x62, 0x2d, 0x33, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	13			; +9 , 1byte : Bank number where the file resides
	dw	7100			; +10, 2bytes: Address in the bank where the file resides
	dw	3968			; +12, 2bytes: file size
	db	20			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 21
	db	0x6d, 0x6e, 0x62, 0x2d, 0x34, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	14			; +9 , 1byte : Bank number where the file resides
	dw	2876			; +10, 2bytes: Address in the bank where the file resides
	dw	5120			; +12, 2bytes: file size
	db	21			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 22
	db	0x6d, 0x6e, 0x62, 0x2d, 0x35, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	14			; +9 , 1byte : Bank number where the file resides
	dw	7996			; +10, 2bytes: Address in the bank where the file resides
	dw	7296			; +12, 2bytes: file size
	db	22			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 23
	db	0x6d, 0x6e, 0x62, 0x2d, 0x36, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	15			; +9 , 1byte : Bank number where the file resides
	dw	7100			; +10, 2bytes: Address in the bank where the file resides
	dw	5120			; +12, 2bytes: file size
	db	23			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 24
	db	0x6d, 0x6e, 0x62, 0x2d, 0x37, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	16			; +9 , 1byte : Bank number where the file resides
	dw	4028			; +10, 2bytes: Address in the bank where the file resides
	dw	5632			; +12, 2bytes: file size
	db	24			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 25
	db	0x6d, 0x6e, 0x62, 0x2d, 0x38, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	17			; +9 , 1byte : Bank number where the file resides
	dw	1468			; +10, 2bytes: Address in the bank where the file resides
	dw	7424			; +12, 2bytes: file size
	db	25			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 26
	db	0x6d, 0x6e, 0x62, 0x2d, 0x62, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	18			; +9 , 1byte : Bank number where the file resides
	dw	700			; +10, 2bytes: Address in the bank where the file resides
	dw	3072			; +12, 2bytes: file size
	db	26			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 27
	db	0x6d, 0x6e, 0x62, 0x2d, 0x65, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	18			; +9 , 1byte : Bank number where the file resides
	dw	3772			; +10, 2bytes: Address in the bank where the file resides
	dw	9216			; +12, 2bytes: file size
	db	27			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 28
	db	0x6d, 0x6e, 0x62, 0x2d, 0x67, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	19			; +9 , 1byte : Bank number where the file resides
	dw	4796			; +10, 2bytes: Address in the bank where the file resides
	dw	1664			; +12, 2bytes: file size
	db	28			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 29
	db	0x6d, 0x6e, 0x62, 0x2d, 0x6c, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	19			; +9 , 1byte : Bank number where the file resides
	dw	6460			; +10, 2bytes: Address in the bank where the file resides
	dw	2560			; +12, 2bytes: file size
	db	29			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 30
	db	0x6d, 0x6e, 0x62, 0x2d, 0x6d, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	20			; +9 , 1byte : Bank number where the file resides
	dw	828			; +10, 2bytes: Address in the bank where the file resides
	dw	2304			; +12, 2bytes: file size
	db	30			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 31
	db	0x6d, 0x6e, 0x62, 0x2d, 0x6f, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	20			; +9 , 1byte : Bank number where the file resides
	dw	3132			; +10, 2bytes: Address in the bank where the file resides
	dw	5888			; +12, 2bytes: file size
	db	31			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 32
	db	0x6d, 0x6e, 0x62, 0x2d, 0x70, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	21			; +9 , 1byte : Bank number where the file resides
	dw	828			; +10, 2bytes: Address in the bank where the file resides
	dw	5760			; +12, 2bytes: file size
	db	32			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 33
	db	0x4d, 0x4f, 0x41, 0x44, 0x32, 0x30, 0x34, 0x32, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	21			; +9 , 1byte : Bank number where the file resides
	dw	6588			; +10, 2bytes: Address in the bank where the file resides
	dw	2176			; +12, 2bytes: file size
	db	33			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 34
	db	0x4d, 0x4f, 0x4a, 0x41, 0x49, 0x4d, 0x45, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	22			; +9 , 1byte : Bank number where the file resides
	dw	572			; +10, 2bytes: Address in the bank where the file resides
	dw	1152			; +12, 2bytes: file size
	db	34			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 35
	db	0x4e, 0x45, 0x4f, 0x4b, 0x4f, 0x42, 0x45, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	22			; +9 , 1byte : Bank number where the file resides
	dw	1724			; +10, 2bytes: Address in the bank where the file resides
	dw	9984			; +12, 2bytes: file size
	db	35			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 36
	db	0x53, 0x4e, 0x38, 0x2d, 0x4a, 0x41, 0x49, 0x4d, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	23			; +9 , 1byte : Bank number where the file resides
	dw	3516			; +10, 2bytes: Address in the bank where the file resides
	dw	1408			; +12, 2bytes: file size
	db	36			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 37
	db	0x53, 0x4e, 0x38, 0x2d, 0x53, 0x4e, 0x41, 0x54, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	23			; +9 , 1byte : Bank number where the file resides
	dw	4924			; +10, 2bytes: Address in the bank where the file resides
	dw	3584			; +12, 2bytes: file size
	db	37			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 38
	db	0x53, 0x4e, 0x38, 0x2d, 0x54, 0x57, 0x49, 0x4c, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	24			; +9 , 1byte : Bank number where the file resides
	dw	316			; +10, 2bytes: Address in the bank where the file resides
	dw	4480			; +12, 2bytes: file size
	db	38			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 39
	db	0x53, 0x4e, 0x38, 0x5f, 0x4a, 0x41, 0x49, 0x4d, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	24			; +9 , 1byte : Bank number where the file resides
	dw	4796			; +10, 2bytes: Address in the bank where the file resides
	dw	1408			; +12, 2bytes: file size
	db	39			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 40
	db	0x53, 0x4e, 0x38, 0x5f, 0x53, 0x4e, 0x41, 0x54, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	24			; +9 , 1byte : Bank number where the file resides
	dw	6204			; +10, 2bytes: Address in the bank where the file resides
	dw	3584			; +12, 2bytes: file size
	db	40			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 41
	db	0x53, 0x4e, 0x38, 0x5f, 0x54, 0x57, 0x49, 0x4c, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	25			; +9 , 1byte : Bank number where the file resides
	dw	1596			; +10, 2bytes: Address in the bank where the file resides
	dw	4480			; +12, 2bytes: file size
	db	41			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 42
	db	0x53, 0x4e, 0x41, 0x54, 0x2d, 0x54, 0x4f, 0x53, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	25			; +9 , 1byte : Bank number where the file resides
	dw	6076			; +10, 2bytes: Address in the bank where the file resides
	dw	1944			; +12, 2bytes: file size
	db	42			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 43
	db	0x53, 0x4e, 0x41, 0x54, 0x43, 0x48, 0x2d, 0x31, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	25			; +9 , 1byte : Bank number where the file resides
	dw	8020			; +10, 2bytes: Address in the bank where the file resides
	dw	1792			; +12, 2bytes: file size
	db	43			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 44
	db	0x53, 0x4e, 0x41, 0x54, 0x43, 0x48, 0x2d, 0x32, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	26			; +9 , 1byte : Bank number where the file resides
	dw	1620			; +10, 2bytes: Address in the bank where the file resides
	dw	2048			; +12, 2bytes: file size
	db	44			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 45
	db	0x53, 0x4e, 0x41, 0x54, 0x43, 0x48, 0x2d, 0x33, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	26			; +9 , 1byte : Bank number where the file resides
	dw	3668			; +10, 2bytes: Address in the bank where the file resides
	dw	1024			; +12, 2bytes: file size
	db	45			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 46
	db	0x53, 0x4e, 0x41, 0x54, 0x5f, 0x54, 0x4f, 0x53, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	26			; +9 , 1byte : Bank number where the file resides
	dw	4692			; +10, 2bytes: Address in the bank where the file resides
	dw	2048			; +12, 2bytes: file size
	db	46			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 47
	db	0x53, 0x4e, 0x54, 0x2d, 0x4b, 0x4f, 0x42, 0x45, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	26			; +9 , 1byte : Bank number where the file resides
	dw	6740			; +10, 2bytes: Address in the bank where the file resides
	dw	6016			; +12, 2bytes: file size
	db	47			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 48
	db	0x53, 0x4e, 0x54, 0x5f, 0x4b, 0x4f, 0x42, 0x45, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	27			; +9 , 1byte : Bank number where the file resides
	dw	4564			; +10, 2bytes: Address in the bank where the file resides
	dw	5913			; +12, 2bytes: file size
	db	48			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 49
	db	0x57, 0x49, 0x43, 0x48, 0x45, 0x44, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	28			; +9 , 1byte : Bank number where the file resides
	dw	2285			; +10, 2bytes: Address in the bank where the file resides
	dw	5120			; +12, 2bytes: file size
	db	49			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 50
	db	0x59, 0x53, 0x33, 0x2d, 0x30, 0x31, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	28			; +9 , 1byte : Bank number where the file resides
	dw	7405			; +10, 2bytes: Address in the bank where the file resides
	dw	1274			; +12, 2bytes: file size
	db	50			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 51
	db	0x59, 0x53, 0x33, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	487			; +10, 2bytes: Address in the bank where the file resides
	dw	794			; +12, 2bytes: file size
	db	51			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 52
	db	0x59, 0x53, 0x33, 0x30, 0x31, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	1281			; +10, 2bytes: Address in the bank where the file resides
	dw	591			; +12, 2bytes: file size
	db	52			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 53
	db	0x59, 0x53, 0x33, 0x30, 0x32, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	1872			; +10, 2bytes: Address in the bank where the file resides
	dw	1055			; +12, 2bytes: file size
	db	53			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 54
	db	0x59, 0x53, 0x33, 0x30, 0x32, 0x41, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	2927			; +10, 2bytes: Address in the bank where the file resides
	dw	758			; +12, 2bytes: file size
	db	54			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 55
	db	0x59, 0x53, 0x33, 0x30, 0x33, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	3685			; +10, 2bytes: Address in the bank where the file resides
	dw	573			; +12, 2bytes: file size
	db	55			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 56
	db	0x59, 0x53, 0x33, 0x30, 0x34, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	4258			; +10, 2bytes: Address in the bank where the file resides
	dw	674			; +12, 2bytes: file size
	db	56			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 57
	db	0x59, 0x53, 0x33, 0x30, 0x35, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	4932			; +10, 2bytes: Address in the bank where the file resides
	dw	603			; +12, 2bytes: file size
	db	57			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 58
	db	0x59, 0x53, 0x33, 0x30, 0x36, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	5535			; +10, 2bytes: Address in the bank where the file resides
	dw	1816			; +12, 2bytes: file size
	db	58			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 59
	db	0x59, 0x53, 0x33, 0x30, 0x36, 0x41, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	29			; +9 , 1byte : Bank number where the file resides
	dw	7351			; +10, 2bytes: Address in the bank where the file resides
	dw	1816			; +12, 2bytes: file size
	db	59			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 60
	db	0x59, 0x53, 0x33, 0x30, 0x37, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	30			; +9 , 1byte : Bank number where the file resides
	dw	975			; +10, 2bytes: Address in the bank where the file resides
	dw	1626			; +12, 2bytes: file size
	db	60			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 61
	db	0x59, 0x53, 0x33, 0x30, 0x38, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	30			; +9 , 1byte : Bank number where the file resides
	dw	2601			; +10, 2bytes: Address in the bank where the file resides
	dw	783			; +12, 2bytes: file size
	db	61			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 62
	db	0x59, 0x53, 0x33, 0x30, 0x39, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	30			; +9 , 1byte : Bank number where the file resides
	dw	3384			; +10, 2bytes: Address in the bank where the file resides
	dw	1727			; +12, 2bytes: file size
	db	62			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 63
	db	0x59, 0x53, 0x33, 0x30, 0x39, 0x41, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	30			; +9 , 1byte : Bank number where the file resides
	dw	5111			; +10, 2bytes: Address in the bank where the file resides
	dw	990			; +12, 2bytes: file size
	db	63			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 64
	db	0x59, 0x53, 0x33, 0x31, 0x30, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	30			; +9 , 1byte : Bank number where the file resides
	dw	6101			; +10, 2bytes: Address in the bank where the file resides
	dw	1811			; +12, 2bytes: file size
	db	64			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 65
	db	0x59, 0x53, 0x33, 0x31, 0x31, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	30			; +9 , 1byte : Bank number where the file resides
	dw	7912			; +10, 2bytes: Address in the bank where the file resides
	dw	1025			; +12, 2bytes: file size
	db	65			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 66
	db	0x59, 0x53, 0x33, 0x31, 0x31, 0x41, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	745			; +10, 2bytes: Address in the bank where the file resides
	dw	706			; +12, 2bytes: file size
	db	66			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 67
	db	0x59, 0x53, 0x33, 0x31, 0x32, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	1451			; +10, 2bytes: Address in the bank where the file resides
	dw	700			; +12, 2bytes: file size
	db	67			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 68
	db	0x59, 0x53, 0x33, 0x31, 0x33, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	2151			; +10, 2bytes: Address in the bank where the file resides
	dw	295			; +12, 2bytes: file size
	db	68			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 69
	db	0x59, 0x53, 0x33, 0x31, 0x34, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	2446			; +10, 2bytes: Address in the bank where the file resides
	dw	1565			; +12, 2bytes: file size
	db	69			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 70
	db	0x59, 0x53, 0x33, 0x31, 0x34, 0x41, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	4011			; +10, 2bytes: Address in the bank where the file resides
	dw	972			; +12, 2bytes: file size
	db	70			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 71
	db	0x59, 0x53, 0x33, 0x31, 0x35, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	4983			; +10, 2bytes: Address in the bank where the file resides
	dw	481			; +12, 2bytes: file size
	db	71			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 72
	db	0x59, 0x53, 0x33, 0x31, 0x36, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	5464			; +10, 2bytes: Address in the bank where the file resides
	dw	1712			; +12, 2bytes: file size
	db	72			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 73
	db	0x59, 0x53, 0x33, 0x31, 0x37, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	7176			; +10, 2bytes: Address in the bank where the file resides
	dw	631			; +12, 2bytes: file size
	db	73			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 74
	db	0x59, 0x53, 0x33, 0x31, 0x38, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	31			; +9 , 1byte : Bank number where the file resides
	dw	7807			; +10, 2bytes: Address in the bank where the file resides
	dw	631			; +12, 2bytes: file size
	db	74			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 75
	db	0x59, 0x53, 0x33, 0x31, 0x39, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	32			; +9 , 1byte : Bank number where the file resides
	dw	246			; +10, 2bytes: Address in the bank where the file resides
	dw	1280			; +12, 2bytes: file size
	db	75			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 76
	db	0x59, 0x53, 0x33, 0x31, 0x39, 0x41, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	32			; +9 , 1byte : Bank number where the file resides
	dw	1526			; +10, 2bytes: Address in the bank where the file resides
	dw	809			; +12, 2bytes: file size
	db	76			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 77
	db	0x59, 0x53, 0x33, 0x32, 0x30, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	32			; +9 , 1byte : Bank number where the file resides
	dw	2335			; +10, 2bytes: Address in the bank where the file resides
	dw	928			; +12, 2bytes: file size
	db	77			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 78
	db	0x59, 0x53, 0x33, 0x32, 0x31, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	32			; +9 , 1byte : Bank number where the file resides
	dw	3263			; +10, 2bytes: Address in the bank where the file resides
	dw	861			; +12, 2bytes: file size
	db	78			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 79
	db	0x59, 0x53, 0x33, 0x32, 0x32, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	32			; +9 , 1byte : Bank number where the file resides
	dw	4124			; +10, 2bytes: Address in the bank where the file resides
	dw	970			; +12, 2bytes: file size
	db	79			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 80
	db	0x59, 0x53, 0x33, 0x32, 0x33, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	32			; +9 , 1byte : Bank number where the file resides
	dw	5094			; +10, 2bytes: Address in the bank where the file resides
	dw	1327			; +12, 2bytes: file size
	db	80			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 81
	db	0x59, 0x53, 0x33, 0x32, 0x33, 0x41, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	32			; +9 , 1byte : Bank number where the file resides
	dw	6421			; +10, 2bytes: Address in the bank where the file resides
	dw	932			; +12, 2bytes: file size
	db	81			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 82
	db	0x59, 0x53, 0x33, 0x32, 0x34, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	32			; +9 , 1byte : Bank number where the file resides
	dw	7353			; +10, 2bytes: Address in the bank where the file resides
	dw	1662			; +12, 2bytes: file size
	db	82			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 83
	db	0x59, 0x53, 0x33, 0x32, 0x35, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	823			; +10, 2bytes: Address in the bank where the file resides
	dw	2611			; +12, 2bytes: file size
	db	83			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 84
	db	0x59, 0x53, 0x33, 0x32, 0x35, 0x41, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	3434			; +10, 2bytes: Address in the bank where the file resides
	dw	1589			; +12, 2bytes: file size
	db	84			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 85
	db	0x59, 0x53, 0x33, 0x32, 0x36, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	5023			; +10, 2bytes: Address in the bank where the file resides
	dw	889			; +12, 2bytes: file size
	db	85			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 86
	db	0x59, 0x53, 0x33, 0x32, 0x37, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	5912			; +10, 2bytes: Address in the bank where the file resides
	dw	214			; +12, 2bytes: file size
	db	86			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 87
	db	0x59, 0x53, 0x33, 0x32, 0x38, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	6126			; +10, 2bytes: Address in the bank where the file resides
	dw	259			; +12, 2bytes: file size
	db	87			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 88
	db	0x59, 0x53, 0x33, 0x32, 0x39, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	6385			; +10, 2bytes: Address in the bank where the file resides
	dw	533			; +12, 2bytes: file size
	db	88			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 89
	db	0x59, 0x53, 0x33, 0x33, 0x30, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	6918			; +10, 2bytes: Address in the bank where the file resides
	dw	442			; +12, 2bytes: file size
	db	89			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 90
	db	0x59, 0x53, 0x33, 0x33, 0x31, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	7360			; +10, 2bytes: Address in the bank where the file resides
	dw	397			; +12, 2bytes: file size
	db	90			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 91
	db	0x59, 0x53, 0x33, 0x33, 0x32, 0x0, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	33			; +9 , 1byte : Bank number where the file resides
	dw	7757			; +10, 2bytes: Address in the bank where the file resides
	dw	760			; +12, 2bytes: file size
	db	91			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
	; entry 92
	db	0x59, 0x53, 0x33, 0x5f, 0x30, 0x31, 0x0, 0x0, 0x0	; +0 , 9bytes: file name( ASCIIZ )
	db	34			; +9 , 1byte : Bank number where the file resides
	dw	325			; +10, 2bytes: Address in the bank where the file resides
	dw	1257			; +12, 2bytes: file size
	db	92			; +14, 1byte : Directory entry index
	db	0			; +15, 1byte : Reserved
