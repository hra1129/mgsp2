; ==============================================================================
;	Graphic initial datas
;
;  Copyright (C) 2020 Takayuki Hara (HRA!)
;  All rights reserved.
;                           http://hraroom.s602.xrea.com/msx/software/mgsp.html
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
		ds		" Version 2.1.2R"
		db		0
mgsp_copyright::
		ds		"Copyright (C)2021 HRA!"
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
mgsp_speed::
		ds		"Spd:"
mgsp_speed_value_init::
		ds		"100%"
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
	vram_transfer_item	1 * 8		, 1		, mgsp_sound_source_logo_found_color	, 0x2000 + 221 * 8
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

		graphic_pattern
