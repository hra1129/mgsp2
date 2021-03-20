@if not exist KFONT.BIN (
@	rem @echo "Misaki Gothic Font"
@	rem BDF2BIN.exe ../misaki_bdf_2019-10-19/misaki_gothic.bdf     KFONT.BIN > nul

@	echo "Misaki Gothic Font [2nd]"
@	BDF2BIN.exe ../misaki_bdf_2019-10-19/misaki_gothic_2nd.bdf KFONT.BIN > nul

@	rem @echo "Misaki Mincho Font"
@	rem BDF2BIN.exe ../misaki_bdf_2019-10-19/misaki_mincho.bdf     KFONT.BIN > nul
)
