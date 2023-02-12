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
		; カレントドライブを取得する
		ld			c, D1F_CURDRV
		call		bdos
		add			a, 'A'
		ld			[current_drive], a

		; 現在の 仮想ドライブ切り替えプロンプトフック を保存しておく
		di
		ld			a, [h_prompt]
		ld			[save_h_prompt_hook], a
		ld			hl, [h_prompt + 1]
		ld			[save_h_prompt_hook + 1], hl

		; 新しいフックに更新する
		ld			a, 0xC3			; JP
		ld			[h_prompt], a
		ld			hl, disk_change_prompt
		ld			[h_prompt + 1], hl
		ei
		ret
		endscope

; ==============================================================================
;	環境変数 PATH で指定されているパスの中にある指定のファイルを開く
; input)
;	de ....... ファイル名
; output)
;	a ........ 0: 失敗, 1: 成功
; ==============================================================================
		scope		open_file_on_path_env
open_file_on_path_env::
		ld		[s_file_name], de
		xor		a, a
		ld		[s_path_env_end - 1], a

		; 環境変数 "PATH" の内容を取得する
		ld		c, D2F_GENV
		ld		de, s_path_env
		ld		hl, s_path
		ld		b, s_path_env_end - s_path_env - 1
		call	safe_bdos
		or		a, a
		jp		z, no_blank
		; 環境変数 "PATH" が得られなかったら空っぽの扱い
		xor		a, a
		ld		[de], a
no_blank:
		ex		de, hl
		ld		de, s_file_name_work

		; 最初は "PATH" の内容にかかわらず、カレントディレクトリを調べる
		jp		skip_separator

		; 環境変数 "PATH" から順にパスを抽出する
open_check_loop:
		ld		de, s_file_name_work
		ld		b, 0
		ld		c, 1					; 1: last character is '\\', 0: others
transfer_path:
		ld		a, [hl]
		or		a, a
		jr		z, transfer_end
		inc		hl
		cp		a, ' '					; path separator ' '
		jr		z, transfer_end
		cp		a, '\t'					; path separator '\t'
		jr		z, transfer_end
		cp		a, ';'					; path separator ';'
		jr		z, transfer_end
		cp		a, '='					; path separator '='
		jr		z, transfer_end
		cp		a, ','					; path separator ','
		jr		z, transfer_end
		cp		a, ' ' + 1				; ignore control code and space
		jr		c, transfer_path
		cp		a, '\\'
		ld		c, 0					; 1: last character is '\\', 0: others
		jr		nz, skip1
		inc		c						; last character is '\\'
skip1:
		ld		[de], a
		inc		de
		inc		b
		jr		transfer_path
transfer_end:

		; 最後の文字が '\\' でなければ、末尾に \ を追加
		dec		c
		jr		z, skip_separator
		ld		a, '\\'
		ld		[de], a
		inc		de
skip_separator:
		; 続けてファイル名を追加
		push	hl
		ld		hl, [s_file_name]
		call	strcpy
		; 出来たパスのファイルを開く
		ld		c, D2F_OPEN
		ld		a, 1
		ld		de, s_file_name_work
		call	safe_bdos
		or		a, a
		pop		hl
		jr		z, success
		; 開けなかったので、"PATH" をすべて処理したか確認
		ld		a, [hl]
		or		a, a
		ret		z					; パスを全部処理し終えていて、ファイル開けない場合は失敗
		jp		open_check_loop

success:
		ld		a, b
		ld		[file_handle], a
		ld		a, 1
		ret

s_file_name:
		dw		0

s_crlf:
		db		0x0d, 0x0a, 0
s_path:
		ds		"PATH"
		db		0
		endscope

; ==============================================================================
;	ファイルアクセス関連の後始末
; ==============================================================================
		scope		file_term
file_term::
		; 元のフックを書き戻す
		di
		ld			hl, [save_h_prompt_hook]
		ld			[h_prompt], hl
		ld			a, [save_h_prompt_hook + 2]
		ld			[h_prompt + 2], a
		ei
		ret
		endscope

; ==============================================================================
;	ドライブチェンジのフックから呼ばれるルーチン
; ==============================================================================
		scope		disk_change_prompt
disk_change_prompt::
		ld			a, 1
		ld			[called_disk_change_prompt], a
		pop			af			; スタックを一レベル捨てる
		ret
		endscope

; ==============================================================================
;	ファイルアクセス関連の BDOSコール
; ==============================================================================
		scope		safe_bdos
safe_bdos::
		; ディスクエラー処理のポインタのポインタを更新
		push		hl
		ld			hl, [diskve]
		ld			[save_diskve], hl
		ld			hl, [0x0001]
		ld			[save_worm_boot], hl

		ld			hl, ptr_new_diskve
		ld			[diskve], hl
		ld			hl, restore_diskve
		ld			[0x0001], hl
		pop			hl

		ld			[save_sp_for_diskve], sp
		call		bdos

return_address:
		ld			hl, [save_diskve]
		ld			[diskve], hl
		ld			hl, [save_worm_boot]
		ld			[0x0001], hl
		ret

restore_diskve:
		ld			hl, [save_diskve]
		ld			[diskve], hl
		ld			hl, [save_worm_boot]
		ld			[0x0001], hl
		jp			0x0000

physical_error:
		ld			sp, [save_sp_for_diskve]
		ld			a, c
		ld			[error_status], a
		or			a, a
		jr			return_address

ptr_new_diskve:
		dw			physical_error
		endscope

; ==============================================================================
;	カレントディレクトリを変更する
;	input)
;		de ..... ディレクトリ名(ASCIIZ)
; ==============================================================================
		scope	change_directory
change_directory::
		ld			c, D2F_CHDIR
		call		safe_bdos
		ret
		endscope

; ==============================================================================
;	カレントドライブを変更する
;	input)
;		a .... target drive (A:=0, B:=1, ... ,H:=7)
;	output)
;		Zf ... 0: 成功, 1: 失敗
; ==============================================================================
		scope	change_current_drive
change_current_drive::
		ld			e, a
		xor			a, a
		ld			[called_disk_change_prompt], a
		ld			[error_status], a

		; カレントドライブ変更を試みる (存在しないドライブだと変更されない)
		ld			c, D1F_SELDSK
		call		safe_bdos
		; カレントドライブレターを取得する
		ld			c, D1F_CURDRV
		call		bdos
		ld			d, a
		push		de
		; アクセスを試みる
		ld			bc, (FIB_ATTR_DIRECTORY << 8) | D2F_FFIRST
		ld			de, search_name
		ld			ix, fl_fib
		call		safe_bdos
		; 仮想ディスクドライブのディスクチェンジが発生したか？
		pop			bc
		ld			a, [called_disk_change_prompt]
		or			a, a
		jp			nz, failed
		; ハードエラーが発生したか？
		ld			a, [error_status]
		or			a, a
		jp			nz, failed
		; 無事にドライブ変更できた
		ld			a, b
		add			a, 'A'						; Zf = 0
		ld			[current_drive], a
		ret

failed:
		; 指定のドライブが仮想ドライブだった場合、またはハードエラーが発生した場合、元に戻す
		xor			a, a
		ld			[error_status], a
		ld			a, [current_drive]
		sub			a, 'A'
		ld			e, a
		ld			c, D1F_SELDSK
		call		safe_bdos

		ld			bc, (FIB_ATTR_DIRECTORY << 8) | D2F_FFIRST
		ld			de, search_name
		ld			ix, fl_fib
		call		safe_bdos
		xor			a, a					; Zf = 1
		ret
		endscope

; ==============================================================================
;	fl_update_entries
; ==============================================================================
		scope		fl_update_entries
fl_update_entries::
		call		mmap_change_to_tpa				; set TPA slot on page1 and page2.
		call		grp_begin_progress_bar
		xor			a, a
		ld			[fl_files], a
		ld			[fl_song_files], a
		ld			[fl_preload_index], a
		ld			[fl_remain_no_read_titles], a
		ld			[error_status], a
		ld			hl, start_of_title_buffer
		ld			[fl_string_table_bottom], hl

		ld			[fl_current_index], a
		ld			[fl_fib + 1], a
		ld			hl, fl_fib + 1
		ld			de, fl_fib + 2
		ld			bc, 62
		ldir

		dec			a
		ld			[fl_fib], a

		; 最初のファイルを取得 
		ld			bc, (FIB_ATTR_DIRECTORY << 8) | D2F_FFIRST
		ld			de, search_name
		ld			ix, fl_fib
		call		safe_bdos
		or			a, a
		jr			nz, exit

		; ハードエラーが発生したか確認
		ld			a, [error_status]
		or			a, a
		jr			nz, exit

		ld			hl, fl_fib + FIB_FILENAME
		ld			de, fl_entry_table
		ld			bc, fl_entry_fib_size
		ldir

		ld			de, fl_entry_table
		call		reset_song_title
		ld			a, 0						; Cyフラグ保存
		jr			c, loop
		inc			a
loop:
		; 進捗を表示
		push		af
		push		de
		call		grp_update_progress_bar
		pop			de
		pop			af

		; 処理可能な最大数に到達したか？
		ld			[fl_files], a
		cp			a, fl_max_entries
		jr			z, exit

		; 2個目以降のファイルを取得
		push		de
		ld			c, D2F_FNEXT
		ld			ix, fl_fib
		call		safe_bdos
		pop			de
		or			a, a
		jr			nz, exit

		; ハードエラーが発生したか確認
		ld			a, [error_status]
		or			a, a
		jr			nz, exit

		ld			hl, fl_fib + FIB_FILENAME
		ld			bc, fl_entry_fib_size
		push		de
		ldir
		pop			de
		call		reset_song_title

		ld			a, [fl_files]
		jr			c, loop
		inc			a
		jr			loop

exit:
		call		grp_end_progress_bar

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
;	ファイルの曲名アドレス部分を初期化する
;	input)
;		de ... entry table
;	output)
;		de ... ディレクトリまたは MGSファイルなら次のエントリのアドレス
;		       関係ないファイルなら変更無し
;		Cy ... 0: 有効, 1: 無効
;	break)
;		af, bc
; ==============================================================================
		scope		reset_song_title
reset_song_title::
		push		hl
		push		de
		; fl_entry の中の 曲名アドレス(FENT_MGS_TITLE_ADDRESS) を 0 クリアする
		ld			hl, FENT_MGS_TITLE_ADDRESS
		add			hl, de
		xor			a, a
		ld			[hl], a
		inc			hl
		ld			[hl], a
		; アトリビュートチェック
		ld			de, (FIB_ATTRIBUTE - FIB_FILENAME) - FENT_MGS_TITLE_ADDRESS - 1
		add			hl, de
		ld			a, [hl]
		and			a, FIB_ATTR_DIRECTORY
		ld			a, 0
		jr			nz, success_exit			; ディレクトリなので何もしない
		; 拡張子チェック
		ld			de, FIB_FILENAME - FIB_ATTRIBUTE
		add			hl, de
search_dot:
		ld			a, [hl]
		or			a, a
		jr			z, ignore_exit				; 拡張子が無いので何もしない
		inc			hl
		cp			a, '.'
		jr			nz, search_dot
		ld			de, ext_mgs
		call		strcmpi
		jr			z, do_copy					; 拡張子が MGS なら、コピー処理へ
ignore_exit:
		pop			de
		pop			hl
		scf
		ret
success_exit:
		; インデックス処理
		ld			a, [fl_current_index]
		inc			a
		ld			[fl_current_index], a
		dec			a

		; FENT_MGS_ENTRY_INDEX を更新(Aの値にする)。
		pop			de
		ex			de, hl
		ld			de, FENT_MGS_ENTRY_INDEX
		add			hl, de
		ld			[hl], a
		; 次のエントリのアドレスを求める
		ld			de, fl_entry_size - FENT_MGS_ENTRY_INDEX
		add			hl, de
		ex			de, hl
		pop			hl
		or			a, a
		ret
do_copy:
		; copy song title
		pop			hl
		push		hl
		ld			de, FENT_MGS_TITLE_ADDRESS
		add			hl, de
		ld			a, 0xFF
		ld			[hl], a
		inc			hl
		ld			[hl], a							; 曲名格納アドレスを 0xFFFF(まだ読んでないフラグ) に更新

		; 残りの数を増やす
		ld			a, [fl_remain_no_read_titles]
		inc			a
		ld			[fl_remain_no_read_titles], a

		; 再生可能な曲ファイルの数を増やす
		ld			a, [fl_song_files]
		inc			a
		ld			[fl_song_files], a
		jr			success_exit
		endscope

; ==============================================================================
;	まだ読み込んでいない曲名があれば読み込みをトライする
;	input)
;		--
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope		preload_song_title
preload_song_title::
		; 残りが無ければ抜ける
		ld			a, [fl_remain_no_read_titles]
		or			a, a
		ret			z

		; ファイルが一つも無ければ抜ける
		ld			a, [fl_files]
		or			a, a
		ret			z

		; 調べる番号を得る
loop:
		ld			a, [fl_preload_index]
		call		get_current_file_entry

		ld			de, FENT_MGS_TITLE_ADDRESS
		add			hl, de
		ld			e, [hl]
		inc			hl
		ld			d, [hl]
		dec			hl

		; 曲名情報を調べる
		inc			de
		ld			a, e
		or			a, d
		dec			de
		jp			nz, exit_preload_song_title

		; 曲名情報を取得する
		ld			de, -FENT_MGS_TITLE_ADDRESS
		add			hl, de
		ex			de, hl
		call		get_mgs_song_title

exit_preload_song_title:
		; 次のインデックスにする
		ld			a, [fl_files]
		ld			b, a
		ld			a, [fl_preload_index]
		inc			a
		ld			[fl_preload_index], a
		cp			a, b
		ret			c
		xor			a, a
		ld			[fl_preload_index], a
		jp			loop
		endscope

; ==============================================================================
;	メモリを確保して指定のファイルの曲名を取得する
;	input)
;		de ... entry table
;	output)
;		de ... entry table (変更無し)
;		Cy ... 0: 有効, 1: 無効
;	break)
;		af, bc
; ==============================================================================
		scope		get_mgs_song_title
get_mgs_song_title::
		push		hl
		push		de
		; 残数を調査
		ld			a, [fl_remain_no_read_titles]
		or			a, a
		jp			z, success_exit		; 残数無ければ何もせずに抜ける。

		; fl_entry の中の 曲名アドレス(FENT_MGS_TITLE_ADDRESS) を調べる
		ld			hl, FENT_MGS_TITLE_ADDRESS
		add			hl, de
		ld			e, [hl]
		inc			hl
		ld			d, [hl]

		ld			a, e
		or			a, d
		jr			z, success_exit		; 0000h の場合、ディレクトリ。何もせずに抜ける。

		inc			de
		ld			a, e
		or			a, d
		dec			de
		jr			nz, success_exit	; FFFFh でない場合、すでに曲名を取得済みなので、何もせずに抜ける.

do_copy:
		; read buffer を事前に 0埋め
		xor			a, a
		ld			[error_status], a
		ld			[read_buffer], a
		ld			hl, read_buffer
		ld			de, read_buffer + 1
		ld			bc, 62 + 8
		ldir

		; open the file
		pop			de
		push		de
		ld			c, D2F_OPEN
		ld			a, 1						; Disable write access
		call		safe_bdos
		ld			a, b
		ld			[file_handle], a
		jp			nz, ignore_exit

		; ハードエラーが発生したか確認
		ld			a, [error_status]
		or			a, a
		jr			nz, ignore_exit

		; read the file
		ld			c, D2F_READ
		ld			de, read_buffer
		ld			hl, 62 + 8
		call		safe_bdos

		; ハードエラーが発生したか確認
		ld			a, [error_status]
		or			a, a
		jr			nz, ignore_exit

		; close the file
		ld			c, D2F_CLOSE
		ld			a, [file_handle]
		ld			b, a
		call		safe_bdos

		; ハードエラーが発生したか確認
		ld			a, [error_status]
		or			a, a
		jr			nz, ignore_exit

		; copy song title
		pop			hl
		push		hl
		ld			de, FENT_MGS_TITLE_ADDRESS
		add			hl, de
		ld			de, [fl_string_table_bottom]
		ld			[hl], e
		inc			hl
		ld			[hl], d							; 曲名格納アドレスを更新

		ld			hl, read_buffer + 8
		call		strlen							; deは破壊しない。bc に文字列長
		inc			bc								; 端末文字もコピーするので +1

		ld			hl, read_buffer + 8
		ldir
		ld			[fl_string_table_bottom], de

		; 残数を減らす
		ld			a, [fl_remain_no_read_titles]
		dec			a
		ld			[fl_remain_no_read_titles], a

success_exit:
		pop			de
		pop			hl
		or			a, a
		ret
ignore_exit:
		pop			de
		pop			hl
		scf
		ret
		endscope

; ==============================================================================
;	get_current_file_entry
;	input)
;		a ................... 対象のファイルの番号 (一覧表の中の何番目か)
;	output)
;		Zf .................. 1: ファイルが無い(HL無効), 0: 通常
;		hl .................. 指定のファイルのファイルのエントリアドレス
;	break)
;		bc以外すべて
; ==============================================================================
		scope	get_current_file_entry
get_current_file_entry::
		push	bc
		push	af
		call	mmap_change_to_tpa
		pop		af
		pop		bc
get_current_file_entry_wo_chgslot::
		ld		l, a
		ld		h, 0
		ld		a, [fl_files]
		or		a, a
		ret		z
		; fl_entry_size = 25 = 8 * (2 + 1) + 1
		ld		a, l					; a = file number
		add		hl, hl					; +-- hl = file_number * 8
		add		hl, hl					; |
		add		hl, hl					; |
		ld		e, l					;   +-- de = file_number * 8
		ld		d, h					;   |
		add		hl, hl					;      hl = file_number * 16
		add		hl, de					;      hl = file_number * 16 + file_number * 8
		ld		e, a					;      +-- hl = file_number * 16 + file_number * 8 + file_number = file_number * 25
		ld		d, 0					;      |
		add		hl, de					;      |
		ld		de, fl_entry_table
		add		hl, de					; 絶対0 にはならないので、Zf = 0
		ret
		endscope

; ==============================================================================
;	fl_swap_entry
;	input)
;		a .... 1st target entry
;		b .... 2nd target entry
;	comment)
;		swap_cbr_address に HL, DE の２レジスタが示す entry を入れ替える判定ルーチン
;		のアドレスを書き込んでおくこと
; ==============================================================================
		scope	fl_swap_entry
fl_swap_entry::
		; get 1st target entry address (A)
		push	bc
		call	get_current_file_entry_wo_chgslot

		; get 2nd target entry address (B)
		pop		af
		push	hl
		call	get_current_file_entry_wo_chgslot
		pop		de
		push	de
		push	hl

		; このエントリをスワップするか判定する
swap_cbr_address	:= code_address + 1
		call	cbr_compare_normal
		pop		hl
		pop		de
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
		push	hl
		push	de

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
		push	hl
		push	de

		; 曲名が読まれていなければ読み込む
		call	get_mgs_song_title
		ex		de, hl
		call	get_mgs_song_title

		pop		ix		; 2つ目
		pop		iy		; 1つ目
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2つ目の ENTRY_INDEX][1つ目の ENTRY_INDEX]
		push	bc
		ld		b, [ix + FENT_MGS_ATTRIBUTE]
		ld		c, [iy + FENT_MGS_ATTRIBUTE]			; BC = [2つ目の ATTRIBUTE][1つ目の ATTRIBUTE]
		ld		e, [ix + FENT_MGS_TITLE_ADDRESS + 0]
		ld		d, [ix + FENT_MGS_TITLE_ADDRESS + 1]
		ld		l, [iy + FENT_MGS_TITLE_ADDRESS + 0]
		ld		h, [iy + FENT_MGS_TITLE_ADDRESS + 1]
cbr_compare_common::			; ※ここは他のソートからも呼ばれる
		; ATTRIBUTEチェック: 1つ目はディレクトリか？
		ld		a, c
		and		a, FIB_ATTR_DIRECTORY
		jp		nz, check_dir

		; ATTRIBUTEチェック: 2つ目はディレクトリか？
		ld		a, b
		and		a, FIB_ATTR_DIRECTORY
		pop		bc
		scf
		ret		nz				; 1つ目が曲で、2つ目がディレクトリなら必ず入れ替える

		; strcmp( hl, de ) の結果で入れ替え判定
		call	strcmp
		ret

check_dir:
		; ATTRIBUTEチェック: 2つ目はディレクトリか？
		ld		a, b
		and		a, FIB_ATTR_DIRECTORY
		pop		bc
		ret		z				; 2つ目がディレクトリでないなら交換対象外 (Cy=0)

		ld		a, b			; 両方ディレクトリなので、エントリ順でソート
		cp		a, c
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
		push	hl
		push	de
		pop		ix		; 2つ目
		pop		iy		; 1つ目
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2つ目の ENTRY_INDEX][1つ目の ENTRY_INDEX]
		push	bc
		ld		b, [ix + FENT_MGS_ATTRIBUTE]
		ld		c, [iy + FENT_MGS_ATTRIBUTE]			; BC = [2つ目の ATTRIBUTE][1つ目の ATTRIBUTE]
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
		push	bc
		ld		b, [ix + FENT_MGS_ATTRIBUTE]
		ld		c, [iy + FENT_MGS_ATTRIBUTE]			; BC = [2つ目の ATTRIBUTE][1つ目の ATTRIBUTE]

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
		ld		a, [fl_files]
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
		ld		a, [fl_files]
		cp		a, c
		jr		nz, loop2

		pop		bc
		; 着目エントリを次へ遷移
		inc		b
		inc		c
		ld		a, [fl_files]
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
		call	mmap_change_to_tpa
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
		call	mmap_change_to_tpa
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
		call	mmap_change_to_tpa
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
		call	mmap_change_to_tpa
		ld		hl, cbr_compare_shuffle
		ld		[swap_cbr_address], hl
		call	fl_buble_sort
		ret
		endscope

; ==============================================================================
;	Work area
; ==============================================================================
called_disk_change_prompt::
		db			0			; ドライブチェンジが呼ばれたら 1 になる
save_h_prompt_hook::
		db			0, 0, 0
error_status::
		db			0
save_diskve::
		dw			0
save_worm_boot::
		dw			0
save_sp_for_diskve::
		dw			0
current_drive::
		db			0, 0		; カレントドライブ名 'A'～'H': 2byte目は ASCIIZの端末文字
search_name::
		ds		"*.*"
		db		0
ext_mgs::
		ds		"MGS"
		db		0
fl_fib::
		db		0xFF
		ds		" " * 63
read_buffer::
		ds		" " * (62 + 8 + 1)
fl_files::
		db		0				; リストに格納されているエントリの数
fl_song_files::
		db		0				; リストの中の MGSファイルの数
fl_remain_no_read_titles::
		db		0				; リスト内のファイルで、まだ曲名データが読み込まれていないデータの残数
fl_preload_index::
		db		0				; fl_remain_no_read_titles != 0 の場合に暇になると、こっそり調べる番号
fl_current_index::
		db		0				; fl_entry +24 を決めるためのワークエリア
fl_string_table_bottom::
		dw		0				; 文字列格納領域の終了アドレス

s_path_env:
		db		0,0,0,0,0,0,0,0		; +0
		db		0,0,0,0,0,0,0,0		; +1
		db		0,0,0,0,0,0,0,0		; +2
		db		0,0,0,0,0,0,0,0		; +3
		db		0,0,0,0,0,0,0,0		; +4
		db		0,0,0,0,0,0,0,0		; +5
		db		0,0,0,0,0,0,0,0		; +6
		db		0,0,0,0,0,0,0,0		; +7
		db		0,0,0,0,0,0,0,0		; +8
		db		0,0,0,0,0,0,0,0		; +9
		db		0,0,0,0,0,0,0,0		; +10
		db		0,0,0,0,0,0,0,0		; +11
		db		0,0,0,0,0,0,0,0		; +12
		db		0,0,0,0,0,0,0,0		; +13
		db		0,0,0,0,0,0,0,0		; +14
		db		0,0,0,0,0,0,0,0		; +15
		db		0,0,0,0,0,0,0,0		; +16
		db		0,0,0,0,0,0,0,0		; +17
		db		0,0,0,0,0,0,0,0		; +18
		db		0,0,0,0,0,0,0,0		; +19
		db		0,0,0,0,0,0,0,0		; +20
		db		0,0,0,0,0,0,0,0		; +21
		db		0,0,0,0,0,0,0,0		; +22
		db		0,0,0,0,0,0,0,0		; +23
		db		0,0,0,0,0,0,0,0		; +24
		db		0,0,0,0,0,0,0,0		; +25
		db		0,0,0,0,0,0,0,0		; +26
		db		0,0,0,0,0,0,0,0		; +27
		db		0,0,0,0,0,0,0,0		; +28
		db		0,0,0,0,0,0,0,0		; +29
		db		0,0,0,0,0,0,0,0		; +30
s_path_env_end:

s_file_name_work:
		db		0,0,0,0,0,0,0,0		; +0
		db		0,0,0,0,0,0,0,0		; +1
		db		0,0,0,0,0,0,0,0		; +2
		db		0,0,0,0,0,0,0,0		; +3
		db		0,0,0,0,0,0,0,0		; +4
		db		0,0,0,0,0,0,0,0		; +5
		db		0,0,0,0,0,0,0,0		; +6
		db		0,0,0,0,0,0,0,0		; +7
		db		0,0,0,0,0,0,0,0		; +8
		db		0,0,0,0,0,0,0,0		; +9
		db		0,0,0,0,0,0,0,0		; +10
		db		0,0,0,0,0,0,0,0		; +11
		db		0,0,0,0,0,0,0,0		; +12
		db		0,0,0,0,0,0,0,0		; +13
		db		0,0,0,0,0,0,0,0		; +14
		db		0,0,0,0,0,0,0,0		; +15
		db		0,0,0,0,0,0,0,0		; +16
		db		0,0,0,0,0,0,0,0		; +17
		db		0,0,0,0,0,0,0,0		; +18
		db		0,0,0,0,0,0,0,0		; +19
		db		0,0,0,0,0,0,0,0		; +20
		db		0,0,0,0,0,0,0,0		; +21
		db		0,0,0,0,0,0,0,0		; +22
		db		0,0,0,0,0,0,0,0		; +23
		db		0,0,0,0,0,0,0,0		; +24
		db		0,0,0,0,0,0,0,0		; +25
		db		0,0,0,0,0,0,0,0		; +26
		db		0,0,0,0,0,0,0,0		; +27
		db		0,0,0,0,0,0,0,0		; +28
		db		0,0,0,0,0,0,0,0		; +29
		db		0,0,0,0,0,0,0,0		; +30
s_file_name_work_end:

fl_entry_size			:= 25
fl_entry_fib_size		:= 22	; fl_entry の中の FIBコピー部分のサイズ
FENT_MGS_ATTRIBUTE		:= 13
FENT_MGS_TITLE_ADDRESS	:= 22
FENT_MGS_ENTRY_INDEX	:= 24

fl_entry	macro				; 24bytes
		ds		" " * 13		; +0, 13bytes: file name (ASCIIZ)
		db		0				; +13, 1byte: attribute
		dw		0				; +14, 2bytes: last update time
		dw		0				; +16, 2bytes: last update data
		dw		0, 0			; +18, 4bytes: file size
		dw		0				; +22, 2bytes: MGS song title address. FFFFh: no read, 0000h: not found the title, others: the title address
		db		0				; +24, 1byte: Directory entry index
			endm

fl_entry_table::
		repeat	i,fl_max_entries
		fl_entry
		endr
