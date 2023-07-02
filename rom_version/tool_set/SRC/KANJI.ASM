; ==============================================================================
;	Kanji Driver
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
;	2020/9/26	t.hara	1.0		1st release
; ==============================================================================

; ==============================================================================
;	kanji_init
;	漢字フォント描画ルーチンを page3 へ転送する
;	input)
;		--
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope		kanji_init
kanji_init::
		; page3 へ kanji_driver を転送する
		ld			hl, kanji_driver_on_rom
		ld			de, kanji_driver_top
		ld			bc, kanji_driver_size
		ldir
		ret
		endscope

; ==============================================================================
kanji_driver_on_rom::
		org		kanji_driver
kanji_driver_top::

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
		call	SETWRT
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
		; Page1, Page2 をカートリッジのスロットに変更する
		push	de
		ld		h, 0x40
		ld		a, [my_slot_no]
		call	enaslt				; 割禁
		ld		h, 0x80
		ld		a, [my_slot_no]
		call	enaslt				; 割禁
		pop		de

		ld		hl, kanji_work
		xor		a, a				; Cy = 0
		ld		[rom_ctrl], a		; MegaSCC RAM対応 - select lower/upper bank
		ld		[rom_bank0], a		; HELP や 各種表示文字列は Bank#0 にあるので、Bank0 を Bank#0 に戻しておく
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
		push	af
		push	hl
		ld		a, 0x3F
		ld		[scc_bank2], a		; Konami8K SCC の場合、SCCレジスタを出現させておく。ASCII8K の場合、意味も無く ROM に 3Fh 書き込む。
		ld		h, 0x40
		ld		a, [page1_slot]
		call	enaslt				; 割禁
		ld		h, 0x80
		ld		a, [page2_slot]
		call	enaslt				; 割禁
		ei
		pop		hl
		pop		af

		ld		de, kanji_work
		sbc		hl, de
		ld		b, l
		ex		de, hl
		ret
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
		; 必要なバンク(HLの上位3bit)に切り替える
		ld		a, h
		rlca
		rlca
		rlca
		and		a, 0b0000_0111
		ld		[rom_ctrl], a			; MegaSCC RAM対応 - select lower/upper bank
		add		a, KANJI_BANK
		ld		[rom_bank2], a
		; バンク内アドレスを求める
		pop		hl
		ld		a, h
		and		a, 0b0001_1111
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
		ld		a, KANJI_BANK
		ld		[rom_ctrl], a			; MegaSCC RAM対応 - select lower/upper bank
		ld		[rom_bank2], a
		ld		a, 0x80
		add		a, h
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
		; 必要なバンク(HLの上位3bit)に切り替える
		ld		a, h
		rlca
		rlca
		rlca
		and		a, 0b0000_0111
		add		a, KANJI_BANK
		ld		[rom_ctrl], a			; MegaSCC RAM対応 - select lower/upper bank
		ld		[rom_bank2], a
		; バンク内アドレスを求める
		pop		hl
		ld		a, h
		and		a, 0b0001_1111
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
		ld		a, KANJI_BANK
		ld		[rom_ctrl], a			; MegaSCC RAM対応 - select lower/upper bank
		ld		[rom_bank2], a
		ld		a, 0x80
		add		a, h
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
;	issjis1st
;	input)
;		a ..... Character code
;	output)
;		Cy .... 0: ASCIIコード/かな文字コード, 1: マルチバイト1byte目
;	break)
;		f
;	comment)
;		文字コード A が、ShiftJIS のマルチバイト1byte目かどうかを判定する
; ==============================================================================
		scope	issjis1st
issjis1st::
		or		a, a
		ret		p			; 0～127 は ASCIIコード
		cp		a, 161
		ret		c			; 128～160 は マルチバイト1byte目
		cp		a, 224
		ccf					; 161～223 は かな文字コード, 224～255 はマルチバイト1byte目
		ret
		endscope

kanji_target_address:
		dw		0

grp_draw_file_line::
sort_song_title1::
		space	64
sort_song_title2::
		space	64
target_file_name::				; 曲名表示(スクロールあり)のために、曲名を保持する領域
		space		128
target_file_name_end::
		db			0, 0

kanji_driver_bottom::
kanji_driver_size	:= kanji_driver_bottom - kanji_driver_top
		org		kanji_driver_on_rom + kanji_driver_size
