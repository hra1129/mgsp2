; ==============================================================================
;	MGSDRV制御
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

mgs_song_data	:= 0x8000
mgs_song_size	:= 0x4000
mgs_song_title	:= 0x8008

; ==============================================================================
;	init_mgsdrv
;	input)
;		--
;	output)
;		Zf .... 0: エラー, 1: 正常
;	comment)
;		PATHの通った場所から MGSDRV.COM を見つけ出し、マッパーメモリを確保して
;		メモリに読み込む
;		マッパー処理の方の初期化が済んでいる必要がある。
; ==============================================================================
		scope	init_mgsdrv
init_mgsdrv::
		; MGSDRV用のメモリを確保する
		xor		a, a
		ld		b, a					; プライマリーマッパー
		call	mapper_all_seg			; 1セグメント請求
		jp		c, error_exit
		ld		[mgs_id_drvseg], a

		ld		a, b					; A = 0
		call	mapper_all_seg			; 1セグメント請求
		jp		c, error_exit
		ld		[mgs_id_datseg], a

		ld		a, [ramad1]
		ld		[mgs_id_drvslt], a
		ld		[mgs_id_datslt], a

		and		a, 0x03
		ld		b, a
		rlca
		rlca
		or		a, b
		rlca
		rlca
		or		a, b
		rlca
		rlca
		or		a, b
		ld		[mgsdrv_slot], a

		ld		a, [ramad1]
		and		a, 0x0C
		ld		b, a
		rlca
		rlca
		or		a, b
		rlca
		rlca
		or		a, b
		rlca
		rlca
		or		a, b
		ld		[mgsdrv_exp_slot], a

		; MGSDRV.COM を開く
		ld		de, s_mgsdrv_com
		call	open_file_on_path_env
		dec		a
		ret		nz						; エラーなら Zf = 0 にして抜ける

		; page1, page2 のセグメント番号をバックアップ
		call	mapper_get_p1
		ld		[backup_segment1], a
		call	mapper_get_p2
		ld		[backup_segment2], a

		; page1, page2 を MGSDRV のセグメントに切り替える
		ld		a, [mgs_id_drvseg]
		call	mapper_put_p1
		ld		a, [mgs_id_datseg]
		call	mapper_put_p2

		; MGSDRV.COM を読み込む
		ld			c, D2F_READ
		ld			a, [file_handle]
		ld			b, a
		ld			de, 0x6000 - 0x000D		; load address
		ld			hl, 0x200D				; size
		call		safe_bdos
		or			a, a
		ret			nz

		; ファイルを閉じる
		ld			c, D2F_CLOSE
		ld			a, [file_handle]
		ld			b, a
		call		safe_bdos

		; MGSDRVを初期化する
		call		mgs_sysck
		ld			[mgs_id_mgsver], hl
		ld			[mgs_id_mibadr], ix
		ld			[mgs_id_trwadr], iy
		ld			[mgs_id_trwsiz], bc

		; H.TIMI割り込みをフックする
	mgsdrv_h_timi_rel := 0xC000
		di
		ld			de, old_h_timi
		ld			hl, h_timi
		ld			bc, 5
		ldir

		ld			de, mgsdrv_h_timi_rel
		ld			hl, mgsdrv_h_timi
		ld			bc, mgsdrv_h_timi_end - mgsdrv_h_timi
		ldir

		ld			a, 0xC3				; JP xxxx 命令
		ld			[h_timi], a
		ld			hl, mgsdrv_h_timi_rel
		ld			[h_timi + 1], hl
		ei

		; マッパーを戻す
		ld			a, [backup_segment1]
		call		mapper_put_p1
		ld			a, [backup_segment2]
		call		mapper_put_p2
		xor			a, a
		ret

error_exit:
		xor			a, a
		inc			a						; Zf = 0 にして抜ける (エラー)
		ret

s_mgsdrv_com:
		ds		"MGSDRV.COM"
		db		0
		endscope

; ==============================================================================
;	term_mgsdrv
; ==============================================================================
		scope	term_mgsdrv
term_mgsdrv::
		di
		ld			de, h_timi
		ld			hl, old_h_timi
		ld			bc, 5
		ldir
		ei
		ret
		endscope

; ==============================================================================
;	MGSDRVのトラックワークをクリアする
; ==============================================================================
		scope		clear_mgsdrv_track_work
clear_mgsdrv_track_work::
		call		stop_song

		di
		ld			hl, [mgs_id_trwsiz]
		ld			c, l
		ld			b, h
		add			hl, hl
		add			hl, hl
		add			hl, hl
		add			hl, hl
		add			hl, bc
		ld			c, l
		ld			b, h
		ld			hl, [mgs_id_trwadr]
		ld			de, [mgs_id_trwadr]
		inc			de
		dec			bc
		xor			a, a
		ld			[hl], a
		ldir
		ei
		ret
		endscope

; ==============================================================================
;	スロット構成をMGSDRV用にする
; ==============================================================================
		scope		change_mgsdrv_slot
change_mgsdrv_slot::
		; change slot of page1 (mgsdrv body)
		ld			h, 0x40
		ld			a, [mgs_id_drvslt]
		call		enaslt

		; change slot of page2 (song data)
		ld			h, 0x80
		ld			a, [mgs_id_datslt]
		call		enaslt

		; change mapper segment of page1
		ld			a, [mgs_id_drvseg]
		call		mapper_put_p1

		; change mapper segment of page2
		ld			a, [mgs_id_datseg]
		call		mapper_put_p2
		ei
		ret
		endscope

; ==============================================================================
;	load_mgs_file
;	input)
;		de .... ファイル名のアドレス (ASCIIZ)
;	output)
;		Zf .... 0: 成功, 1: 失敗
; ==============================================================================
		scope		load_mgs_file
load_mgs_file::
		ld			[file_name_address], de
		ld			a, [de]
		or			a, a				; Zf = 0:成功, 1:失敗
		ret			z					; 失敗なら抜ける

		call		stop_song

		; エラー変数をクリアする
		xor			a, a
		ld			[error_status], a
		; open the file
		ld			c, D2F_OPEN
		ld			a, 1				; Disable write access
		ld			de, [file_name_address]
		call		safe_bdos
		ld			a, b
		ld			[file_handle], a
		jp			nz, error_exit

		; read the file
		ld			c, D2F_READ
		ld			de, mgs_song_data
		ld			hl, mgs_song_size
		call		safe_bdos

		; close the file
		ld			c, D2F_CLOSE
		ld			a, [file_handle]
		ld			b, a
		call		safe_bdos

		; エラーなら抜ける
		ld			a, [error_status]
		or			a, a
		jp			nz, error_exit

		; check song data
		ld			hl, 0x8000
		call		mgs_datck
		jp			nz, error_exit

		; clear song Title area
		ld			hl, (256 + 32) * 8
		ld			bc, 32 * 8
		xor			a, a
		ld			ix, FILVRM
		ld			iy, [exptbl - 1]
		call		CALSLT
		xor			a, a
		inc			a					; Zf = 0:成功
		ret
error_exit:
		ld			a, 1
		ld			[error_status], a
		xor			a, a				; Zf = 1:失敗
		ret
		endscope

; ==============================================================================
;	ファイルパスからファイル名（拡張子含まず）をコピーする
;	input)
;		hl .... ファイルパスのアドレス (ASCIIZ)
;		de .... コピー先アドレス (9byte)
;	output)
;		--
;	break)
;		af, bc, de, hl
; ==============================================================================
		scope		copy_file_name
copy_file_name::
		; 最後のパスセパレータ \ を見つける
		ld			c, l
		ld			b, h
search_sep:
		ld			a, [hl]
		inc			hl
		or			a, a
		jr			z, exit_search_sep
		cp			a, '\\'
		jr			nz, search_sep
		jr			copy_file_name

exit_search_sep:
		ld			l, c
		ld			h, b
		ld			b, 8
copy_loop:
		ld			a, [hl]
		inc			hl
		or			a, a
		jr			z, exit_copy_loop
		cp			a, '.'
		jr			z, exit_copy_loop
		ld			[de], a
		inc			de
		djnz		copy_loop
exit_copy_loop:
		xor			a, a
		ld			[de], a
		ret
		endscope

; ==============================================================================
;	曲を再生する
;	output)
;		Zf .... 0: 失敗, 1: 成功
; ==============================================================================
		scope		play_song
play_song::
		call		stop_song

		; check song data
		ld			hl, 0x8000
		call		mgs_datck
		ret			nz

		; song start
		ld			b, -1
		ld			hl, -1
		ld			de, 0x8000
		call		mgs_plyst
		ei
		xor			a, a
		ret
		endscope

; ==============================================================================
;	曲を停止する
; ==============================================================================
		scope		stop_song
stop_song::
		; song stop
		call		change_mgsdrv_slot
		call		mgs_initm
		ret
		endscope

; ==============================================================================
;	割り込み処理ルーチン ( 0xC000～ に転送して使う )
; ==============================================================================
		scope		mgsdrv_h_timi
mgsdrv_h_timi::
		ld			a, [ 0xFFFF ]		; 拡張スロット番号 (page3 はすでにプライマリマッパスロット)
		cpl								; 読み出し結果は反転してるので戻す
		ld			h, a				; 復元用バックアップ
	mgsdrv_exp_slot	:= $ + 1
		ld			a, 0				; page0～3 を プライマリマッパスロット(TPA)へ
		ld			[ 0xFFFF ], a		; 拡張スロット変更

		in			a, [ 0xA8 ]			; 基本スロット番号
		ld			l, a				; 復元用バックアップ
	mgsdrv_slot		:= $ + 1
		ld			a, 0				; page0～3 を プライマリマッパスロット(TPA)へ
		out			[ 0xA8 ], a			; 基本スロット変更

		push		hl					; 復元用バックアップをスタックへ保存

		; page1, page2 のセグメント番号をバックアップ
		call		mapper_get_p1
		ld			b, a
		call		mapper_get_p2
		ld			c, a
		push		bc					; マッパーメモリのセグメント番号(page1, page2)を保存

		; page1, page2 を MGSDRV のセグメントに切り替える
		ld			a, [mgs_id_drvseg]
		call		mapper_put_p1
		ld			a, [mgs_id_datseg]
		call		mapper_put_p2

		; MGSP内で利用するカウンター
		ld			a, [timer_counter]
		inc			a
		ld			[timer_counter], a

		; CPU負荷表示
		ld			a, [show_cpu_load_time]
		or			a, a
		jr			z, skip_load_time1
		ld			a, 0x0C
		out			[ vdp_port1 ], a
		ld			a, 0x87
		out			[ vdp_port1 ], a
skip_load_time1:

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
		; CPU負荷表示
		ld			a, [show_cpu_load_time]
		or			a, a
		jr			z, skip_load_time2
		ld			a, 0x00
		out			[ vdp_port1 ], a
		ld			a, 0x87
		out			[ vdp_port1 ], a
skip_load_time2:

		; page1, page2 のマッパーメモリのセグメント番号を復元
		pop			bc
		ld			a, b
		call		mapper_put_p1
		ld			a, c
		call		mapper_put_p2

		; スロットを復元
		pop			hl
		ld			a, l
		out			[ 0xA8 ], a			; 基本スロットを元に戻す
		ld			a, h
		ld			[ 0xFFFF ], a		; 拡張スロットを元に戻す
old_h_timi::
		ret
		ret
		ret
		ret
		ret
mgsdrv_h_timi_end::
		endscope

; ==============================================================================
;	WORKAREA
; ==============================================================================
song_speed::
		dw		100		; 2byte: 1%...255% の範囲のみ有効
song_speed_counter::
		dw		0
backup_segment1::
		db		0
backup_segment2::
		db		0
show_cpu_load_time::
		db		0		; MGSDRVのCPU負荷の表示 0:OFF, 1:ON

file_name_address::
		dw		0
file_name_copy::
		db		0, 0, 0, 0, 0, 0, 0, 0, 0
file_handle::
		db		0

mgs_parameter_block::
mgs_id_drvslt::			; 1byte: MGSDRV本体のスロット情報
		db			0
mgs_id_drvseg::			; 1byte: MGSDRV本体のセグメント情報
		db			0
mgs_id_datslt::			; 1byte: 演奏データ領域のスロット情報
		db			0
mgs_id_datseg::			; 1byte: 演奏データ領域のセグメント情報
		db			0
mgs_id_mgsver::			; 2bytes: MGSDRVのバージョン
		dw			0
mgs_id_mibadr::			; 2bytes: MIBへのアドレス
		dw			0
mgs_id_trwadr::			; 2bytes: トラックワークのアドレス
		dw			0
mgs_id_trwsiz::			; 2bytes: トラックワークのサイズ
		dw			0
