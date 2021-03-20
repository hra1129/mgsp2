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
;	Dec/14/2020	t.hara	1.0.0	1st release
; ==============================================================================

; ==============================================================================
; �L�[���͂Ƃ���ɉ���������
; ==============================================================================
		scope		mgsp_check_key
mgsp_check_key::
		ld			ix, newkey			; �L�[�}�g���N�X (�L�[���������� �Ή�bit�� 0 �ɂȂ�)
		ld			iy, keymap_table	; �L�[�}�b�v�e�[�u��
		ld			de, 5

		ld			a, [ix + 6]			; �V�t�g�L�[�̏��
		and			a, 0b0000_0111
		ld			c, a
key_check_loop1:
		ld			l, [ix]				; �L�[�̏�Ԃ��擾 (�V)
key_check_loop2:
		ld			a, [iy]				; �L�[�}�b�v�̃L�[����ǂ�
		or			a, a
		jp			z, skip_key_input
		inc			a
		jp			z, change_next_key_code
		dec			a
		ld			b, a				; �}�X�N�l�ۑ�
		and			a, l				; �V�L�[��Ԃ𒲍� (������Ă���� 0, ������ĂȂ��� ��0)
		jp			nz, next_key_check	; �L�[��������Ă��Ȃ���Ύ��̃L�[�`�F�b�N�֑J��

		; �Ώۂ̃L�[��������Ă����ꍇ
		ld			a, [iy + 1]			; �L�[�}�b�v�̃V�t�g�L�[����ǂ�
		cp			a, c
		jp			nz, next_key_check	; �V�t�g�L�[����v���Ȃ���Ύ��̃L�[�`�F�b�N�֑J��

		; �Ō�ɉ����ꂽ�L�[�ƈ�v���Ă��邩�m�F (������Ƃ��������Ȕ���)
		ld			a, [last_key]
		cp			a, b
		jr			z, key_repeat

		; ��v���Ă��Ȃ��ꍇ�A�V�����L�[�Ƃ��ď���̃L�[���s�[�g�E�F�C�g��ݒ�
		ld			a, b
		ld			[last_key], a
		ld			a, [key_repeat_begin_wait]
		jp			skip3

		; �O��ƈ�v���Ă���΁A�L�[���s�[�g�E�F�C�g���`�F�b�N����
key_repeat:
		ld			a, [key_wait]
		dec			a
		ld			[key_wait], a

		jr			nz, skip2						; 0 �łȂ���΁A�L�[���s�[�g�҂����Ȃ̂ŏ������Ȃ�
		ld			a, [key_repeat_wait]			; 0 �Ȃ�΁A�L�[���s�[�g��1�񕪂��I������̂ŏ��������{
skip3:
		ld			[key_wait], a					; �V�����E�F�C�g�l���w��
skip1:
		call		call_routine					; �Ώۂ̏��������s
skip2:
		jp			exit_key_input

call_routine:
		ld			a, [iy + 2]
		ld			l, [iy + 3]
		ld			h, [iy + 4]
		jp			hl

next_key_check:
		add			iy, de
		jp			key_check_loop2

change_next_key_code:
		inc			iy
		inc			ix
		jp			key_check_loop1

skip_key_input:
		xor			a, a
		ld			[last_key], a
exit_key_input:

		; �W���C�X�e�B�b�N���͂ɂ���ď�������
		ld			a, 1				; Joypad1 A button
		call		GTTRIG
		and			a, JOYMAP_A
		push		af

		ld			a, 3				; Joypad1 B button
		call		GTTRIG
		and			a, JOYMAP_B
		pop			bc
		or			a, b
		push		af

		ld			a, 1				; Joypad1 stick
		call		GTSTCK
		pop			bc
		or			a, b

		ld			b, a
		ld			a, [joy_last_stick]
		cp			a, b						; �O��̓��͂Ɠ����H
		ld			a, b
		ld			[joy_last_stick], a
		ld			a, [key_repeat_begin_wait]	; ������͂� wait �� 30/60[sec]
		jr			nz, joy_key_affect

		ld			a, [joy_key_wait]			; �O��Ɠ��͓����ŁA���� wait �� 0�H
		dec			a
		ld			[joy_key_wait], a
		jr			nz, skip_joy_key
		ld			a, [key_repeat_wait]		; ���s�[�g�Ԋu�� wait �� 4/60[sec]
joy_key_affect:
		ld			[joy_key_wait], a
		ld			a, b
		ld			hl, joymap_table
		call		call_keymap
skip_joy_key:

		ret
		endscope

; ==============================================================================
; A���W�X�^�ƃL�[�}�b�v�e�[�u���ɏ]���ăT�u���[�`���R�[������
; input)
;	A .... �L�[�R�[�h
;	HL ... �L�[�}�b�v�e�[�u���̃A�h���X
; break)
;	all
; ==============================================================================
		scope		call_keymap
call_keymap::
		ld			de, 3
keymap_loop:
		ld			b, [hl]
		inc			b
		ret			z						; terminator �Ȃ甲����
		dec			b
		cp			a, b
		jp			z, call_keymap_routine
		add			hl, de
		jp			keymap_loop
call_keymap_routine:
		inc			hl
		ld			e, [hl]
		inc			hl
		ld			d, [hl]
		ex			de, hl
		jp			hl
		endscope

; ==============================================================================
; �L�[���̓`�F�b�N (for Help, Exit dialog)
; output)
;	a .... [��][��][��][��][ESC][*][*][SPACE/RET]
;			������Ă���L�[�� 1, ������Ă��Ȃ��L�[�� 0 �ɂȂ�B
; ==============================================================================
		scope		check_key_press
check_key_press::
		; HL �ɃL�[�}�g���N�X�l���擾
		;   Key matrix 7 : [RET][SEL][BS][STOP][TAB][ESC][F5][F4]  --> L
		;   Key matrix 8 : [��][��][��][��][DEL][INS][CLS][SPACE]  --> H
		ld			hl, [ newkey + 7 ]

		ld			a, 0b01111011
		or			a, l
		rlca
		ld			l, a

		ld			a, 0b00001110
		or			a, h

		and			a, l
		cpl
		or			a, a
		jp			nz, exit_check_key_press

		; �W���C�p�b�h�{�^��
		ld			a, 1				; Joypad1 stick
		call		GTSTCK
		or			a, a
		jr			z, skip1
		ld			a, 0b11110000		; ���L�[�̃t��
skip1:
		push		af

		ld			a, 1				; Joypad1 A button
		call		GTTRIG
		and			a, 0b00000001		; [SPC] �̃t��
		pop			bc
		or			a, b
		push		af

		ld			a, 3				; Joypad1 B button
		call		GTTRIG
		and			a, 0b00001000		; [ESC] �̃t��
		pop			bc
		or			a, b
		ret			z

exit_check_key_press:
		ret
		endscope

; ==============================================================================
;	DATA AREA
; ==============================================================================
key_repeat_begin_wait:
		db			PRM_KEY_REPEAT_WAIT_1ST
key_repeat_wait:
		db			PRM_KEY_REPEAT_WAIT
key_wait::
		db			0
last_key::
		db			0
joy_key_wait::
		db			0
joy_last_stick::
		db			255

keymap	macro		keymask, shiftkey, data, routine_name
		db			keymask						; Key mask code     - 0x00: Terminate, 0xFF: Next line of key matrix, others: mask
		db			shiftkey					; Shift key pattern - bit0: shift, bit1: ctrl, bit2: graph
		db			data						; A���W�X�^�ɓ����l
		dw			routine_name
		endm

key_bit0	= 0b00000001
key_bit1	= 0b00000010
key_bit2	= 0b00000100
key_bit3	= 0b00001000
key_bit4	= 0b00010000
key_bit5	= 0b00100000
key_bit6	= 0b01000000
key_bit7	= 0b10000000
key_none	= 0b00000111
key_shift	= 0b00000110
key_ctrl	= 0b00000101
key_graph	= 0b00000011
key_term	= 0x00
key_next	= 0xFF

keymap_table::
		;           bit:  7  6  5  4  3  2  1  0
		; Key matrix 0 : [7][6][5][4][3][2][1][0]
		keymap		key_bit1, key_none, 0b00000001, mgsp_track_mute_h	; [1]  OPLL Track Mute ch.0
		keymap		key_bit2, key_none, 0b00000010, mgsp_track_mute_h	; [2]  OPLL Track Mute ch.1
		keymap		key_bit3, key_none, 0b00000100, mgsp_track_mute_h	; [3]  OPLL Track Mute ch.2
		keymap		key_bit4, key_none, 0b00001000, mgsp_track_mute_h	; [4]  OPLL Track Mute ch.3
		keymap		key_bit5, key_none, 0b00010000, mgsp_track_mute_h	; [5]  OPLL Track Mute ch.4
		keymap		key_bit6, key_none, 0b00100000, mgsp_track_mute_h	; [6]  OPLL Track Mute ch.5
		keymap		key_bit7, key_none, 0b01000000, mgsp_track_mute_h	; [7]  OPLL Track Mute ch.6
		db			key_next
		; Key matrix 1 : [;][[][@][\][^][-][9][8]
		keymap		key_bit0, key_none, 0b10000000, mgsp_track_mute_h	; [8]  OPLL Track Mute ch.7
		keymap		key_bit1, key_none, 0b00000001, mgsp_track_mute_b	; [9]  OPLL Track Mute ch.8
		keymap		key_bit3, key_none, 0, loop_down					; [\]  Loop couunter down
		keymap		key_bit4, key_none, 0, loop_up						; [^]  Loop couunter up

		db			key_next
		; Key matrix 2 : [B][A][_][/][.][,][]][:]
		keymap		key_bit2, key_none, -1, mgsp_speed_change			; [,]  Play speed -1%
		keymap		key_bit3, key_none, 0, mgsp_speed_reset				; [.]  Play speed 100%
		keymap		key_bit4, key_none, 1, mgsp_speed_change			; [/]  Play speed +1%
		keymap		key_bit5, key_none, 10, mgsp_speed_change			; [_]  Play speed +10%
		keymap		key_bit6, key_none, 0, sort_by_title				; [A]  Sort by song title
		db			key_next
		; Key matrix 3 : [J][I][H][G][F][E][D][C]
		keymap		key_bit1, key_none, 0, sort_by_entry				; [D]  Sort by directory entry
		keymap		key_bit2, key_none, 0b00000100, mgsp_track_mute_l	; [E]  PSG Track Mute ch.2
		keymap		key_bit3, key_none, 0, sort_by_filename				; [F]  Sort by file name
		keymap		key_bit6, key_none, 0b10000000, mgsp_track_mute_l	; [I]  SCC Track Mute ch.4
		db			key_next
		; Key matrix 4 : [R][Q][P][O][N][M][L][K]
		keymap		key_bit2, key_none, -10, mgsp_speed_change			; [M]  Play speed -10%
		keymap		key_bit6, key_none, 0b00000001, mgsp_track_mute_l	; [Q]  PSG Track Mute ch.0
		keymap		key_bit7, key_none, 0b00001000, mgsp_track_mute_l	; [R]  SCC Track Mute ch.0
		db			key_next
		; Key matrix 5 : [Z][Y][X][W][V][U][T][S]
		keymap		key_bit0, key_none, 0, sort_by_shuffle				; [S]  Shuffle
		keymap		key_bit1, key_none, 0b00010000, mgsp_track_mute_l	; [T]  SCC Track Mute ch.1
		keymap		key_bit2, key_none, 0b01000000, mgsp_track_mute_l	; [U]  SCC Track Mute ch.3
		keymap		key_bit4, key_none, 0b00000010, mgsp_track_mute_l	; [W]  PSG Track Mute ch.1
		keymap		key_bit5, key_none, 0, start_next_song				; [X]  Play next song
		keymap		key_bit6, key_none, 0b00100000, mgsp_track_mute_l	; [Y]  SCC Track Mute ch.2
		keymap		key_bit7, key_none, 0, start_previous_song			; [Z]  Play previous song
		db			key_next
		; Key matrix 6 : [F3][F2][F1][KANA][CAPS][GRAPH][CTRL][SHIFT]
		keymap		key_bit5, key_none, 0, play_current_song			; [F1]  Play song
		keymap		key_bit6, key_none, 0, mgsp_stop_song				; [F2]  Stop song
		keymap		key_bit7, key_none, 0, start_fadeout				; [F3]  Fade out
		keymap		key_bit5, key_shift, 0, mgsp_play_song				; [F6]  Play loaded song
		keymap		key_bit6, key_shift, 0, master_volume_down			; [F7]  Down master volume
		keymap		key_bit7, key_shift, 0, master_volume_up			; [F8]  Up master volume
		db			key_next
		; Key matrix 7 : [RET][SEL][BS][STOP][TAB][ESC][F5][F4]
		keymap		key_bit1, key_none, 0, mgsp_show_help				; [F5]  Show help message
		keymap		key_bit2, key_none, 0, mgsp_show_license			; [ESC] License
		keymap		key_bit6, key_none, 0, toggle_file_list_mode		; [SEL] toggle file list
		keymap		key_bit7, key_none, 0, play_current_song			; [RET] Play song
		keymap		key_bit0, key_shift, 0, change_mode					; [F9]  Mode change
		keymap		key_bit1, key_shift, 0, mgsp_show_license			; [F10] License
		db			key_next
		; Key matrix 8 : [��][��][��][��][DEL][INS][CLS][SPACE]
		keymap		key_bit0, key_none, 0, play_current_song			; [SPC] Play song
		keymap		key_bit1, key_none, 0, change_mode					; [CLS] Mode change
		keymap		key_bit2, key_none, 0, master_volume_down			; [INS] Down master volume
		keymap		key_bit3, key_none, 0, master_volume_up				; [DEL] Up master volume
		keymap		key_bit4, key_none, 0, left_select					; [��]  left (page down)
		keymap		key_bit5, key_none, 0, up_select					; [��]  Up
		keymap		key_bit6, key_none, 0, down_select					; [��]  Down
		keymap		key_bit7, key_none, 0, right_select					; [��]  right (page up)
		keymap		key_bit5, key_shift, 0, minus_select				; [SFT]+[��]  Top
		keymap		key_bit6, key_shift, 0, plus_select					; [SFT]+[��]  Bottom
		db			key_term

JOYMAP_UP		:= 1		; JOYMAP_UP, DOWN, RIGHT, LEFT �͔r��
JOYMAP_RIGHT	:= 3
JOYMAP_DOWN		:= 5
JOYMAP_LEFT		:= 7
JOYMAP_A		:= 16
JOYMAP_B		:= 32
JOYMAP_AB		:= JOYMAP_A + JOYMAP_B

joymap	macro		keycode, routine_name
		db			keycode
		dw			routine_name
		endm

joymap_table::
		joymap		JOYMAP_UP						, up_select				; [��] Key
		joymap		JOYMAP_DOWN						, down_select			; [��] Key
		joymap		JOYMAP_RIGHT					, play_current_song		; [��] Key
		joymap		JOYMAP_A  + JOYMAP_UP			, left_select			; (A) + [��] Key
		joymap		JOYMAP_A  + JOYMAP_DOWN			, right_select			; (A) + [��] Key
		joymap		JOYMAP_A  + JOYMAP_LEFT			, master_volume_down	; (A) + [��] Key
		joymap		JOYMAP_A  + JOYMAP_RIGHT		, master_volume_up		; (A) + [��] Key
		joymap		JOYMAP_B  + JOYMAP_UP			, loop_up				; (B) + [��] Key
		joymap		JOYMAP_B  + JOYMAP_DOWN			, loop_down				; (B) + [��] Key
		joymap		JOYMAP_B  + JOYMAP_LEFT			, mgsp_stop_song		; (B) + [��] Key
		joymap		JOYMAP_B  + JOYMAP_RIGHT		, mgsp_play_song		; (B) + [��] Key
		joymap		JOYMAP_AB + JOYMAP_DOWN			, start_fadeout			; (A) + (B) + [��] Key
		joymap		JOYMAP_AB + JOYMAP_LEFT			, sort_by_entry			; (A) + (B) + [��] Key
		joymap		JOYMAP_AB + JOYMAP_RIGHT		, sort_by_title			; (A) + (B) + [��] Key
		joymap		0xFF, 0x0000											; Terminator