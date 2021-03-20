MGSP version 2.1.3		Copyright (C) 2020 HRA!

[See in TAB width 4 characters]

<< Overview >>
  An MGS file player that supports MGSDRV.
It requires MGSDRV v3.20 or later (we have not checked 
the operation of MGSDRV below v3.20).
I'm imitating Ain's MGSEL, but the differences are as follows:

	(1) Works with MSX1 (using SCREEN2)
	(2) You can display the song titles in kanji, even on models without a kanji ROM
	(3) NEXTOR is the recommended environment
	(4) Does not work on MSX-DOS1
	(5) 64KB for DOS, 64KB for Kanji fonts, 32KB for MGSDRV, 64KB for DOS RAM, 
		for a total of 224KB is the minimum operating environment.
	(6) The mouse is non-compliant.
	(7) It is non-compliant with track-by-track mute.
	(8) Up to 192 files per directory (MGS files and directories combined), any more than that will be ignored.
	(9) And many other things, it is less functional than MGSEL.

  Recently, the DOS2-compatible NEXTOR and the MapperRAM + 
sound source + SD/CF media cartridge have appeared on the market.
The purpose of this software is to equip MSX1 with these components, 
allowing it to become a music player.

<< Launch Method >>
  Place MGSDRV.COM, KFONT.BIN, MGSP.COM in the directory through which PATH is passed, 
and start it up by typing MGSP from the command prompt of MSX-DOS2/NextorDOS.
  If the MGSP.INI exists, it will be loaded as a configuration file.

  With MGSP P and option P, it will start playing automatically after startup.

<< About Kanji Fonts >>
  I converted the Misaki font BDF version (2019-10-19 version) for use.
  I'd like to thank Namu Kadoma for publishing such a useful font data. 

<< Key Controls (keyboard) >>
  Please refer to MGSP2_Keymap.png

<< Key Controls (Joypad) >>
  The A button, B button is the position of the shift key.
  For statements like A + xx, feel like holding down A and pressing xx.

  UP           : File selection bar to the top
  DOWN         : File selection bar down
  LEFT         : Go to one of the top directories
  RIGHT        : Play songs in the file selection bar position / Go to Directory
  A + UP       : Page up
  A + DOWN     : Page down
  A + LEFT     : Volume reduction
  A + RIGHT    : Volume increase
  B + UP       : Increased number of loops
  B + DOWN     : Loop count reduction
  B + LEFT     : Stop playing the song while it is playing
  B + RIGHT    : Re-play an already loaded song from the beginning
  A + B + UP   : Exit
  A + B + DOWN : Fade out
  A + B + LEFT : Sort the song list by directory entry
  A + B + RIGHT: Sort the song list by song title

<< MGSP.INI >>
  If you prepare a text file called MGSP.INI and place it in the same directory 
as MGSP.COM, you will be able to customize it to some extent.

  Skip from ; to the end of the line as a comment.
  In the attached MGSP.INI, you can find the setting range of values in the comments, 
so please refer to it.

  Please note that if there is an error in the description, 
it will be ignored without displaying any error messages, etc.


<< Contact >>
  HRA! hra@mvj.biglobe.ne.jp

  Primary Distribution Sites
  http://hraroom.s602.xrea.com/msx/software/mgsp.html
