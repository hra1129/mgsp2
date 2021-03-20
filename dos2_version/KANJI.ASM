; ==============================================================================
;	Kanji Driver
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
;	2020/9/26	t.hara	1.0		1st release
; ==============================================================================

; ==============================================================================
;	kanji_init
;	漢字フォントを読み込んで初期化する
;	input)
;		--
;	output)
;		a .... エラー番号: 0: Success, 1: Not enough memory, 2: Read error
;	break)
;		all
; ==============================================================================
		scope		kanji_init
kanji_init::
		call		mmap_change_to_tpa
		; Search target mapper
		ld			hl, [mmap_table_ptr]
		ld			de, 6
search_mapper_slot::
		inc			hl
		inc			hl
		ld			a, [hl]			; 未使用の16KBセグメントの数
		cp			a, 4
		jr			nc, detect_mapper_slot
		add			hl, de			; 次のマッパーへ
		ld			a, [hl]			; 次のマッパーが無ければ 0
		or			a, a			; 0か？
		jr			nz, search_mapper_slot
		inc			a				; エラー1: 4セグメント以上空いてるマッパーが無い
		ret
detect_mapper_slot::
		dec			hl
		dec			hl
		ld			a, [hl]			; マッパーのスロット
		ld			[kanji_ram_slot], a

		; TPA (page2) のセグメント番号を覚えておく
		call		mapper_get_p2
		ld			[tpa_page2_segment], a

		; Allocate memory mapper for kanji data
		ld			a, [kanji_ram_slot]
		ld			b, a			; B = Slot#
		xor			a, a			; A = 0: Allocate User Segment
		call		mapper_all_seg
		ld			[kanji_ram0_seg], a
		ld			a, 1
		ret			c

		ld			a, [kanji_ram_slot]
		ld			b, a			; B = Slot#
		xor			a, a			; A = 0: Allocate User Segment
		call		mapper_all_seg
		ld			[kanji_ram1_seg], a
		ld			a, 1
		ret			c

		ld			a, [kanji_ram_slot]
		ld			b, a			; B = Slot#
		xor			a, a			; A = 0: Allocate User Segment
		call		mapper_all_seg
		ld			[kanji_ram2_seg], a
		ld			a, 1
		ret			c

		ld			a, [kanji_ram_slot]
		ld			b, a			; B = Slot#
		xor			a, a			; A = 0: Allocate User Segment
		call		mapper_all_seg
		ld			[kanji_ram3_seg], a
		ld			a, 1
		ret			c

		; load KFONT.BIN
		ld			de, s_font_name
		call		open_file_on_path_env
		or			a, a
		jp			z, error_exit1

		ld			de, msg_load_kfont
		call		puts

		ld			a, [kanji_ram0_seg]
		call		load_1segment
		jr			c, error_exit2

		ld			a, [kanji_ram1_seg]
		call		load_1segment
		jr			c, error_exit2

		ld			a, [kanji_ram2_seg]
		call		load_1segment
		jr			c, error_exit2

		ld			a, [kanji_ram3_seg]
		call		load_1segment
		jr			c, error_exit2

		ld			de, s_crlf
		call		puts

		; close
close_file:
		ld			c, D2F_CLOSE
		ld			a, [file_handle]
		ld			b, a
		call		bdos
		xor			a, a
		ret
error_exit2:
		call		close_file
error_exit1:
		ld			de, s_crlf
		call		puts
		ld			a, 2
		ret

		; 1segment分読み出す
load_1segment:
		push		af

		ld			de, progress_bar
		call		puts

		; -- read 1st 8KB
		ld			c, D2F_READ
		ld			a, [file_handle]
		ld			b, a
		ld			de, 0x6000				; load address (TPA)
		ld			hl, 0x2000				; size
		call		bdos
		or			a, a
		jp			nz, error_load_1segment

		ld			de, progress_bar
		call		puts

		; -- 一時的に page2 を漢字RAM用メモリに切り替える
		ld			h, 0x80
		ld			a, [kanji_ram_slot]
		call		enaslt

		pop			af
		push		af
		call		mapper_put_p2

		ld			hl, 0x6000
		ld			de, 0x8000
		ld			bc, 0x2000
		ldir

		; -- page2 を TPA に戻す
		ld			h, 0x80
		ld			a, [ramad2]
		call		enaslt

		ld			a, [tpa_page2_segment]
		call		mapper_put_p2
		ei

		; -- read 2nd 8KB
		ld			c, D2F_READ
		ld			a, [file_handle]
		ld			b, a
		ld			de, 0x6000				; load address (TPA)
		ld			hl, 0x2000				; size
		call		bdos
		or			a, a
		jp			nz, error_load_1segment

		ld			de, progress_bar
		call		puts

		; -- 一時的に page2 を漢字RAM用メモリに切り替える
		ld			h, 0x80
		ld			a, [kanji_ram_slot]
		call		enaslt

		pop			af
		call		mapper_put_p2

		ld			hl, 0x6000
		ld			de, 0xA000
		ld			bc, 0x2000
		ldir

		; -- page2 を TPA に戻す
		ld			h, 0x80
		ld			a, [ramad2]
		call		enaslt

		ld			a, [tpa_page2_segment]
		call		mapper_put_p2
		ei

		or			a, a
		ret

error_load_1segment:
		pop			af
		scf
		ret


file_handle:
		db			0
msg_load_kfont:
		ds			"Load KFONT.BIN: "
		db			0
progress_bar:
		ds			"*"
		db			0
s_crlf:
		db			0x0d, 0x0a, 0
tpa_page2_segment:
		db			0
s_font_name:
		ds			"KFONT.BIN"
		db			0
		endscope

; ==============================================================================
;	put_kanji
;	一文字描画する
;	input)
;		de ... 文字が格納されているアドレス (ShiftJIS)
;		hl ... 描画メモリのアドレス
;	output)
;		de ... 次の文字の格納アドレス
;		a .... 0: 終端文字だった
;		       1: 半角文字だった
;		       2: 全角文字だった
;	break)
;		all
; ==============================================================================
		scope	put_kanji
put_kanji::
		ld		[kanji_target_address], hl
		ld		a, [de]
		cp		a, ' '
		jp		nc, skip1
		xor		a, a
		ret
skip1:
		inc		de
		call	issjis1st
		jp		nc, put_half_size

		; 全角文字の描画
		cp		a, 0xE0
		jp		c, skip_pfs1
		sub		a, 0x40			; 0xE0..0xFF --> 0xA0..0xBF
skip_pfs1:
		cp		a, 0x88
		jp		c, skip_pfs2
		sub		a, 0x03			; 0x88..0xBF --> 0x85..0xBC
skip_pfs2:
		sub		a, 0x81			; A = 0x00..0x3A
		; 192倍 = 3 * 64倍  ※3倍は 8bit を越えない
		ld		b, a
		add		a, a
		add		a, b
		ld		l, a
		ld		h, 0
		ld		b, h
		ld		c, 159
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, bc
		; 2byte目
		ld		a, [de]
		inc		de
		push	de
		sub		a, 0x40
		ld		c, a
		add		hl, bc
		; 1文字8byte
		add		hl, hl
		add		hl, hl
		add		hl, hl
		push	hl
		; 必要なセグメントに切り替える
		ld		a, h
		rlca
		rlca
		and		a, 3
		ld		l, a
		ld		h, 0
		ld		de, kanji_ram0_seg
		add		hl, de
		ld		a, [hl]
		call	mapper_put_p2
		; セグメント内アドレスを求める
		pop		hl
		ld		a, h
		and		a, 0x3F
		or		a, 0x80
		ld		h, a
		ld		de, [kanji_target_address]
		ld		a, 2
		jp		transfer
		; 半角文字の描画
put_half_size:
		push	de
		; 32～127, 161～223 → 0～158 に変換
		sub		a, 32
		cp		a, 96
		jr		c, skip_phs1
		sub		a, 33
skip_phs1:
		ex		de, hl
		; アドレスに変換
		ld		l, a
		ld		h, 0
		add		hl, hl
		add		hl, hl
		add		hl, hl
		ld		a, [kanji_ram0_seg]			; 半角文字は必ず kanji_ram0
		call	mapper_put_p2
		ld		a, h
		or		a, 0x80
		ld		h, a
		ld		a, 1
transfer:
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		pop		de
		ret
		endscope

; ==============================================================================
;	put_kanji_4sft
;	一文字描画する (4画素シフト)
;	input)
;		de ... 文字が格納されているアドレス (ShiftJIS)
;		hl ... 描画メモリのアドレス
;	output)
;		de ... 次の文字の格納アドレス
;		a .... 0: 終端文字だった
;		       1: 半角文字だった
;		       2: 全角文字だった
;	break)
;		all
; ==============================================================================
		scope	put_kanji_4sft
put_kanji_4sft::
		ld		[kanji_target_address], hl
		ld		a, [de]
		cp		a, ' '
		jp		nc, skip1
		xor		a, a
		ret
skip1:
		inc		de
		call	issjis1st
		jp		nc, put_half_size

		; 全角文字の描画
		cp		a, 0xE0
		jp		c, skip_pfs1
		sub		a, 0x40			; 0xE0..0xFF --> 0xA0..0xBF
skip_pfs1:
		cp		a, 0x88
		jp		c, skip_pfs2
		sub		a, 0x03			; 0x88..0xBF --> 0x85..0xBC
skip_pfs2:
		sub		a, 0x81			; A = 0x00..0x3A
		; 192倍 = 3 * 64倍  ※6倍は 8bit を越えない
		ld		b, a
		add		a, a
		add		a, b
		ld		l, a
		ld		h, 0
		ld		b, h
		ld		c, 159
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, bc
		; 2byte目
		ld		a, [de]
		inc		de
		push	de
		sub		a, 0x40
		ld		c, a
		add		hl, bc
		; 1文字8byte
		add		hl, hl
		add		hl, hl
		add		hl, hl
		push	hl
		; 必要なセグメントに切り替える
		ld		a, h
		rlca
		rlca
		and		a, 3
		ld		l, a
		ld		h, 0
		ld		de, kanji_ram0_seg
		add		hl, de
		ld		a, [hl]
		call	mapper_put_p2
		; セグメント内アドレスを求める
		pop		hl
		ld		a, h
		and		a, 0x3F
		or		a, 0x80
		ld		h, a
		ld		de, [kanji_target_address]
		; 左半分の描画
		push	hl
		ld		b, 8
loop_pfs1:
		ld		a, [hl]
		rrca
		rrca
		rrca
		rrca
		and		a, 0x0F
		ex		de, hl
		or		a, [hl]
		ld		[hl], a
		ex		de, hl
		inc		hl
		inc		de
		djnz	loop_pfs1
		pop		hl
		; 右半分の描画
		ld		b, 8
loop_pfs2:
		ld		a, [hl]
		rrca
		rrca
		rrca
		rrca
		and		a, 0xF0
		ld		[de], a
		inc		hl
		inc		de
		djnz	loop_pfs2
		pop		de
		ld		a, 2
		ret

		; 半角文字の描画
put_half_size:
		push	de
		; 32～127, 161～223 → 0～158 に変換
		sub		a, 32
		cp		a, 96
		jr		c, skip_phs1
		sub		a, 33
skip_phs1:
		ex		de, hl
		; アドレスに変換
		ld		l, a
		ld		h, 0
		add		hl, hl
		add		hl, hl
		add		hl, hl
		ld		a, [kanji_ram0_seg]			; 半角文字は必ず kanji_ram0
		call	mapper_put_p2
		ld		a, h
		or		a, 0x80
		ld		h, a
		ld		b, 8
loop_phs1:
		ld		a, [hl]
		rrca
		rrca
		rrca
		rrca
		and		a, 0x0F
		ex		de, hl
		or		a, [hl]
		ld		[hl], a
		ex		de, hl
		inc		hl
		inc		de
		djnz	loop_phs1
		pop		de
		ld		a, 1
		ret
		endscope

; ==============================================================================
;	put_string
;	input)
;		de .... 描画する文字列 (ASCIIZ), MAX62文字
;	output)
;		hl ........... kanji_work
;		kanji_work ... 描画する文字
;		b ............ 転送するbyte数
;		a ............ 次の文字
; ==============================================================================
		scope	put_string
put_string::
		; Change to kanji-ram mapper slot
		push	de
		ld		h, 0x80
		ld		a, [kanji_ram_slot]
		call	enaslt
		ei
		pop		de

		ld		hl, kanji_work
		xor		a, a				; Cy = 0
loop:
		push	hl
		ld		bc, kanji_work_end
		sbc		hl, bc
		pop		hl
		jp		nc, exit_put_string	; 終端に到着
		or		a, a
		jp		nz, skip_4sft		; a = 0 なら 綺麗な位置, 非0 なら 4ドットシフト位置

		; 綺麗な位置に描画
		push	hl
		call	put_kanji
		pop		hl
		or		a, a
		jp		z, exit_put_string_term
		dec		a
		dec		a
		jp		nz, loop			; 半角描画した場合は hl は進めず a = -1 にする
		ld		bc, 8				; 全角描画した場合は hl を進めて a = 0 にする
		add		hl, bc				; Cy = 0
		jp		loop

skip_4sft:
		; 4ドットシフトした位置に描画
		push	hl
		call	put_kanji_4sft
		pop		hl
		ld		bc, 8				; 半角でも全角でも hl は進める
		add		hl, bc				; 半角だった場合は綺麗な位置 ( a = 0 ) にする , ついでに Cy = 0
		or		a, a
		jp		z, exit_put_string_term
		dec		a
		jp		loop				; 全角だった場合は4ドットシフト位置 ( a = 1 ) にする

exit_put_string:
		ld		a, [de]				; 次の文字
exit_put_string_term:
		ei
		ld		de, kanji_work
		sbc		hl, de
		ld		b, l
		ex		de, hl
		ret
		endscope

; ==============================================================================
;	WORKAREA
; ==============================================================================
kanji_target_address:
		dw		0
kanji_ram_slot:
		db		0
kanji_ram0_seg:
		db		0
kanji_ram1_seg:
		db		0
kanji_ram2_seg:
		db		0
kanji_ram3_seg:
		db		0

kanji_work		:= s_path_env
kanji_work_end	:= s_path_env_end
