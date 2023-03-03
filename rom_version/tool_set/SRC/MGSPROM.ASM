; ==============================================================================
;   MGSP ROM version
;
;  Copyright (C) 2020-2023 Takayuki Hara (HRA!)
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
; ==============================================================================
		include		"MSXBIOS.ASM"
		include		"MGSDRV_API.ASM"
		include		"ROM_BANK.ASM"
		include		"MGSP_WORK.ASM"
		include		"CUSTOM.ASM"

BOOT_BANK		:= 0
MGSDRV_BANK		:= 1
MGSP_BANK		:= 2
KANJI_BANK		:= 3

		org			0x4000
; ==============================================================================
;	ROM Header
; ==============================================================================
rom_header_id:
		ds			"AB"
rom_header_init:
		dw			entry
rom_header_statement:
		dw			0
rom_header_device:
		dw			0
rom_header_text:
		dw			0
rom_header_reserved:
		space		0x0010 - 0x000A, 0

; ==============================================================================
;	Initializer
; ==============================================================================
		scope		entry_point
entry::
		di
		; スタックポインタを初期化
		ld			hl, [himem]
		ld			de, diskve
		or			a, a
		sbc			hl, de
		ld			sp, diskve
		jp			nc, skip1
		ld			sp, [himem]
skip1:
		; その他の初期化
		call		init_memory_mapper
		call		get_rom_slot
		call		search_page1_dram_slot
		call		search_page2_dram_slot
		call		transfer_to_ram
		call		other_init
		call		kanji_init
		call		grp_init
		jp			go_mgsp_body
		endscope

; ==============================================================================
;	Memory Mapper を初期化する
;
;	メモリマッパーは使わないが、page0～3 がすべて異なるセグメントになっていないと
;	不都合がでる。MSX1 では BIOS にマッパー初期化処理が含まれておらず、
;	メモリマッパーRAMも、セグメントレジスタを初期化せず、全ページ同じセグメントに
;	なっているケースがある。
;	一方で MSX2 は BIOS にセグメントレジスタを初期化する処理が含まれており、
;	page3, 2, 1, 0 の順で 0, 1, 2, 3 を割り付ける。
;	これに合わせて page3, 2, 1, 0 の順で 0, 1, 2, 3 に初期化してしまうことで、
;	例えば page1 と 2 に同じセグメントが現れて、片方に書くともう片方も書き換わる
;	という状況を避ける。
; ==============================================================================
		scope		init_memory_mapper
init_memory_mapper::
		xor			a, a
		out			[0xFF], a
		inc			a
		out			[0xFE], a
		inc			a
		out			[0xFD], a
		inc			a
		out			[0xFC], a

		ld			a, [0x002D]
		cp			a, 3					; MSXturboR or later?
		ret			c						; Return when this system is MSX1/2/2+.

		ld			a, 0x81					; R800 ROM Mode
		call		chgcpu
		ret
		endscope

; ==============================================================================
;	この ROMカートリッジが存在するスロット番号を求める
; ==============================================================================
		scope		get_rom_slot
get_rom_slot::
		di
		; 基本スロット切り替え: page3 を page1 と同じスロットに切り替える
		in			a, [0xA8]
		ld			d, a						; 基本スロットレジスタ 0xA8 を D にバックアップ
		ld			c, a
		and			a, 0b00_11_11_11
		ld			b, a						; B = 00zzyyxx : xx=page0slot, yy=page1slot, zz=page2slot
		ld			a, c
		and			a, 0b00_00_11_00			; A = 0000yy00 : yy=page1slot
		rrca
		rrca
		ld			c, a						; C = 000000yy : yy=page1slot
		rrca
		rrca
		or			a, b						; A = yyzzyyxx : xx=page0slot, yy=page1slot, zz=page2slot

		ld			b, 0
		ld			hl, exptbl
		add			hl, bc
		ld			b, [hl]						; B = 拡張スロットの有無

		; 基本スロットを切り替える
		out			[0xA8], a					; page3 に page1 と同じ基本スロット番号を指定

		; 拡張スロットが存在するか確認する
		ld			a, b
		and			a, 0x80
		jr			z, page1_is_not_expanded

		; 拡張スロット読み取り
		ld			a, [0xFFFF]
		cpl
		and			a, 0b00_00_11_00			; page1 の拡張スロット番号
		or			a, 0x80						; 拡張スロットフラグ
		or			a, c
		ld			c, a						; C = e000YYyy : yy = page1 primary slot, YY = page1 secondary slot, e = expanded
page1_is_not_expanded:

		; 基本スロットを元に戻す
		ld			a, d
		out			[0xA8], a

		; 求めたスロット番号を保存
		ld			a, c
		ld			[my_slot_no], a

		; page2 を求めたスロットに変更する
		ld			h, 0x80
		call		enaslt

		; ROM Bank を 0,1,0,1 にする (rom_bank0 はこのコードが動いてる時点で 0 になっている)
		xor			a, a
		ld			[rom_bank2], a
		inc			a
		ld			[rom_bank1], a
		ld			[rom_bank3], a
		ei
		ret
		endscope

; ==============================================================================
;	Page1 の DRAMスロットを検出して RAMAD1 にセットする
;		このコードは、page2 で稼働する。
; ==============================================================================
		org			$ + 0x4000
		scope		search_page1_dram_slot
search_page1_dram_slot::
		di
		ld			a, [exptbl + 0]
		and			a, 0x80
		call		search_page1_sub
		ret			nc

		ld			a, [exptbl + 1]
		and			a, 0x80
		or			a, 0x01
		call		search_page1_sub
		ret			nc

		ld			a, [exptbl + 2]
		and			a, 0x80
		or			a, 0x02
		call		search_page1_sub
		ret			nc

		ld			a, [exptbl + 3]
		and			a, 0x80
		or			a, 0x03
		call		search_page1_sub
		ret			nc

not_enough_memory:
		; SCREEN 1
		ld			a, 1
		call		CHGMOD

		ld			hl, error_message
		ld			de, 0x1800				; Pattern name table
		ld			bc, error_message_end - error_message
		call		LDIRVM
		di
		halt
error_message:
					;01234567890123456789012345678901
		ds			"Not enough memory.              "
		ds			"At least 64KB is required."
error_message_end:

search_page1_sub:
		push		af
		; page1 のスロットを切り替える
		ld			h, 0x40
		call		enaslt
		; page1 が RAMかどうか調べる
		ld			hl, 0x4000
		ld			de, 0x4000
loop:
		ld			a, [hl]
		cpl
		ld			[hl], a
		cp			a, [hl]
		cpl
		ld			[hl], a
		jr			nz, no_match
		inc			hl
		dec			de
		ld			a, d
		or			a, e
		jr			nz, loop
match:
		pop			af
		ld			[ramad1], a
		; page1 のスロットを切り替える
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt
		ei
		or			a, a						; Cy = 0
		ret

no_match:
		pop			af
		or			a, a
		jp			p, not_found
		add			a, 0b0000_01_00
		bit			4, a
		jp			z, search_page1_sub

not_found:
		scf
		ret										; Cy = 1
		endscope
		org			$ - 0x4000

; ==============================================================================
;	page2 の DRAMスロットを検出して RAMAD2 にセットする
;		このコードは、page1 で稼働する。
; ==============================================================================
		scope		search_page2_dram_slot
search_page2_dram_slot::
		di
		ld			a, [exptbl + 0]
		and			a, 0x80
		call		search_page2_sub
		ret			nc

		ld			a, [exptbl + 1]
		and			a, 0x80
		or			a, 0x01
		call		search_page2_sub
		ret			nc

		ld			a, [exptbl + 2]
		and			a, 0x80
		or			a, 0x02
		call		search_page2_sub
		ret			nc

		ld			a, [exptbl + 3]
		and			a, 0x80
		or			a, 0x03
		call		search_page2_sub
		ret			nc

not_enough_memory:
		di
		halt

search_page2_sub:
		push		af
		; page2 のスロットを切り替える
		ld			h, 0x80
		call		enaslt
		; page2 が RAMかどうか調べる
		ld			hl, 0x8000
		ld			de, 0x4000
loop:
		ld			a, [hl]
		cpl
		ld			[hl], a
		cp			a, [hl]
		cpl
		ld			[hl], a
		jr			nz, no_match
		inc			hl
		dec			de
		ld			a, d
		or			a, e
		jr			nz, loop
match:
		pop			af
		ld			[ramad2], a
		; page2 のスロットを切り替える
		ld			a, [my_slot_no]
		ld			h, 0x80
		call		enaslt
		ei
		or			a, a						; Cy = 0
		ret

no_match:
		pop			af
		or			a, a
		jp			p, not_found
		add			a, 0b0000_01_00
		bit			4, a
		jp			z, search_page2_sub

not_found:
		scf
		ret										; Cy = 1
		endscope

; ==============================================================================
; 各種ブロック転送
; ==============================================================================
		scope		transfer_to_ram
transfer_to_ram::
		; page2 へジャンプする
		jp			transfer_to_ram_sub

		org			$ + 0x4000
transfer_to_ram_sub:
		; page1 を RAM に切り替える
		ld			a, [ramad1]
		ld			h, 0x40
		call		enaslt

		; MGSDRV を page1 (6000h-7fffh) へ転送する (※ rom_bank3 がすでに MGSDRV_BANK)
		ld			hl, 0xA000			; rom_bank3
		ld			de, 0x6000
		ld			bc, 0x2000
		ldir

		; page1 を ROM に切り替える
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt

		; rom_bank3 を MGSP_BANK に切り替える
		ld			a, MGSP_BANK
		ld			[rom_bank3], a

		; page1 を RAM に切り替える
		ld			a, [ramad1]
		ld			h, 0x40
		call		enaslt

		; MGSP を page1 (4000h-5fffh) へ転送する
		ld			hl, 0xA000			; rom_bank3
		ld			de, 0x4000
		ld			bc, 0x2000
		ldir

		; page1 を ROM に切り替える
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt

		; H.TIMIルーチンを page3 へ転送する (※まだフックはかけない)
		ld			hl, mgsdrv_h_timi
		ld			de, mgsdrv_h_timi_rel
		ld			bc, mgsdrv_h_timi_size
		ldir

		ld			hl, h_timi
		ld			de, old_h_timi
		ld			bc, 5
		ldir

		ld			a, [my_slot_no]
		ld			[page1_slot], a
		ld			[page2_slot], a
		ret
		endscope

; ==============================================================================
;	page3で動作するルーチン
; ==============================================================================

; ==============================================================================
;	go_mgsp_body
;		MGSP.ASM の先頭にある mgsp_body (page1 の RAM) へジャンプするルーチン
; ==============================================================================
		scope		mgsdrv_h_timi
mgsdrv_h_timi::
		org			mgsdrv_h_timi_rel
go_mgsp_body::
		di
		; page1 を RAMスロットに切り替える
		ld			a, [ramad1]
		ld			h, 0x40
		ld			[page1_slot], a
		call		enaslt					; 割禁
		; page2 を RAMスロットに切り替える
		ld			a, [ramad2]
		ld			h, 0x80
		ld			[page2_slot], a
		call		enaslt					; 割禁
		; MGSDRVを初期化する
		call		init_mgsdrv
		ei
		jp			mgsp_body
		endscope

; ==============================================================================
;	copy_mgs_data
;		page2 の RAM へ MGSファイルイメージを転送するルーチン
;	input)
;		HL ........ ファイルエントリのアドレス
; ==============================================================================
		scope		copy_mgs_data
copy_mgs_data::
		ld			de, FENT_MGS_BANK_ADDRESS
		add			hl, de
		ld			a, [hl]					; +9 : A=バンク番号
		ld			[bank_num], a
		inc			hl
		ld			e, [hl]
		inc			hl
		ld			d, [hl]					; +10, +11 : DE=オフセットアドレス
		ld			[offset_address], de
		inc			hl
		ld			e, [hl]
		inc			hl
		ld			d, [hl]					; +12, +13 : DE=ファイルサイズ
		ld			[file_size], de
		; page1 を ROMスロットに切り替える
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt					; 割禁
		; page2 を RAMスロットに切り替える
		ld			a, [ramad2]
		ld			h, 0x80
		call		enaslt					; 割禁
		; アドレス計算
		ld			hl, [offset_address]
		ld			a, h
		or			a, 0x40
		ld			h, a
		; サイズ計算
		ld			bc, [file_size]
		ld			a, b
		cp			a, 0x20
		jp			nc, over_2000h
		; bank0 (page1) を所望のファイルが置いてあるバンクに切り替える
		ld			a, [bank_num]
		ld			[rom_bank0], a
		inc			a
		ld			[rom_bank1], a
		; page1 --> page2 ブロック転送 (8192byte未満の場合)
		ld			de, 0x8000
		ldir
		jp			exit_copy_mgs_data
over_2000h:
		; bank0 (page1) を所望のファイルが置いてあるバンクに切り替える
		ld			a, [bank_num]
		ld			[rom_bank0], a
		inc			a
		ld			[rom_bank1], a
		; まず前半 8192byte を転送
		push		hl
		ld			bc, 0x2000
		ld			de, 0x8000
		ldir
		pop			hl
		; バンク切り替え
		ld			[rom_bank0], a
		inc			a
		ld			[rom_bank1], a
		; 残りを転送
		ld			bc, [file_size]
		ld			a, b
		sub			a, 0x20
		ld			b, a
		ld			de, 0xA000
		ldir
exit_copy_mgs_data:
		; page1 を 元スロットに切り替える
		ld			a, [page1_slot]
		ld			h, 0x40
		call		enaslt					; 割禁
		; page2 を 元スロットに切り替える
		ld			a, [page2_slot]
		ld			h, 0x80
		call		enaslt					; 割禁
		ret
bank_num:
		db			0
offset_address:
		dw			0
file_size:
		dw			0
		endscope

; ==============================================================================
;	enble_page2_bank
;		page2 を ROMスロット に切り替えて、page2 の ROM を指定のバンクに切り替える
;	input)
;		A ........ bank2 のバンク番号
;	comment)
;		bank2 は A, bank3 は A+1 のバンクに切り替わって page2 に現れる。
;		割禁のまま戻る
; ==============================================================================
		scope		enble_page2_bank
enble_page2_bank::							; page2をROMスロットに切り替えて指定のバンクに切り替える
		push		af						; DI のまま戻る
		; page1 を ROMスロットに切り替える
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt					; 割禁
		; page2 を ROMスロットに切り替える
		ld			a, [my_slot_no]
		ld			h, 0x80
		call		enaslt					; 割禁
		pop			af
		ld			[rom_bank2], a
		inc			a
		ld			[rom_bank3], a
		inc			a
		; page1 を 元スロットに切り替える
		ld			a, [page1_slot]
		ld			h, 0x40
		call		enaslt					; 割禁
		ret
		endscope

; ==============================================================================
;	mgsdrv_h_timi_start
;		H.TIMI 処理ルーチン
; ==============================================================================
		scope		mgsdrv_h_timi_start
mgsdrv_h_timi_start::
		; MGSP内で利用するカウンター
		ld			a, [timer_counter]
		inc			a
		ld			[timer_counter], a

		; 再生速度カウンターをインクリメント
		ld			hl, [song_speed_counter]
		ld			de, [song_speed]
		add			hl, de
		ld			[song_speed_counter], hl

loop1:
		or			a, a
		ld			de, 100
		sbc			hl, de
		jr			c, mgs_inter_skip

		ld			[song_speed_counter], hl

		; MGSDRV を呼ぶ
		call		mgs_inter

		ld			hl, [song_speed_counter]
		jr			loop1

mgs_inter_skip:
old_h_timi::
		ret
		ret
		ret
		ret
		ret
mgsdrv_h_timi_end::

mgsdrv_h_timi_size	:= mgsdrv_h_timi_end - mgsdrv_h_timi_rel

		if mgsdrv_h_timi_size >= 0x400
			error "MGSDRV_H_TIMI is too big!"
		endif

		org			mgsdrv_h_timi + mgsdrv_h_timi_size - 0x4000
		endscope

; ==============================================================================
; Graphic 初期化ルーチン
; ==============================================================================
		include		"GRAPHIC_INIT.ASM"
		include		"GRAPHIC_INIT_DATA.ASM"
		include		"GRAPHIC_RO_DATA.ASM"
		include		"KANJI.ASM"
		include		"GamingLED.asm"

; ==============================================================================
; その他の初期化ルーチン
; ==============================================================================
		scope		other_init
other_init::
		; キークリック音 OFF
		xor			a, a
		ld			[cliksw], a
		; 定数を初期化
		ld			[timer_counter], a
		ld			hl, 100
		ld			[song_speed], hl
		ret
		endscope

end_of_boot_code:
		space		(0x6000 - 13) - $, 0

; ==============================================================================
; MGSDRV.COM をここにリンクする
; ==============================================================================
mgsdrv_address::
		binary_link	"../MGSDRV/MGSDRV.COM"

; ==============================================================================
; MGSP本体 (MGSDRV.COM が 8192 align をやや越えてくるので 0x4000ぴったりにはならない)
; ==============================================================================
		org			($ % 8192) + 0x4000
mgsp_address::
		include		"MGSP.ASM"
		include		"GamingLED_cmd.asm"
		align		8192

; ==============================================================================
; 漢字ROM
; ==============================================================================
kanji_address::
		binary_link	"KFONT_ROM.BIN"

; ==============================================================================
; ファイル情報
; ==============================================================================
		include		"FL_ENTRY.ASM"

; ==============================================================================
; MGSファイル
; ==============================================================================
		binary_link	"MGS_PACK.BIN"

		scope		post_mgs_padding
padding_size	= (8192 - ($ % 8192)) % 8192
			space	padding_size, 0xFF
		endscope
end_of_program::
