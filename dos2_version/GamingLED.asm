; ==============================================================================
;	Gaming LED control routine
;
;  Copyright (C) 2023 Takayuki Hara (HRA!)
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
;	2020/9/21	t.hara	1.0		1st release
; ==============================================================================

; ※ATMEGA の関数テーブルのインデックスになっているため、未定義の値は指定不可
gled_c_cmd_st			:= 0x43					;        CMDスタート識別子 (Serviceルーチン使用時は不要）
gled_cl_debugen			:= ( 0 << 1) | 1		; 1byte: LED Debug UART On
gled_cl_off				:= ( 1 << 1) | 1		; 1byte: LED OFF/DEMO STOP
gled_cl_draw			:= ( 2 << 1) | 1		; 1byte: LED draw
gled_cl_pos				:= ( 3 << 1) | 1		; 2byte: LED position setting
gled_cl_pat				:= ( 4 << 1) | 1		; 2byte: LED pattern setting
gled_cl_eepinit			:= ( 5 << 1) | 1		; 1byte: EEPROM Init
gled_cl_demo			:= ( 6 << 1) | 1		; 4byte: LED DEMO
gled_cl_real			:= ( 7 << 1) | 1		; 9byte: LED REAL Test
gled_cl_c_rgb			:= ( 8 << 1) | 1		; 4byte: RGB Coler code
gled_cl_c_hue			:= ( 9 << 1) | 1		; 9byte: HSV Coler code hue
gled_cl_c_sat			:= (10 << 1) | 1		; 9byte: HSV Coler code sat
gled_cl_c_val			:= (11 << 1) | 1		; 9byte: HSV Coler code val
gled_cl_p_hue			:= (12 << 1) | 1		; 9byte: Gradation Pattern hue step value
gled_cl_p_rep			:= (13 << 1) | 1		; 2byte: LED pattern repeat value
gled_cl_a_ena			:= (14 << 1) | 1		; 1byte: LED Animation enable
gled_cl_a_dis			:= (15 << 1) | 1		; 1byte: LED Animation disable
gled_cl_a_hue			:= (16 << 1) | 1		; 9byte: HSV Animation hue
gled_cl_a_sat			:= (17 << 1) | 1		; 9byte: HSV Animation sat
gled_cl_a_val			:= (18 << 1) | 1		; 9byte: HSV Animation val
gled_cl_a_pos			:= (19 << 1) | 1		; 9byte: HSV Animation pos
gled_cl_a_moden			:= (20 << 1) | 1		; 2byte: HSV AnimationMode hue
gled_cl_a_modes			:= (21 << 1) | 1		; 2byte: HSV AnimationMode sat
gled_cl_a_modev			:= (22 << 1) | 1		; 2byte: HSV AnimationMode val
gled_cl_a_modep			:= (23 << 1) | 1		; 2byte: HSV AnimationMode val
gled_cl_p_sat			:= (24 << 1) | 1		; 9byte: Gradation Pattern sat step value
gled_cl_p_val			:= (25 << 1) | 1		; 9byte: Gradation Pattern val step value
gled_cl_p_aval			:= (26 << 1) | 1		; 9byte: Gradation Pattern all val value
gled_cl_ee_set			:= (27 << 1) | 1		; 2byte: EEPROM Write
gled_cl_ee_get			:= (28 << 1) | 1		; 2byte: EEPROM Read
gled_cl_ee_cnf			:= (29 << 1) | 1		; 1byte: EEPROM Config set
gled_cl_a_pause			:= (30 << 1) | 1		; 2byte: AnimationMode pause

gled_command_port		:= 0x7F00
gled_signature			:= 0x4010

; ==============================================================================
;	detect gaming LED
;	input)
;		none
;	output)
;		none
;	break)
;		all
;	comment)
;		見つかった場合は、game_led_slot にスロット番号
;		見つからない場合は、game_led_slot に 0x00
;		スロットを切り替えたままで戻るので要注意。
; ==============================================================================
		scope		detect_gaming_led
detect_gaming_led::
		; 基本スロットを調べる
		xor			a, a
	loop_for_primary_slot:
		; 拡張スロットの有無を調べる
		ld			b, a
		add			a, exptbl & 0x0FF
		ld			h, exptbl >> 8
		ld			l, a
		ld			a, [hl]
		or			a, a
		ld			a, b							; フラグ不変
		ld			[game_led_slot], a				; フラグ不変
		jp			p, have_not_secondary_slot_1
		; 拡張スロットが存在する場合
		or			a, 0x80
	loop_for_secondary_slot:
		; 1スロットのチェック
	have_not_secondary_slot_1:
		push		af
		; 指定のスロットに切り替えて +4010h: "MSXLED" の存在を確かめる
		ld			h, 0x40
		call		enaslt

		ld			hl, gled_signature
		ld			de, s_signature
		ld			b, 6
	strcmp:
		ld			a, [de]
		cp			a, [hl]
		jr			nz, no_match
		inc			de
		inc			hl
		djnz		strcmp
	match:
		; 初期化のためのコマンド送信
		ld			hl, command
		ld			b, command_end - command
	send_command_loop:
		xor			a, a
		ld			[gled_command_port], a
		nop
		nop
		nop
		ld			a, [hl]
		ld			[gled_command_port], a
		nop
		nop
		nop
		djnz		send_command_loop

		; 一致したので戻る
		pop			af
		ret
	no_match:
		pop			af
		; 次のスロット
		or			a, a							; 拡張スロット付きか？
		jp			p, have_not_secondary_slot_2
		; 次の拡張スロット
		add			a, 0b0_000_01_00
		bit			4, a
		jr			z, loop_for_secondary_slot
		and			a, 0b0_000_00_11
	have_not_secondary_slot_2:
		inc			a
		bit			2, a
		jp			z, loop_for_primary_slot
		; 見つからなかった
		xor			a, a
		ld			[game_led_slot], a
		ret
	s_signature:
		db			"MSXLED"
	command:
		; _LED_PT(4)
		db			gled_c_cmd_st
		db			gled_cl_pat, (4 << 1) | 1
	command_end:
		endscope

; ==============================================================================
;	gaming LED 1tick
;	input)
;		none
;	output)
;		none
;	break)
;		all
;	comment)
;		1/60秒に1回の処理を実行する
;
;		LED  0    1    2    3    4    5    6    7    8    9
;		R   ch1  ch4  ch7  ch10 ch13 ch16 ch1  ch4  ch7  ch10
;		G   ch2  ch5  ch8  ch11 ch14 ch17 ch2  ch5  ch8  ch11
;		B   ch3  ch6  ch9  ch12 ch15 -    ch3  ch6  ch9  ch12
; ==============================================================================
		scope		gaming_led_1tick
gaming_led_1tick::
		; GamingLEDカートリッジが存在しなければ何もせずに戻る
		ld			a, [game_led_slot]
		or			a, a
		ret			z

		; 着目しているトラック情報のアドレスを求める
		ld			a, [game_led_state]
		ld			b, a
		xor			a, a
	address_loop:
		add			a, 3 * 2
		djnz		address_loop
		cp			a, 17
		jr			c, address_skip
		sub			a, 17
	address_skip:
		ld			l, a
		ld			h, 0
		ld			de, grp_track_volume
		add			hl, de

		; LEDポジション情報を更新する
		ld			a, [game_led_state]
		add			a, a					; 1回で 2LED なので 2倍
		add			a, a					; pos は 2倍+1 を設定
		inc			a
		ld			[parameter_pos1], a
		add			a, 2
		ld			[parameter_pos2], a

		; 音量情報を得る
		ld			bc, 2
		ld			de, parameter_rgb1
		call		update_volume
		call		update_volume
		call		update_volume

		ld			de, parameter_rgb2
		call		update_volume
		call		update_volume
		call		update_volume

		; GamingLEDカートリッジに切り替える
		ld			h, 0x40
		call		enaslt

		; コマンドを送信する
		ld			b, command_end - command_start
		ld			hl, command_start
	send_loop:
		xor			a, a
		ld			[gled_command_port], a
		nop
		nop
		nop
		ld			a, [hl]
		ld			[gled_command_port], a
		inc			hl
		nop
		nop
		nop
		djnz		send_loop

		; 次のステートへ遷移
		ld			a, [game_led_state]
		inc			a
		cp			a, 5
		jr			c, skip_clear_state
		xor			a, a
	skip_clear_state:
		ld			[game_led_state], a

		; スロットをRAMに戻す
		ld			h, 0x40
		ld			a, [ramad1]
		call		enaslt
		ei
		ret

	update_volume:
		ld			a, [hl]
		xor			a, 15				; 0 が最大なので反転させる
		add			a, a				; 0～15 → 0～120
		add			a, a
		add			a, a
		add			a, a				; コマンドは 2倍+1 を指定する
		inc			a
		ld			[de], a
		add			hl, bc
		inc			de
		ret

	command_start:
	command_pos1:
		db			gled_c_cmd_st, gled_cl_pos
	parameter_pos1:
		db			0									; POS
		db			0									; for wait dummy
	command_rgb1:
		db			gled_c_cmd_st, gled_cl_c_rgb
	parameter_rgb1:
		db			0, 0, 0								; R, G, B
		db			0									; for wait dummy
	command_draw1:
		db			gled_c_cmd_st, gled_cl_draw
	command_pos2:
		db			gled_c_cmd_st, gled_cl_pos
	parameter_pos2:
		db			0									; POS
		db			0									; for wait dummy
	command_rgb2:
		db			gled_c_cmd_st, gled_cl_c_rgb
	parameter_rgb2:
		db			0, 0, 0								; R, G, B
		db			0									; for wait dummy
	command_draw2:
		db			gled_c_cmd_st, gled_cl_draw
	command_end:
		endscope

; ==============================================================================
;	gaming LED へのアクセス (page0)
;	input)
;		none
;	output)
;		none
;	break)
;		all
;	comment)
;		このルーチンは、page2 か page3 に置くこと
; ==============================================================================
		scope		gaming_led_send
gaming_led_send::
		ret
		endscope

; ==============================================================================
game_led_slot::
		db			0					; GamingLEDカートリッジが存在するスロット番号。0x00 なら存在しない。
game_led_state::
		db			0					; どのLEDを制御するか 0～4
