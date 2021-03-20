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

; ==============================================================================
mgsp_body::
		call		file_init
		; �T�E���h�`�b�v�̗L�����E��ɕ\��
		call		grp_sound_chip_indicator
		; ���x�����[�^�[��\������
		call		grp_update_keyboard_spot
		; ���ʕ\���X�V
		ld			a, [master_volume]
		call		grp_update_master_volume
		; ���[�v�J�E���g�\��
		xor			a, a
		ld			[s_number + 2], a
		ld			a, [loop_counter]
		call		grp_update_loop_count
		; �\�[�g���[�h�\��
		ld			a, [sort_mode]
		call		grp_update_sort_mode_info
		; �Đ����[�h�\��
		ld			a, [play_mode]
		call		grp_update_mode_info
		; �t�@�C�����X�g���X�V
		ld			a, 1
		call		grp_update_file_list
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
		call		vsync_wait
		call		mgsp_check_song_change
		call		grp_update_keyboard_spot		; A �ɉғ����̃g���b�N�����Ԃ�
		call		mgsp_check_song_stop

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
		ld			b, fl_files

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
		ld			c, a
		call		get_current_file_entry
		ld			a, c
		call		play_new_song
		ret
		endscope

; ==============================================================================
; �O�̋Ȃ��Đ�
; ==============================================================================
		scope		start_previous_song
start_previous_song::
		call		clear_mgsdrv_track_work
		ld			b, fl_files

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
; �����Đ��J�n
; ==============================================================================
		scope		mgsp_auto_start
mgsp_auto_start::
		ld			a, PRM_AUTO_START
		or			a, a
		ret			z
		; Normal���[�h�̏ꍇ�A�ŏ��̃t�@�C�����Đ������悤�Ɍ��݂̋ȔԂ� -1 �ɂ��Ă���
		ld			a, -1
		ld			[playing_song_number], a	; -1 �ɂ���
		jp			start_next_song
		endscope

; ==============================================================================
; ���t��ԊĎ�����
; ==============================================================================
		scope		mgsp_check_song_change
mgsp_check_song_change::
		; ���t�I���`�F�b�N
		ld			a, [play_state]				; A = 0: ��~, 1: ���̋ȍĐ��҂�, 2: �t�F�[�h�A�E�g��, 3: �Đ���
		or			a, a
		ret			z							; ��~���Ȃ�Ȃɂ����Ȃ�
		dec			a
		jp			z, play_next_song			; ���̋ȍĐ��҂��Ȃ玟�̋Ȃ��Đ�����
		dec			a
		jp			z, wait_fadeout				; �t�F�[�h�A�E�g���Ȃ�t�F�[�h�A�E�g�����`�F�b�N��

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
		call		start_next_song
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
mgsp_show_messages::
		; �X�N���[���o�[���u�X�N���[�����Ȃ��v�\���ɂ���
		call		grp_hide_scroll_bar

		call		release_loop

main_loop:
		call		mgsp_common_proc

		; �L�[���͂�����Βʏ�ɖ߂�
		call		check_key_press
		or			a, a
		jp			nz, exit_help
		jp			main_loop

exit_help:
		ld			a, 1
		ld			[grp_select_line_on], a
		call		grp_update_file_list

		; �L�[����҂�
release_loop::
		call		mgsp_common_proc
		call		check_key_press
		or			a, a
		jp			nz, release_loop
		ret
		endscope

; ==============================================================================
; ���C�Z���X��\��
; ==============================================================================
		scope		mgsp_show_license
mgsp_show_license::
		call		grp_unselect_playing_line
		call		grp_unselect_line
		call		grp_show_license
		jp			mgsp_show_messages
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
		jp			grp_update_file_list
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
		jp			grp_update_file_list
		endscope

; ==============================================================================
; ���ֈړ�
; ==============================================================================
		scope		down_select
down_select::
		ld			b, fl_files
		ld			a, [grp_select_file]
		inc			a
		cp			a, b
		ret			nc						; ���łɈ�ԉ��Ȃ牽�����Ȃ�
		ld			[grp_select_file], a
		xor			a, a
		jp			grp_update_file_list
		endscope

; ==============================================================================
; �y�[�W�A�b�v
; ==============================================================================
		scope		left_select
left_select::
		ld			a, [grp_select_file]
		or			a, a
		ret			z						; ���łɈ�ԏ�Ȃ牽�����Ȃ�
		sub			a, 9
		jr			nc, left_select_clip
		xor			a, a
left_select_clip:
		ld			[grp_select_file], a
		xor			a, a
		jp			grp_update_file_list
		endscope

; ==============================================================================
; �y�[�W�_�E��
; ==============================================================================
		scope		right_select
right_select::
		ld			b, fl_files
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
		jp			grp_update_file_list
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
		jp			grp_update_file_list
		endscope

; ==============================================================================
; �y�[�W�{�g��
; ==============================================================================
		scope		plus_select
plus_select::
		ld			b, fl_files
		ld			a, [grp_select_file]
		cp			a, b
		ret			z						; ���łɈ�ԉ��Ȃ牽�����Ȃ�
		ld			a, b
		dec			a
		ld			[grp_select_file], a
		xor			a, a
		jp			grp_update_file_list
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
		jp			grp_update_loop_count
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
		jp			grp_update_loop_count
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
;	�I�𒆂̋ȃf�[�^���Đ�����
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
		; ���t��ԂɕύX
		ld			a, 3
		ld			[play_state], a
		xor			a, a
		call		grp_update_file_list
		ret

mgsp_update_file_list_all::
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
;	�t�@�C����ǂݍ���Ń^�C�g���\�����X�V����
;	input)
;		hl .... �t�@�C���G���g���̃A�h���X
;	output)
;		Zf .... 1: ����, 0: ���s
; ==============================================================================
		scope		load_mgs_file_and_show_title
load_mgs_file_and_show_title::
		ld			[file_name_address], hl
		call		load_mgs_file
		ret			nz							; Zf = 0: ���s

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
		ldir									; page2 �ɂ���ȃf�[�^�̃^�C�g���� page0 �ɃR�s�[����

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

		xor			a, a					; Zf = 1: ����
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
;	DATA AREA
; ==============================================================================
cliksw_backup::
		db			0
track_mute::
		db			0xFF, 0xFF, 0xFF			; L, H, B : BHL�ŉ��ʂ��� 17bit ���L���B1=ON, 0=MUTE
title_scroll_timer::
		db			title_scroll_wait

random_seed1::
		db			0xa3
random_seed2::
		db			0x5b
sort_mode::
		db			PRM_SORT_MODE		; �\�[�g���[�h 0: Entry, 1: Title, 2: File name, 3: Shuffle
play_mode::
		db			PRM_PLAY_MODE		; ���샂�[�h 0: Normal, 1: Random, 2: Repeat
playing_song_number::
		db			0					; �Đ����̋Ȃ̃t�@�C���ԍ�
play_state::
		db			0					; 0: ��~, 1: ���̋ȍĐ��҂�, 2: �t�F�[�h�A�E�g��, 3: �Đ���
fadeout_volume::
		db			0
fadeout_speed::
		db			1					; 1: slow speed ... 128: high speed
loop_counter::
		db			PRM_LOOP_COUNTER
master_volume::
		db			PRM_MASTER_VOLUME	; 0: Max, 15: Min
target_file_name_position::
		db			0					; �Ȗ��X�N���[���\���̈ʒu

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