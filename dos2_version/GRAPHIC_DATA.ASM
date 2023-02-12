; ==============================================================================
;	Graphic datas
;
;  Copyright (C) 2020 Takayuki Hara (HRA!)
;  All rights reserved.
;                                              https://github.com/hra1129/mgsp2
;
;  本ソフトウェアおよび本ソフトウェアに基づいて作成された派生物は、以下の条件を
;  満たす場合に限り、再頒布および使用が許可されます。
;
;  1.ソースコード形式で再頒布する場合、上記の著作権表示、本条件一覧、および下記
;    免責条項をそのままの形で保持すること。
;  2.バイナリ形式で再頒布する場合、頒布物に付属のドキュメント等の資料に、上記の
;    著作権表示、本条件一覧、および下記免責条項を含めること。
;  3.書面による事前の許可なしに、本ソフトウェアを販売、および商業的な製品や活動
;    に使用しないこと。
;
;  本ソフトウェアは、著作権者によって「現状のまま」提供されています。著作権者は、
;  特定目的への適合性の保証、商品性の保証、またそれに限定されない、いかなる明示
;  的もしくは暗黙な保証責任も負いません。著作権者は、事由のいかんを問わず、損害
;  発生の原因いかんを問わず、かつ責任の根拠が契約であるか厳格責任であるか（過失
;  その他の）不法行為であるかを問わず、仮にそのような損害が発生する可能性を知ら
;  されていたとしても、本ソフトウェアの使用によって発生した（代替品または代用サ
;  ービスの調達、使用の喪失、データの喪失、利益の喪失、業務の中断も含め、またそ
;  れに限定されない）直接損害、間接損害、偶発的な損害、特別損害、懲罰的損害、ま
;  たは結果損害について、一切責任を負わないものとします。
;
;  Note that above Japanese version license is the formal document.
;  The following translation is only for reference.
;
;  Redistribution and use of this software or any derivative works,
;  are permitted provided that the following conditions are met:
;
;  1. Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;  2. Redistributions in binary form must reproduce the above
;     copyright notice, this list of conditions and the following
;     disclaimer in the documentation and/or other materials
;     provided with the distribution.
;  3. Redistributions may not be sold, nor may they be used in a
;     commercial product or activity without specific prior written
;     permission.
;
;  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
;  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
;  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
;  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
;  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;  POSSIBILITY OF SUCH DAMAGE.
; ------------------------------------------------------------------------------
;	Date		Author	Ver		Description
;	2020/10/25	t.hara	1.0		1st release, separated from GRAPHIC.ASM
; ==============================================================================

; ==============================================================================
;	WORKAREA (Read/Write)
; ==============================================================================
grp_select_line_on::			; 0: undisplay, 1: display
		db		1
grp_file_list_mode::			; 0: 曲名表示モード, 1: ファイル名表示モード
		db		0
grp_top_file::					; ファイルリストの一番上に表示されているファイルのインデックス (255は非表示)
		db		255
grp_select_file::				; カーソルの位置のファイルのインデックス
		db		0
grp_play_file::					; 再生中のファイルのインデックス (255は停止中)
		db		255
grp_select_line_no::			; カーソルの位置の行番号 (0～10)
		db		0
grp_no_title::					; 曲名情報を含まないMGSファイルの場合の一覧表示名
		ds		"No title ["
grp_no_title_file_name::		; ※ここはファイル名で上書きされる
		ds		"        "
		ds		"]"
		db		0
grp_track_volume:				; +0: current volume level, +1: track volume level
		db		0, 0			; track 1
		db		0, 0			; track 2
		db		0, 0			; track 3
		db		0, 0			; track 4
		db		0, 0			; track 5
		db		0, 0			; track 6
		db		0, 0			; track 7
		db		0, 0			; track 8
		db		0, 0			; track 9
		db		0, 0			; track A
		db		0, 0			; track B
		db		0, 0			; track C
		db		0, 0			; track D
		db		0, 0			; track E
		db		0, 0			; track F
		db		0, 0			; track G
		db		0, 0			; track H
		db		0				; dummy for GamingLED
grp_yes_no:
		db		0				; 0: Yes, 1: No

; ==============================================================================
;	WORKAREA (Read only)
; ==============================================================================
theme_start::
grp_color_scroll_bar_blank::
		db		0x44
grp_color_scroll_bar_knob::
		db		0x47
grp_color_scroll_bar_none::
		db		0x45
grp_color_cursor::
		db		0x0B
grp_color_cursor_playing::
		db		0x09
grp_color_playing::
		db		0x06
grp_color_exit_dialog_top::
		db		0x55, 0x77, 0x77, 0x55, 0x55, 0x44, 0x44, 0x44
grp_color_exit_dialog_middle::
		db		0x44
grp_color_exit_dialog_bottom::
		db		0x44, 0x44, 0x55, 0x44, 0x55, 0x55, 0x55, 0x44
thene_end::

grp_mgs_exit_dialog1::
		ds		" Exit MGSP? "
		db		0
grp_mgs_exit_dialog2::
		ds		" Yes    No  "
		db		0

grp_help_table::			; ヘルプメッセージリスト
		dw		grp_help_line1, grp_help_line2, grp_help_line3, grp_help_line4
		dw		grp_help_line5, grp_help_line6, grp_help_line7, grp_help_line8
		dw		grp_help_line9, grp_help_line10, grp_help_line11

		;		 012345678901234567890123456789012345678901234567890123456789
grp_help_line1::
		ds		"<< Keyboard >>"
		db		0
grp_help_line2::
		ds		"[↑]-[→],[SFT]+[↑][↓]:Sel.File. [1]-[9][Q]-[I]:T-Mute."
		db		0
grp_help_line3::
		ds		"[A]-[F]:Sort/Shuffle. [^][\\]:LoopCount. [Z][X]:Back/Next."
		db		0
grp_help_line4::
		ds		"[M]-[\]:Speed. [SPC][RET]:Play. [HOME]:Mode. [INS][DEL]:Vol."
		db		0
grp_help_line5::
		ds		"[F2]:Stop. [F3]:Fade. [F4][BS]:UpDir. [F5]:Help. [ESC]:Exit."
		db		0
grp_help_line6::
		ds		"[F6]:PlayMem. [SFT]+[1]-[8]:DriveChg."
		db		0
grp_help_line7::
		ds		"<< Joypad >>"
		db		0
grp_help_line8::
		ds		"[↑][↓],[A]+[↑][↓]:Sel.File. [←]:UpDir. [→]:Play."
		db		0
grp_help_line9::
		ds		"[A]+[←][→]:Vol. [B]+[↑][↓]:LoopCount."
		db		0
grp_help_line10::
		ds		"[B]+[←]:Stop. [B]+[→]:PlayMem. [A]+[B]+[↑]:Exit"
		db		0
grp_help_line11::
		ds		"[A]+[B]+[→][←]:Sort"
		db		0

grp_directory_mark::
		ds		"[DIR] "
mgsp_order_entry::			; 8bytes
		ds		"Entry  "
		db		0
mgsp_order_title::			; 8bytes
		ds		"Title  "
		db		0
mgsp_order_filename::		; 8bytes
		ds		"F.Name "
		db		0
mgsp_order_shuffle::		; 8bytes
		ds		"Shuffle"
		db		0
mgsp_speed::
		ds		"Spd:"
mgsp_speed_value::
		ds		"100%"
		db		0
mgsp_normal_mode::			; 8bytes
		ds		"Normal"
		db		0, 0
mgsp_random_mode::			; 8bytes
		ds		"Random"
		db		0, 0
mgsp_repeat_mode::			; 8bytes
		ds		"Repeat"
		db		0, 0
mgsp_progress_bar::
		db		94 - 1, 97,72, 0		; 進捗バー(輝点1)
		db		94 - 1,129,76, 0		; 進捗バー(輝点2)
		db		92 - 1, 97,64, 0		; 進捗バー(黒線1)
		db		92 - 1,129,68, 0		; 進捗バー(黒線2)
mgsp_progress_bar_state::
		db		0
mgsp_progress_bar_point::
		db		0b00000000, 0b00000000, 0b00000000, 0b00000000	; #0
		db		0b01100000, 0b00000000, 0b00000000, 0b00000000	; #1
		db		0b01101100, 0b00000000, 0b00000000, 0b00000000	; #2
		db		0b01101101, 0b10000000, 0b00000000, 0b00000000	; #3
		db		0b01101101, 0b10110000, 0b00000000, 0b00000000	; #4
		db		0b01101101, 0b10110110, 0b00000000, 0b00000000	; #5
		db		0b01101101, 0b10110110, 0b11000000, 0b00000000	; #6
		db		0b01101101, 0b10110110, 0b11011000, 0b00000000	; #7
		db		0b01101101, 0b10110110, 0b11011011, 0b00000000	; #8
		db		0b01101101, 0b10110110, 0b11011011, 0b01100000	; #9
		db		0b01101101, 0b10110110, 0b11011011, 0b01101100	; #10
mgsp_filename_line::		; ファイル一覧の行に対応する左端の PCG番号
		db		96, 127, 158, 189, 220, 6, 37, 68, 99, 130, 161
grp_volume_table::			; MasterVolumeに対する設定値 (0が最大) に対応する音量表示パターン
		db		0b11111111, 0b11111111
		db		0b11111111, 0b11111110
		db		0b11111111, 0b11111100
		db		0b11111111, 0b11111000
		db		0b11111111, 0b11110000
		db		0b11111111, 0b11100000
		db		0b11111111, 0b11000000
		db		0b11111111, 0b10000000
		db		0b11111111, 0b00000000
		db		0b11111110, 0b00000000
		db		0b11111100, 0b00000000
		db		0b11111000, 0b00000000
		db		0b11110000, 0b00000000
		db		0b11100000, 0b00000000
		db		0b11000000, 0b00000000
		db		0b10000000, 0b00000000

mgsp_keyboard_spot_pattern::
		db		0xAA				; 上段白鍵 +0
		db		0xAA				; 上段白鍵 +1
		db		0xAA				; 上段白鍵 +2
		db		0xAA				; 上段白鍵 +3
		db		0xAA				; 上段白鍵 +4
		db		0xAA				; 上段白鍵 +5
		db		0xAA				; 上段白鍵 +6
		db		0xA2				; 上段黒鍵 +7
		db		0xA2				; 上段黒鍵 +8
		db		0x8A				; 上段黒鍵 +9
		db		0x8A				; 上段黒鍵 +10
		db		0x2A				; 上段黒鍵 +11
		db		0x28				; 上段黒鍵 +12
		db		0xA8				; 上段黒鍵 +13
		db		0xAA				; 下段白鍵 +14
		db		0xAA				; 下段白鍵 +15
		db		0xAA				; 下段白鍵 +16
		db		0xAA				; 下段白鍵 +17
		db		0xAA				; 下段白鍵 +18
		db		0xAA				; 下段白鍵 +19
		db		0xAA				; 下段白鍵 +20
		db		0xA2				; 下段黒鍵 +21
		db		0xA2				; 下段黒鍵 +22
		db		0x8A				; 下段黒鍵 +23
		db		0x8A				; 下段黒鍵 +24
		db		0x2A				; 下段黒鍵 +25
		db		0x28				; 下段黒鍵 +26
		db		0xA8				; 下段黒鍵 +27

mgsp_tone_to_keyboard::
		db		0    , 0x80			; O0C  --> 上段白鍵
		db		7    , 0x80			; O0C# --> 上段黒鍵
		db		0    , 0x20			; O0D  --> 上段白鍵
		db		7    , 0x20			; O0D# --> 上段黒鍵
		db		0    , 0x08			; O0E  --> 上段白鍵
		db		0    , 0x02			; O0F  --> 上段白鍵
		db		7    , 0x02			; O0F# --> 上段黒鍵
		db		1    , 0x80			; O0G  --> 上段白鍵
		db		8    , 0x80			; O0G# --> 上段黒鍵
		db		1    , 0x20			; O0A  --> 上段白鍵
		db		8    , 0x20			; O0A# --> 上段黒鍵
		db		1    , 0x08			; O0B  --> 上段白鍵
		db		1    , 0x02			; O1C  --> 上段白鍵
		db		8    , 0x02			; O1C# --> 上段黒鍵
		db		2    , 0x80			; O1D  --> 上段白鍵
		db		9    , 0x80			; O1D# --> 上段黒鍵
		db		2    , 0x20			; O1E  --> 上段白鍵
		db		2    , 0x08			; O1F  --> 上段白鍵
		db		9    , 0x08			; O1F# --> 上段黒鍵
		db		2    , 0x02			; O1G  --> 上段白鍵
		db		9    , 0x02			; O1G# --> 上段黒鍵
		db		3    , 0x80			; O1A  --> 上段白鍵
		db		10   , 0x80			; O1A# --> 上段黒鍵
		db		3    , 0x20			; O1B  --> 上段白鍵
		db		3    , 0x08			; O2C  --> 上段白鍵
		db		10   , 0x08			; O2C# --> 上段黒鍵
		db		3    , 0x02			; O2D  --> 上段白鍵
		db		10   , 0x02			; O2D# --> 上段黒鍵
		db		4    , 0x80			; O2E  --> 上段白鍵
		db		4    , 0x20			; O2F  --> 上段白鍵
		db		11   , 0x20			; O2F# --> 上段黒鍵
		db		4    , 0x08			; O2G  --> 上段白鍵
		db		11   , 0x08			; O2G# --> 上段黒鍵
		db		4    , 0x02			; O2A  --> 上段白鍵
		db		11   , 0x02			; O2A# --> 上段黒鍵
		db		5    , 0x80			; O2B  --> 上段白鍵
		db		5    , 0x20			; O3C  --> 上段白鍵
		db		12   , 0x20			; O3C# --> 上段黒鍵
		db		5    , 0x08			; O3D  --> 上段白鍵
		db		12   , 0x08			; O3D# --> 上段黒鍵
		db		5    , 0x02			; O3E  --> 上段白鍵
		db		6    , 0x80			; O3F  --> 上段白鍵
		db		13   , 0x80			; O3F# --> 上段黒鍵
		db		6    , 0x20			; O3G  --> 上段白鍵
		db		13   , 0x20			; O3G# --> 上段黒鍵
		db		6    , 0x08			; O3A  --> 上段白鍵
		db		13   , 0x08			; O3A# --> 上段黒鍵
		db		6    , 0x02			; O3B  --> 上段白鍵

		db		0 +14, 0x80			; O4C  --> 下段白鍵
		db		7 +14, 0x80			; O4C# --> 下段黒鍵
		db		0 +14, 0x20			; O4D  --> 下段白鍵
		db		7 +14, 0x20			; O4D# --> 下段黒鍵
		db		0 +14, 0x08			; O4E  --> 下段白鍵
		db		0 +14, 0x02			; O4F  --> 下段白鍵
		db		7 +14, 0x02			; O4F# --> 下段黒鍵
		db		1 +14, 0x80			; O4G  --> 下段白鍵
		db		8 +14, 0x80			; O4G# --> 下段黒鍵
		db		1 +14, 0x20			; O4A  --> 下段白鍵
		db		8 +14, 0x20			; O4A# --> 下段黒鍵
		db		1 +14, 0x08			; O4B  --> 下段白鍵
		db		1 +14, 0x02			; O5C  --> 下段白鍵
		db		8 +14, 0x02			; O5C# --> 下段黒鍵
		db		2 +14, 0x80			; O5D  --> 下段白鍵
		db		9 +14, 0x80			; O5D# --> 下段黒鍵
		db		2 +14, 0x20			; O5E  --> 下段白鍵
		db		2 +14, 0x08			; O5F  --> 下段白鍵
		db		9 +14, 0x08			; O5F# --> 下段黒鍵
		db		2 +14, 0x02			; O5G  --> 下段白鍵
		db		9 +14, 0x02			; O5G# --> 下段黒鍵
		db		3 +14, 0x80			; O5A  --> 下段白鍵
		db		10+14, 0x80			; O5A# --> 下段黒鍵
		db		3 +14, 0x20			; O5B  --> 下段白鍵
		db		3 +14, 0x08			; O6C  --> 下段白鍵
		db		10+14, 0x08			; O6C# --> 下段黒鍵
		db		3 +14, 0x02			; O6D  --> 下段白鍵
		db		10+14, 0x02			; O6D# --> 下段黒鍵
		db		4 +14, 0x80			; O6E  --> 下段白鍵
		db		4 +14, 0x20			; O6F  --> 下段白鍵
		db		11+14, 0x20			; O6F# --> 下段黒鍵
		db		4 +14, 0x08			; O6G  --> 下段白鍵
		db		11+14, 0x08			; O6G# --> 下段黒鍵
		db		4 +14, 0x02			; O6A  --> 下段白鍵
		db		11+14, 0x02			; O6A# --> 下段黒鍵
		db		5 +14, 0x80			; O6B  --> 下段白鍵
		db		5 +14, 0x20			; O7C  --> 下段白鍵
		db		12+14, 0x20			; O7C# --> 下段黒鍵
		db		5 +14, 0x08			; O7D  --> 下段白鍵
		db		12+14, 0x08			; O7D# --> 下段黒鍵
		db		5 +14, 0x02			; O7E  --> 下段白鍵
		db		6 +14, 0x80			; O7F  --> 下段白鍵
		db		13+14, 0x80			; O7F# --> 下段黒鍵
		db		6 +14, 0x20			; O7G  --> 下段白鍵
		db		13+14, 0x20			; O7G# --> 下段黒鍵
		db		6 +14, 0x08			; O7A  --> 下段白鍵
		db		13+14, 0x08			; O7A# --> 下段黒鍵
		db		6 +14, 0x02			; O7B  --> 下段白鍵
