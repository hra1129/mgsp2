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
		; page2 �� ROM, fl_entry_table_init �̃o���N �ɕς���
		ld			a, fl_entry_table_init_bank
		call		enble_page2_bank
		; �u���b�N�]��
		ld			hl, fl_entry_table_init_offset + 0x8000
		ld			de, fl_entry_table
		ld			bc, fl_files * fl_entry_size
		ldir
		; page2 �� RAM�֖߂�
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
		ret			z						;	�f�B���N�g���G���g����(fl_sort_normal)�̏ꍇ�A�\�[�g���̎��s���Ȃ�
		dec			a
		jp			z, fl_sort_title
		dec			a
		jp			z, fl_sort_filename
		jp			fl_sort_shuffle
		endscope

; ==============================================================================
;	���������m�ۂ��Ďw��̃t�@�C���̋Ȗ����擾����
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
		; page2 �� ROM�X���b�g�ɐ؂�ւ��āA�ȃf�[�^�̃o���N�ɐ؂�ւ���
		ld			de, FENT_MGS_BANK_ADDRESS
		add			hl, de
		ld			a, [hl]				; BANK�ԍ�
		inc			hl
		ld			c, [hl]				; �I�t�Z�b�g�A�h���X����
		inc			hl
		ld			b, [hl]				; �I�t�Z�b�g�A�h���X���
		push		bc
		call		enble_page2_bank
		; �Ȗ��f�[�^��]������
		pop			hl					; HL = �I�t�Z�b�g�A�h���X + 0x8008
		ld			bc, 0x8008
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
		ld			[scc_bank2], a		; Konami8K SCC �̏ꍇ�ASCC���W�X�^���o�������Ă����BASCII8K �̏ꍇ�A�Ӗ������� ROM �� 3Fh �������ށB
		; page2 �� RAM�X���b�g�ɖ߂�
		ld			a, [page2_slot]
		ld			h, 0x80
		call		enaslt
		ei
		pop			hl
		ld			a, l
		ret
		endscope

; ==============================================================================
;	get_current_file_entry
;	input)
;		a ................... �Ώۂ̃t�@�C���̔ԍ� (�ꗗ�\�̒��̉��Ԗڂ�)
;	output)
;		hl .................. �w��̃t�@�C���̃t�@�C���̃G���g���A�h���X
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
		add		hl, de					; ���0 �ɂ͂Ȃ�Ȃ��̂ŁAZf = 0
		ret
		endscope

; ==============================================================================
;	fl_swap_entry
;	input)
;		a .... 1st target number
;		b .... 2nd target number
;	comment)
;		swap_cbr_address �� HL, DE �̂Q���W�X�^������ entry �����ւ��锻�胋�[�`��
;		�̃A�h���X����������ł�������
; ==============================================================================
		scope	fl_swap_entry
fl_swap_entry::
		; get 1st target entry address (A)
		push	bc							; 2nd target �ۑ�
		call	get_current_file_entry

		; get 2nd target entry address (B)
		pop		af							; 2nd target ����
		push	hl							; 1st target �� entry �ۑ�
		call	get_current_file_entry
		pop		de							; 1st target entry ����
		push	de							; 1st target entry �ۑ�
		push	hl							; 2nd target entry �ۑ�, ���̎��_�� HL=2nd target entry, DE=1st target entry

		; ���̃G���g�����X���b�v���邩���肷��
swap_cbr_address	:= code_address + 1
		call	cbr_compare_normal
		pop		hl							; 2nd target entry ����
		pop		de							; 1st target entry ����
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
		push	hl		; 1�� �ۑ�
		push	de		; 2�� �ۑ�

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
		push	hl		; 1�� �ۑ�
		push	de		; 2�� �ۑ�

		; �Ȗ����ǂ܂�Ă��Ȃ���Γǂݍ���
		ld		de, sort_song_title1
		ld		b, 62
		call	get_mgs_song_title
		pop		hl		; 2�� ����
		push	hl		; 2�� �ۑ�
		ld		de, sort_song_title2
		ld		b, 62
		call	get_mgs_song_title

		pop		ix		; 2��
		pop		iy		; 1��
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2�ڂ� ENTRY_INDEX][1�ڂ� ENTRY_INDEX]
		ld		hl, sort_song_title1
		ld		de, sort_song_title2
cbr_compare_common::			; �������͑��̃\�[�g������Ă΂��
		; strcmp( hl, de ) �̌��ʂœ���ւ�����
		call	strcmp
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
		push	hl		; 1�� �ۑ�
		push	de		; 2�� �ۑ�
		pop		ix		; 2��
		pop		iy		; 1��
		ld		b, [ix + FENT_MGS_ENTRY_INDEX]
		ld		c, [iy + FENT_MGS_ENTRY_INDEX]			; BC = [2�ڂ� ENTRY_INDEX][1�ڂ� ENTRY_INDEX]
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
		ld		a, fl_files
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
		ld		a, fl_files
		cp		a, c
		jr		nz, loop2

		pop		bc
		; ���ڃG���g�������֑J��
		inc		b
		inc		c
		ld		a, fl_files
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