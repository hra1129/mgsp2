; ==============================================================================
;	Graphic initial datas
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

grp_draw_file_line::
		; 下記データは、初期化時に一度だけ利用する内容で、初期化後は不要。
		; そのため、初期化後には grp_draw_file_line (256byte) の場所として利用
start_of_title_buffer	:= $ + 256

; ==============================================================================
;	grp_theme_color_change
;	input)
;		theme_code .... 0: blue, 1: green, 2: red, 3: silver
;	break)
;		all
; ==============================================================================
		scope	grp_theme_color_change
grp_theme_color_change::
		ld		a, [theme_code]
		or		a, a
		ret		z

		dec		a
		add		a, a
		add		a, a
		add		a, a
		add		a, a
		ld		e, a
		ld		d, 0
		ld		ix, grp_theme_palette
		add		ix, de
		push	ix
		ld		hl, theme_init_start
		ld		b, theme_init_end - theme_init_start
loop1:
		ld		a, [hl]
		ld		c, a
		and		a, 0x0F
		ld		[index1], a
		ld		a, c
		rrca
		rrca
		rrca
		rrca
		and		a, 0x0F
		ld		[index2], a
index2 := $ + 2
		ld		a, [ix+0]
		rlca
		rlca
		rlca
		rlca
index1 := $ + 2
		or		a, [ix+0]
		ld		[hl], a
		inc		hl
		djnz	loop1

		pop		ix
		ld		hl, theme_start
		ld		b, thene_end - theme_start
loop2:
		ld		a, [hl]
		ld		c, a
		and		a, 0x0F
		ld		[index3], a
		ld		a, c
		rrca
		rrca
		rrca
		rrca
		and		a, 0x0F
		ld		[index4], a
index4 := $ + 2
		ld		a, [ix+0]
		rlca
		rlca
		rlca
		rlca
index3 := $ + 2
		or		a, [ix+0]
		ld		[hl], a
		inc		hl
		djnz	loop2
		ret
		endscope

theme_code::
		db		0

grp_theme_palette::
		; source0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15
		db		0, 1, 8, 9,12, 2, 4, 3, 5, 7,10,11, 6,13,14,15		; theme GREEN
		db		0, 1, 5, 7, 6, 8,12, 9, 2, 3,10,11, 4,13,14,15		; theme RED
		db		0, 1, 2, 3,14,14, 6, 7, 8, 9,10,13,12,13, 7,15		; theme SILVER

vram_transfer_item macro vram_transfer_bytes, vram_repeat_count, source_address, destination_address
		db		vram_transfer_bytes
		db		vram_repeat_count
		dw		source_address
		dw		destination_address
endm

mgsp_keyboard_spot_attrib::			; スプライトアトリビュートテーブル
		db		44 - 1, 1, 0, 8		; 下段白鍵
		db		44 - 1,33, 4, 8
		db		44 - 1,65, 8, 8
		db		44 - 1,97,12, 8
		db		38 - 1, 2,16, 8		; 下段黒鍵
		db		38 - 1,34,20, 8
		db		38 - 1,66,24, 8
		db		38 - 1,98,28, 8
		db		28 - 1, 1,32, 8		; 上段白鍵
		db		28 - 1,33,36, 8
		db		28 - 1,65,40, 8
		db		28 - 1,97,44, 8
		db		22 - 1, 2,48, 8		; 上段黒鍵
		db		22 - 1,34,52, 8
		db		22 - 1,66,56, 8
		db		22 - 1,98,60, 8

mgsp_name::
		ds		"MGSP"
mgsp_version::
		ds		" Version 2.1.7"
		db		0
mgsp_copyright::
		ds		"Copyright (C)2020-2023 HRA!"
		db		0
mgsp_volume::
		ds		"Vol:"
		db		0
mgsp_order::
		ds		"Order:"
		db		0
mgsp_automode::
		ds		"Mode :"
		db		0
mgsp_ch::
		ds		" 1 2 3 4 5 6 7 8 9 A B C D E F G H"
		db		0
mgsp_loop_count::
		ds		"Loop :"
		db		0
mgsp_filename::
		ds		"Filename: "
		db		0
mgsp_drive::
		ds		"Drive: "
		db		0

grp_vram_transfer_table::
	vram_transfer_item	4 * 8		, 1		, mgsp_logo_pattern						, 0x0000 + 85 * 8
	vram_transfer_item	(3 * 5) * 8	, 1		, mgsp_function_key_pattern1			, 0x0000 + (256 + 256 + 224) * 8
	vram_transfer_item	(3 * 5) * 8	, 1		, mgsp_function_key_pattern2			, 0x0000 + (256 + 256 + 241) * 8
	vram_transfer_item	4 * 8		, 1		, mgsp_sound_source_logo				, 0x0000 + 218 * 8
	vram_transfer_item	7 * 8		, 2		, mgsp_keyboard_pattern1				, 0x0000 + 115 * 8
	vram_transfer_item	7 * 8		, 2		, mgsp_keyboard_pattern2				, 0x0000 + 130 * 8
	vram_transfer_item	7 * 8		, 2		, mgsp_keyboard_pattern1				, 0x0000 + 145 * 8
	vram_transfer_item	7 * 8		, 2		, mgsp_keyboard_pattern2				, 0x0000 + 160 * 8
	vram_transfer_item	4 * 4 * 4	, 1		, mgsp_keyboard_spot_attrib				, 0x1B00
	vram_transfer_item	8			, 32	, mgsp_separator_pattern				, 0x0000 + (256 + 0) * 8
	vram_transfer_item	8			, 32	, mgsp_separator_pattern				, 0x0000 + (256 + 64) * 8
	vram_transfer_item	8			, 32	, mgsp_separator_pattern				, 0x0000 + (256 + 256 + 192) * 8
	vram_transfer_item	8			, 1		, mgsp_scroll_bar_up_pattern			, 0x0000 + (256 + 95) * 8
	vram_transfer_item	8			, 1		, mgsp_scroll_bar_down_pattern			, 0x0000 + (256 + 256 + 223) * 8
	vram_transfer_item	3 * 8		, 1		, mgsp_track_sw_pattern					, 0x0000 + 68 * 8
	vram_transfer_item	2 * 8		, 1		, mgsp_error_pattern					, 0x0000 + 205 * 8
	vram_transfer_item	32 * 2		, 1		, mgsp_progress_bar_pattern				, 0x3800 + 32 * 16

	vram_transfer_item	8			, 30	, mgsp_logo_color						, 0x2000 + 85 * 8
	vram_transfer_item	8			, 32	, mgsp_function_key_color				, 0x2000 + (256 + 256 + 224) * 8
vram_transfer_item_opll_logo_color	:= code_address + 2
	vram_transfer_item	1 * 8		, 1		, mgsp_sound_source_logo_found_color	, 0x2000 + 221 * 8
vram_transfer_item_scc_logo_color	:= code_address + 2
	vram_transfer_item	1 * 8		, 3		, mgsp_sound_source_logo_found_color	, 0x2000 + 218 * 8
	vram_transfer_item	8			, 15	, mgsp_keyboard_color					, 0x2000 + 130 * 8
	vram_transfer_item	8			, 15	, mgsp_keyboard_color					, 0x2000 + 160 * 8
	vram_transfer_item	8			, 32	, mgsp_separator_color					, 0x2000 + (256 + 0) * 8
	vram_transfer_item	8			, 32	, mgsp_separator_color					, 0x2000 + (256 + 64) * 8
	vram_transfer_item	8			, 32	, mgsp_separator_color					, 0x2000 + (256 + 256 + 192) * 8
	vram_transfer_item	4 * 8		, 17	, mgsp_volume_bar_color					, 0x2000
	vram_transfer_item	3 * 8		, 1		, mgsp_track_sw_color					, 0x2000 + 68 * 8
	vram_transfer_item	8			, 2		, mgsp_volume_color						, 0x2000 + 192 * 8
	vram_transfer_item	8			, 2		, mgsp_error_color						, 0x2000 + 205 * 8
		db		0					; terminator

mgsp_compressed_pattern_name_table::
		db		15,  1, 85			; number of times, step, initial value
		db		2,   0, 114
		db		15,  1, 207
		db		15,  1, 100
		db		17,  4, 0
		db		15,  1, 115
		db		17,  4, 1
		db		15,  1, 130
		db		17,  4, 2
		db		15,  1, 145
		db		17,  4, 3
		db		15,  1, 160
		db		17,  0, 68
		db		15,  1, 175
		db		17,  1, 222
		db		15,  1, 190
		db		17,  1, 239
		db		127, 1, 0
		db		1,      251			; if number of times is 1, don't need to step data.
		db		31,  1, 127
		db		1,      252
		db		31,  1, 158
		db		1,      253
		db		31,  1, 189
		db		1,      254
		db		31,  1, 220
		db		1,      255
		db		31,  1, 6
		db		1,      0
		db		31,  1, 37
		db		1,      1
		db		31,  1, 68
		db		1,      2
		db		31,  1, 99
		db		1,      3
		db		31,  1, 130
		db		1,      4
		db		31,  1, 161
		db		1,      5
		db		64,  1, 192
		db		0				; terminator (number of times = 0)
grp_decompress_area::

mgsp_logo_pattern::
		db		0xF6, 0xFF, 0xDB, 0xDB, 0xDB, 0xDB, 0xDB, 0x00
		db		0x7F, 0x7F, 0x60, 0x6F, 0x63, 0x7F, 0x7F, 0x00
		db		0x7F, 0x7F, 0x70, 0x7F, 0x07, 0x7F, 0x7F, 0x00
		db		0x7F, 0x41, 0x5D, 0x41, 0x5F, 0x50, 0x70, 0x00
mgsp_keyboard_pattern1::
		db		0x00, 0x00, 0xC4, 0xC4, 0xC4, 0xC4, 0xC4, 0xC4
		db		0x00, 0x00, 0x6C, 0x6C, 0x6C, 0x6C, 0x6C, 0x6C
		db		0x00, 0x00, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44
		db		0x00, 0x00, 0x6C, 0x6C, 0x6C, 0x6C, 0x6C, 0x6C
		db		0x00, 0x00, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46
		db		0x00, 0x00, 0xC4, 0xC4, 0xC4, 0xC4, 0xC4, 0xC4
		db		0x00, 0x00, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46
mgsp_keyboard_pattern2::
		db		0xC4, 0xC4, 0xC4, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE
		db		0x6C, 0x6C, 0x6C, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE
		db		0x44, 0x44, 0x44, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE
		db		0x6C, 0x6C, 0x6C, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE
		db		0x46, 0x46, 0x46, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE
		db		0xC4, 0xC4, 0xC4, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE
		db		0x46, 0x46, 0x46, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE
mgsp_track_sw_pattern::
		db		0xFE, 0x82, 0x82, 0x82, 0x82, 0x82, 0xFE, 0x00
		db		0xFE, 0x82, 0xBA, 0xBA, 0xBA, 0x82, 0xFE, 0x00
		db		0xFE, 0x82, 0xAA, 0x92, 0xAA, 0x82, 0xFE, 0x00
mgsp_function_key_pattern1::
		db		0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF	; F1
		db		0x00, 0xFF, 0x9F, 0x87, 0x81, 0x87, 0x9F, 0xFF
		db		0x00, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE
		db		0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF	; F2
		db		0x00, 0xFF, 0x83, 0x83, 0x83, 0x83, 0x83, 0xFF
		db		0x00, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE
		db		0x00, 0xFF, 0xC3, 0xC0, 0xC0, 0xC0, 0xC0, 0xFF	; F3
		db		0x00, 0xFF, 0xFF, 0x3F, 0x03, 0x00, 0x00, 0xFF
		db		0x00, 0xFE, 0xFE, 0xFE, 0xFE, 0x3E, 0x02, 0xFE
		db		0x00, 0xFF, 0xFF, 0xFE, 0xFC, 0xFF, 0xFF, 0xFF	; F4
		db		0x00, 0xBF, 0x3F, 0x3F, 0x3F, 0xBF, 0x81, 0xFF
		db		0x00, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE
		db		0x00, 0xFF, 0xDA, 0xDA, 0xC2, 0xDA, 0xDA, 0xFF	; F5
		db		0x00, 0xFF, 0x17, 0xF7, 0x17, 0xF7, 0x10, 0xFF
		db		0x00, 0xFE, 0x8E, 0xB6, 0xB6, 0x8E, 0xBE, 0xFE
mgsp_function_key_pattern2::
		db		0x00, 0xFF, 0xBA, 0x92, 0xAA, 0xBA, 0xBA, 0xFF	; F6
		db		0x00, 0xFF, 0x17, 0xF2, 0x15, 0xF7, 0x17, 0xFF
		db		0x00, 0xFE, 0x4E, 0x42, 0x40, 0x42, 0x4E, 0xFE
		db		0x00, 0xFF, 0xAD, 0xAA, 0xAA, 0xAA, 0xDD, 0xFF	; F7
		db		0x00, 0xFF, 0xBF, 0xBF, 0xBF, 0xBF, 0x8B, 0xFF
		db		0x00, 0xFE, 0xCE, 0xCE, 0x02, 0x86, 0xCE, 0xFE
		db		0x00, 0xFF, 0xAD, 0xAA, 0xAA, 0xAA, 0xDD, 0xFF	; F8
		db		0x00, 0xFF, 0xBF, 0xBF, 0xBF, 0xBF, 0x8B, 0xFF
		db		0x00, 0xFE, 0xCE, 0x86, 0x02, 0xCE, 0xCE, 0xFE
		db		0x00, 0xFF, 0x76, 0x25, 0x55, 0x75, 0x76, 0xFF	; F9
		db		0x00, 0xFF, 0x30, 0xD7, 0xD7, 0xD7, 0x30, 0xFF
		db		0x00, 0xFE, 0xC2, 0x5E, 0x42, 0x5E, 0xC2, 0xFE
		db		0x00, 0xFF, 0x85, 0xBE, 0x87, 0xBE, 0x85, 0xFF	; F10
		db		0x00, 0xFF, 0xD1, 0xBB, 0x7B, 0xBB, 0xD1, 0xFF
		db		0x00, 0xFE, 0x06, 0xDE, 0xDE, 0xDE, 0xDE, 0xFE
mgsp_scroll_bar_up_pattern::
		db		0xFF, 0xFF, 0xFF, 0xFF, 0xE7, 0xC3, 0x81, 0xFF
mgsp_scroll_bar_down_pattern::
		db		0xFF, 0x81, 0xC3, 0xE7, 0xFF, 0xFF, 0xFF, 0xFF
mgsp_sound_source_logo::
		db		0x02, 0x05, 0x04, 0x12, 0x01, 0x05, 0x02, 0x00		; SCC
		db		0x08, 0x14, 0x14, 0x51, 0x14, 0x14, 0x08, 0x00
		db		0x20, 0x50, 0x50, 0x44, 0x50, 0x50, 0x20, 0x00
		db		0xF3, 0xF1, 0xF4, 0xF6, 0xC7, 0x87, 0x8F, 0xFF		; MSX-song
mgsp_separator_pattern::
		db		0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
mgsp_error_pattern::
		db		0x7F, 0xC7, 0xDF, 0xC5, 0xDC, 0xDD, 0xC5, 0x7F
		db		0xFE, 0xFF, 0xFF, 0x57, 0xCF, 0xDF, 0xDB, 0xFE
mgsp_progress_bar_pattern::
		db		0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
		db		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
		db		0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
		db		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
		db		0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
		db		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
		db		0xFE, 0xFE, 0xFE, 0xFE, 0x00, 0x00, 0x00, 0x00
		db		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

theme_init_start::
mgsp_logo_color::
		db		0xE0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xE0, 0x00
mgsp_keyboard_color::
		db		0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xE0
mgsp_function_key_color::
		db		0x00, 0xE0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xE0
mgsp_volume_bar_color::
		db		0xF0, 0xF0, 0xF0, 0xF0, 0xE0, 0xE0, 0xE0, 0xE0
		db		0x70, 0x70, 0x70, 0x70, 0x50, 0x50, 0x50, 0x50
		db		0x50, 0x50, 0x50, 0x50, 0x40, 0x40, 0x40, 0x40
		db		0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
mgsp_volume_color::
		db		0x94, 0xF4, 0x94, 0x84, 0x64, 0x64, 0x84, 0x00
mgsp_sound_source_logo_not_found_color::
		db		0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
mgsp_sound_source_logo_found_color::
		db		0xE0, 0xE0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xE0
mgsp_separator_color::
		db		0x51, 0x71, 0x71, 0x51, 0x51, 0x41, 0x41, 0x41
mgsp_error_color::
		db		0x91, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81, 0x61
mgsp_track_sw_color::
		db		0x50, 0x70, 0x70, 0x50, 0x40, 0x40, 0x40, 0x00
		db		0x80, 0x90, 0x90, 0x80, 0x60, 0x60, 0x60, 0x00
		db		0x20, 0x30, 0x30, 0x20, 0xC0, 0xC0, 0xC0, 0x00
theme_init_end::
