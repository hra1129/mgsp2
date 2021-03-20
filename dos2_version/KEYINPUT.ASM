; ==============================================================================
;   MGSP
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
;	Date		Author	Ver.	Description
;	Dec/14/2020	t.hara	1.0.0	1st release
; ==============================================================================

; ==============================================================================
; キー入力とそれに応じた分岐
; ==============================================================================
		scope		mgsp_check_key
mgsp_check_key::
		ld			ix, newkey			; キーマトリクス (キーが押されると 対応bitが 0 になる)
		ld			iy, keymap_table	; キーマップテーブル
		ld			de, 5

		ld			a, [ix + 6]			; シフトキーの状態
		and			a, 0b0000_0111
		ld			c, a
key_check_loop1:
		ld			l, [ix]				; キーの状態を取得 (新)
key_check_loop2:
		ld			a, [iy]				; キーマップのキー情報を読む
		or			a, a
		jp			z, skip_key_input
		inc			a
		jp			z, change_next_key_code
		dec			a
		ld			b, a				; マスク値保存
		and			a, l				; 新キー状態を調査 (押されていると 0, 押されてないと 非0)
		jp			nz, next_key_check	; キーが押されていなければ次のキーチェックへ遷移

		; 対象のキーが押されていた場合
		ld			a, [iy + 1]			; キーマップのシフトキー情報を読む
		cp			a, c
		jp			nz, next_key_check	; シフトキーが一致しなければ次のキーチェックへ遷移

		; 最後に押されたキーと一致しているか確認 (ちょっといい加減な判定)
		ld			a, [last_key]
		cp			a, b
		jr			z, key_repeat

		; 一致していない場合、新しいキーとして初回のキーリピートウェイトを設定
		ld			a, b
		ld			[last_key], a
		ld			a, [key_repeat_begin_wait]
		jp			skip3

		; 前回と一致していれば、キーリピートウェイトをチェックする
key_repeat:
		ld			a, [key_wait]
		dec			a
		ld			[key_wait], a

		jr			nz, skip2						; 0 でなければ、キーリピート待ち中なので処理しない
		ld			a, [key_repeat_wait]			; 0 ならば、キーリピートの1回分が終わったので処理を実施
skip3:
		ld			[key_wait], a					; 新しいウェイト値を指定
skip1:
		call		call_routine					; 対象の処理を実行
skip2:
		jp			exit_key_input

call_routine:
		; プリロードウェイトを初期化
		ld			a, [preload_wait]
		ld			[preload_wait_count], a

		ld			a, [iy + 2]
		ld			l, [iy + 3]
		ld			h, [iy + 4]
		jp			hl

next_key_check:
		add			iy, de
		jp			key_check_loop2

change_next_key_code:
		inc			iy
		inc			ix
		jp			key_check_loop1

skip_key_input:
		xor			a, a
		ld			[last_key], a
exit_key_input:

		; ジョイスティック入力によって条件分岐
		ld			a, 1				; Joypad1 A button
		ld			ix, GTTRIG
		ld			iy, [exptbl - 1]
		call		CALSLT
		and			a, JOYMAP_A
		push		af

		ld			a, 3				; Joypad1 B button
		ld			ix, GTTRIG
		ld			iy, [exptbl - 1]
		call		CALSLT
		and			a, JOYMAP_B
		pop			bc
		or			a, b
		push		af

		ld			a, 1				; Joypad1 stick
		ld			ix, GTSTCK
		ld			iy, [exptbl - 1]
		call		CALSLT
		pop			bc
		or			a, b

		ld			b, a
		ld			a, [joy_last_stick]
		cp			a, b						; 前回の入力と同じ？
		ld			a, b
		ld			[joy_last_stick], a
		ld			a, [key_repeat_begin_wait]	; 初回入力の wait は 30/60[sec]
		jr			nz, joy_key_affect

		ld			a, [joy_key_wait]			; 前回と入力同じで、かつ wait は 0？
		dec			a
		ld			[joy_key_wait], a
		jr			nz, skip_joy_key
		ld			a, [key_repeat_wait]		; リピート間隔の wait は 4/60[sec]
joy_key_affect:
		ld			[joy_key_wait], a
		ld			a, b
		ld			hl, joymap_table
		call		call_keymap
skip_joy_key:

		ret
		endscope

; ==============================================================================
; Aレジスタとキーマップテーブルに従ってサブルーチンコールする
; input)
;	A .... キーコード
;	HL ... キーマップテーブルのアドレス
; break)
;	all
; ==============================================================================
		scope		call_keymap
call_keymap::
		ld			de, 3
keymap_loop:
		ld			b, [hl]
		inc			b
		ret			z						; terminator なら抜ける
		dec			b
		cp			a, b
		jp			z, call_keymap_routine
		add			hl, de
		jp			keymap_loop
call_keymap_routine:
		; プリロードウェイトを初期化
		ld			a, [preload_wait]
		ld			[preload_wait_count], a

		inc			hl
		ld			e, [hl]
		inc			hl
		ld			d, [hl]
		ex			de, hl
		jp			hl
		endscope

; ==============================================================================
; キー入力チェック (for Help, Exit dialog)
; output)
;	a .... [→][↓][↑][←][ESC][*][*][SPACE/RET]
;			押されているキーは 1, 押されていないキーは 0 になる。
; ==============================================================================
		scope		check_key_press
check_key_press::
		; HL にキーマトリクス値を取得
		;   Key matrix 7 : [RET][SEL][BS][STOP][TAB][ESC][F5][F4]  --> L
		;   Key matrix 8 : [→][↓][↑][←][DEL][INS][CLS][SPACE]  --> H
		ld			hl, [ newkey + 7 ]

		ld			a, 0b01111011
		or			a, l
		rlca
		ld			l, a

		ld			a, 0b00001110
		or			a, h

		and			a, l
		cpl
		or			a, a
		jp			nz, exit_check_key_press

		; ジョイパッドボタン
		ld			a, 1				; Joypad1 stick
		ld			ix, GTSTCK
		ld			iy, [exptbl - 1]
		call		CALSLT
		or			a, a
		jr			z, skip1
		ld			a, 0b11110000		; 矢印キーのフリ
skip1:
		push		af

		ld			a, 1				; Joypad1 A button
		ld			ix, GTTRIG
		call		CALSLT
		and			a, 0b00000001		; [SPC] のフリ
		pop			bc
		or			a, b
		push		af

		ld			a, 3				; Joypad1 B button
		ld			ix, GTTRIG
		call		CALSLT
		and			a, 0b00001000		; [ESC] のフリ
		pop			bc
		or			a, b
		ret			z

exit_check_key_press:
		; キーが押されたらプリロードウェイトを初期化
		ld			b, a
		ld			a, [preload_wait]
		ld			[preload_wait_count], a
		ld			a, b
		ret
		endscope

; ==============================================================================
;	DATA AREA
; ==============================================================================
key_repeat_begin_wait:
		db			10
key_repeat_wait:
		db			2
key_wait::
		db			0
last_key::
		db			0
joy_key_wait::
		db			0
joy_last_stick::
		db			255

keymap	macro		keymask, shiftkey, data, routine_name
		db			keymask						; Key mask code     - 0x00: Terminate, 0xFF: Next line of key matrix, others: mask
		db			shiftkey					; Shift key pattern - bit0: shift, bit1: ctrl, bit2: graph
		db			data						; Aレジスタに入れる値
		dw			routine_name
		endm

key_bit0	= 0b00000001
key_bit1	= 0b00000010
key_bit2	= 0b00000100
key_bit3	= 0b00001000
key_bit4	= 0b00010000
key_bit5	= 0b00100000
key_bit6	= 0b01000000
key_bit7	= 0b10000000
key_none	= 0b00000111
key_shift	= 0b00000110
key_ctrl	= 0b00000101
key_graph	= 0b00000011
key_term	= 0x00
key_next	= 0xFF

keymap_table::
		;           bit:  7  6  5  4  3  2  1  0
		; Key matrix 0 : [7][6][5][4][3][2][1][0]
		keymap		key_bit1, key_none, 0b00000001, mgsp_track_mute_h	; [1]  OPLL Track Mute ch.0
		keymap		key_bit2, key_none, 0b00000010, mgsp_track_mute_h	; [2]  OPLL Track Mute ch.1
		keymap		key_bit3, key_none, 0b00000100, mgsp_track_mute_h	; [3]  OPLL Track Mute ch.2
		keymap		key_bit4, key_none, 0b00001000, mgsp_track_mute_h	; [4]  OPLL Track Mute ch.3
		keymap		key_bit5, key_none, 0b00010000, mgsp_track_mute_h	; [5]  OPLL Track Mute ch.4
		keymap		key_bit6, key_none, 0b00100000, mgsp_track_mute_h	; [6]  OPLL Track Mute ch.5
		keymap		key_bit7, key_none, 0b01000000, mgsp_track_mute_h	; [7]  OPLL Track Mute ch.6

		keymap		key_bit1, key_shift, 0, mgsp_drive_change			; [SFT]+[1]  Drive change to A:
		keymap		key_bit2, key_shift, 1, mgsp_drive_change			; [SFT]+[2]  Drive change to B:
		keymap		key_bit3, key_shift, 2, mgsp_drive_change			; [SFT]+[3]  Drive change to C:
		keymap		key_bit4, key_shift, 3, mgsp_drive_change			; [SFT]+[4]  Drive change to D:
		keymap		key_bit5, key_shift, 4, mgsp_drive_change			; [SFT]+[5]  Drive change to E:
		keymap		key_bit6, key_shift, 5, mgsp_drive_change			; [SFT]+[6]  Drive change to F:
		keymap		key_bit7, key_shift, 6, mgsp_drive_change			; [SFT]+[7]  Drive change to G:
		db			key_next
		; Key matrix 1 : [;][[][@][\][^][-][9][8]
		keymap		key_bit0, key_none, 0b10000000, mgsp_track_mute_h	; [8]  OPLL Track Mute ch.7
		keymap		key_bit1, key_none, 0b00000001, mgsp_track_mute_b	; [9]  OPLL Track Mute ch.8
		keymap		key_bit3, key_none, 0, loop_down					; [\]  Loop couunter down
		keymap		key_bit4, key_none, 0, loop_up						; [^]  Loop couunter up

		keymap		key_bit0, key_shift, 7, mgsp_drive_change			; [SFT]+[8]  Drive change to H:
		db			key_next
		; Key matrix 2 : [B][A][_][/][.][,][]][:]
		keymap		key_bit2, key_none, -1, mgsp_speed_change			; [,]  Play speed -1%
		keymap		key_bit3, key_none, 0, mgsp_speed_reset				; [.]  Play speed 100%
		keymap		key_bit4, key_none, 1, mgsp_speed_change			; [/]  Play speed +1%
		keymap		key_bit5, key_none, 10, mgsp_speed_change			; [_]  Play speed +10%
		keymap		key_bit6, key_none, 0, sort_by_title				; [A]  Sort by song title
		db			key_next
		; Key matrix 3 : [J][I][H][G][F][E][D][C]
		keymap		key_bit1, key_none, 0, sort_by_entry				; [D]  Sort by directory entry
		keymap		key_bit2, key_none, 0b00000100, mgsp_track_mute_l	; [E]  PSG Track Mute ch.2
		keymap		key_bit3, key_none, 0, sort_by_filename				; [F]  Sort by file name
		keymap		key_bit6, key_none, 0b10000000, mgsp_track_mute_l	; [I]  SCC Track Mute ch.4
		db			key_next
		; Key matrix 4 : [R][Q][P][O][N][M][L][K]
		keymap		key_bit2, key_none, -10, mgsp_speed_change			; [M]  Play speed -10%
		keymap		key_bit6, key_none, 0b00000001, mgsp_track_mute_l	; [Q]  PSG Track Mute ch.0
		keymap		key_bit7, key_none, 0b00001000, mgsp_track_mute_l	; [R]  SCC Track Mute ch.0
		db			key_next
		; Key matrix 5 : [Z][Y][X][W][V][U][T][S]
		keymap		key_bit0, key_none, 0, sort_by_shuffle				; [S]  Shuffle
		keymap		key_bit1, key_none, 0b00010000, mgsp_track_mute_l	; [T]  SCC Track Mute ch.1
		keymap		key_bit2, key_none, 0b01000000, mgsp_track_mute_l	; [U]  SCC Track Mute ch.3
		keymap		key_bit4, key_none, 0b00000010, mgsp_track_mute_l	; [W]  PSG Track Mute ch.1
		keymap		key_bit5, key_none, 0, start_next_song				; [X]  Play next song
		keymap		key_bit6, key_none, 0b00100000, mgsp_track_mute_l	; [Y]  SCC Track Mute ch.2
		keymap		key_bit7, key_none, 0, start_previous_song			; [Z]  Play previous song
		db			key_next
		; Key matrix 6 : [F3][F2][F1][KANA][CAPS][GRAPH][CTRL][SHIFT]
		keymap		key_bit5, key_none, 0, play_current_song			; [F1]  Play song
		keymap		key_bit6, key_none, 0, mgsp_stop_song				; [F2]  Stop song
		keymap		key_bit7, key_none, 0, start_fadeout				; [F3]  Fade out
		keymap		key_bit5, key_shift, 0, mgsp_play_song				; [F6]  Play loaded song
		keymap		key_bit6, key_shift, 0, master_volume_down			; [F7]  Down master volume
		keymap		key_bit7, key_shift, 0, master_volume_up			; [F8]  Up master volume
		db			key_next
		; Key matrix 7 : [RET][SEL][BS][STOP][TAB][ESC][F5][F4]
		keymap		key_bit0, key_none, 0, goto_parent_dir				; [F4]  Go to upper directory
		keymap		key_bit1, key_none, 0, mgsp_show_help				; [F5]  Show help message
		keymap		key_bit2, key_none, 0, mgsp_show_exit_dialog		; [ESC] Exit
		keymap		key_bit5, key_none, 0, goto_parent_dir				; [BS]  Go to upper directory
		keymap		key_bit6, key_none, 0, toggle_file_list_mode		; [SEL] toggle file list
		keymap		key_bit7, key_none, 0, play_current_song			; [RET] Play song
		keymap		key_bit0, key_shift, 0, change_mode					; [F9]  Mode change
		keymap		key_bit1, key_shift, 0, mgsp_show_exit_dialog		; [F10] Exit
		db			key_next
		; Key matrix 8 : [→][↓][↑][←][DEL][INS][CLS][SPACE]
		keymap		key_bit0, key_none, 0, play_current_song			; [SPC] Play song
		keymap		key_bit1, key_none, 0, change_mode					; [CLS] Mode change
		keymap		key_bit2, key_none, 0, master_volume_down			; [INS] Down master volume
		keymap		key_bit3, key_none, 0, master_volume_up				; [DEL] Up master volume
		keymap		key_bit4, key_none, 0, left_select					; [←]  left (page down)
		keymap		key_bit5, key_none, 0, up_select					; [↑]  Up
		keymap		key_bit6, key_none, 0, down_select					; [↓]  Down
		keymap		key_bit7, key_none, 0, right_select					; [→]  right (page up)
		keymap		key_bit5, key_shift, 0, minus_select				; [SFT]+[↑]  Top
		keymap		key_bit6, key_shift, 0, plus_select					; [SFT]+[↓]  Bottom
		db			key_term

JOYMAP_UP		:= 1		; JOYMAP_UP, DOWN, RIGHT, LEFT は排他
JOYMAP_RIGHT	:= 3
JOYMAP_DOWN		:= 5
JOYMAP_LEFT		:= 7
JOYMAP_A		:= 16
JOYMAP_B		:= 32
JOYMAP_AB		:= JOYMAP_A + JOYMAP_B

joymap	macro		keycode, routine_name
		db			keycode
		dw			routine_name
		endm

joymap_table::
		joymap		JOYMAP_UP						, up_select				; [↑] Key
		joymap		JOYMAP_DOWN						, down_select			; [↓] Key
		joymap		JOYMAP_LEFT						, goto_parent_dir		; [←] Key
		joymap		JOYMAP_RIGHT					, play_current_song		; [→] Key
		joymap		JOYMAP_A  + JOYMAP_UP			, left_select			; (A) + [↑] Key
		joymap		JOYMAP_A  + JOYMAP_DOWN			, right_select			; (A) + [↓] Key
		joymap		JOYMAP_A  + JOYMAP_LEFT			, master_volume_down	; (A) + [←] Key
		joymap		JOYMAP_A  + JOYMAP_RIGHT		, master_volume_up		; (A) + [→] Key
		joymap		JOYMAP_B  + JOYMAP_UP			, loop_up				; (B) + [↑] Key
		joymap		JOYMAP_B  + JOYMAP_DOWN			, loop_down				; (B) + [↓] Key
		joymap		JOYMAP_B  + JOYMAP_LEFT			, mgsp_stop_song		; (B) + [←] Key
		joymap		JOYMAP_B  + JOYMAP_RIGHT		, mgsp_play_song		; (B) + [→] Key
		joymap		JOYMAP_AB + JOYMAP_UP			, mgsp_show_exit_dialog	; (A) + (B) + [↑] Key
		joymap		JOYMAP_AB + JOYMAP_DOWN			, start_fadeout			; (A) + (B) + [↓] Key
		joymap		JOYMAP_AB + JOYMAP_LEFT			, sort_by_entry			; (A) + (B) + [←] Key
		joymap		JOYMAP_AB + JOYMAP_RIGHT		, sort_by_title			; (A) + (B) + [→] Key
		joymap		0xFF, 0x0000											; Terminator
