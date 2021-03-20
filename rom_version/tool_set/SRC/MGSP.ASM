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
; ==============================================================================

; ==============================================================================
mgsp_body::
		call		file_init
		; サウンドチップの有無を右上に表示
		call		grp_sound_chip_indicator
		; レベルメーターを表示する
		call		grp_update_keyboard_spot
		; 音量表示更新
		ld			a, [master_volume]
		call		grp_update_master_volume
		; ループカウント表示
		xor			a, a
		ld			[s_number + 2], a
		ld			a, [loop_counter]
		call		grp_update_loop_count
		; ソートモード表示
		ld			a, [sort_mode]
		call		grp_update_sort_mode_info
		; 再生モード表示
		ld			a, [play_mode]
		call		grp_update_mode_info
		; ファイルリストを更新
		ld			a, 1
		call		grp_update_file_list
		call		mgsp_auto_start

; ==============================================================================
; メインループ
; ==============================================================================
		scope		mgsp_main_loop
main_loop:
		call		mgsp_common_proc
		call		mgsp_check_key
		jp			main_loop
		endscope

; ==============================================================================
; メインループの中のキー入力以外
; ==============================================================================
		scope		mgsp_common_proc
mgsp_common_proc::
		call		vsync_wait
		call		mgsp_check_song_change
		call		grp_update_keyboard_spot		; A に稼働中のトラック数が返る
		call		mgsp_check_song_stop

		; 曲名スクロール
		ld			a, [title_scroll_timer]
		dec			a
		ld			[title_scroll_timer], a
		or			a, a
		jp			nz, skip1

		call		update_title
		ld			a, title_scroll_wait
		ld			[title_scroll_timer], a
skip1:
		ret
		endscope

title_scroll_wait := 20

; ==============================================================================
; 1コマ待ち (30fps)
; ==============================================================================
		scope		vsync_wait
vsync_wait::
		ld			a, [timer_counter]
		cp			a, 2
		jr			c, vsync_wait
		xor			a, a
		ld			[timer_counter], a
		ret
		endscope

; ==============================================================================
; 動作モードを変更する
; ==============================================================================
		scope		change_mode
change_mode::
		ld			a, [play_mode]
		inc			a
		cp			a, 3
		jr			nz, skip1
		xor			a, a
skip1:
		ld			[play_mode], a
		jp			grp_update_mode_info
		endscope

; ==============================================================================
; 次の曲を再生
; ==============================================================================
		scope		start_next_song
start_next_song::
		call		clear_mgsdrv_track_work
		ld			b, fl_files

		; 動作モードを判別
		ld			a, [play_mode]
		or			a, a
		jp			z, normal_mode
		dec			a
		jp			z, random_mode
repeat_mode:
		ld			a, [playing_song_number]
		jr			check_and_play

random_mode:
		call		get_random			; b は保存される
adjust_random_max:
		cp			a, b
		jr			c, check_and_play
		sub			a, b
		jr			adjust_random_max

normal_mode:
		; 再生中の曲の次の番号を得る
		ld			a, [playing_song_number]
change_next:
		inc			a
		cp			a, b
		jp			c, check_and_play

		; 最後の曲だった場合は、最初へ戻る
		xor			a, a
check_and_play:
		ld			c, a
		call		get_current_file_entry
		ld			a, c
		call		play_new_song
		ret
		endscope

; ==============================================================================
; 前の曲を再生
; ==============================================================================
		scope		start_previous_song
start_previous_song::
		call		clear_mgsdrv_track_work
		ld			b, fl_files

		; 動作モードを判別
		ld			a, [play_mode]
		or			a, a
		jp			z, normal_mode
		dec			a
		jp			z, random_mode
repeat_mode:
		ld			a, [playing_song_number]
		jr			check_and_play

random_mode:
		call		get_random			; b は保存される
adjust_random_max:
		cp			a, b
		jr			c, check_and_play
		sub			a, b
		jr			adjust_random_max

normal_mode:
		; 再生中の曲の前の番号を得る
		ld			a, [playing_song_number]
change_previous:
		sub			a, 1
		jp			c, error_start_previous_song

check_and_play:
		ld			c, a
		call		get_current_file_entry
		ld			a, c
		call		play_new_song
		ret

error_start_previous_song::
		xor			a, a
		ld			[play_state], a
		ld			[playing_song_number], a
		ret
		endscope

; ==============================================================================
; 自動再生開始
; ==============================================================================
		scope		mgsp_auto_start
mgsp_auto_start::
		ld			a, PRM_AUTO_START
		or			a, a
		ret			z
		; Normalモードの場合、最初のファイルが再生されるように現在の曲番を -1 にしておく
		ld			a, -1
		ld			[playing_song_number], a	; -1 にする
		jp			start_next_song
		endscope

; ==============================================================================
; 演奏状態監視処理
; ==============================================================================
		scope		mgsp_check_song_change
mgsp_check_song_change::
		; 演奏終了チェック
		ld			a, [play_state]				; A = 0: 停止, 1: 次の曲再生待ち, 2: フェードアウト中, 3: 再生中
		or			a, a
		ret			z							; 停止中ならなにもしない
		dec			a
		jp			z, play_next_song			; 次の曲再生待ちなら次の曲を再生する
		dec			a
		jp			z, wait_fadeout				; フェードアウト中ならフェードアウト完了チェックへ

		; 演奏回数が loop_counter に達したか?
		ld			a, [play_mode]
		cp			a, 2						; repeat mode なら、loop回数チェックはしない
		ret			z
		ld			hl, [mgs_id_mibadr]
		ld			de, mgs_mib_loopct
		add			hl, de
		ld			a, [hl]
		ld			hl, loop_counter
		cp			a, [hl]
		ret			c							; 達していないなら何もしない
		call		start_fadeout
		ret
		; フェードアウト処理
wait_fadeout:
		ld			a, [fadeout_volume]
		ld			b, a
		ld			a, [fadeout_speed]
		add			a, b
		ld			[fadeout_volume], a
		jp			c, fadeout_end
		srl			a
		srl			a
		srl			a
		srl			a
		call		mgs_msvst
		ei
		ret
fadeout_end:
		; 次の曲の再生待ちへ遷移
		call		mgsp_stop_song
		ld			a, 1
		ld			[play_state], a
		ld			a, [master_volume]
		call		mgs_msvst
		ei
		ret

play_next_song:
		; 次の曲を再生
		call		start_next_song
		ret
		endscope

; ==============================================================================
; ヘルプを表示
; ==============================================================================
		scope		mgsp_show_help
mgsp_show_help::
		call		grp_unselect_playing_line
		call		grp_unselect_line
		call		grp_show_help
mgsp_show_messages::
		; スクロールバーを「スクロールしない」表示にする
		call		grp_hide_scroll_bar

		call		release_loop

main_loop:
		call		mgsp_common_proc

		; キー入力があれば通常に戻る
		call		check_key_press
		or			a, a
		jp			nz, exit_help
		jp			main_loop

exit_help:
		ld			a, 1
		ld			[grp_select_line_on], a
		call		grp_update_file_list

		; キー解放待ち
release_loop::
		call		mgsp_common_proc
		call		check_key_press
		or			a, a
		jp			nz, release_loop
		ret
		endscope

; ==============================================================================
; ライセンスを表示
; ==============================================================================
		scope		mgsp_show_license
mgsp_show_license::
		call		grp_unselect_playing_line
		call		grp_unselect_line
		call		grp_show_license
		jp			mgsp_show_messages
		endscope

; ==============================================================================
; 再生開始
; ==============================================================================
		scope		mgsp_play_song
mgsp_play_song::
		ld			a, [master_volume]
		call		mgs_msvst
		ei

		ld			a, 0xFF
		ld			h, a
		ld			l, a
		ld			[track_mute], hl
		ld			[track_mute + 2], a

		call		play_song
		ret
		endscope

; ==============================================================================
; 再生停止
; ==============================================================================
		scope		mgsp_stop_song
mgsp_stop_song::
		call		clear_mgsdrv_track_work
		call		grp_unselect_playing_line
		xor			a, a
		ld			[fadeout_volume], a
		ld			[play_state], a
		dec			a
		ld			[grp_play_file], a
		call		grp_playing_line
		call		grp_select_line
		ret
		endscope

; ==============================================================================
; 曲の再生が停止したかチェックする
; input)
;	A .... Number of active tracks
; ==============================================================================
		scope		mgsp_check_song_stop
mgsp_check_song_stop::
		or			a, a
		ret			nz					; 再生中のトラックが残っているので何もしない

		ld			a, [play_state]
		or			a, a
		ret			z					; そもそも再生していない状態なので何もしない

		; 次の曲を再生する状態に遷移する
		ld			a, 1
		ld			[play_state], a
		ret
		endscope

; ==============================================================================
; 乱数を得る
; ==============================================================================
		scope		get_random
get_random::
		ld			a, [random_seed1]
		rlca
		xor			a, 0x24
		ld			[random_seed1], a
		ld			d, a
		ld			a, [random_seed2]
		rrca
		xor			a, 0x41
		ld			[random_seed2], a
		xor			a, d
		add			a, 0x73
		ret
		endscope

; ==============================================================================
; ディレクトリエントリ順でソート
; ==============================================================================
		scope		sort_by_entry
sort_by_entry::
		call		fl_sort_normal

		ld			a, 1
		call		grp_update_file_list

		xor			a, a
		ld			[sort_mode], a
		call		grp_update_sort_mode_info
		ret
		endscope

; ==============================================================================
; 曲名でソート
; ==============================================================================
		scope		sort_by_title
sort_by_title::
		call		fl_sort_title

		ld			a, 1
		call		grp_update_file_list

		ld			a, 1
		ld			[sort_mode], a
		call		grp_update_sort_mode_info
		ret
		endscope

; ==============================================================================
; ファイル名順でソート
; ==============================================================================
		scope		sort_by_filename
sort_by_filename::
		call		fl_sort_filename

		ld			a, 1
		call		grp_update_file_list

		ld			a, 2
		ld			[sort_mode], a
		call		grp_update_sort_mode_info
		ret
		endscope

; ==============================================================================
; シャッフル
; ==============================================================================
		scope		sort_by_shuffle
sort_by_shuffle::
		call		fl_sort_shuffle

		ld			a, 1
		call		grp_update_file_list

		ld			a, 3
		ld			[sort_mode], a
		call		grp_update_sort_mode_info
		ret
		endscope

; ==============================================================================
; 曲名表示・ファイル名表示の切り替え
; ==============================================================================
		scope		toggle_file_list_mode
toggle_file_list_mode::
		ld			a, [grp_file_list_mode]
		xor			a, 1
		ld			[grp_file_list_mode], a

		ld			a, 1
		jp			grp_update_file_list
		endscope

; ==============================================================================
; フェードアウト開始
; ==============================================================================
		scope		start_fadeout
start_fadeout::
		ld			a, [play_state]
		cp			a, 3
		ret			nz
		ld			a, [master_volume]
		add			a, a
		add			a, a
		add			a, a
		add			a, a
		ld			[fadeout_volume], a
		ld			a, 2
		ld			[play_state], a
		ret
		endscope

; ==============================================================================
; 上へ移動
; ==============================================================================
		scope		up_select
up_select::
		ld			a, [grp_select_file]
		or			a, a
		ret			z						; すでに一番上なら何もしない
		dec			a
		ld			[grp_select_file], a
		xor			a, a
		jp			grp_update_file_list
		endscope

; ==============================================================================
; 下へ移動
; ==============================================================================
		scope		down_select
down_select::
		ld			b, fl_files
		ld			a, [grp_select_file]
		inc			a
		cp			a, b
		ret			nc						; すでに一番下なら何もしない
		ld			[grp_select_file], a
		xor			a, a
		jp			grp_update_file_list
		endscope

; ==============================================================================
; ページアップ
; ==============================================================================
		scope		left_select
left_select::
		ld			a, [grp_select_file]
		or			a, a
		ret			z						; すでに一番上なら何もしない
		sub			a, 9
		jr			nc, left_select_clip
		xor			a, a
left_select_clip:
		ld			[grp_select_file], a
		xor			a, a
		jp			grp_update_file_list
		endscope

; ==============================================================================
; ページダウン
; ==============================================================================
		scope		right_select
right_select::
		ld			b, fl_files
		ld			a, [grp_select_file]
		cp			a, b
		ret			z						; すでに一番下なら何もしない
		add			a, 9
		cp			a, b
		jr			c, right_select_clip
		ld			a, b
		dec			a
right_select_clip:
		ld			[grp_select_file], a
		xor			a, a
		jp			grp_update_file_list
		endscope

; ==============================================================================
; ページトップ
; ==============================================================================
		scope		minus_select
minus_select::
		ld			a, [grp_select_file]
		or			a, a
		ret			z						; すでに一番上なら何もしない
		xor			a, a
		ld			[grp_select_file], a
		jp			grp_update_file_list
		endscope

; ==============================================================================
; ページボトム
; ==============================================================================
		scope		plus_select
plus_select::
		ld			b, fl_files
		ld			a, [grp_select_file]
		cp			a, b
		ret			z						; すでに一番下なら何もしない
		ld			a, b
		dec			a
		ld			[grp_select_file], a
		xor			a, a
		jp			grp_update_file_list
		endscope

; ==============================================================================
;	ループカウント減少
; ==============================================================================
		scope		loop_down
loop_down::
		ld			a, [loop_counter]
		dec			a
		ret			z						; すでに 1 なら何もしない
		ld			[loop_counter], a
		jp			grp_update_loop_count
		endscope

; ==============================================================================
;	ループカウント減少
; ==============================================================================
		scope		loop_up
loop_up::
		ld			a, [loop_counter]
		inc			a
		cp			a, 65
		ret			z						; すでに 64 なら何もしない
		ld			[loop_counter], a
		jp			grp_update_loop_count
		endscope

; ==============================================================================
;	マスター音量 増加
; ==============================================================================
		scope		master_volume_up
master_volume_up::
		ld			a, [master_volume]
		dec			a
		ret			m
		ld			[master_volume], a
		call		grp_update_master_volume
		ld			a, [master_volume]
		call		mgs_msvst
		ei
		ret
		endscope

; ==============================================================================
;	マスター音量 減少
; ==============================================================================
		scope		master_volume_down
master_volume_down::
		ld			a, [master_volume]
		inc			a
		cp			a, 16
		ret			nc
		ld			[master_volume], a
		call		grp_update_master_volume
		ld			a, [master_volume]
		call		mgs_msvst
		ei
		ret
		endscope

; ==============================================================================
;	再生速度変更 (速度リセット)
; ==============================================================================
		scope		mgsp_speed_reset
mgsp_speed_reset::
		ld			a, 100
		ld			[song_speed], a
		jp			grp_update_speed
		endscope

; ==============================================================================
;	再生速度変更
; ==============================================================================
		scope		mgsp_speed_change
mgsp_speed_change::
		ld			b, a
		ld			a, [song_speed]
		add			a, b
		cp			a, 200
		jp			c, skip1
		ld			a, 200
		jp			skip2
skip1:
		cp			a, 20
		jp			nc, skip2
		ld			a, 20
skip2:
		ld			[song_speed], a
		jp			grp_update_speed
		endscope

; ==============================================================================
;	トラックミュート (Lパート)
; ==============================================================================
		scope		mgsp_track_mute_l
mgsp_track_mute_l::
		ld			hl, [track_mute]
		xor			a, l
		ld			l, a
		ld			[track_mute], hl
		ld			a, [track_mute + 2]
		ld			b, a
		ld			c, 2
		jp			mgs_tmst1
		endscope

; ==============================================================================
;	トラックミュート (Hパート)
; ==============================================================================
		scope		mgsp_track_mute_h
mgsp_track_mute_h::
		ld			hl, [track_mute]
		xor			a, h
		ld			h, a
		ld			[track_mute], hl
		ld			a, [track_mute + 2]
		ld			b, a
		ld			c, 2
		jp			mgs_tmst1
		endscope

; ==============================================================================
;	トラックミュート (Bパート)
; ==============================================================================
		scope		mgsp_track_mute_b
mgsp_track_mute_b::
		ld			b, a
		ld			hl, [track_mute]
		ld			a, [track_mute + 2]
		xor			a, b
		ld			b, a
		ld			[track_mute + 2], a
		ld			c, 2
		jp			mgs_tmst1
		endscope

; ==============================================================================
;	選択中の曲データを再生する
; ==============================================================================
		scope		play_current_song
play_current_song::
		ld			a, [grp_select_file]
play_new_song::
		push		af
		call		grp_unselect_playing_line
		pop			af
		ld			c, a
		ld			[grp_play_file], a
		call		get_current_file_entry

		ld			a, c
		ld			[playing_song_number], a

		call		load_mgs_file_and_show_title
		ret			nz
		call		mgsp_play_song
		; 演奏状態に変更
		ld			a, 3
		ld			[play_state], a
		xor			a, a
		call		grp_update_file_list
		ret

mgsp_update_file_list_all::
		; カーソルを一番上に変更
		xor			a, a
		ld			[grp_select_file], a
		ld			[playing_song_number], a
		; 再生中の強調表示は非表示に変更
		dec			a
		ld			[grp_play_file], a

		; 表示を更新
		dec			a
		ld			[grp_top_file], a
		xor			a, a
		call		grp_update_file_list
		ret
		endscope

; ==============================================================================
;	ファイルを読み込んでタイトル表示を更新する
;	input)
;		hl .... ファイルエントリのアドレス
;	output)
;		Zf .... 1: 成功, 0: 失敗
; ==============================================================================
		scope		load_mgs_file_and_show_title
load_mgs_file_and_show_title::
		ld			[file_name_address], hl
		call		load_mgs_file
		ret			nz							; Zf = 0: 失敗

		; clear song Title area
		xor			a, a
		ld			[file_name_copy + 8], a
		ld			[target_file_name_position], a
		ld			hl, (256 + 32) * 8
		ld			bc, 32 * 8
		call		FILVRM

		; draw song Title
		ld			hl, mgs_song_title
		ld			de, target_file_name
		ld			bc, target_file_name_end - target_file_name
		ldir									; page2 にある曲データのタイトルを page0 にコピーする

		call		update_title

		; copy file name
		ld			hl, [file_name_address]
		ld			de, file_name_copy
		ld			bc, 8
		ldir

		; clear file name area
		ld			hl, 251 * 8
		ld			bc, 4 * 8
		xor			a, a
		call		FILVRM

		; draw file name
		ld			hl, 251 * 8
		ld			de, file_name_copy
		call		draw_string

		xor			a, a					; Zf = 1: 成功
		ret
		endscope

; ==============================================================================
;	タイトル表示を更新する
;	input)
;		--
;	output)
;		--
; ==============================================================================
		scope		update_title
update_title::
		ld			a, [target_file_name_position]
		ld			e, a
		ld			d, 0
		ld			hl, target_file_name
		add			hl, de
		ex			de, hl
		ld			hl, (256 + 32) * 8
		push		de
		call		draw_string					; page2 を漢字RAMとして利用する
		pop			de

		or			a, a
		jp			z, skip1

		ld			a, [de]
		call		issjis1st
		ld			a, [target_file_name_position]
		jr			nc, skip2
		inc			a
skip2:
		inc			a
skip1:
		ld			[target_file_name_position], a
		ret
		endscope

; ==============================================================================
;	Aに入ってる値を16進数文字列に変換して、[HL]に格納
; ==============================================================================
		scope		dec_to_hex
dec_to_hex::
		ld			b, a
		rrca
		rrca
		rrca
		rrca
		and			a, 0x0F
		add			a, '0'
		cp			a, '9' + 1
		jr			c, skip1
		add			a, 'A' - '0' - 10
skip1:
		ld			[hl], a
		inc			hl
		ld			a, b
		and			a, 0x0F
		add			a, '0'
		cp			a, '9' + 1
		jr			c, skip2
		add			a, 'A' - '0' - 10
skip2:
		ld			[hl], a
		inc			hl
		ret
		endscope

; ==============================================================================
;	DATA AREA
; ==============================================================================
cliksw_backup::
		db			0
track_mute::
		db			0xFF, 0xFF, 0xFF			; L, H, B : BHLで下位から 17bit が有効。1=ON, 0=MUTE
title_scroll_timer::
		db			title_scroll_wait

random_seed1::
		db			0xa3
random_seed2::
		db			0x5b
sort_mode::
		db			PRM_SORT_MODE		; ソートモード 0: Entry, 1: Title, 2: File name, 3: Shuffle
play_mode::
		db			PRM_PLAY_MODE		; 動作モード 0: Normal, 1: Random, 2: Repeat
playing_song_number::
		db			0					; 再生中の曲のファイル番号
play_state::
		db			0					; 0: 停止, 1: 次の曲再生待ち, 2: フェードアウト中, 3: 再生中
fadeout_volume::
		db			0
fadeout_speed::
		db			1					; 1: slow speed ... 128: high speed
loop_counter::
		db			PRM_LOOP_COUNTER
master_volume::
		db			PRM_MASTER_VOLUME	; 0: Max, 15: Min
target_file_name_position::
		db			0					; 曲名スクロール表示の位置

		include	"MGSDRVCTL.ASM";
		include	"KEYINPUT.ASM";
		include	"FILE_ACCESS.ASM"
		include	"GRAPHIC.ASM"
		include	"GRAPHIC_DATA.ASM"
		include	"STRING.ASM"

		if $ >= 0x6000
			error "OUT OF MEMORY (" + $ + ")"
		else
			message "MGSP SIZE CHECK OK (" + $ + ")"
		endif
