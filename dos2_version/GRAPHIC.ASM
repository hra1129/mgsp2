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

vdp_port0	:=	0x98
vdp_port1	:=	0x99

; ==============================================================================
;	grp_init
;	画面を初期化する
; ==============================================================================
		scope	grp_init
grp_init::
		; GamingLED を検出
		call	detect_gaming_led
		ld		h, 0x40
		ld		a, [ramad1]
		call	enaslt
		ei

		; SCREEN 2
		ld		a, [scrmod]
		ld		[oldscr], a

		ld		a, 2
		ld		ix, CHGMOD
		ld		iy, [exptbl - 1]
		call	CALSLT

		; MSX2以上ならパレットを初期化
		ld		hl, 0x002D
		ld		a, [exptbl]
		call	RDSLT
		or		a, a
		call	nz, palette_init

		; パターンネープテーブルをブランクパーツで埋め尽くす
		ld		hl, 0x1800
		ld		bc, 768
		ld		d, 114
		call	memset_v

		; スプライト2倍角モード, 16x16モード
		ld		a, [rg1sav]
		or		a, 3
		ld		c, 1
		ld		b, a
		ld		ix, WRTVDP
		call	CALSLT

		; VDP R#7 = 0x00  (背景を黒くする)
		ld		c, 7
		ld		b, 0
		ld		ix, WRTVDP
		call	CALSLT

		; Color Table を 0xF0 で塗りつぶす
		ld		hl, 0x2000
		ld		bc, 256 * 8 * 3
		ld		d, 0xF0
		call	memset_v

		; スプライトジェネレータテーブルを 0x00 で塗りつぶす
		ld		hl, 0x3800
		ld		bc, 256 * 8
		ld		d, 0
		call	memset_v

		; バージョン表示
		ld		hl, 89 * 8
		ld		de, mgsp_version
		call	draw_string
		; Copyright
		ld		hl, 100 * 8
		ld		de, mgsp_copyright
		call	draw_string
		; Order
		ld		hl, 175 * 8
		ld		de, mgsp_order
		call	draw_string
		; Drive
		ld		hl, 200 * 8
		ld		de, mgsp_drive
		call	draw_string
		call	grp_update_current_drive
		; ch
		ld		hl, 222 * 8
		ld		de, mgsp_ch
		call	draw_string
		; Volume
		ld		hl, 190 * 8
		ld		de, mgsp_volume
		call	draw_string
		; Speed
		ld		hl, 195 * 8
		ld		de, mgsp_speed
		call	draw_string
		; Auto mode
		ld		hl, 183 * 8
		ld		de, mgsp_automode
		call	draw_string
		; Loop count
		ld		hl, 240 * 8
		ld		de, mgsp_loop_count
		call	draw_string
		; Filename
		ld		hl, 246 * 8
		ld		de, mgsp_filename
		call	draw_string
		; OPLL check
		call	change_mgsdrv_slot
		ld		hl, [mgs_id_mibadr]
		ld		a, [hl]
		inc		a
		ld		de, mgsp_sound_source_logo_not_found_color
		jr		z, opll_is_not_found
		ld		de, mgsp_sound_source_logo_found_color
opll_is_not_found::
		ld		[vram_transfer_item_opll_logo_color], de

		inc		hl
		ld		a, [hl]
		inc		a
		ld		de, mgsp_sound_source_logo_not_found_color
		jr		z, scc_is_not_found
		ld		de, mgsp_sound_source_logo_found_color
scc_is_not_found::
		ld		[vram_transfer_item_scc_logo_color], de

		; スクロールバーを初期化
		ld		hl, 0x2000 + (256 + 251) * 8
		ld		bc, 11 * 8
		ld		a, [grp_color_scroll_bar_blank]
		ld		d, a
		call	memset_v

		ld		hl, 0x0000 + (256 + 251) * 8
		ld		bc, 11 * 8
		ld		d, 0x81
		call	memset_v

		; PCGパーツ等を VRAMへ転送する
		ld		hl, grp_vram_transfer_table
		call	memcpy_transfer_data

		; 圧縮されたパターンネームテーブルをメモリへ展開する
		call	grp_decompress_pattern_name_table

		; レベルメーターを表示する
		call	grp_update_keyboard_spot

		; 表示効果付きでパターンネームテーブルをメモリからVRAMへ転送する
		ei
		ld		b, 32			; for B = 32 to 1 step -1
grp_startup_effect_loop1:
		push	bc
		ld		a, b
		dec		a				; 	DE = (B - 1) * 32 + grp_decompress_area - 8 * 32: HL = (B - 1) * 32 + 0x1800 - 8 * 32
		add		a, a
		add		a, a
		add		a, a
		ld		l, a
		ld		h, 0
		add		hl, hl
		add		hl, hl
		ld		e, l
		ld		d, h
		ld		bc, 0x1800 - 8 * 32
		add		hl, bc
		ex		de, hl
		ld		bc, grp_decompress_area - 8 * 32
		add		hl, bc
		ex		de, hl

		ld		b, 8
grp_startup_effect_loop2:
		push	bc
		push	de
		push	hl
		ld		bc, 4
		ld		a, 0x17
		cp		a, h
		jr		nc, grp_startup_effect_skip
		ld		a, 0x1A
		cp		a, h
		call	nc, memcpy_m2v
grp_startup_effect_skip:
		pop		hl
		pop		de
		ld		bc, 32 + 4
		add		hl, bc
		ex		de, hl
		add		hl, bc
		ex		de, hl
		pop		bc
		djnz	grp_startup_effect_loop2

		pop		bc
		halt
		djnz	grp_startup_effect_loop1
		ret

palette_init:
		di
		ld		c, vdp_port1
		xor		a, a
		out		[c], a
		ld		a, 0x80 + 16
		out		[c], a
		inc		c
		ld		hl, palettes_like_msx1
		ld		b, 32
		otir								; V9938/V9958 は OTIR でも問題ない
		ei

		; VDP R#9 の bit1 を 0 にする (強制的に NTSC にする)
		ld		a, [rg9sav]
		and		a, 0b1111_1101				; NT(bit1) = 0.  0:NTSC, 1:PAL
		ld		c, 9
		ld		b, 0
		ld		ix, WRTVDP
		ld		iy, [exptbl - 1]
		call	CALSLT
		ret

palettes_like_msx1:
		db		0x00, 0x00				; 0
		db		0x00, 0x00				; 1
		db		0x33, 0x05				; 2
		db		0x44, 0x06				; 3
		db		0x37, 0x02				; 4
		db		0x47, 0x03				; 5
		db		0x52, 0x03				; 6
		db		0x36, 0x05				; 7
		db		0x62, 0x03				; 8
		db		0x63, 0x04				; 9
		db		0x53, 0x06				; 10
		db		0x64, 0x06				; 11
		db		0x21, 0x04				; 12
		db		0x55, 0x03				; 13
		db		0x55, 0x05				; 14
		db		0x77, 0x07				; 15
		endscope

; ==============================================================================
;	Err表示 ON
; ==============================================================================
		scope	grp_update_error_indicator
grp_update_error_indicator::
		ld		hl, 0x1800 + 15 + 0 * 32
		call	grp_setwrt

		ld		a, [error_status]
		or		a, a
		jr		z, error_off

		ld		a, 205
		out		[vdp_port0], a
		ld		a, 206
		out		[vdp_port0], a

		; VDP R#7 = flash_pattern  (背景を光らせる)
		ld		hl, flash_pattern
		ld		c, 7
loop1:
		ld		b, [hl]
		push	bc
		push	hl
		ld		ix, WRTVDP
		ld		iy, [exptbl - 1]
		call	CALSLT
		halt
		halt
		halt
		halt
		pop		hl
		pop		bc
		inc		hl
		inc		b
		dec		b
		jr		nz, loop1
		ret

error_off:
		ld		a, 114
		out		[vdp_port0], a
		ld		a, 114
		out		[vdp_port0], a

		; VDP R#7 = 0x00  (背景を黒くする)
		ld		c, 7
		ld		b, 0
		ld		ix, WRTVDP
		ld		iy, [exptbl - 1]
		call	CALSLT
		ret

flash_pattern::
		db		0x06, 0x08, 0x09, 0x0A, 0x0B, 0x0F, 0x0B, 0x0A, 0x09, 0x08, 0x06, 0x00
		endscope

; ==============================================================================
;	カレントドライブの表示を更新
; ==============================================================================
		scope	grp_update_current_drive
grp_update_current_drive::
		ld		hl, 203 * 8
		ld		de, current_drive
		call	draw_string
		ret
		endscope

; ==============================================================================
;	メモリからVRAMへのブロック転送(転送パターンデータ)
;	input)
;		hl ..... 転送パターンデータアドレス
; ==============================================================================
		scope	memcpy_transfer_data
memcpy_transfer_data::
		; get vram_transfer_bytes
		ld		a, [hl]
		or		a, a
		ret		z					; Return when vram_transfer_bytes is 0 (terminator).
		ld		c, a
		inc		hl
		; get vram_repeat_count
		ld		b, [hl]
		inc		hl
		; get source_address
		ld		e, [hl]
		inc		hl
		ld		d, [hl]
		inc		hl
		; get destination_address
		ld		a, [hl]
		inc		hl
		push	hl
		ld		h, [hl]
		ld		l, a
repeat_loop:
		push	de
		push	bc
		ld		b, 0
		call	memcpy_m2v			; RAM(de), VRAM(hl), SIZE(bc)
		pop		bc
		pop		de
		ld		a, b
		ld		b, 0
		add		hl, bc
		ld		b, a
		djnz	repeat_loop
		pop		hl
		inc		hl
		jp		memcpy_transfer_data
		endscope

; ==============================================================================
;	メモリからVRAMへのブロック転送
;	input)
;		hl ..... 転送先VRAMアドレス
;		de ..... 転送元メモリアドレス
;		bc ..... 転送バイト数
; ==============================================================================
		scope	memcpy_m2v
memcpy_m2v::
		call	grp_setwrt
		
loop:
		ld		a, [de]
		out		[vdp_port0], a
		inc		de
		dec		bc
		ld		a, c
		or		a, b
		jp		nz, loop
		ret
		endscope

; ==============================================================================
;	VRAMを指定の値で塗りつぶす
;	input)
;		hl ..... 転送先VRAMアドレス
;		d ...... 塗りつぶす値
;		bc ..... 転送バイト数
;	break)
;		af, bc
; ==============================================================================
		scope	memset_v
memset_v::
		call	grp_setwrt

loop:
		ld		a, d
		out		[vdp_port0], a
		dec		bc
		ld		a, c
		or		a, b
		jp		nz, loop
		ret
		endscope

; ==============================================================================
;	grp_term
;	画面の後始末処理
; ==============================================================================
		scope	grp_term
grp_term::
		; スプライトジェネレータテーブルを 0x00 で塗りつぶす
		ld		hl, 0x3800
		ld		bc, 256 * 8
		ld		d, 0
		call	memset_v

		; ファイルリストの内容をクリアする
		ld		a, 0
loop0:
		push	af
		call	grp_clear_line
		pop		af
		inc		a
		cp		a, 11
		jr		nz, loop0

		; 画面のフェードアウト処理
		ld		de, 79							; ※循環しても重ならないように 1～767の範囲の素数にする
		ld		hl, 0x1800 + 373
		ld		b, 64
loop1:
		push	bc
		ld		b, 12
loop2:
		push	bc
		; 着目アドレスに 141 を書き込む
		push	de
		push	hl
		ld		a, 114
		ld		ix, WRTVRM
		ld		iy, [exptbl - 1]
		call	CALSLT
		pop		hl
		pop		de
		; 次のアドレスを計算
		add		hl, de
		ld		a, h
		cp		a, 0x1B
		jr		c, skip1
		sub		a, 0x3
		ld		h, a
skip1:
		pop		bc
		djnz	loop2
		; 割り込み待ち
		halt
		pop		bc
		djnz	loop1

		; 0.1秒 待機
		halt
		halt
		halt
		halt
		halt
		halt

		; 画面モードを戻す
		ld		a, [oldscr]
		ld		ix, CHGMOD
		ld		iy, [exptbl - 1]
		call	CALSLT

		; MSX2以上ならパレットを初期化
		ld		hl, 0x002D
		ld		a, [exptbl]
		call	RDSLT
		or		a, a
		ret		z

		ld		ix, sub_iniplt
		ld		iy, [exbrsa - 1]
		jp		CALSLT
		endscope

; ==============================================================================
;	grp_update_scroll_bar
; ==============================================================================
		scope	grp_update_scroll_bar
grp_update_scroll_bar::
		ld		hl, 0x2000 + (256 + 251) * 8
		call	grp_setwrt

		; ファイル・ディレクトリの下図が 12 に満たない場合はスクロールバーは表示しない (no_scroll)
		ld		a, [fl_files]			; ファイル・ディレクトリの総数
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
		ld		a, [grp_color_scroll_bar_blank]
loop2:
		nop								; VDP待ち
		nop								; VDP待ち
		nop								; VDP待ち
		out		[c], a
		djnz	loop2
skip1:
		; スクロールバーのつまみのサイズは 11[file] * 88[dot] / fl_files[file]
		ld		a, [fl_files]
		ld		c, a
		ld		a, 11
		call	grp_calc_scroll_pos
		ld		b, a
		ld		a, [save_a]
		add		a, b
		ld		[save_a], a
		ld		c, vdp_port0
		ld		a, [grp_color_scroll_bar_knob]
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
		ld		a, [grp_color_scroll_bar_blank]
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
		ld		a, [grp_color_scroll_bar_none]
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
loop1:
		sla		a			; HL.A を 1bit 左シフト
		rl		l
		rl		h			; 必ず Cy = 0 になる
		sbc		hl, de		; 試しに引いてみる
		jr		nc, skip1	; 引けた場合は skip1 へ
		add		hl, de		; 引けなかった(MSB桁借りが発生した:Cy=1)場合は足し戻す
skip1:
		rl		c			; 引けた場合は CのLSBに 0, 引けなかった場合は 1 を入れる
		djnz	loop1
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
		ld		d, [hl]
		inc		hl
		ld		e, [hl]

		ld		hl, 192 * 8
		ld		bc, 8
		call	memset_v

		ld		hl, 193 * 8
		ld		bc, 8
		ld		d, e
		jp		memset_v
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
		ld		hl, 0x1B00 + 16 * 4
		ld		de, mgsp_progress_bar
		ld		bc, 4 * 4
		jp		memcpy_m2v
		endscope

; ==============================================================================
;	grp_end_progress_bar
;	プログレスバーを隠す
; ==============================================================================
		scope	grp_end_progress_bar
grp_end_progress_bar::
		; 指定したアトリビュートを 0フィル
		ld		hl, 0x1B00 + 16 * 4
		ld		d, 0
		ld		bc, 4 * 4
		jp		memset_v
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
		call	grp_setwrt
		call	vpoke
		ld		hl, 0x3800 + 74 * 8
		call	grp_setwrt
		call	vpoke
		ld		hl, 0x3800 + 76 * 8
		call	grp_setwrt
		call	vpoke
		ld		hl, 0x3800 + 78 * 8
		call	grp_setwrt
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

; ==============================================================================
;	grp_update_file_list
;	ファイル一覧表示を更新する
;	input)
;		a ................... 0: 通常, 1: 強制全リフレッシュ
;		[fl_files] .......... 一覧表に格納されているファイル数
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
		ld		a, c
		call	get_current_file_entry
		push	hl
		; grp_draw_file_line を ' 'でフィル
		ld		hl, grp_draw_file_line
		ld		de, grp_draw_file_line + 1
		ld		bc, 62
		ld		a, ' '
		ld		[hl], a
		ldir
		xor		a, a
		ld		[de], a
		; 曲名読んでなければ読む
		pop		de
		push	de
		call	get_mgs_song_title
		; ディレクトリか？ MGSファイルか？
		pop		ix
		ld		a, [ix + FENT_MGS_TITLE_ADDRESS]
		or		a, [ix + FENT_MGS_TITLE_ADDRESS + 1]
		jp		z, draw_directory
		; MGSファイルの場合
draw_mgs_file:
		; -- 曲名表示モードか？ ファイル名表示モードか？
		ld		a, [grp_file_list_mode]					; 0: 曲名表示モード, 1: ファイル名表示モード
		or		a, a
		jp		nz, draw_mgs_file_name
		; -- 曲名をバッファへコピーする
		ld		l, [ix + FENT_MGS_TITLE_ADDRESS]
		ld		h, [ix + FENT_MGS_TITLE_ADDRESS + 1]
		jp		skip1
draw_mgs_file_name:
		push	ix
		pop		hl
skip1:
		; -- 曲名が存在するか確認
		ld		a, [hl]
		cp		a, ' '
		jr		nc, do_title_copy

		; -- 曲名が存在しない場合は代わりの文字列を表示する "No title (file name)"
		push	ix
		ld		hl, 0x2020
		ld		[grp_no_title_file_name + 0], hl
		ld		[grp_no_title_file_name + 2], hl
		ld		[grp_no_title_file_name + 4], hl
		ld		[grp_no_title_file_name + 6], hl
		pop		hl
		ld		de, grp_no_title_file_name
		ld		b, 8
filename_copy_loop:
		ld		a, [hl]
		cp		a, '.'
		jr		z, filename_copy_loop_exit
		ld		[de], a
		inc		hl
		inc		de
		djnz	filename_copy_loop
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
		ld		hl, fl_files
		cp		a, [hl]
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

		; ディレクトリの場合
draw_directory:
		; -- 記号をバッファへコピーする
		ld		hl, grp_directory_mark
		ld		de, grp_draw_file_line
		ld		bc, 6
		ldir
		push	ix
		pop		hl
		ld		b, 62 - 6
		jr		title_copy_loop
		endscope

; ==============================================================================
;	grp_get_top_entry_number
;	一番上に表示するエントリの番号を求める
;	input)
;		[fl_files] .......... 一覧表に格納されているファイル数
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
		ld		a, [fl_files]
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
s_number:
		db		0, 0, 0
		endscope

; ==============================================================================
;	draw_string
;	文字列を描画する
;	input)
;		hl .... 描画するパターンジェネレーターテーブルのアドレス
;		de .... 描画する文字列 (MAX 30文字, ASCIIZ)
;	output)
;		a ..... 0: 終端, 1～255: 次の文字 (kanji_work に収まらなかった)
;	break)
;		all
; ==============================================================================
		scope	draw_string
draw_string::
		call	grp_setwrt
		call	put_string
		dec		b
		inc		b
		ret		z						; 長さ 0 なら抜ける
		ld		c, vdp_port0
transfer_loop:
		outi
		jr		nz, transfer_loop		; OTIRだと速すぎる
		ret
		endscope

; ==============================================================================
;	grp_draw_keyboard_spot
;	キーボードの輝点を描画する
; ==============================================================================
		scope	grp_draw_keyboard_spot
grp_draw_keyboard_spot::
		ld		hl, 0x3800
		call	grp_setwrt

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
		call	change_mgsdrv_slot
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
		call	grp_setwrt
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
		ld		d, 0
		call	memset_v
		; カラーテーブルは 0xF0クリア
		ld		bc, 0x2000
		add		hl, bc
		ld		bc, 31 * 8
		ld		d, 0xF0
		call	memset_v
		ret
		endscope

; ==============================================================================
;	grp_show_exit_dialog
;	終了ダイアログを表示
; ==============================================================================
		scope	grp_show_exit_dialog
grp_show_exit_dialog::
		ld		hl, 0x2000 + (256 + 201) * 8
		ld		de, grp_color_exit_dialog_top
		ld		b, 8
		call	transfer8

		ld		hl, 0x2000 + (256 + 256 + 49) * 8
		ld		de, grp_color_exit_dialog_bottom
		ld		b, 8
		call	transfer8

		ld		hl, 0x2000 + (256 + 232) * 8
		ld		bc, 8
		ld		a, [grp_color_exit_dialog_middle]
		ld		d, a
		call	memset_v

		ld		hl, 0x2000 + (256 + 239) * 8
		ld		bc, 8
		ld		a, [grp_color_exit_dialog_middle]
		ld		d, a
		call	memset_v

		ld		hl, 0x2000 + (256 + 256 + 18) * 8
		ld		bc, 8
		ld		a, [grp_color_exit_dialog_middle]
		ld		d, a
		call	memset_v

		ld		hl, 0x2000 + (256 + 256 + 25) * 8
		ld		bc, 8
		ld		a, [grp_color_exit_dialog_middle]
		ld		d, a
		call	memset_v

		ld		hl, (256 + 233) * 8
		ld		de, grp_mgs_exit_dialog1
		call	draw_string

		ld		hl, (256 + 256 + 19) * 8
		ld		de, grp_mgs_exit_dialog2
		call	draw_string

		ld		a, 1
		ld		[grp_yes_no], a
		call	grp_update_exit_dialog_cursor
		ret

transfer8:
		push	bc
		push	de
		push	hl
		ld		bc, 8
		call	memcpy_m2v
		pop		hl
		ld		bc, 8
		add		hl, bc
		pop		de
		pop		bc
		djnz	transfer8
		ret
		endscope

; ==============================================================================
;	grp_update_exit_dialog_cursor
;	終了ダイアログの YES/NO カーソルの表示を更新する
; ==============================================================================
		scope	grp_update_exit_dialog_cursor
grp_update_exit_dialog_cursor::
		; Yes
		ld		a, [grp_yes_no]
		or		a, a
		ld		a, 0xF1
		jr		nz, skip1
		ld		a, [grp_color_cursor]
skip1:
		ld		hl, 0x2000 + (256 + 256 + 19) * 8
		ld		d, a
		ld		bc, 3 * 8
		call	memset_v

		; No
		ld		a, [grp_yes_no]
		or		a, a
		ld		a, 0xF1
		jr		z, skip2
		ld		a, [grp_color_cursor]
skip2:
		ld		hl, 0x2000 + (256 + 256 + 22) * 8
		ld		d, a
		ld		bc, 3 * 8
		jp		memset_v
		endscope

; ==============================================================================
;	grp_show_help
;	ヘルプを表示
; ==============================================================================
		scope	grp_show_help
grp_show_help::
		xor		a, a
		ld		[grp_select_line_on], a
clear_loop:
		push	af
		call	grp_clear_line
		pop		af
		inc		a
		cp		a, 11
		jr		nz, clear_loop

		xor		a, a
		ld		hl, grp_help_table
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
		ld		a, [fl_files]
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
		ld		a, [grp_color_cursor]
		ld		d, a
		jr		nz, skip1

		; 選択状態かつ再生中の色は 前景 黒, 背景 ライトレッド
		ld		a, [grp_color_cursor_playing]
		ld		d, a

skip1:
		ld		bc, 31 * 8
		jp		memset_v
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
		ld		a, [fl_files]
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
		ld		a, [grp_color_playing]
		ld		d, a
		ld		bc, 31 * 8
		jp		memset_v
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
		ld		d, 0xF0
		ld		bc, 31 * 8
		jp		memset_v
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
		ld		d, 0xF0
		jp		memset_v
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
		call	grp_setwrt
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
		call	grp_setwrt

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
;	BIOS SETWRT Compatible Routine
;	input)
;		hl ...... Target VRAM address
;	output)
;		None
;	break)
;		af
; ==============================================================================
		scope	grp_setwrt
grp_setwrt::
		ld		a, l
		di
		out		[vdp_port1], a
		ld		a, h
		or		a, 0x40
		out		[vdp_port1], a
		ei
		ret
		endscope

; ==============================================================================
;	Decompress pattern name table
; ==============================================================================
		scope	grp_decompress_pattern_name_table
grp_decompress_pattern_name_table::
		ld		de, mgsp_compressed_pattern_name_table
		ld		hl, grp_decompress_area
loop1:
		; get number of times
		ld		a, [de]
		or		a, a
		ret		z
		ld		b, a
		dec		a
		jr		z, skip1
		; get step
		inc		de
		ld		a, [de]
		ld		c, a
		; get initial value
skip1:
		inc		de
		ld		a, [de]
		inc		de
loop2:
		ld		[hl], a
		add		a, c
		inc		hl
		djnz	loop2
		jr		loop1
		endscope
