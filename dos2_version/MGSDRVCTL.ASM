; ==============================================================================
;	MGSDRV����
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
;		Zf .... 0: �G���[, 1: ����
;	comment)
;		PATH�̒ʂ����ꏊ���� MGSDRV.COM �������o���A�}�b�p�[���������m�ۂ���
;		�������ɓǂݍ���
;		�}�b�p�[�����̕��̏��������ς�ł���K�v������B
; ==============================================================================
		scope	init_mgsdrv
init_mgsdrv::
		; MGSDRV�p�̃��������m�ۂ���
		xor		a, a
		ld		b, a					; �v���C�}���[�}�b�p�[
		call	mapper_all_seg			; 1�Z�O�����g����
		jp		c, error_exit
		ld		[mgs_id_drvseg], a

		ld		a, b					; A = 0
		call	mapper_all_seg			; 1�Z�O�����g����
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

		; MGSDRV.COM ���J��
		ld		de, s_mgsdrv_com
		call	open_file_on_path_env
		dec		a
		ret		nz						; �G���[�Ȃ� Zf = 0 �ɂ��Ĕ�����

		; page1, page2 �̃Z�O�����g�ԍ����o�b�N�A�b�v
		call	mapper_get_p1
		ld		[backup_segment1], a
		call	mapper_get_p2
		ld		[backup_segment2], a

		; page1, page2 �� MGSDRV �̃Z�O�����g�ɐ؂�ւ���
		ld		a, [mgs_id_drvseg]
		call	mapper_put_p1
		ld		a, [mgs_id_datseg]
		call	mapper_put_p2

		; MGSDRV.COM ��ǂݍ���
		ld			c, D2F_READ
		ld			a, [file_handle]
		ld			b, a
		ld			de, 0x6000 - 0x000D		; load address
		ld			hl, 0x200D				; size
		call		safe_bdos
		or			a, a
		ret			nz

		; �t�@�C�������
		ld			c, D2F_CLOSE
		ld			a, [file_handle]
		ld			b, a
		call		safe_bdos

		; MGSDRV������������
		call		mgs_sysck
		ld			[mgs_id_mgsver], hl
		ld			[mgs_id_mibadr], ix
		ld			[mgs_id_trwadr], iy
		ld			[mgs_id_trwsiz], bc

		; H.TIMI���荞�݂��t�b�N����
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

		ld			a, 0xC3				; JP xxxx ����
		ld			[h_timi], a
		ld			hl, mgsdrv_h_timi_rel
		ld			[h_timi + 1], hl
		ei

		; �}�b�p�[��߂�
		ld			a, [backup_segment1]
		call		mapper_put_p1
		ld			a, [backup_segment2]
		call		mapper_put_p2
		xor			a, a
		ret

error_exit:
		xor			a, a
		inc			a						; Zf = 0 �ɂ��Ĕ����� (�G���[)
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
;	MGSDRV�̃g���b�N���[�N���N���A����
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
;	�X���b�g�\����MGSDRV�p�ɂ���
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
;		de .... �t�@�C�����̃A�h���X (ASCIIZ)
;	output)
;		Zf .... 0: ����, 1: ���s
; ==============================================================================
		scope		load_mgs_file
load_mgs_file::
		ld			[file_name_address], de
		ld			a, [de]
		or			a, a				; Zf = 0:����, 1:���s
		ret			z					; ���s�Ȃ甲����

		call		stop_song

		; �G���[�ϐ����N���A����
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

		; �G���[�Ȃ甲����
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
		inc			a					; Zf = 0:����
		ret
error_exit:
		ld			a, 1
		ld			[error_status], a
		xor			a, a				; Zf = 1:���s
		ret
		endscope

; ==============================================================================
;	�t�@�C���p�X����t�@�C�����i�g���q�܂܂��j���R�s�[����
;	input)
;		hl .... �t�@�C���p�X�̃A�h���X (ASCIIZ)
;		de .... �R�s�[��A�h���X (9byte)
;	output)
;		--
;	break)
;		af, bc, de, hl
; ==============================================================================
		scope		copy_file_name
copy_file_name::
		; �Ō�̃p�X�Z�p���[�^ \ ��������
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
;	�Ȃ��Đ�����
;	output)
;		Zf .... 0: ���s, 1: ����
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
;	�Ȃ��~����
; ==============================================================================
		scope		stop_song
stop_song::
		; song stop
		call		change_mgsdrv_slot
		call		mgs_initm
		ret
		endscope

; ==============================================================================
;	���荞�ݏ������[�`�� ( 0xC000�` �ɓ]�����Ďg�� )
; ==============================================================================
		scope		mgsdrv_h_timi
mgsdrv_h_timi::
		ld			a, [ 0xFFFF ]		; �g���X���b�g�ԍ� (page3 �͂��łɃv���C�}���}�b�p�X���b�g)
		cpl								; �ǂݏo�����ʂ͔��]���Ă�̂Ŗ߂�
		ld			h, a				; �����p�o�b�N�A�b�v
	mgsdrv_exp_slot	:= $ + 1
		ld			a, 0				; page0�`3 �� �v���C�}���}�b�p�X���b�g(TPA)��
		ld			[ 0xFFFF ], a		; �g���X���b�g�ύX

		in			a, [ 0xA8 ]			; ��{�X���b�g�ԍ�
		ld			l, a				; �����p�o�b�N�A�b�v
	mgsdrv_slot		:= $ + 1
		ld			a, 0				; page0�`3 �� �v���C�}���}�b�p�X���b�g(TPA)��
		out			[ 0xA8 ], a			; ��{�X���b�g�ύX

		push		hl					; �����p�o�b�N�A�b�v���X�^�b�N�֕ۑ�

		; page1, page2 �̃Z�O�����g�ԍ����o�b�N�A�b�v
		call		mapper_get_p1
		ld			b, a
		call		mapper_get_p2
		ld			c, a
		push		bc					; �}�b�p�[�������̃Z�O�����g�ԍ�(page1, page2)��ۑ�

		; page1, page2 �� MGSDRV �̃Z�O�����g�ɐ؂�ւ���
		ld			a, [mgs_id_drvseg]
		call		mapper_put_p1
		ld			a, [mgs_id_datseg]
		call		mapper_put_p2

		; MGSP���ŗ��p����J�E���^�[
		ld			a, [timer_counter]
		inc			a
		ld			[timer_counter], a

		; CPU���ו\��
		ld			a, [show_cpu_load_time]
		or			a, a
		jr			z, skip_load_time1
		ld			a, 0x0C
		out			[ vdp_port1 ], a
		ld			a, 0x87
		out			[ vdp_port1 ], a
skip_load_time1:

		; �Đ����x�J�E���^�[���C���N�������g
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

		; MGSDRV ���Ă�
		call		mgs_inter

		ld			hl, [song_speed_counter]
		jr			loop1

mgs_inter_skip:
		; CPU���ו\��
		ld			a, [show_cpu_load_time]
		or			a, a
		jr			z, skip_load_time2
		ld			a, 0x00
		out			[ vdp_port1 ], a
		ld			a, 0x87
		out			[ vdp_port1 ], a
skip_load_time2:

		; page1, page2 �̃}�b�p�[�������̃Z�O�����g�ԍ��𕜌�
		pop			bc
		ld			a, b
		call		mapper_put_p1
		ld			a, c
		call		mapper_put_p2

		; �X���b�g�𕜌�
		pop			hl
		ld			a, l
		out			[ 0xA8 ], a			; ��{�X���b�g�����ɖ߂�
		ld			a, h
		ld			[ 0xFFFF ], a		; �g���X���b�g�����ɖ߂�
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
		dw		100		; 2byte: 1%...255% �͈̔͂̂ݗL��
song_speed_counter::
		dw		0
backup_segment1::
		db		0
backup_segment2::
		db		0
show_cpu_load_time::
		db		0		; MGSDRV��CPU���ׂ̕\�� 0:OFF, 1:ON

file_name_address::
		dw		0
file_name_copy::
		db		0, 0, 0, 0, 0, 0, 0, 0, 0
file_handle::
		db		0

mgs_parameter_block::
mgs_id_drvslt::			; 1byte: MGSDRV�{�̂̃X���b�g���
		db			0
mgs_id_drvseg::			; 1byte: MGSDRV�{�̂̃Z�O�����g���
		db			0
mgs_id_datslt::			; 1byte: ���t�f�[�^�̈�̃X���b�g���
		db			0
mgs_id_datseg::			; 1byte: ���t�f�[�^�̈�̃Z�O�����g���
		db			0
mgs_id_mgsver::			; 2bytes: MGSDRV�̃o�[�W����
		dw			0
mgs_id_mibadr::			; 2bytes: MIB�ւ̃A�h���X
		dw			0
mgs_id_trwadr::			; 2bytes: �g���b�N���[�N�̃A�h���X
		dw			0
mgs_id_trwsiz::			; 2bytes: �g���b�N���[�N�̃T�C�Y
		dw			0