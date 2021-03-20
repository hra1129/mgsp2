; ==============================================================================
;	File list
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
;	2020/9/20	t.hara	v1.0	1st release
; ==============================================================================

fl_max_entries	:= 192

; ==============================================================================
;	�t�@�C���A�N�Z�X�֘A�̏�����
; ==============================================================================
		scope		file_init
file_init::
		; �J�����g�h���C�u���擾����
		ld			c, D1F_CURDRV
		call		bdos
		add			a, 'A'
		ld			[current_drive], a

		; ���݂� ���z�h���C�u�؂�ւ��v�����v�g�t�b�N ��ۑ����Ă���
		di
		ld			a, [h_prompt]
		ld			[save_h_prompt_hook], a
		ld			hl, [h_prompt + 1]
		ld			[save_h_prompt_hook + 1], hl

		; �V�����t�b�N�ɍX�V����
		ld			a, 0xC3			; JP
		ld			[h_prompt], a
		ld			hl, disk_change_prompt
		ld			[h_prompt + 1], hl
		ei
		ret
		endscope

; ==============================================================================
;	���ϐ� PATH �Ŏw�肳��Ă���p�X�̒��ɂ���w��̃t�@�C�����J��
; input)
;	de ....... �t�@�C����
; output)
;	a ........ 0: ���s, 1: ����
; ==============================================================================
		scope		open_file_on_path_env
open_file_on_path_env::
		ld		[s_file_name], de
		xor		a, a
		ld		[s_path_env_end - 1], a

		; ���ϐ� "PATH" �̓��e���擾����
		ld		c, D2F_GENV
		ld		de, s_path_env
		ld		hl, s_path
		ld		b, s_path_env_end - s_path_env - 1
		call	safe_bdos
		or		a, a
		jp		z, no_blank
		; ���ϐ� "PATH" �������Ȃ����������ۂ̈���
		xor		a, a
		ld		[de], a
no_blank:
		ex		de, hl
		ld		de, s_file_name_work

		; �ŏ��� "PATH" �̓��e�ɂ�����炸�A�J�����g�f�B���N�g���𒲂ׂ�
		jp		skip_separator

		; ���ϐ� "PATH" ���珇�Ƀp�X�𒊏o����
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

		; �Ō�̕����� '\\' �łȂ���΁A������ \ ��ǉ�
		dec		c
		jr		z, skip_separator
		ld		a, '\\'
		ld		[de], a
		inc		de
skip_separator:
		; �����ăt�@�C������ǉ�
		push	hl
		ld		hl, [s_file_name]
		call	strcpy
		; �o�����p�X�̃t�@�C�����J��
		ld		c, D2F_OPEN
		ld		a, 1
		ld		de, s_file_name_work
		call	safe_bdos
		or		a, a
		pop		hl
		jr		z, success
		; �J���Ȃ������̂ŁA"PATH" �����ׂď����������m�F
		ld		a, [hl]
		or		a, a
		ret		z					; �p�X��S���������I���Ă��āA�t�@�C���J���Ȃ��ꍇ�͎��s
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
;	�t�@�C���A�N�Z�X�֘A�̌�n��
; ==============================================================================
		scope		file_term
file_term::
		; ���̃t�b�N�������߂�
		di
		ld			hl, [save_h_prompt_hook]
		ld			[h_prompt], hl
		ld			a, [save_h_prompt_hook + 2]
		ld			[h_prompt + 2], a
		ei
		ret
		endscope

; ==============================================================================
;	�h���C�u�`�F���W�̃t�b�N����Ă΂�郋�[�`��
; ==============================================================================
		scope		disk_change_prompt
disk_change_prompt::
		ld			a, 1
		ld			[called_disk_change_prompt], a
		pop			af			; �X�^�b�N���ꃌ�x���̂Ă�
		ret
		endscope

; ==============================================================================
;	�t�@�C���A�N�Z�X�֘A�� BDOS�R�[��
; ==============================================================================
		scope		safe_bdos
safe_bdos::
		; �f�B�X�N�G���[�����̃|�C���^�̃|�C���^���X�V
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
;	�J�����g�f�B���N�g����ύX����
;	input)
;		de ..... �f�B���N�g����(ASCIIZ)
; ==============================================================================
		scope	change_directory
change_directory::
		ld			c, D2F_CHDIR
		call		safe_bdos
		ret
		endscope

; ==============================================================================
;	�J�����g�h���C�u��ύX����
;	input)
;		a .... target drive (A:=0, B:=1, ... ,H:=7)
;	output)
;		Zf ... 0: ����, 1: ���s
; ==============================================================================
		scope	change_current_drive
change_current_drive::
		ld			e, a
		xor			a, a
		ld			[called_disk_change_prompt], a
		ld			[error_status], a

		; �J�����g�h���C�u�ύX�����݂� (���݂��Ȃ��h���C�u���ƕύX����Ȃ�)
		ld			c, D1F_SELDSK
		call		safe_bdos
		; �J�����g�h���C�u���^�[���擾����
		ld			c, D1F_CURDRV
		call		bdos
		ld			d, a
		push		de
		; �A�N�Z�X�����݂�
		ld			bc, (FIB_ATTR_DIRECTORY << 8) | D2F_FFIRST
		ld			de, search_name
		ld			ix, fl_fib
		call		safe_bdos
		; ���z�f�B�X�N�h���C�u�̃f�B�X�N�`�F���W�������������H
		pop			bc
		ld			a, [called_disk_change_prompt]
		or			a, a
		jp			nz, failed
		; �n�[�h�G���[�������������H
		ld			a, [error_status]
		or			a, a
		jp			nz, failed
		; �����Ƀh���C�u�ύX�ł���
		ld			a, b
		add			a, 'A'						; Zf = 0
		ld			[current_drive], a
		ret

failed:
		; �w��̃h���C�u�����z�h���C�u�������ꍇ�A�܂��̓n�[�h�G���[�����������ꍇ�A���ɖ߂�
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

		; �ŏ��̃t�@�C�����擾 
		ld			bc, (FIB_ATTR_DIRECTORY << 8) | D2F_FFIRST
		ld			de, search_name
		ld			ix, fl_fib
		call		safe_bdos
		or			a, a
		jr			nz, exit

		; �n�[�h�G���[�������������m�F
		ld			a, [error_status]
		or			a, a
		jr			nz, exit

		ld			hl, fl_fib + FIB_FILENAME
		ld			de, fl_entry_table
		ld			bc, fl_entry_fib_size
		ldir

		ld			de, fl_entry_table
		call		reset_song_title
		ld			a, 0						; Cy�t���O�ۑ�
		jr			c, loop
		inc			a
loop:
		; �i����\��
		push		af
		push		de
		call		grp_update_progress_bar
		pop			de
		pop			af

		; �����\�ȍő吔�ɓ��B�������H
		ld			[fl_files], a
		cp			a, fl_max_entries
		jr			z, exit

		; 2�ڈȍ~�̃t�@�C�����擾
		push		de
		ld			c, D2F_FNEXT
		ld			ix, fl_fib
		call		safe_bdos
		pop			de
		or			a, a
		jr			nz, exit

		; �n�[�h�G���[�������������m�F
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
		ret			z						;	�f�B���N�g���G���g����(fl_sort_normal)�̏ꍇ�A�\�[�g���̎��s���Ȃ�
		dec			a
		jp			z, fl_sort_title
		dec			a
		jp			z, fl_sort_filename
		jp			fl_sort_shuffle
		endscope

; ==============================================================================
;	�t�@�C���̋Ȗ��A�h���X����������������
;	input)
;		de ... entry table
;	output)
;		de ... �f�B���N�g���܂��� MGS�t�@�C���Ȃ玟�̃G���g���̃A�h���X
;		       �֌W�Ȃ��t�@�C���Ȃ�ύX����
;		Cy ... 0: �L��, 1: ����
;	break)
;		af, bc
; ==============================================================================
		scope		reset_song_title
reset_song_title::
		push		hl
		push		de
		; fl_entry �̒��� �Ȗ��A�h���X(FENT_MGS_TITLE_ADDRESS) �� 0 �N���A����
		ld			hl, FENT_MGS_TITLE_ADDRESS
		add			hl, de
		xor			a, a
		ld			[hl], a
		inc			hl
		ld			[hl], a
		; �A�g���r���[�g�`�F�b�N
		ld			de, (FIB_ATTRIBUTE - FIB_FILENAME) - FENT_MGS_TITLE_ADDRESS - 1
		add			hl, de
		ld			a, [hl]
		and			a, FIB_ATTR_DIRECTORY
		ld			a, 0
		jr			nz, success_exit			; �f�B���N�g���Ȃ̂ŉ������Ȃ�
		; �g���q�`�F�b�N
		ld			de, FIB_FILENAME - FIB_ATTRIBUTE
		add			hl, de
search_dot:
		ld			a, [hl]
		or			a, a
		jr			z, ignore_exit				; �g���q�������̂ŉ������Ȃ�
		inc			hl
		cp			a, '.'
		jr			nz, search_dot
		ld			de, ext_mgs
		call		strcmpi
		jr			z, do_copy					; �g���q�� MGS �Ȃ�A�R�s�[������
ignore_exit:
		pop			de
		pop			hl
		scf
		ret
success_exit:
		; �C���f�b�N�X����
		ld			a, [fl_current_index]
		inc			a
		ld			[fl_current_index], a
		dec			a

		; FENT_MGS_ENTRY_INDEX ���X�V(A�̒l�ɂ���)�B
		pop			de
		ex			de, hl
		ld			de, FENT_MGS_ENTRY_INDEX
		add			hl, de
		ld			[hl], a
		; ���̃G���g���̃A�h���X�����߂�
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
		ld			[hl], a							; �Ȗ��i�[�A�h���X�� 0xFFFF(�܂��ǂ�łȂ��t���O) �ɍX�V

		; �c��̐��𑝂₷
		ld			a, [fl_remain_no_read_titles]
		inc			a
		ld			[fl_remain_no_read_titles], a

		; �Đ��\�ȋȃt�@�C���̐��𑝂₷
		ld			a, [fl_song_files]
		inc			a
		ld			[fl_song_files], a
		jr			success_exit
		endscope

; ==============================================================================
;	�܂��ǂݍ���ł��Ȃ��Ȗ�������Γǂݍ��݂��g���C����
;	input)
;		--
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope		preload_song_title
preload_song_title::
		; �c�肪������Δ�����
		ld			a, [fl_remain_no_read_titles]
		or			a, a
		ret			z

		; �t�@�C�������������Δ�����
		ld			a, [fl_files]
		or			a, a
		ret			z

		; ���ׂ�ԍ��𓾂�
loop:
		ld			a, [fl_preload_index]
		call		get_current_file_entry

		ld			de, FENT_MGS_TITLE_ADDRESS
		add			hl, de
		ld			e, [hl]
		inc			hl
		ld			d, [hl]
		dec			hl

		; �Ȗ����𒲂ׂ�
		inc			de
		ld			a, e
		or			a, d
		dec			de
		jp			nz, exit_preload_song_title

		; �Ȗ������擾����
		ld			de, -FENT_MGS_TITLE_ADDRESS
		add			hl, de
		ex			de, hl
		call		get_mgs_song_title

exit_preload_song_title:
		; ���̃C���f�b�N�X�ɂ���
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
;	���������m�ۂ��Ďw��̃t�@�C���̋Ȗ����擾����
;	input)
;		de ... entry table
;	output)
;		de ... entry table (�ύX����)
;		Cy ... 0: �L��, 1: ����
;	break)
;		af, bc
; ==============================================================================
		scope		get_mgs_song_title
get_mgs_song_title::
		push		hl
		push		de
		; �c���𒲍�
		ld			a, [fl_remain_no_read_titles]
		or			a, a
		jp			z, success_exit		; �c��������Ή��������ɔ�����B

		; fl_entry �̒��� �Ȗ��A�h���X(FENT_MGS_TITLE_ADDRESS) �𒲂ׂ�
		ld			hl, FENT_MGS_TITLE_ADDRESS
		add			hl, de
		ld			e, [hl]
		inc			hl
		ld			d, [hl]

		ld			a, e
		or			a, d
		jr			z, success_exit		; 0000h �̏ꍇ�A�f�B���N�g���B���������ɔ�����B

		inc			de
		ld			a, e
		or			a, d
		dec			de
		jr			nz, success_exit	; FFFFh �łȂ��ꍇ�A���łɋȖ����擾�ς݂Ȃ̂ŁA���������ɔ�����.

do_copy:
		; read buffer �����O�� 0����
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

		; �n�[�h�G���[�������������m�F
		ld			a, [error_status]
		or			a, a
		jr			nz, ignore_exit

		; read the file
		ld			c, D2F_READ
		ld			de, read_buffer
		ld			hl, 62 + 8
		call		safe_bdos

		; �n�[�h�G���[�������������m�F
		ld			a, [error_status]
		or			a, a
		jr			nz, ignore_exit

		; close the file
		ld			c, D2F_CLOSE
		ld			a, [file_handle]
		ld			b, a
		call		safe_bdos

		; �n�[�h�G���[�������������m�F
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
		ld			[hl], d							; �Ȗ��i�[�A�h���X���X�V

		ld			hl, read_buffer + 8
		call		strlen							; de�͔j�󂵂Ȃ��Bbc �ɕ�����
		inc			bc								; �[���������R�s�[����̂� +1

		ld			hl, read_buffer + 8
		ldir
		ld			[fl_string_table_bottom], de

		; �c�������炷
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
;		a ................... �Ώۂ̃t�@�C���̔ԍ� (�ꗗ�\�̒��̉��Ԗڂ�)
;	output)
;		Zf .................. 1: �t�@�C��������(HL����), 0: �ʏ�
;		hl .................. �w��̃t�@�C���̃t�@�C���̃G���g���A�h���X
;	break)
;		bc�ȊO���ׂ�
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
		add		hl, de					; ���0 �ɂ͂Ȃ�Ȃ��̂ŁAZf = 0
		ret
		endscope

; ==============================================================================
;	fl_swap_entry
;	input)
;		a .... 1st target entry
;		b .... 2nd target entry
;	comment)
;		swap_cbr_address �� HL, DE �̂Q���W�X�^������ entry �����ւ��锻�胋�[�`��
;		�̃A�h���X����������ł�������
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

		; ���̃G���g�����X���b�v���邩���肷��
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
;	cbr_compare_normal (�f�B���N�g���G���g����)
;	input)
;		hl .... 1�ڂ̃G���g��
;		de .... 2�ڂ̃G���g��
;	output)
;		Cy�t���O ... 0: ����ւ��Ȃ�, 1: ����ւ���
;	break)
;		all
; ==============================================================================
		scope	cbr_compare_normal
cbr_compare_normal::
		push	hl
		push	de

		pop		ix		; 2��
		pop		iy		; 1��
		ld		a, [ix + FENT_MGS_ENTRY_INDEX]
		ld		b, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2�ڂ� ENTRY_INDEX][1�ڂ� ENTRY_INDEX]
		sub		a, b
		ret
		endscope

; ==============================================================================
;	cbr_compare_title (�Ȗ���)
;	input)
;		hl .... 1�ڂ̃G���g��
;		de .... 2�ڂ̃G���g��
;	output)
;		Cy�t���O ... 0: ����ւ��Ȃ�, 1: ����ւ���
;	break)
;		all
; ==============================================================================
		scope	cbr_compare_title
cbr_compare_title::
		push	hl
		push	de

		; �Ȗ����ǂ܂�Ă��Ȃ���Γǂݍ���
		call	get_mgs_song_title
		ex		de, hl
		call	get_mgs_song_title

		pop		ix		; 2��
		pop		iy		; 1��
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2�ڂ� ENTRY_INDEX][1�ڂ� ENTRY_INDEX]
		push	bc
		ld		b, [ix + FENT_MGS_ATTRIBUTE]
		ld		c, [iy + FENT_MGS_ATTRIBUTE]			; BC = [2�ڂ� ATTRIBUTE][1�ڂ� ATTRIBUTE]
		ld		e, [ix + FENT_MGS_TITLE_ADDRESS + 0]
		ld		d, [ix + FENT_MGS_TITLE_ADDRESS + 1]
		ld		l, [iy + FENT_MGS_TITLE_ADDRESS + 0]
		ld		h, [iy + FENT_MGS_TITLE_ADDRESS + 1]
cbr_compare_common::			; �������͑��̃\�[�g������Ă΂��
		; ATTRIBUTE�`�F�b�N: 1�ڂ̓f�B���N�g�����H
		ld		a, c
		and		a, FIB_ATTR_DIRECTORY
		jp		nz, check_dir

		; ATTRIBUTE�`�F�b�N: 2�ڂ̓f�B���N�g�����H
		ld		a, b
		and		a, FIB_ATTR_DIRECTORY
		pop		bc
		scf
		ret		nz				; 1�ڂ��ȂŁA2�ڂ��f�B���N�g���Ȃ�K������ւ���

		; strcmp( hl, de ) �̌��ʂœ���ւ�����
		call	strcmp
		ret

check_dir:
		; ATTRIBUTE�`�F�b�N: 2�ڂ̓f�B���N�g�����H
		ld		a, b
		and		a, FIB_ATTR_DIRECTORY
		pop		bc
		ret		z				; 2�ڂ��f�B���N�g���łȂ��Ȃ�����ΏۊO (Cy=0)

		ld		a, b			; �����f�B���N�g���Ȃ̂ŁA�G���g�����Ń\�[�g
		cp		a, c
		ret
		endscope

; ==============================================================================
;	cbr_compare_filename (�t�@�C������)
;	input)
;		hl .... 1�ڂ̃G���g��
;		de .... 2�ڂ̃G���g��
;	output)
;		Cy�t���O ... 0: ����ւ��Ȃ�, 1: ����ւ���
;	break)
;		all
; ==============================================================================
		scope	cbr_compare_filename
cbr_compare_filename::
		push	hl
		push	de
		pop		ix		; 2��
		pop		iy		; 1��
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2�ڂ� ENTRY_INDEX][1�ڂ� ENTRY_INDEX]
		push	bc
		ld		b, [ix + FENT_MGS_ATTRIBUTE]
		ld		c, [iy + FENT_MGS_ATTRIBUTE]			; BC = [2�ڂ� ATTRIBUTE][1�ڂ� ATTRIBUTE]
		jp		cbr_compare_common
		endscope

; ==============================================================================
;	cbr_compare_shuffle (�V���b�t��)
;	input)
;		hl .... 1�ڂ̃G���g��
;		de .... 2�ڂ̃G���g��
;	output)
;		Cy�t���O ... 0: ����ւ��Ȃ�, 1: ����ւ���
;	break)
;		all
; ==============================================================================
		scope	cbr_compare_shuffle
cbr_compare_shuffle::
		push	hl
		push	de
		pop		ix		; 2��
		pop		iy		; 1��
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2�ڂ� ENTRY_INDEX][1�ڂ� ENTRY_INDEX]
		push	bc
		ld		b, [ix + FENT_MGS_ATTRIBUTE]
		ld		c, [iy + FENT_MGS_ATTRIBUTE]			; BC = [2�ڂ� ATTRIBUTE][1�ڂ� ATTRIBUTE]

		push	de
		call	get_random								; A, D���W�X�^�j��
		pop		de

		and		a, 0x04
		jp		z, cbr_compare_common
		ex		de, hl
		jp		cbr_compare_common
		endscope

; ==============================================================================
;	fl_buble_sort
;	fl_entry ���o�u���\�[�g���餃\�[�g��� swap_cbr_address �Ŏw�肳��Ă�
;	���[�`���̃A�h���X�ɂ��
; ==============================================================================
		scope	fl_buble_sort
fl_buble_sort::
		ld		a, [fl_files]
		or		a, a					; �t�@�C�������������Ή������Ȃ�
		ret		z
		dec		a						; �t�@�C����������̏ꍇ���������Ȃ�
		ret		z

		call	grp_begin_progress_bar
		ld		bc, 0x0001				; B=���ڃG���g��(0), C=���̃G���g��(1)
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
		; ���ڃG���g�������֑J��
		inc		b
		inc		c
		ld		a, [fl_files]
		cp		a, c
		jr		nz, loop1
		call	grp_end_progress_bar
		ret
		endscope

; ==============================================================================
;	fl_sort_normal (�f�B���N�g���G���g����)
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
;	fl_sort_title (�Ȗ���)
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
;	fl_sort_filename (�t�@�C������)
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
;	fl_sort_shuffle (�V���b�t��)
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
		db			0			; �h���C�u�`�F���W���Ă΂ꂽ�� 1 �ɂȂ�
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
		db			0, 0		; �J�����g�h���C�u�� 'A'�`'H': 2byte�ڂ� ASCIIZ�̒[������
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
		db		0				; ���X�g�Ɋi�[����Ă���G���g���̐�
fl_song_files::
		db		0				; ���X�g�̒��� MGS�t�@�C���̐�
fl_remain_no_read_titles::
		db		0				; ���X�g���̃t�@�C���ŁA�܂��Ȗ��f�[�^���ǂݍ��܂�Ă��Ȃ��f�[�^�̎c��
fl_preload_index::
		db		0				; fl_remain_no_read_titles != 0 �̏ꍇ�ɉɂɂȂ�ƁA�������蒲�ׂ�ԍ�
fl_current_index::
		db		0				; fl_entry +24 �����߂邽�߂̃��[�N�G���A
fl_string_table_bottom::
		dw		0				; ������i�[�̈�̏I���A�h���X

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
fl_entry_fib_size		:= 22	; fl_entry �̒��� FIB�R�s�[�����̃T�C�Y
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