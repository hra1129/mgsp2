; ==============================================================================
;   MGSP
;
;  Copyright (C) 2020 Takayuki Hara (HRA!)
;  All rights reserved.
;                           http://hraroom.s602.xrea.com/msx/software/mgsp.html
;
;  �{�\�t�g�E�F�A����і{�\�t�g�E�F�A�Ɋ�Â��č쐬���ꂽ�h�����́A�ȉ��̏�����
;  �������ꍇ�Ɍ���A�ĔЕz����юg�p��������܂��B
;
;  1.�\�[�X�R�[�h�`���ōĔЕz����ꍇ�A��L�̒��쌠�\���A�{�����ꗗ�A����щ��L
;    �Ɛӏ��������̂܂܂̌`�ŕێ����邱�ƁB
;  2.�o�C�i���`���ōĔЕz����ꍇ�A�Еz���ɕt���̃h�L�������g���̎����ɁA��L��
;    ���쌠�\���A�{�����ꗗ�A����щ��L�Ɛӏ������܂߂邱�ƁB
;  3.���ʂɂ�鎖�O�̋��Ȃ��ɁA�{�\�t�g�E�F�A��̔��A����я��ƓI�Ȑ��i�⊈��
;    �Ɏg�p���Ȃ����ƁB
;
;  �{�\�t�g�E�F�A�́A���쌠�҂ɂ���āu����̂܂܁v�񋟂���Ă��܂��B���쌠�҂́A
;  ����ړI�ւ̓K�����̕ۏ؁A���i���̕ۏ؁A�܂�����Ɍ��肳��Ȃ��A�����Ȃ閾��
;  �I�������͈ÖقȕۏؐӔC�������܂���B���쌠�҂́A���R�̂�������킸�A���Q
;  �����̌�����������킸�A���ӔC�̍������_��ł��邩���i�ӔC�ł��邩�i�ߎ�
;  ���̑��́j�s�@�s�ׂł��邩���킸�A���ɂ��̂悤�ȑ��Q����������\����m��
;  ����Ă����Ƃ��Ă��A�{�\�t�g�E�F�A�̎g�p�ɂ���Ĕ��������i��֕i�܂��͑�p�T
;  �[�r�X�̒��B�A�g�p�̑r���A�f�[�^�̑r���A���v�̑r���A�Ɩ��̒��f���܂߁A�܂���
;  ��Ɍ��肳��Ȃ��j���ڑ��Q�A�Ԑڑ��Q�A�����I�ȑ��Q�A���ʑ��Q�A�����I���Q�A��
;  ���͌��ʑ��Q�ɂ��āA��ؐӔC�𕉂�Ȃ����̂Ƃ��܂��B
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
		include	"MSXBIOS.ASM"
		include	"MSXDOS1.ASM"
		include	"MSXDOS2.ASM"
		include	"MGSDRV_API.ASM"

		org		0x100
; ==============================================================================
entry::
		ld			sp, [TPA_BOTTOM]
		call		mgsp_init
		call		mgsp_auto_start

; ==============================================================================
; ���C�����[�v
; ==============================================================================
		scope		mgsp_main_loop
main_loop:
		call		mgsp_common_proc
		call		mgsp_check_key
		jp			main_loop
		endscope

; ==============================================================================
; ���C�����[�v�̒��̃L�[���͈ȊO
; ==============================================================================
		scope		mgsp_common_proc
mgsp_common_proc::
		call		change_mgsdrv_slot
		call		vsync_wait
		call		mgsp_check_song_change
		call		grp_update_keyboard_spot		; A �ɉғ����̃g���b�N�����Ԃ�
		call		mgsp_check_song_stop

		; fl_remain_no_read_titles ����ʂɕ\������
		ld			a, [fl_remain_no_read_titles]	; 00 �łȂ���Ζ������ɕ\�������֔��
		or			a, a
		jr			nz, skip3

		ld			hl, [s_words]					; �O��̕\���� "00" �Ȃ�`�揈�����X�L�b�v����
		ld			a, l
		or			a, h
		cp			a, '0'
		jr			z, skip2

skip3:
		ld			a, [fl_remain_no_read_titles]	; 16�i���ɕϊ�����
		ld			hl, s_words
		call		dec_to_hex

		ld			hl, [s_words]					; "00" ���ǂ������ׂ�
		ld			a, l
		or			a, h
		cp			a, '0'
		jr			nz, skip4
		ld			hl, 0x2020						; "00" �Ȃ� "  " �ɒu��
		ld			[s_words], hl
skip4:
		ld			hl, 216 * 8
		ld			de, s_words
		call		draw_string
skip2:

		; �Ȗ��X�N���[��
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

s_words:
		ds			"00"
		db			0
		endscope

title_scroll_wait := 20

; ==============================================================================
; 1�R�}�҂� (30fps)
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
; �W���o�͂Ƀo�[�W�������b�Z�[�W��\������
; ==============================================================================
		scope		show_version_message
show_version_message::
		ld			de, mgsp_name
		call		puts
		ld			de, msg_ret
		call		puts
		ld			de, mgsp_copyright
		call		puts
		ld			de, msg_ret
		jp			puts
		endscope

; ==============================================================================
; ���샂�[�h��ύX����
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
; ���̋Ȃ��Đ�
; ==============================================================================
		scope		start_next_song
start_next_song::
		call		clear_mgsdrv_track_work
		; �Đ��\�ȃt�@�C�����P�����݂��Ȃ��ꍇ�͉������Ȃ�
		ld			a, [fl_song_files]
		or			a, a
		jp			z, error_start_next_song
		ld			a, [fl_files]
		ld			b, a

		; ���샂�[�h�𔻕�
		ld			a, [play_mode]
		or			a, a
		jp			z, normal_mode
		dec			a
		jp			z, random_mode
repeat_mode:
		ld			a, [playing_song_number]
		jr			check_and_play

random_mode:
		call		get_random			; b �͕ۑ������
adjust_random_max:
		cp			a, b
		jr			c, check_and_play
		sub			a, b
		jr			adjust_random_max

normal_mode:
		; �Đ����̋Ȃ̎��̔ԍ��𓾂�
		ld			a, [playing_song_number]
change_next:
		inc			a
		cp			a, b
		jp			c, check_and_play

		; �Ō�̋Ȃ������ꍇ�́A�ŏ��֖߂�
		xor			a, a
check_and_play:
		; �f�B���N�g����?
		ld			c, a
		call		get_current_file_entry
		ld			de, 13
		add			hl, de
		ld			a, [hl]
		and			a, FIB_ATTR_DIRECTORY
		ld			a, c
		jr			nz, change_next
		call		play_new_song
		ret

error_start_next_song::
		xor			a, a
		ld			[play_state], a
		ld			[playing_song_number], a
		ret
		endscope

; ==============================================================================
; �O�̋Ȃ��Đ�
; ==============================================================================
		scope		start_previous_song
start_previous_song::
		call		clear_mgsdrv_track_work
		; �t�@�C�����P�����݂��Ȃ��ꍇ�͉������Ȃ�
		ld			a, [fl_files]
		or			a, a
		jp			z, error_start_previous_song
		ld			b, a

		; ���샂�[�h�𔻕�
		ld			a, [play_mode]
		or			a, a
		jp			z, normal_mode
		dec			a
		jp			z, random_mode
repeat_mode:
		ld			a, [playing_song_number]
		jr			check_and_play

random_mode:
		call		get_random			; b �͕ۑ������
adjust_random_max:
		cp			a, b
		jr			c, check_and_play
		sub			a, b
		jr			adjust_random_max

normal_mode:
		; �Đ����̋Ȃ̑O�̔ԍ��𓾂�
		ld			a, [playing_song_number]
change_previous:
		sub			a, 1
		jp			c, error_start_previous_song

check_and_play:
		; �f�B���N�g����?
		ld			c, a
		call		get_current_file_entry
		ld			de, 13
		add			hl, de
		ld			a, [hl]
		and			a, FIB_ATTR_DIRECTORY
		ld			a, c
		jr			nz, change_previous
		call		play_new_song
		ret

error_start_previous_song::
		xor			a, a
		ld			[play_state], a
		ld			[playing_song_number], a
		ret
		endscope

; ==============================================================================
; ����������
; ==============================================================================
		scope		mgsp_init
mgsp_init::
		; Key Click Sound S/W OFF
		ld			a, [cliksw]
		ld			[cliksw_backup], a

		; Show version information
		call		show_version_message

		; Initialize MemoryMapper
		call		mmap_init
		ld			de, msg_error_mmap_not_found
		jp			z, g_dos1_error_exit

		; check installed MGSDRV
		call		init_mgsdrv
		ld			de, msg_error_mgsdrv_not_found
		jp			nz, g_error_exit

		; show MGSDRV version
		call		change_mgsdrv_slot
		ld			de, msg_detect
		call		puts

		ld			a, [mgs_id_mgsver + 1]
		ld			hl, msg_1byte_hex
		call		dec_to_hex

		ld			de, msg_1byte_hex + 1
		call		puts

		ld			c, D1F_CONOUT
		ld			e, '.'
		call		bdos

		ld			a, [mgs_id_mgsver]
		ld			hl, msg_1byte_hex
		call		dec_to_hex

		ld			de, msg_1byte_hex
		call		puts

		ld			de, msg_ret
		call		puts

		; show OPLL slot number
		ld			de, msg_opll_slot_num
		call		puts
		ld			ix, [mgs_id_mibadr]
		ld			a, [ix + 0]
		call		put_slot_num
		ld			de, msg_ret
		call		puts

		; show SCC slot number
		ld			de, msg_scc_slot_num
		call		puts
		ld			ix, [mgs_id_mibadr]
		ld			a, [ix + 1]
		call		put_slot_num
		ld			de, msg_ret
		call		puts

		; check command line options
		call		check_options

		; �������� GUI�N���m��

		; initialize kanji driver
		call		kanji_init
		or			a, a
		jr			z, kanji_init_no_error

		push		af
		call		term_mgsdrv					; �G���[�����Ȃ̂ŁAH.TIMI�̉���Ȃǌ�n���B
		pop			af
		ld			de, msg_not_enough_memory
		dec			a
		jp			z, g_error_exit

		ld			de, msg_cannot_read_kfont
		jp			g_error_exit
kanji_init_no_error:

		call		load_ini_file

		; �v�����[�h�E�F�C�g��������
		ld			a, [preload_wait]
		ld			[preload_wait_count], a

		; MSX1 �̏ꍇ�AINI�t�@�C���� LOAD_TIME �͖����ɂ���
		ld			a, [exptbl]
		ld			hl, 0x002D					; MSX1=0, MSX2=1, MSX2+=2, MSXtR=3
		call		rdslt

		or			a, a
		jr			nz, skip_disable_load_time
		ld			[show_cpu_load_time], a		; MSX1 �ł͖����ɂ���
skip_disable_load_time:

		; �L�[�N���b�N�� OFF
		xor			a, a
		ld			[cliksw], a

		call		change_mgsdrv_slot
		call		clear_mgsdrv_track_work
		call		file_init
		call		grp_theme_color_change
		call		grp_init
		ld			a, [master_volume]
		call		grp_update_master_volume
		ld			a, [loop_counter]
		call		grp_update_loop_count
		ld			a, [sort_mode]
		call		grp_update_sort_mode_info
		ld			a, [play_mode]
		call		grp_update_mode_info
		call		change_mgsdrv_slot

		xor			a, a
		ld			[mgs_song_title], a

		call		fl_update_entries
		ld			a, 1
		call		grp_update_file_list
		ret
		endscope

; ==============================================================================
; �����Đ��J�n
; ==============================================================================
		scope		mgsp_auto_start
mgsp_auto_start::
		ld			a, [option_p]
		or			a, a
		ret			z

		call		preload_before_playback
		; Normal���[�h�̏ꍇ�A�ŏ��̃t�@�C�����Đ������悤�Ɍ��݂̋ȔԂ� -1 �ɂ��Ă���
		ld			a, [play_mode]
		or			a, a
		jr			nz, skip1
		dec			a
		ld			[playing_song_number], a	; -1 �ɂ���
skip1:
		call		start_next_song
		ret
		endscope

; ==============================================================================
; ���t��ԊĎ�����
; ==============================================================================
		scope		mgsp_check_song_change
mgsp_check_song_change::
		; ���t�I���`�F�b�N
		ld			a, [play_state]				; A = 0: ��~, 1: ���̋ȍĐ��҂�, 2: �t�F�[�h�A�E�g��, 3: �Đ���
		or			a, a
		jp			z, preload					; ��~���Ȃ�Ȗ��v�����[�h
		dec			a
		jp			z, play_next_song			; ���̋ȍĐ��҂��Ȃ玟�̋Ȃ��Đ�����
		dec			a
		jp			z, wait_fadeout				; �t�F�[�h�A�E�g���Ȃ�t�F�[�h�A�E�g�����`�F�b�N��
		; �Đ����̃v�����[�h��������Ă��邩�H
		ld			a, [playing_preload_en]			; ���`�F�b�N
		or			a, a
		jp			z, check_loop_counter
		ld			a, [fl_remain_no_read_titles]	; ���łɃv�����[�h���K�v�Ȃ����`�F�b�N
		or			a, a
		jp			z, check_loop_counter
		ld			a, [preload_wait_count]			; �v�����[�h�J�n�ҋ@�����H
		or			a, a
		jp			z, do_preload1
		dec			a
		ld			[preload_wait_count], a
		jp			check_loop_counter
do_preload1:
		call		preload_song_title
		call		change_mgsdrv_slot
check_loop_counter:
		; ���t�񐔂� loop_counter �ɒB������?
		ld			a, [play_mode]
		cp			a, 2						; repeat mode �Ȃ�Aloop�񐔃`�F�b�N�͂��Ȃ�
		ret			z
		ld			hl, [mgs_id_mibadr]
		ld			de, mgs_mib_loopct
		add			hl, de
		ld			a, [hl]
		ld			hl, loop_counter
		cp			a, [hl]
		ret			c							; �B���Ă��Ȃ��Ȃ牽�����Ȃ�
		call		start_fadeout
		ret
		; �t�F�[�h�A�E�g����
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
		; ���̋Ȃ̍Đ��҂��֑J��
		call		mgsp_stop_song
		ld			a, 1
		ld			[play_state], a
		ld			a, [master_volume]
		call		mgs_msvst
		ei
		ret

play_next_song:
		; ���̋Ȃ��Đ�
		ld			a, [error_status]
		or			a, a
		ret			nz
		call		preload_song_title			; ���łɃv�����[�h
		call		preload_song_title			; ���łɃv�����[�h
		call		preload_song_title			; ���łɃv�����[�h
		call		start_next_song
		ret

preload:
		ld			a, [preload_wait_count]			; �v�����[�h�J�n�ҋ@�����H
		or			a, a
		jp			z, do_preload2
		dec			a
		ld			[preload_wait_count], a
		ret
do_preload2:
		call		preload_song_title			; ���łɃv�����[�h
		ret
		endscope

; ==============================================================================
; �Đ��J�n���O�̃v�����[�h��ʔ��s
; ==============================================================================
		scope		preload_before_playback
preload_before_playback::
		; �v�����[�h���s�񐔂� 0 �Ȃ牽�����Ȃ��Ŕ�����
		ld			a, [preload_try_count]
preload_page_change::
		or			a, a
		ret			z

		; ���s�񐔂����J��Ԃ�
		ld			b, a
		push		bc
		call		grp_begin_progress_bar
		pop			bc
loop:
		; ���łɃv�����[�h���s�v�ȏ�ԂȂ甲����
		ld			a, [fl_remain_no_read_titles]
		or			a, a
		jp			z, skip

		push		bc
		call		preload_song_title
		call		grp_update_progress_bar
		pop			bc
		djnz		loop
skip:
		call		grp_end_progress_bar
		ret
		endscope

; ==============================================================================
; �h���C�u�ύX
; input)
;	a .... Driver number (0=A:, 1=B:, ... 7=H:)
; ==============================================================================
		scope		mgsp_drive_change
mgsp_drive_change::
		push		af
		call		mgsp_stop_song		; ���t���̋Ȃ��~
		pop			af

		call		change_current_drive
		push		af

		xor			a, a
		ld			[play_state], a		; ��~��ԂɕύX

		call		grp_update_current_drive
		call		grp_update_error_indicator
		pop			af
		ret			z

		call		grp_unselect_playing_line
		call		mgsp_update_file_list_all
		ret
		endscope

; ==============================================================================
; �I���_�C�A���O��\��
; ==============================================================================
		scope		mgsp_show_exit_dialog
mgsp_show_exit_dialog::
		call		grp_unselect_playing_line
		call		grp_unselect_line
		call		grp_show_exit_dialog

		; �X�N���[���o�[���u�X�N���[�����Ȃ��v�\���ɂ���
		ld			a, [fl_files]
		ld			[fl_files_restore], a
		xor			a, a
		ld			[fl_files], a
		call		grp_update_scroll_bar

		; A�{�^������҂�
		call		release_loop

main_loop:
		call		mgsp_common_proc

		; �L�[����
		call		check_key_press
		or			a, a
		jp			z, skip_key_input
		ld			b, a

		; ����L�[�Ȃ� exit_exit_dialog ��
		and			a, 0b0000_0001
		jp			nz, exit_exit_dialog

		; �L�����Z���L�[�Ȃ� return_mgsp ��
		ld			a, b
		and			a, 0b0000_1000
		jp			nz, return_mgsp

		; ����ȊO�Ȃ�I��ύX
		ld			a, [grp_yes_no]
		xor			a, 1
		ld			[grp_yes_no], a
		call		grp_update_exit_dialog_cursor
		call		release_loop
skip_key_input:
		jp			main_loop

exit_exit_dialog:
		ld			a, [grp_yes_no]
		or			a, a
		jp			z, exit_main_loop			; YES �Ȃ�I����

return_mgsp:
		ld			a, 3
		call		grp_clear_line
		ld			a, 4
		call		grp_clear_line
		ld			a, 5
		call		grp_clear_line
		ld			a, 6
		call		grp_clear_line

fl_files_restore	= $ + 1
		ld			a, 0						; ���ȏ����� fl_files �̓K�؂Ȓl������
		ld			[fl_files], a

		ld			a, 1
		ld			[grp_select_line_on], a
		call		grp_update_file_list
		call		change_mgsdrv_slot
		call		release_loop
		ret
		endscope

; ==============================================================================
; �w���v��\��
; ==============================================================================
		scope		mgsp_show_help
mgsp_show_help::
		call		grp_unselect_playing_line
		call		grp_unselect_line
		call		grp_show_help

		; �X�N���[���o�[���u�X�N���[�����Ȃ��v�\���ɂ���
		ld			a, [fl_files]
		ld			[fl_files_restore], a
		xor			a, a
		ld			[fl_files], a
		call		grp_update_scroll_bar

		call		release_loop

main_loop:
		call		mgsp_common_proc

		; �L�[���͂�����Βʏ�ɖ߂�
		call		check_key_press
		or			a, a
		jp			nz, exit_help
		jp			main_loop

exit_help:
fl_files_restore	= $ + 1
		ld			a, 0						; ���ȏ����� fl_files �̓K�؂Ȓl������
		ld			[fl_files], a

		ld			a, 1
		ld			[grp_select_line_on], a
		call		grp_update_file_list
		call		change_mgsdrv_slot

		; �L�[����҂�
release_loop::
		call		mgsp_common_proc
		call		check_key_press
		or			a, a
		jp			nz, release_loop
		ret
		endscope

; ==============================================================================
; �Đ��J�n
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
; �Đ���~
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
; �Ȃ̍Đ�����~�������`�F�b�N����
; input)
;	A .... Number of active tracks
; ==============================================================================
		scope		mgsp_check_song_stop
mgsp_check_song_stop::
		or			a, a
		ret			nz					; �Đ����̃g���b�N���c���Ă���̂ŉ������Ȃ�

		ld			a, [play_state]
		or			a, a
		ret			z					; ���������Đ����Ă��Ȃ���ԂȂ̂ŉ������Ȃ�

		; ���̋Ȃ��Đ������ԂɑJ�ڂ���
		ld			a, 1
		ld			[play_state], a
		ret
		endscope

; ==============================================================================
; �����𓾂�
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
; �f�B���N�g���G���g�����Ń\�[�g
; ==============================================================================
		scope		sort_by_entry
sort_by_entry::
		call		fl_sort_normal

		ld			a, 1
		call		grp_update_file_list
		call		change_mgsdrv_slot

		xor			a, a
		ld			[sort_mode], a
		call		grp_update_sort_mode_info
		ret
		endscope

; ==============================================================================
; �Ȗ��Ń\�[�g
; ==============================================================================
		scope		sort_by_title
sort_by_title::
		call		fl_sort_title

		ld			a, 1
		call		grp_update_file_list
		call		change_mgsdrv_slot

		ld			a, 1
		ld			[sort_mode], a
		call		grp_update_sort_mode_info
		ret
		endscope

; ==============================================================================
; �t�@�C�������Ń\�[�g
; ==============================================================================
		scope		sort_by_filename
sort_by_filename::
		call		fl_sort_filename

		ld			a, 1
		call		grp_update_file_list
		call		change_mgsdrv_slot

		ld			a, 2
		ld			[sort_mode], a
		call		grp_update_sort_mode_info
		ret
		endscope

; ==============================================================================
; �V���b�t��
; ==============================================================================
		scope		sort_by_shuffle
sort_by_shuffle::
		call		fl_sort_shuffle

		ld			a, 1
		call		grp_update_file_list
		call		change_mgsdrv_slot

		ld			a, 3
		ld			[sort_mode], a
		call		grp_update_sort_mode_info
		ret
		endscope

; ==============================================================================
; �Ȗ��\���E�t�@�C�����\���̐؂�ւ�
; ==============================================================================
		scope		toggle_file_list_mode
toggle_file_list_mode::
		ld			a, [grp_file_list_mode]
		xor			a, 1
		ld			[grp_file_list_mode], a

		ld			a, 1
		call		grp_update_file_list
		call		change_mgsdrv_slot
		ret
		endscope

; ==============================================================================
; �t�F�[�h�A�E�g�J�n
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
; ��ֈړ�
; ==============================================================================
		scope		up_select
up_select::
		ld			a, [grp_select_file]
		or			a, a
		ret			z						; ���łɈ�ԏ�Ȃ牽�����Ȃ�
		dec			a
		ld			[grp_select_file], a
		xor			a, a
		call		grp_update_file_list
		call		change_mgsdrv_slot
		ret
		endscope

; ==============================================================================
; ���ֈړ�
; ==============================================================================
		scope		down_select
down_select::
		ld			a, [fl_files]
		ld			b, a
		ld			a, [grp_select_file]
		inc			a
		cp			a, b
		ret			nc						; ���łɈ�ԉ��Ȃ牽�����Ȃ�
		ld			[grp_select_file], a
		xor			a, a
		call		grp_update_file_list
		call		change_mgsdrv_slot
		ret
		endscope

; ==============================================================================
; �y�[�W�A�b�v
; ==============================================================================
		scope		left_select
left_select::
		ld			a, [preload_try_count_for_page_change]
		call		preload_page_change
		ld			a, [grp_select_file]
		or			a, a
		ret			z						; ���łɈ�ԏ�Ȃ牽�����Ȃ�
		sub			a, 9
		jr			nc, left_select_clip
		xor			a, a
left_select_clip:
		ld			[grp_select_file], a
		xor			a, a
		call		grp_update_file_list
		call		change_mgsdrv_slot
		ret
		endscope

; ==============================================================================
; �y�[�W�_�E��
; ==============================================================================
		scope		right_select
right_select::
		ld			a, [preload_try_count_for_page_change]
		call		preload_page_change
		ld			a, [fl_files]
		ld			b, a
		ld			a, [grp_select_file]
		cp			a, b
		ret			z						; ���łɈ�ԉ��Ȃ牽�����Ȃ�
		add			a, 9
		cp			a, b
		jr			c, right_select_clip
		ld			a, b
		dec			a
right_select_clip:
		ld			[grp_select_file], a
		xor			a, a
		call		grp_update_file_list
		call		change_mgsdrv_slot
		ret
		endscope

; ==============================================================================
; �y�[�W�g�b�v
; ==============================================================================
		scope		minus_select
minus_select::
		ld			a, [grp_select_file]
		or			a, a
		ret			z						; ���łɈ�ԏ�Ȃ牽�����Ȃ�
		xor			a, a
		ld			[grp_select_file], a
		call		grp_update_file_list
		call		change_mgsdrv_slot
		ret
		endscope

; ==============================================================================
; �y�[�W�{�g��
; ==============================================================================
		scope		plus_select
plus_select::
		ld			a, [fl_files]
		ld			b, a
		ld			a, [grp_select_file]
		cp			a, b
		ret			z						; ���łɈ�ԉ��Ȃ牽�����Ȃ�
		ld			a, b
		dec			a
		ld			[grp_select_file], a
		xor			a, a
		call		grp_update_file_list
		call		change_mgsdrv_slot
		ret
		endscope

; ==============================================================================
; �I������
; ==============================================================================
		scope		exit_main_loop
exit_main_loop::
		ei
		call		mgsp_stop_song
		call		term_mgsdrv
		call		grp_term
		call		file_term
exit_command_line::
		call		mmap_change_to_tpa

		; �L�[�o�b�t�@���N���A
		ld			ix, kilbuf
		ld			iy, [exptbl - 1]
		call		CALSLT

		; �L�[�N���b�N�X�C�b�`�𕜌�
		ld			a, [cliksw_backup]
		ld			[cliksw], a

		ld			b, 0
		ld			c, D2F_TERM
		jp			bdos
		endscope

; ==============================================================================
;	���[�v�J�E���g����
; ==============================================================================
		scope		loop_down
loop_down::
		ld			a, [loop_counter]
		dec			a
		ret			z						; ���ł� 1 �Ȃ牽�����Ȃ�
		ld			[loop_counter], a
		call		grp_update_loop_count
		jp			change_mgsdrv_slot
		endscope

; ==============================================================================
;	���[�v�J�E���g����
; ==============================================================================
		scope		loop_up
loop_up::
		ld			a, [loop_counter]
		inc			a
		cp			a, 65
		ret			z						; ���ł� 64 �Ȃ牽�����Ȃ�
		ld			[loop_counter], a
		call		grp_update_loop_count
		jp			change_mgsdrv_slot
		endscope

; ==============================================================================
;	�}�X�^�[���� ����
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
;	�}�X�^�[���� ����
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
;	�Đ����x�ύX (���x���Z�b�g)
; ==============================================================================
		scope		mgsp_speed_reset
mgsp_speed_reset::
		ld			a, 100
		ld			[song_speed], a
		jp			grp_update_speed
		endscope

; ==============================================================================
;	�Đ����x�ύX
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
;	�g���b�N�~���[�g (L�p�[�g)
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
;	�g���b�N�~���[�g (H�p�[�g)
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
;	�g���b�N�~���[�g (B�p�[�g)
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
;	�G���[�I��
; ==============================================================================
		scope		g_error_exit
g_error_exit::
		ei
		push		de
		call		mmap_change_to_tpa
		pop			de

		call		puts

		ld			b, 1
		ld			c, D2F_TERM
		jp			bdos
		endscope

; ==============================================================================
;	�G���[�I��
; ==============================================================================
		scope		g_dos1_error_exit
g_dos1_error_exit::
		push		de

		; change slot of page1
		ld			h, 0x40
		ld			a, [ramad1]
		call		enaslt

		; change slot of page2
		ld			h, 0x80
		ld			a, [ramad2]
		call		enaslt
		ei

		pop			de
		call		puts

		ld			c, D1F_TERM0		; MemoryMapper��������MSX-DOS1�Ȃ̂ŁADOS1�t�@���N�V�����R�[���Ŕ�����
		jp			bdos
		endscope

; ==============================================================================
; �e�f�B���N�g���ֈړ�����
; ==============================================================================
		scope		goto_parent_dir
goto_parent_dir::
		ld			ix, parent_dir
		jp			enter_directory
parent_dir:
		ds			".."
		db			0
		endscope

; ==============================================================================
;	�I�𒆂̋ȃf�[�^���Đ�����
; ==============================================================================
		scope		play_current_song
play_current_song::
		call		preload_before_playback
		ld			a, [grp_select_file]
play_new_song::
		push		af
		call		grp_unselect_playing_line
		pop			af
		ld			c, a
		ld			[grp_play_file], a
		call		get_current_file_entry
		ret			z							; �t�@�C�����������
		push		hl
		pop			ix
		ld			a, [ix + 13]
		and			a, FIB_ATTR_DIRECTORY
		jp			nz, enter_directory

		ld			a, c
		ld			[playing_song_number], a

		ex			de, hl
		push		de
		call		change_mgsdrv_slot
		pop			de
		call		load_mgs_file_and_show_title
		ret			z
		call		mgsp_play_song
		; ���t��ԂɕύX
		ld			a, 3
		ld			[play_state], a
		xor			a, a
		call		grp_update_file_list
		ret

enter_directory::
		push		ix
		call		mgsp_stop_song
		xor			a, a
		ld			[play_state], a
		pop			de
		call		change_directory

mgsp_update_file_list_all::
		; �t�@�C�����X�g���X�V
		call		fl_update_entries

		; �J�[�\������ԏ�ɕύX
		xor			a, a
		ld			[grp_select_file], a
		ld			[playing_song_number], a
		; �Đ����̋����\���͔�\���ɕύX
		dec			a
		ld			[grp_play_file], a

		; �\�����X�V
		dec			a
		ld			[grp_top_file], a
		xor			a, a
		call		grp_update_file_list
		ret
		endscope

; ==============================================================================
;	�R�}���h���C���I�v�V�����𒲂ׂ�
;	input)
;		[dma] .... Command line parameter
; ==============================================================================
		scope		check_options
check_options::
		ld			hl, dma + 1
		ld			b, 127				; max length of dma
skip_white_space:
		call		get_upper_one
		ret			z
		cp			a, ' '
		jr			z, skip_white_space

		cp			a, '/'				; this is a option?
		jp			z, skip_white_space

		cp			a, 'P'
		jr			nz, skip_white_space
		ld			a, 1
		ld			[option_p], a
		jp			skip_white_space
		endscope

		scope		get_one
get_one::
		ld			a, b
		or			a, a
		ret			z
		ld			a, [hl]
		inc			hl
		dec			b
		or			a, a
		ret
		endscope

		scope		get_upper_one
get_upper_one::
		call		get_one
		ret			z
		cp			a, 'a'
		ret			c
		cp			a, 'z' + 1
		ret			nc
		add			a, 'A' - 'a'
		ret
		endscope

; ==============================================================================
;	�t�@�C����ǂݍ���Ń^�C�g���\�����X�V����
;	input)
;		de .... �t�@�C�����̃A�h���X (ASCIIZ)
;	output)
;		Zf .... 0: ����, 1: ���s
; ==============================================================================
		scope		load_mgs_file_and_show_title
load_mgs_file_and_show_title::
		call		load_mgs_file
		push		af
		call		grp_update_error_indicator
		pop			af
		ret			z

		; clear song Title area
		ld			hl, (256 + 32) * 8
		ld			bc, 32 * 8
		xor			a, a
		ld			ix, FILVRM
		ld			iy, [exptbl - 1]
		call		CALSLT

		; draw song Title
		call		change_mgsdrv_slot
		ld			hl, mgs_song_title
		ld			de, target_file_name
		ld			bc, target_file_name_end - target_file_name
		ldir									; page2 �ɂ���ȃf�[�^�̃^�C�g���� page0 �ɃR�s�[����

		xor			a, a
		ld			[target_file_name_position], a
		call		update_title

		; copy file name
		ld			hl, [file_name_address]
		ld			de, file_name_copy
		call		copy_file_name

		; clear file name area
		ld			hl, 251 * 8
		ld			bc, 4 * 8
		xor			a, a
		ld			ix, FILVRM
		ld			iy, [exptbl - 1]
		call		CALSLT

		; draw file name
		ld			hl, 251 * 8
		ld			de, file_name_copy
		call		draw_string

		call		change_mgsdrv_slot
		xor			a, a
		inc			a					; Zf = 0:����
		ret
		endscope

; ==============================================================================
;	�^�C�g���\�����X�V����
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
		call		draw_string					; page2 ������RAM�Ƃ��ė��p����
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
;	A�ɓ����Ă�l��16�i��������ɕϊ����āA[HL]�Ɋi�[
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
;	A�ɓ����Ă���X���b�g�ԍ���\������
; ==============================================================================
		scope		put_slot_num
put_slot_num::
		ld			[save_slot], a
		inc			a
		jr			z, put_none
		dec			a
		and			a, 3
		add			a, '0'
		ld			e, a
		ld			c, D1F_CONOUT
		call		bdos
		ld			a, [save_slot]
		or			a, a
		ret			p

		ld			e, '-'
		ld			c, D1F_CONOUT
		call		bdos

		ld			a, [save_slot]
		rrca
		rrca
		and			a, 3
		add			a, '0'
		ld			e, a
		ld			c, D1F_CONOUT
		call		bdos
		ret
put_none:
		ld			de, msg_none
		call		puts
		ret

save_slot:
		db			0
		endscope

; ==============================================================================
;	DATA AREA
; ==============================================================================
cliksw_backup::
		db			0
track_mute::
		db			0xFF, 0xFF, 0xFF			; L, H, B : BHL�ŉ��ʂ��� 17bit ���L���B1=ON, 0=MUTE
timer_counter::
		db			0
title_scroll_timer::
		db			title_scroll_wait

preload_try_count::
		db			5
preload_try_count_for_page_change::
		db			15
preload_wait::
		db			90
preload_wait_count::
		db			0
playing_preload_en::
		db			0
random_seed1::
		db			0xa3
random_seed2::
		db			0x5b
sort_mode::
		db			0			; �\�[�g���[�h 0: Entry, 1: Title, 2: File name, 3: Shuffle
play_mode::
		db			0			; ���샂�[�h 0: Normal, 1: Random, 2: Repeat
playing_song_number::
		db			0			; �Đ����̋Ȃ̃t�@�C���ԍ�
play_state::
		db			0			; 0: ��~, 1: ���̋ȍĐ��҂�, 2: �t�F�[�h�A�E�g��, 3: �Đ���
fadeout_volume::
		db			0
fadeout_speed::
		db			1			; 1: slow speed ... 128: high speed
loop_counter::
		db			1
master_volume::
		db			0			; 0: Max, 15: Min
target_file_name_position::
		db			0
target_file_name::
		db			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
target_file_name_end::
		db			0, 0

option_p:
		db			0

		include	"MGSDRVCTL.ASM";
		include	"KEYINPUT.ASM";
		include	"FILE_ACCESS.ASM"
		include	"STRING.ASM"
		include	"STDIO.ASM"
		include	"MEMMAPPER.ASM"
		include	"KANJI.ASM"
		include	"GRAPHIC.ASM"
		include	"GRAPHIC_DATA.ASM"

; �������牺�́A���������݈̂ێ��BGUI�N����́A�Ȗ��o�b�t�@�Ƃ��ď㏑�������B
		include	"GRAPHIC_INIT_DATA.ASM"

msg_error_mmap_not_found::
		ds			"This is MSX-DOS1. Or MemoryMapperBIOS does not exist."
		db			0x0d, 0x0a, 0
msg_error_mgsdrv_not_found::
		ds			"Cannot read MGSDRV.COM."
msg_ret::
		db			0x0d, 0x0a, 0
msg_segment_error:
		ds			"Segment error."
		db			0x0d, 0x0a, 0
msg_cannot_read_kfont::
		ds			"Cannot read KFONT.BIN."
		db			0x0d, 0x0a, 0
msg_detect::
		ds			"Detect MGSDRV "
		db			0
msg_opll_slot_num::
		ds			"  OPLL SLOT #"
		db			0
msg_scc_slot_num::
		ds			"  SCC  SLOT #"
		db			0
msg_none::
		ds			"none"
		db			0
msg_1byte_hex::
		ds			"00"
		db			0
msg_not_enough_memory::
		ds			"Not enough memory."
		db			0x0d, 0x0a, 0

		include	"INIFILE.ASM"

		if ( 0x8000 - start_of_title_buffer ) < (63 * 192)
			error "OUT OF MEMORY (" + ( 0x8000 - start_of_title_buffer ) + ")"
		else
			message "MEMORY CHECK OK (" + ( 0x8000 - start_of_title_buffer ) + ")"
		endif

end_of_program::