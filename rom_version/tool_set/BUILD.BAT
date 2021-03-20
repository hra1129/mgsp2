cd MGS
set PATH=../TOOL
if not exist mgslist.txt (
	call mklist.bat
)
cd ..

cd SRC

mgsp_rom_maker.exe
if errorlevel 1 (
	goto error_exit
)

if exist ROM_BANK.ASM (
	del ROM_BANK.ASM
)
copy ROM_BANK_ASC8.ASM ROM_BANK.ASM
zma MGSPROM.ASM ../MGSPASC8.ROM
move zma.log zma_asc8.log
move zma.sym zma_asc8.sym

del ROM_BANK.ASM
copy ROM_BANK_KNM8.ASM ROM_BANK.ASM
zma MGSPROM.ASM ../MGSPKNM8.ROM
move zma.log zma_knm8.log
move zma.sym zma_knm8.sym

:error_exit
cd ..
pause
