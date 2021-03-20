MGSP version 2.1.2 ROM	Copyright (C) 2021 HRA!

1. Introduction
	I made this as an exercise in creating software for MegaROM cartridges.
	It can only play songs on ROM, and only supports up to 192 songs, 
	no matter how large the ROM you have.
	On the other hand, unlike the regular version of MGSP v2.1.1, 
	it does not require DOS2/Nextor or more than 64KB of RAM, 
	and it can use extended RAM cartridges for MSX1 that do not support 
	the memory mapper.
	SCC is also compatible with SCC-equipped game cartridges, 
	lowering the threshold of equipment that must be prepared.
	If you want to use your MSX as a BGM playback machine, 
	this ROM version may be easier to use.
	If you want to use your MSX as a BGM playing machine, 
	this ROM version may be easier to use.

2. How to use (How to create a ROM image)
	The ROM image generation tool is for Windows 10.

	(1) In the MGS folder, copy all the MGS files that you want to register.
	    You must include at least one of these.

	(2) Double-click BUILD.BAT, which will generate two ROM files.
		MGSPASC8.ROM .... For writing to ASCII8K type cartridges with MegaCon
		MGSPKNM8.ROM .... When MegaComputer writes to Konami8K type cartridge (SCC/SCC-I is also acceptable)

	In the MGS folder, you will find mgslist.txt, 
	which is one file per line, and the order of entry is determined 
	by the order in which the lines are written.
	If you rewrite mgslist.txt and then run BUILD.BAT, it will change in that order.

3. Customize
	SRC/BASE_CUSTOM.ASM の中身を書き替えてカスタマイズして下さい。
	カスタマイズ後は、BUILD.BAT を実行することで ROMファイルも更新されます。

3. License
	This archive contains the following
		(1) MGSDRV.COM
		(2) Misaki font
		(3) MGSP ROM Ver. source files

	License of MGSDRV.COM
		The latest version is the one distributed at the following location.
		https://gigamix.hatenablog.com/entry/mgsdrv/
		Please refer to this page for a summary of the license.
		If you distribute or sell the ROM file you created or the ROM cartridge in which it is written, is there any problem with the license?
		If you distribute or sell ROM files or ROM cartridges with ROM files written on them, please ask GIGAMIX if there are any license problems with the distribution or sale.
		This archive is bundled with MGSDRV.COM with the permission of GIGAMIX.

	Misaki Font
		It seems that both commercial and non-commercial fonts can be included and no contact is required.
		The latest version is available at
		The latest version is distributed at
		http://littlelimit.net/

	MGSP ROM version
		It can be distributed and sold for both commercial and non-commercial use. No special contact or
		You do not need to contact us or submit any documentation.

	The song data (MGS file) belongs to the right holder of each song data (composition, arrangement, input as MGS, etc.).
	If you wish to distribute or sell the data, please contact the copyright holder.
	Please be aware of the rights of the recorded songs when distributing or selling them.

4. contact information
	HRA! (hra@mvj.biglobe.ne.jp)
