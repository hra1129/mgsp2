; ==============================================================================
;	Graphic
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
;	2020/9/22	t.hara	1.0		1st release
; ==============================================================================

; ==============================================================================
;	grp_sound_chip_indicator
; ==============================================================================
		scope	grp_sound_chip_indicator
grp_sound_chip_indicator::
		; OPLLの存在確認
		ld		hl, [mgs_id_mibadr]
		ld		a, [hl]
		inc		a
		jr		nz, opll_is_found
opll_is_not_found::
		ld		a, mgsp_sound_source_logo_not_found_color
		ld		hl, 0x2000 + 221 * 8
		ld		bc, 8
		call	FILVRM
opll_is_found:
		; SCCの存在確認
		ld		hl, [mgs_id_mibadr]
		inc		hl
		ld		a, [hl]
		inc		a
		jr		nz, scc_is_found
scc_is_not_found::
		ld		a, mgsp_sound_source_logo_not_found_color
		ld		hl, 0x2000 + 218 * 8
		ld		bc, 8 * 3
		call	FILVRM
scc_is_found:
		; GamingLEDの存在確認
		ld		a, [game_led_slot]
		or		a, a
		jr		nz, gled_is_found
gled_is_not_found::
		ld		a, mgsp_sound_source_logo_not_found_color
		ld		hl, 0x2000 + 213 * 8
		ld		bc, 8 * 2
		call	FILVRM
gled_is_found:
		ret
		endscope

; ==============================================================================
;	grp_hide_scroll_bar
; ==============================================================================
		scope	grp_update_scroll_bar
grp_hide_scroll_bar::
		ld		hl, 0x2000 + (256 + 251) * 8
		call	SETWRT
		jp		no_scroll

; ==============================================================================
;	grp_update_scroll_bar
; ==============================================================================
grp_update_scroll_bar::
		ld		hl, 0x2000 + (256 + 251) * 8
		call	SETWRT

		; ファイル・ディレクトリの下図が 12 に満たない場合はスクロールバーは表示しない (no_scroll)
		ld		a, fl_files				; ファイル・ディレクトリの総数
		cp		a, 12
		jr		c, no_scroll

		; スクロールバーの全長は 88[dot]
		ld		c, a
		ld		a, [grp_top_file]
		call	grp_calc_scroll_pos		; A = grp_top_file[file] * 88[dot] / fl_files[file]
		ld		[save_a], a
		or		a, a
		jr		z, skip1
		ld		b, a
		ld		c, vdp_port0
		ld		a, grp_color_scroll_bar_blank
loop2:
		nop								; VDP待ち
		nop								; VDP待ち
		nop								; VDP待ち
		out		[c], a
		djnz	loop2
skip1:
		; スクロールバーのつまみのサイズは 11[file] * 88[dot] / fl_files[file]
		ld		a, fl_files
		ld		c, a
		ld		a, 11
		call	grp_calc_scroll_pos
		ld		b, a
		ld		a, [save_a]
		add		a, b
		ld		[save_a], a
		ld		c, vdp_port0
		ld		a, grp_color_scroll_bar_knob
loop3:
		nop								; VDP待ち
		nop								; VDP待ち
		nop								; VDP待ち
		out		[c], a
		djnz	loop3

		ld		a, [save_a]
		ld		b, a
		ld		a, 88
		sub		a, b
		ret		c
		ret		z
		ld		b, a
		ld		c, vdp_port0
		ld		a, grp_color_scroll_bar_blank
loop4:
		nop								; VDP待ち
		nop								; VDP待ち
		nop								; VDP待ち
		out		[c], a
		djnz	loop4
		ret

		; スクロールしない場合
no_scroll:
		ld		b, 11 * 8
		ld		c, vdp_port0
		ld		a, grp_color_scroll_bar_none
loop1:
		nop								; VDP待ち
		nop								; VDP待ち
		nop								; VDP待ち
		out		[c], a
		djnz	loop1
		ret
save_a:
		db		0
		endscope

; ==============================================================================
;	a = a * 88 / c : a = 0～191, c = 0～191, 必ず a <= c
;	break)
;	af, bc, de, hl
; ==============================================================================
		scope	grp_calc_scroll_pos
grp_calc_scroll_pos::
		; HL = a * 88 = a * 8 * (8 + 1 + 1 + 1)
		ld		l, a
		ld		h, 0
		add		hl, hl
		add		hl, hl
		add		hl, hl
		ld		d, h		; DE = A * 8
		ld		e, l
		add		hl, hl
		add		hl, hl
		add		hl, hl		; HL = A * 64
		add		hl, de		; HL = A * 72
		add		hl, de		; HL = A * 80
		add		hl, de		; HL = A * 88
		; HL / C
		ld		a, l
		ld		l, h
		ld		h, 0
		ld		e, c
		ld		d, h
		; C = HL / DE, ※88を越えることはない
		ld		b, 8		; H は 8bit
		ld		c, h		; 商を格納するレジスタ
_loop1:
		sla		a			; HL.A を 1bit 左シフト
		rl		l
		rl		h			; 必ず Cy = 0 になる
		sbc		hl, de		; 試しに引いてみる
		jr		nc, _skip1	; 引けた場合は skip1 へ
		add		hl, de		; 引けなかった(MSB桁借りが発生した:Cy=1)場合は足し戻す
_skip1:
		rl		c			; 引けた場合は CのLSBに 0, 引けなかった場合は 1 を入れる
		djnz	_loop1
		ld		a, c
		cpl					; 各bit は、引けた場合は 1、引けなかった場合は 0 にしたいので反転
		ret
		endscope

; ==============================================================================
;	grp_update_speed
;	再生速度表示を更新する
; ==============================================================================
		scope	grp_update_speed
grp_update_speed::
		ld		a, [song_speed]

		; 100の位
		ld		l, '0'
		cp		a, 100
		jp		c, skip1
		inc		l
		sub		a, 100
skip1:
		cp		a, 100
		jp		c, skip2
		inc		l
		sub		a, 100
skip2:
		; 10の位
		ld		h, '0'
		cp		a, 50
		jp		c, skip10
		inc		h
		inc		h
		inc		h
		inc		h
		inc		h
		sub		a, 50
skip10:
		cp		a, 30
		jp		c, skip20
		inc		h
		inc		h
		inc		h
		sub		a, 30
skip20:
		cp		a, 20
		jp		c, skip30
		inc		h
		inc		h
		sub		a, 20
skip30:
		cp		a, 10
		jp		c, skip40
		inc		h
		sub		a, 10
skip40:
		; 1の位
		add		a, '0'
		ld		[mgsp_speed_value], hl
		ld		[mgsp_speed_value + 2], a
		; 描画処理
		ld		hl, 197 * 8
		ld		de, mgsp_speed_value
		call	draw_string
		ret
		endscope

; ==============================================================================
;	grp_update_master_volume
;	マスターボリューム表示を更新する
;	input)
;		a ..... マスターボリューム (0が最大, 15が最小)
; ==============================================================================
		scope	grp_update_master_volume
grp_update_master_volume::
		add		a, a
		ld		l, a
		ld		h, 0
		ld		de, grp_volume_table
		add		hl, de
		ld		a, [hl]
		inc		hl
		ld		e, [hl]

		ld		hl, 192 * 8
		ld		bc, 8
		call	FILVRM

		ld		hl, 193 * 8
		ld		bc, 8
		ld		a, e
		jp		FILVRM
		endscope

; ==============================================================================
;	grp_update_file_list
;	ファイル一覧表示を更新する
;	input)
;		a ................... 0: 通常, 1: 強制全リフレッシュ
;		fl_files ............ 一覧表に格納されているファイル数
;		[fl_select_file] .... 選択中のファイルの番号 (一覧表の中の何番目か)
; ==============================================================================
		scope	grp_update_file_list
grp_update_file_list::
		push	af
		; 一端選択行を非選択表示にする
		call	grp_unselect_playing_line
		call	grp_unselect_line
		; ファイルが存在する場合、一覧の一番上に表示されるエントリ番号を求める
		call	grp_get_top_entry_number
		push	af
		call	grp_playing_line
		pop		af
		ld		b, a

		or		a, a
		jp		z, skip_do_update_check

		pop		af
		or		a, a
		jr		nz, do_update			; fource update
		push	af

skip_do_update_check:
		pop		af
		ld		a, b
		or		a, a
		jp		z, clear_space
		dec		a
		jp		z, grp_select_line

do_update:
		ld		a, [grp_top_file]
		ld		b, 0
		ld		c, a
loop:
		push	bc
		; file_entry のアドレスを取得する
		ld		a, c
		call	get_current_file_entry
		; -- 曲名表示モードか？ ファイル名表示モードか？
		ld		a, [grp_file_list_mode]					; 0: 曲名表示モード, 1: ファイル名表示モード
		or		a, a
		jp		nz, title_copy_loop_exit
		; grp_draw_file_line に曲名をコピー
		ld		de, grp_draw_file_line
		ld		b, 62
		push	hl
		call	get_mgs_song_title
		pop		hl
		; -- 曲名が存在するか確認
		or		a, a
		jr		nz, title_copy_loop_exit

draw_mgs_file_name:
		; -- 曲名が存在しない場合は代わりの文字列を表示する "No title (file name)"
		ld		de, grp_no_title_file_name
		ld		b, 8
filename_copy_loop:
		ld		a, [hl]
		cp		a, '.'
		jr		z, filename_fill_space
		or		a, a
		jr		z, filename_fill_space
		ld		[de], a
		inc		hl
		inc		de
		djnz	filename_copy_loop
		jr		filename_copy_loop_exit
filename_fill_space:
		ld		a, 0x20
filename_fill_space_loop:
		ld		[de], a
		inc		hl
		inc		de
		djnz	filename_fill_space_loop
filename_copy_loop_exit:
		ld		hl, grp_no_title

do_title_copy:
		ld		de, grp_draw_file_line
		ld		b, 62
title_copy_loop:
		ld		a, [hl]
		cp		a, ' '
		jr		c, title_copy_loop_exit
		ld		[de], a
		inc		hl
		inc		de
		djnz	title_copy_loop
title_copy_loop_exit:

		; 描画する
		pop		bc
		push	bc
		ld		a, b
		call	grp_get_line_address
		ld		de, grp_draw_file_line
		call	draw_string
		pop		bc
		inc		c
		inc		b
		ld		a, c
		cp		a, fl_files
		ld		a, b
		jr		z, clear_space
		cp		a, 11
		jp		c, loop
clear_space_exit:
		call	grp_select_line
		jp		grp_update_scroll_bar
clear_space::
		cp		a, 11					; 0～10が有効ライン, それを越えたら終了
		jp		nc, clear_space_exit
		push	af
		call	grp_clear_line
		pop		af
		inc		a
		jr		clear_space
		endscope

; ==============================================================================
;	grp_get_top_entry_number
;	一番上に表示するエントリの番号を求める
;	input)
;		fl_files ............ 一覧表に格納されているファイル数
;		[grp_select_file] ... 選択中のファイルの番号 (一覧表の中の何番目か)
;		[grp_top_file] ...... 現在一番上に表示されているファイルの番号
;	output)
;		[grp_top_file] ......... 一番上のファイルの番号
;		[grp_select_line_no] ... 選択中のライン番号
;		Zf ..................... 1: ファイルが１つもない, 0: 通常
;		a ...................... 0: ファイルが無い, 1: スクロールしない, 2: 上にスクロール, 3: 下にスクロール
; ==============================================================================
		scope	grp_get_top_entry_number
grp_get_top_entry_number::
		ld		a, fl_files
		or		a, a
		ret		z
		; 一覧に存在するファイルが 11個以下の場合、無条件に全部表示する
		ld		a, [grp_top_file]
		ld		b, a
		ld		a, [grp_select_file]
		cp		a, b				; [grp_select_file] < [grp_top_file]
		jr		c, up_move

		; [grp_select_file] >= [grp_top_file] の場合
		ld		c, a
		ld		a, b
		add		a, 10
		cp		a, c				; ([grp_top_file] + 10) < [grp_select_file]
		jr		c, down_move

		; [grp_select_file] >= [grp_top_file] && ([grp_top_file] + 10) >= [grp_select_file] の場合 (スクロールしない場合)
		ld		a, [grp_top_file]
		ld		b, a
		ld		a, c
		sub		a, b
		ld		[grp_select_line_no], a
		inc		a
		ld		a, 1
		ret							; Zf = 0

		; [grp_select_file] < [grp_top_file] の場合は、 [grp_top_file] = [grp_select_file] にする
up_move:
		ld		[grp_top_file], a
		xor		a, a
		ld		[grp_select_line_no], a
		inc		a
		ld		a, 2
		ret							; Zf = 0

		; ([grp_top_file] + 10) < [grp_select_file] の場合は、 [grp_top_file] = [grp_select_file] - 10 にする
down_move:
		ld		a, c
		sub		a, 10
		ld		[grp_top_file], a
		ld		a, 10
		ld		[grp_select_line_no], a
		ld		a, 3
		ret							; Zf = 0
		endscope

; ==============================================================================
;	ループカウントの表示を更新する
;	input)
;		a ..... ループカウント
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope	grp_update_loop_count
grp_update_loop_count::
		ld		hl, 243 * 8
		jp		draw_number
		endscope

; ==============================================================================
;	モード表示を更新する
;	input)
;		a ..... モード番号 (0: Normal, 1: Random, 2: Repeat)
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope	grp_update_mode_info
grp_update_mode_info::
		add		a, a
		add		a, a
		add		a, a
		ld		l, a
		ld		h, 0
		ld		de, mgsp_normal_mode
		add		hl, de
		ex		de, hl
		ld		hl, 186 * 8
		jp		draw_string
		endscope

; ==============================================================================
;	ソートモード表示を更新する
;	input)
;		a ..... モード番号
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope	grp_update_sort_mode_info
grp_update_sort_mode_info::
		add		a, a
		add		a, a
		add		a, a
		ld		l, a
		ld		h, 0
		ld		de, mgsp_order_entry
		add		hl, de
		ex		de, hl
		ld		hl, 178 * 8
		jp		draw_string
		endscope

; ==============================================================================
;	draw_number
;	数値を描画する
;	input)
;		hl .... 描画するパターンジェネレーターテーブルのアドレス
;		a ..... 描画する数値 (0～99)
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope	draw_number
draw_number::
		ld		b, 0
		cp		a, 50
		jp		c, skip1
		sub		a, 50
		ld		b, 5
skip1:
		cp		a, 30
		jp		c, skip2
		sub		a, 30
		inc		b
		inc		b
		inc		b
skip2:
		cp		a, 20
		jp		c, skip3
		sub		a, 20
		inc		b
		inc		b
skip3:
		cp		a, 10
		jp		c, skip4
		sub		a, 10
		inc		b
skip4:
		add		a, '0'
		ld		[s_number + 1], a
		ld		a, b
		ld		b, '0'
		or		a, a
		jp		nz, skip_number
		ld		b, ' '
skip_number:
		add		a, b
		ld		[s_number], a
		ld		de, s_number
		jp		draw_string
		endscope

; ==============================================================================
;	grp_draw_keyboard_spot
;	キーボードの輝点を描画する
; ==============================================================================
		scope	grp_draw_keyboard_spot
grp_draw_keyboard_spot::
		ld		hl, 0x3800
		call	SETWRT

		ld		hl, mgsp_keyboard_spot_pattern
		ld		bc, (4 << 8) | vdp_port0
		ld		d, 0
loop_row:
		push	bc
		ld		b, 7
loop_column:
		ld		a, [hl]
		out		[c], a
		inc		hl
		push	bc
		ld		b, 14
		out		[c], a
loop_blank:
		nop						; VDP待ち
		nop						; VDP待ち
		nop						; VDP待ち
		out		[c], d
		djnz	loop_blank
		pop		bc
		djnz	loop_column

		ld		b, 16
loop_right_blank:
		nop						; VDP待ち
		nop						; VDP待ち
		nop						; VDP待ち
		out		[c], d
		djnz	loop_right_blank
		pop		bc
		djnz	loop_row
		ret
		endscope

; ==============================================================================
;	grp_update_keyboard_spot
;	キーボードの輝点を更新する
;	input)
;		track_work_area .. トラックワークエリアの先頭アドレス
;		track_size ....... トラックワークエリアの1トラック分のバイト数
;	output)
;		a ................ 演奏中のトラックの数
; ==============================================================================
		scope	grp_update_keyboard_spot
grp_update_keyboard_spot::
		ld		iy, [mgs_id_trwadr]
		; 全クリア
		ld		hl, mgsp_keyboard_spot_pattern
		ld		de, mgsp_keyboard_spot_pattern + 1
		ld		bc, 28 - 1
		xor		a, a
		ld		[hl], a
		ldir

		; トーン情報を得る
		ld		b, 17								; 17[tracks]
		ld		d, 0
track_loop:
		ld		a, [iy + mgs_twa_track_state]		; 0:OFF, 1:ON, 2:MUTE
		dec		a
		jp		nz, track_end						; OFF または 無音 なら track_end へ

		ld		a, [iy + mgs_twa_gate_time_cnt + 1]
		or		a, a
		jp		m, track_end						; GATEタイムカウンタが負なら track_end へ
		or		a, [iy + mgs_twa_gate_time_cnt + 0]
		jp		z, track_end						; GATEタイムカウンタが 0なら track_end へ

		ld		a, [iy + mgs_twa_note_no]
		cp		a, 12								; 休符
		jp		nc, track_end
		ld		c, a

		ld		a, [iy + 0x15]						; オクターブ (0～7)

		; A = 12 * A = (2 * 2 * 2 + 2 * 2) * A
		add		a, a
		add		a, a
		ld		e, a
		add		a, a
		add		a, e

		add		a, c								; A = 音程: 0～95
		ld		e, a

		ld		hl, mgsp_tone_to_keyboard
		add		hl, de
		add		hl, de

		ld		e, [hl]
		inc		hl
		ld		a, [hl]

		ld		hl, mgsp_keyboard_spot_pattern
		add		hl, de
		or		a, [hl]
		ld		[hl], a

track_end:
		ld		de, [mgs_id_trwsiz]
		add		iy, de
		djnz	track_loop
		call	grp_draw_keyboard_spot
		call	grp_update_track_volume
		ret
		endscope

; ==============================================================================
;	grp_get_line_address
;	ファイル一覧画面のパタジェネアドレスを求める
;	input)
;		a ....... 行番号 0~10
;	output)
;		hl ...... パタジェネのアドレス
;	break)
;		f, de
; ==============================================================================
		scope	grp_get_line_address
grp_get_line_address::
		ld		l, a
		ld		h, 0
		ld		de, mgsp_filename_line
		add		hl, de
		ld		l, [hl]
		ld		h, 0
		add		hl, hl
		add		hl, hl
		add		hl, hl
		ld		de, 0x800
		add		hl, de
		cp		a, 5
		ret		c
		add		hl, de
		ret
		endscope

; ==============================================================================
;	grp_set_line_address
;	ファイル一覧画面のパタジェネアドレスをVDPにセットする
;	input)
;		a ....... 行番号 0~10
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_set_line_address
grp_set_line_address::
		call	grp_get_line_address
		call	SETWRT
		ret
		endscope

; ==============================================================================
;	grp_clear_line
;	ファイル一覧画面の指定ラインをクリアする
;	input)
;		a ....... 行番号 0~10
;	output)
;		--
;	break)
;		af, bc, de, hl, ix, iy
; ==============================================================================
		scope	grp_clear_line
grp_clear_line::
		call	grp_get_line_address
		; パタジェネは 0x00クリア
		ld		bc, 31 * 8
		xor		a, a
		call	FILVRM
		; カラーテーブルは 0xF0クリア
		ld		bc, 0x2000
		add		hl, bc
		ld		bc, 31 * 8
		ld		a, 0xF0
		call	FILVRM
		ret
		endscope

; ==============================================================================
;	grp_show_license
;	ライセンスを表示
; ==============================================================================
		scope	grp_show_license
grp_show_license::
		ld		hl, grp_license_table
		jr		grp_show_messages
		endscope

; ==============================================================================
;	grp_show_help
;	ヘルプを表示
; ==============================================================================
		scope	grp_show_help
grp_show_help::
		ld		hl, grp_help_table
grp_show_messages::
		push	hl
		xor		a, a
		ld		[grp_select_line_on], a
clear_loop:
		push	af
		call	grp_clear_line
		pop		af
		inc		a
		cp		a, 11
		jr		nz, clear_loop
		pop		hl

		xor		a, a
loop1:
		push	af
		ld		e, [hl]
		inc		hl
		ld		d, [hl]
		inc		hl
		push	hl
		push	de
		call	grp_get_line_address
		pop		de
		call	draw_string
		pop		hl
		pop		af
		inc		a
		cp		a, 11
		jp		nz, loop1
		ret
		endscope

; ==============================================================================
;	grp_select_line
;	ファイル一覧画面の指定の行を選択表示に変更する
;	input)
;		[grp_select_line_no] ... 現在の選択行
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_select_line
grp_select_line::
		ld		a, fl_files
		or		a, a
		ret		z
		ld		a, [grp_select_line_on]
		or		a, a
		ret		z
		ld		a, [grp_select_line_no]
		call	grp_get_line_address
		ld		de, 0x2000
		add		hl, de

		ld		a, [grp_top_file]
		ld		b, a
		ld		a, [grp_play_file]
		sub		a, b
		ld		c, a
		ld		a, [grp_select_line_no]
		cp		a, c

		; 選択状態の色は 前景 黒, 背景 ライトイエロー
		ld		a, grp_color_cursor
		jr		nz, skip1

		; 選択状態かつ再生中の色は 前景 黒, 背景 ライトレッド
		ld		a, grp_color_cursor_playing

skip1:
		ld		bc, 31 * 8
		jp		FILVRM
		endscope

; ==============================================================================
;	grp_playing_line
;	ファイル一覧画面の再生中の曲の行を強調表示に変更する
;	input)
;		[grp_play_file] ... 現在再生中の曲番号 (※選択バーの位置なら何もしない)
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_playing_line
grp_playing_line::
		ld		a, fl_files
		or		a, a
		ret		z
		ld		a, [grp_select_line_on]
		or		a, a
		ret		z
		ld		a, [grp_top_file]
		ld		b, a
		ld		a, [grp_play_file]
		sub		a, b
		ld		c, a
		ld		a, [grp_select_line_no]
		cp		a, c
		ret		z
		ld		a, c
		cp		a, 11
		ret		nc

		call	grp_get_line_address
		ld		de, 0x2000
		add		hl, de

		; 再生中の色は 前景 黒, 背景 ダークレッド
		ld		a, grp_color_playing
		ld		bc, 31 * 8
		jp		FILVRM
		endscope

; ==============================================================================
;	grp_unselect_playing_line
;	ファイル一覧画面の再生中の曲の行を強調表示に変更する
;	input)
;		[grp_play_file] ... 現在再生中の曲番号 (※選択バーの位置なら何もしない)
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_unselect_playing_line
grp_unselect_playing_line::
		ld		a, [grp_top_file]
		ld		b, a
		ld		a, [grp_play_file]
		sub		a, b
		ld		c, a
		ld		a, [grp_select_line_no]
		cp		a, c
		ret		z
		ld		a, c
		cp		a, 11
		ret		nc

		call	grp_get_line_address
		ld		de, 0x2000
		add		hl, de

		; 再生中の色は 前景 城, 背景 黒
		ld		a, 0xF0
		ld		bc, 31 * 8
		jp		FILVRM
		endscope

; ==============================================================================
;	grp_unselect_line
;	ファイル一覧画面の指定の行を非選択表示に変更する
;	input)
;		[grp_select_line_no] ... 現在の選択行
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_unselect_line
grp_unselect_line::
		ld		a, [grp_select_line_no]
		call	grp_get_line_address
		ld		de, 0x2000
		add		hl, de

		ld		bc, 31 * 8
		; 選択状態の色は 前景 白, 背景 黒
		ld		a, 0xF0
		jp		FILVRM
		endscope

; ==============================================================================
;	grp_update_track_volume
;	トラックごとの音量表示を更新
;	input)
;		track_work_area .. トラックワークエリアの先頭アドレス
;		track_size ....... トラックワークエリアの1トラック分のバイト数
;	output)
;		a ................ 演奏中のトラックの数
; ==============================================================================
		scope	grp_update_track_volume
grp_update_track_volume::
		ld		b, 17				; 17[tracks]
		ld		iy, [mgs_id_trwadr]
		ld		ix, grp_track_volume

		; トーン情報を得る
track_loop:
		ld		e, [iy + mgs_twa_track_state]		; track status  0:OFF, 1:ON, 2:MUTE
		ld		d, [iy + mgs_twa_track_volume]		; track volume
		dec		e
		jp		nz, track_key_off

		ld		a, [iy + mgs_twa_flag]				; フラグ
		ld		e, a
		and		a, 0xE7
		ld		[iy + mgs_twa_flag], a
		bit		4, e								; bit4 is key on flag
		jp		nz, track_key_on
track_decay:
		ld		a, [ix + 0]							; current volume
		or		a, a
		jp		z, track_key_off
		dec		a
		ld		[ix + 0], a							; update current volume
		jp		skip1

track_key_off:
		xor		a, a
		ld		[ix + 0], a
		jp		skip1

track_key_on:						; key on, off のフラグは鍵盤表示更新の track_note_off でクリア
		ld		a, d				; track volume
		ld		[ix + 0], a			; current volume
skip1:
		ld		[ix + 1], d			; track volume level
		ld		de, [mgs_id_trwsiz]
		add		iy, de
		inc		ix
		inc		ix
		djnz	track_loop

		; Update volume level display. 表示自体は左右のどちらか半分だけ処理する
		ld		c, vdp_port0
		ld		hl, 0x0000
		call	SETWRT
		ld		b, 17				; 17[tracks]
		ld		hl, grp_track_volume

grp_update_track_volume_sub:
		push	bc
		ld		b, [hl]				; current volume level
		inc		hl
		ld		d, [hl]				; track volume level
		inc		hl
		inc		b
		ld		a, 15
draw_track_volume_loop:
		ld		e, 0xDE
		cp		a, d
		jp		z, draw_track_volume_skip1
		cp		a, b
		jp		c, draw_track_volume_skip1
		ld		e, 0xC0
draw_track_volume_skip1:
		out		[c], e
		ld		e, 0
		nop							; VDP待ち
		dec		a
		out		[c], e
		jp		p, draw_track_volume_loop
		pop		bc
		djnz	grp_update_track_volume_sub

		; track on/off switch
		ld		hl, 0x1800 + (5 * 32 + 15)
		call	SETWRT

		ld		c, vdp_port0
		ld		iy, [mgs_id_trwadr]
		ld		de, [mgs_id_trwsiz]
		ld		b, 17				; 17[tracks]
		ld		h, 0
track_sw_loop:
		ld		a, [iy + mgs_twa_track_state]		; track status  0:OFF, 1:ON, 2:MUTE
		or		a, a
		jp		z, track_no_active
		inc		h
track_no_active:
		add		a, 68
		out		[c], a
		add		iy, de
		djnz	track_sw_loop
		ld		a, h
		push	af
		call	gaming_led_1tick
		pop		af
		ret
		endscope

; ==============================================================================
;	grp_begin_progress_bar
;	プログレスバーを表示する
; ==============================================================================
		scope	grp_begin_progress_bar
grp_begin_progress_bar::
		; 進捗バースプライトの色を指定
		ld		a, 15
		ld		[mgsp_progress_bar +  0 + 3], a
		ld		[mgsp_progress_bar +  4 + 3], a
		ld		a, 4
		ld		[mgsp_progress_bar +  8 + 3], a
		ld		[mgsp_progress_bar + 12 + 3], a
		xor		a, a
		ld		[mgsp_progress_bar_state], a
		; 指定したアトリビュートを VRAM へコピー
		ld		de, 0x1B00 + 16 * 4
		ld		hl, mgsp_progress_bar
		ld		bc, 4 * 4
		jp		LDIRVM
		endscope

; ==============================================================================
;	grp_end_progress_bar
;	プログレスバーを隠す
; ==============================================================================
		scope	grp_end_progress_bar
grp_end_progress_bar::
		; 指定したアトリビュートを 0フィル
		ld		hl, 0x1B00 + 16 * 4
		xor		a, a
		ld		bc, 4 * 4
		jp		FILVRM
		endscope

; ==============================================================================
;	grp_update_progress_bar
;	プログレスバーを更新
; ==============================================================================
		scope	grp_update_progress_bar
grp_update_progress_bar::
		; 進捗バーのパターンを選択
		ld		a, [mgsp_progress_bar_state]
		and		a, 0xFC
		ld		l, a
		ld		h, 0
		ld		de, mgsp_progress_bar_point
		add		hl, de
		ex		de, hl
		; 進捗バーのパターンを VRAM に書き込む
		ld		hl, 0x3800 + 72 * 8
		call	SETWRT
		call	vpoke
		ld		hl, 0x3800 + 74 * 8
		call	SETWRT
		call	vpoke
		ld		hl, 0x3800 + 76 * 8
		call	SETWRT
		call	vpoke
		ld		hl, 0x3800 + 78 * 8
		call	SETWRT
		call	vpoke
		; 進捗バーの状態を遷移
		ld		a, [mgsp_progress_bar_state]
		inc		a
		ld		[mgsp_progress_bar_state], a
		cp		a, 11 * 4
		ret		c
		xor		a, a
		ld		[mgsp_progress_bar_state], a
		ret
vpoke:
		ld		a, [de]
		out		[vdp_port0], a
		nop
		nop
		nop
		inc		de
		out		[vdp_port0], a
		nop
		nop
		nop
		ret
		endscope
