; ==============================================================================
;	File list
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
;	Date		Author	Ver.	Description
;	2020/9/20	t.hara	v1.0	1st release
; ==============================================================================

fl_max_entries	:= 192

; ==============================================================================
;	ファイルアクセス関連の初期化
; ==============================================================================
		scope		file_init
file_init::
		; page2 を ROM, fl_entry_table_init のバンク に変える
		ld			a, fl_entry_table_init_bank
		call		enble_page2_bank
		; ブロック転送
		ld			hl, fl_entry_table_init_offset + 0x8000
		ld			de, fl_entry_table
		ld			bc, fl_files * fl_entry_size
		ldir
		; page2 を RAMへ戻す
		ld			a, [ramad2]
		ld			h, 0x80
		call		enaslt
		ei
		ret
		endscope

; ==============================================================================
;	fl_update_entries
; ==============================================================================
		scope		fl_update_entries
fl_update_entries::
		ld			a, [sort_mode]
		or			a, a
		ret			z						;	ディレクトリエントリ順(fl_sort_normal)の場合、ソート自体実行しない
		dec			a
		jp			z, fl_sort_title
		dec			a
		jp			z, fl_sort_filename
		jp			fl_sort_shuffle
		endscope

; ==============================================================================
;	メモリを確保して指定のファイルの曲名を取得する
;	input)
;		hl ... entry table
;		de ... destination address
;		b .... length
;	output)
;		a .... string length
;	break)
;		all
; ==============================================================================
		scope		get_mgs_song_title
get_mgs_song_title::
		push		de
		push		bc
		; page2 を ROMスロットに切り替えて、曲データのバンクに切り替える
		ld			de, FENT_MGS_BANK_ADDRESS
		add			hl, de
		ld			a, [hl]				; BANK番号
		inc			hl
		ld			c, [hl]				; オフセットアドレス下位
		inc			hl
		ld			b, [hl]				; オフセットアドレス上位
		push		bc
		ld			[bank_num], a		; バックアップ
		dec			a					; Bank2 は Bank#0x3F を読めないので、Bank3 を使う
		call		enble_page2_bank
		; 曲名データを転送する
		pop			hl					; HL = オフセットアドレス + 0xA008
		ld			bc, 0xA008
		add			hl, bc

		pop			bc					; BC = length
		pop			de					; DE = destination address
		push		de
loop:
		ld			a, [hl]
		cp			a, ' '
		jr			c, fill_space
		ld			[de], a
		inc			de
		inc			hl
		ld			a, h				; バンク境界に到達したか？
		cp			a, 0xC0
		jr			nz, skip_change_bank
		; バンク境界に達した場合、bank3 を次のバンクへ切り替える
		push		de
		push		bc
		ld			a, [bank_num]
		call		enble_page2_bank
		pop			bc
		pop			de
		ld			hl, 0xA000			; バンクの先頭へ移動
skip_change_bank:
		djnz		loop
		jr			skip

fill_space:
		push		de
		ld			a, ' '
fill_space_loop:
		ld			[de], a
		inc			de
		djnz		fill_space_loop
		pop			de

skip:
		pop			hl
		ex			de, hl
		xor			a, a
		sbc			hl, de
		push		hl

		ld			a, 0x3F
		ld			[scc_bank2], a		; Konami8K SCC の場合、SCCレジスタを出現させておく。ASCII8K の場合、意味も無く ROM に 3Fh 書き込む。
		; page2 を RAMスロットに戻す
		ld			a, [page2_slot]
		ld			h, 0x80
		call		enaslt
		ei
		pop			hl
		ld			a, l
		ret
bank_num:
		db			0
		endscope

; ==============================================================================
;	get_current_file_entry
;	input)
;		a ................... 対象のファイルの番号 (一覧表の中の何番目か)
;	output)
;		hl .................. 指定のファイルのファイルのエントリアドレス
;	break)
;		hl, de
; ==============================================================================
		scope	get_current_file_entry
get_current_file_entry::
		ld		l, a
		ld		h, 0
		add		hl, hl					; +-- hl = file_number * 16
		add		hl, hl					; |
		add		hl, hl					; |
		add		hl, hl					; |
		ld		de, fl_entry_table
		add		hl, de					; 絶対0 にはならないので、Zf = 0
		ret
		endscope

; ==============================================================================
;	fl_swap_entry
;	input)
;		a .... 1st target number
;		b .... 2nd target number
;	comment)
;		swap_cbr_address に HL, DE の２レジスタが示す entry を入れ替える判定ルーチン
;		のアドレスを書き込んでおくこと
; ==============================================================================
		scope	fl_swap_entry
fl_swap_entry::
		; get 1st target entry address (A)
		push	bc							; 2nd target 保存
		call	get_current_file_entry

		; get 2nd target entry address (B)
		pop		af							; 2nd target 復元
		push	hl							; 1st target の entry 保存
		call	get_current_file_entry
		pop		de							; 1st target entry 復元
		push	de							; 1st target entry 保存
		push	hl							; 2nd target entry 保存, この時点で HL=2nd target entry, DE=1st target entry

		; このエントリをスワップするか判定する
swap_cbr_address	:= code_address + 1
		call	cbr_compare_normal
		pop		hl							; 2nd target entry 復元
		pop		de							; 1st target entry 復元
		ret		nc

		; swap entry
		ld		b, fl_entry_size
loop:
		ld		a, [de]
		ld		c, [hl]
		ld		[hl], a
		ld		a, c
		ld		[de], a
		inc		hl
		inc		de
		djnz	loop
		ret
		endscope

; ==============================================================================
;	cbr_compare_normal (ディレクトリエントリ順)
;	input)
;		hl .... 1つ目のエントリ
;		de .... 2つ目のエントリ
;	output)
;		Cyフラグ ... 0: 入れ替えない, 1: 入れ替える
;	break)
;		all
; ==============================================================================
		scope	cbr_compare_normal
cbr_compare_normal::
		push	hl		; 1つ目 保存
		push	de		; 2つ目 保存

		pop		ix		; 2つ目
		pop		iy		; 1つ目
		ld		a, [ix + FENT_MGS_ENTRY_INDEX]
		ld		b, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2つ目の ENTRY_INDEX][1つ目の ENTRY_INDEX]
		sub		a, b
		ret
		endscope

; ==============================================================================
;	cbr_compare_title (曲名順)
;	input)
;		hl .... 1つ目のエントリ
;		de .... 2つ目のエントリ
;	output)
;		Cyフラグ ... 0: 入れ替えない, 1: 入れ替える
;	break)
;		all
; ==============================================================================
		scope	cbr_compare_title
cbr_compare_title::
		push	hl		; 1つ目 保存
		push	de		; 2つ目 保存

		; 曲名が読まれていなければ読み込む
		ld		de, sort_song_title1
		ld		b, 62
		call	get_mgs_song_title
		pop		hl		; 2つ目 復元
		push	hl		; 2つ目 保存
		ld		de, sort_song_title2
		ld		b, 62
		call	get_mgs_song_title

		pop		ix		; 2つ目
		pop		iy		; 1つ目
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2つ目の ENTRY_INDEX][1つ目の ENTRY_INDEX]
		ld		hl, sort_song_title1
		ld		de, sort_song_title2
cbr_compare_common::			; ※ここは他のソートからも呼ばれる
		; strcmp( hl, de ) の結果で入れ替え判定
		call	strcmp
		ret
		endscope

; ==============================================================================
;	cbr_compare_filename (ファイル名順)
;	input)
;		hl .... 1つ目のエントリ
;		de .... 2つ目のエントリ
;	output)
;		Cyフラグ ... 0: 入れ替えない, 1: 入れ替える
;	break)
;		all
; ==============================================================================
		scope	cbr_compare_filename
cbr_compare_filename::
		push	hl		; 1つ目 保存
		push	de		; 2つ目 保存
		pop		ix		; 2つ目
		pop		iy		; 1つ目
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2つ目の ENTRY_INDEX][1つ目の ENTRY_INDEX]
		jp		cbr_compare_common
		endscope

; ==============================================================================
;	cbr_compare_shuffle (シャッフル)
;	input)
;		hl .... 1つ目のエントリ
;		de .... 2つ目のエントリ
;	output)
;		Cyフラグ ... 0: 入れ替えない, 1: 入れ替える
;	break)
;		all
; ==============================================================================
		scope	cbr_compare_shuffle
cbr_compare_shuffle::
		push	hl
		push	de
		pop		ix		; 2つ目
		pop		iy		; 1つ目
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2つ目の ENTRY_INDEX][1つ目の ENTRY_INDEX]

		push	de
		call	get_random								; A, Dレジスタ破壊
		pop		de

		and		a, 0x04
		jp		z, cbr_compare_common
		ex		de, hl
		jp		cbr_compare_common
		endscope

; ==============================================================================
;	fl_buble_sort
;	fl_entry をバブルソートする､ソート基準は swap_cbr_address で指定されてる
;	ルーチンのアドレスによる
; ==============================================================================
		scope	fl_buble_sort
fl_buble_sort::
		ld		a, fl_files
		or		a, a					; ファイルが一つも無ければ何もしない
		ret		z
		dec		a						; ファイルが一つだけの場合も何もしない
		ret		z

		call	grp_begin_progress_bar
		ld		bc, 0x0001				; B=着目エントリ(0), C=次のエントリ(1)
loop1:
		push	bc

loop2:
		push	bc
		ld		a, c
		call	fl_swap_entry
		call	grp_update_progress_bar
		pop		bc
		inc		c
		ld		a, fl_files
		cp		a, c
		jr		nz, loop2

		pop		bc
		; 着目エントリを次へ遷移
		inc		b
		inc		c
		ld		a, fl_files
		cp		a, c
		jr		nz, loop1
		call	grp_end_progress_bar
		ret
		endscope

; ==============================================================================
;	fl_sort_normal (ディレクトリエントリ順)
; ==============================================================================
		scope	fl_sort_normal
fl_sort_normal::
		ld		hl, cbr_compare_normal
		ld		[swap_cbr_address], hl
		call	fl_buble_sort
		ret
		endscope

; ==============================================================================
;	fl_sort_title (曲名順)
; ==============================================================================
		scope	fl_sort_title
fl_sort_title::
		ld		hl, cbr_compare_title
		ld		[swap_cbr_address], hl
		call	fl_buble_sort
		ret
		endscope

; ==============================================================================
;	fl_sort_filename (ファイル名順)
; ==============================================================================
		scope	fl_sort_filename
fl_sort_filename::
		ld		hl, cbr_compare_filename
		ld		[swap_cbr_address], hl
		call	fl_buble_sort
		ret
		endscope

; ==============================================================================
;	fl_sort_shuffle (シャッフル)
; ==============================================================================
		scope	fl_sort_shuffle
fl_sort_shuffle::
		ld		hl, cbr_compare_shuffle
		ld		[swap_cbr_address], hl
		call	fl_buble_sort
		ret
		endscope

; ==============================================================================
;	Work area
; ==============================================================================
fl_entry_size			:= 16
FENT_MGS_FILE_NAME		:= 0
FENT_MGS_BANK_ADDRESS	:= 9
FENT_MGS_BANK_OFFSET	:= 10
FENT_MGS_FILE_SIZE		:= 12
FENT_MGS_ENTRY_INDEX	:= 14

;fl_entry	macro				; 16bytes
;		ds		" " * 9			; +0 , 9bytes: file name (ASCIIZ)
;		db		0				; +9 , 1byte : Bank number where the file resides
;		dw		0				; +10, 2bytes: Address in the bank where the file resides
;		dw		0				; +12, 2bytes: file size
;		db		0				; +14, 1byte : Directory entry index
;		db		0				; +15, 1byte : Reserved
;			endm

fl_entry_table::
		space	fl_max_entries * fl_entry_size
