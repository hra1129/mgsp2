; ==============================================================================
;	Graphic
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

vdp_port0	:=	0x98
vdp_port1	:=	0x99

; ==============================================================================
;	grp_init
;	��ʂ�����������
; ==============================================================================
		scope	grp_init
grp_init::
		; SCREEN 2
		ld		a, [scrmod]
		ld		[oldscr], a

		ld		a, 2
		ld		ix, CHGMOD
		ld		iy, [exptbl - 1]
		call	CALSLT

		; MSX2�ȏ�Ȃ�p���b�g��������
		ld		hl, 0x002D
		ld		a, [exptbl]
		call	RDSLT
		or		a, a
		call	nz, palette_init

		; �p�^�[���l�[�v�e�[�u�����u�����N�p�[�c�Ŗ��ߐs����
		ld		hl, 0x1800
		ld		bc, 768
		ld		d, 114
		call	memset_v

		; �X�v���C�g2�{�p���[�h, 16x16���[�h
		ld		a, [rg1sav]
		or		a, 3
		ld		c, 1
		ld		b, a
		ld		ix, WRTVDP
		call	CALSLT

		; VDP R#7 = 0x00  (�w�i����������)
		ld		c, 7
		ld		b, 0
		ld		ix, WRTVDP
		call	CALSLT

		; Color Table �� 0xF0 �œh��Ԃ�
		ld		hl, 0x2000
		ld		bc, 256 * 8 * 3
		ld		d, 0xF0
		call	memset_v

		; �X�v���C�g�W�F�l���[�^�e�[�u���� 0x00 �œh��Ԃ�
		ld		hl, 0x3800
		ld		bc, 256 * 8
		ld		d, 0
		call	memset_v

		; �o�[�W�����\��
		ld		hl, 89 * 8
		ld		de, mgsp_version
		call	draw_string
		; Copyright
		ld		hl, 100 * 8
		ld		de, mgsp_copyright
		call	draw_string
		; Order
		ld		hl, 175 * 8
		ld		de, mgsp_order
		call	draw_string
		; Drive
		ld		hl, 200 * 8
		ld		de, mgsp_drive
		call	draw_string
		call	grp_update_current_drive
		; ch
		ld		hl, 222 * 8
		ld		de, mgsp_ch
		call	draw_string
		; Volume
		ld		hl, 190 * 8
		ld		de, mgsp_volume
		call	draw_string
		; Speed
		ld		hl, 195 * 8
		ld		de, mgsp_speed
		call	draw_string
		; Auto mode
		ld		hl, 183 * 8
		ld		de, mgsp_automode
		call	draw_string
		; Loop count
		ld		hl, 240 * 8
		ld		de, mgsp_loop_count
		call	draw_string
		; Filename
		ld		hl, 246 * 8
		ld		de, mgsp_filename
		call	draw_string
		; OPLL check
		call	change_mgsdrv_slot
		ld		hl, [mgs_id_mibadr]
		ld		a, [hl]
		inc		a
		ld		de, mgsp_sound_source_logo_not_found_color
		jr		z, opll_is_not_found
		ld		de, mgsp_sound_source_logo_found_color
opll_is_not_found::
		ld		[vram_transfer_item_opll_logo_color], de

		inc		hl
		ld		a, [hl]
		inc		a
		ld		de, mgsp_sound_source_logo_not_found_color
		jr		z, scc_is_not_found
		ld		de, mgsp_sound_source_logo_found_color
scc_is_not_found::
		ld		[vram_transfer_item_scc_logo_color], de

		; �X�N���[���o�[��������
		ld		hl, 0x2000 + (256 + 251) * 8
		ld		bc, 11 * 8
		ld		a, [grp_color_scroll_bar_blank]
		ld		d, a
		call	memset_v

		ld		hl, 0x0000 + (256 + 251) * 8
		ld		bc, 11 * 8
		ld		d, 0x81
		call	memset_v

		; PCG�p�[�c���� VRAM�֓]������
		ld		hl, grp_vram_transfer_table
		call	memcpy_transfer_data

		; ���k���ꂽ�p�^�[���l�[���e�[�u�����������֓W�J����
		call	grp_decompress_pattern_name_table

		; ���x�����[�^�[��\������
		call	grp_update_keyboard_spot

		; �\�����ʕt���Ńp�^�[���l�[���e�[�u��������������VRAM�֓]������
		ei
		ld		b, 32			; for B = 32 to 1 step -1
grp_startup_effect_loop1:
		push	bc
		ld		a, b
		dec		a				; 	DE = (B - 1) * 32 + grp_decompress_area - 8 * 32: HL = (B - 1) * 32 + 0x1800 - 8 * 32
		add		a, a
		add		a, a
		add		a, a
		ld		l, a
		ld		h, 0
		add		hl, hl
		add		hl, hl
		ld		e, l
		ld		d, h
		ld		bc, 0x1800 - 8 * 32
		add		hl, bc
		ex		de, hl
		ld		bc, grp_decompress_area - 8 * 32
		add		hl, bc
		ex		de, hl

		ld		b, 8
grp_startup_effect_loop2:
		push	bc
		push	de
		push	hl
		ld		bc, 4
		ld		a, 0x17
		cp		a, h
		jr		nc, grp_startup_effect_skip
		ld		a, 0x1A
		cp		a, h
		call	nc, memcpy_m2v
grp_startup_effect_skip:
		pop		hl
		pop		de
		ld		bc, 32 + 4
		add		hl, bc
		ex		de, hl
		add		hl, bc
		ex		de, hl
		pop		bc
		djnz	grp_startup_effect_loop2

		pop		bc
		halt
		djnz	grp_startup_effect_loop1
		ret

palette_init:
		di
		ld		c, vdp_port1
		xor		a, a
		out		[c], a
		ld		a, 0x80 + 16
		out		[c], a
		inc		c
		ld		hl, palettes_like_msx1
		ld		b, 32
		otir								; V9938/V9958 �� OTIR �ł����Ȃ�
		ei

		; VDP R#9 �� bit1 �� 0 �ɂ��� (�����I�� NTSC �ɂ���)
		ld		a, [rg9sav]
		and		a, 0b1111_1101				; NT(bit1) = 0.  0:NTSC, 1:PAL
		ld		c, 9
		ld		b, 0
		ld		ix, WRTVDP
		ld		iy, [exptbl - 1]
		call	CALSLT
		ret

palettes_like_msx1:
		db		0x00, 0x00				; 0
		db		0x00, 0x00				; 1
		db		0x33, 0x05				; 2
		db		0x44, 0x06				; 3
		db		0x37, 0x02				; 4
		db		0x47, 0x03				; 5
		db		0x52, 0x03				; 6
		db		0x36, 0x05				; 7
		db		0x62, 0x03				; 8
		db		0x63, 0x04				; 9
		db		0x53, 0x06				; 10
		db		0x64, 0x06				; 11
		db		0x21, 0x04				; 12
		db		0x55, 0x03				; 13
		db		0x55, 0x05				; 14
		db		0x77, 0x07				; 15
		endscope

; ==============================================================================
;	Err�\�� ON
; ==============================================================================
		scope	grp_update_error_indicator
grp_update_error_indicator::
		ld		hl, 0x1800 + 15 + 0 * 32
		call	grp_setwrt

		ld		a, [error_status]
		or		a, a
		jr		z, error_off

		ld		a, 205
		out		[vdp_port0], a
		ld		a, 206
		out		[vdp_port0], a

		; VDP R#7 = flash_pattern  (�w�i�����点��)
		ld		hl, flash_pattern
		ld		c, 7
loop1:
		ld		b, [hl]
		push	bc
		push	hl
		ld		ix, WRTVDP
		ld		iy, [exptbl - 1]
		call	CALSLT
		halt
		halt
		halt
		halt
		pop		hl
		pop		bc
		inc		hl
		inc		b
		dec		b
		jr		nz, loop1
		ret

error_off:
		ld		a, 114
		out		[vdp_port0], a
		ld		a, 114
		out		[vdp_port0], a

		; VDP R#7 = 0x00  (�w�i����������)
		ld		c, 7
		ld		b, 0
		ld		ix, WRTVDP
		ld		iy, [exptbl - 1]
		call	CALSLT
		ret

flash_pattern::
		db		0x06, 0x08, 0x09, 0x0A, 0x0B, 0x0F, 0x0B, 0x0A, 0x09, 0x08, 0x06, 0x00
		endscope

; ==============================================================================
;	�J�����g�h���C�u�̕\�����X�V
; ==============================================================================
		scope	grp_update_current_drive
grp_update_current_drive::
		ld		hl, 203 * 8
		ld		de, current_drive
		call	draw_string
		ret
		endscope

; ==============================================================================
;	����������VRAM�ւ̃u���b�N�]��(�]���p�^�[���f�[�^)
;	input)
;		hl ..... �]���p�^�[���f�[�^�A�h���X
; ==============================================================================
		scope	memcpy_transfer_data
memcpy_transfer_data::
		; get vram_transfer_bytes
		ld		a, [hl]
		or		a, a
		ret		z					; Return when vram_transfer_bytes is 0 (terminator).
		ld		c, a
		inc		hl
		; get vram_repeat_count
		ld		b, [hl]
		inc		hl
		; get source_address
		ld		e, [hl]
		inc		hl
		ld		d, [hl]
		inc		hl
		; get destination_address
		ld		a, [hl]
		inc		hl
		push	hl
		ld		h, [hl]
		ld		l, a
repeat_loop:
		push	de
		push	bc
		ld		b, 0
		call	memcpy_m2v			; RAM(de), VRAM(hl), SIZE(bc)
		pop		bc
		pop		de
		ld		a, b
		ld		b, 0
		add		hl, bc
		ld		b, a
		djnz	repeat_loop
		pop		hl
		inc		hl
		jp		memcpy_transfer_data
		endscope

; ==============================================================================
;	����������VRAM�ւ̃u���b�N�]��
;	input)
;		hl ..... �]����VRAM�A�h���X
;		de ..... �]�����������A�h���X
;		bc ..... �]���o�C�g��
; ==============================================================================
		scope	memcpy_m2v
memcpy_m2v::
		call	grp_setwrt
		
loop:
		ld		a, [de]
		out		[vdp_port0], a
		inc		de
		dec		bc
		ld		a, c
		or		a, b
		jp		nz, loop
		ret
		endscope

; ==============================================================================
;	VRAM���w��̒l�œh��Ԃ�
;	input)
;		hl ..... �]����VRAM�A�h���X
;		d ...... �h��Ԃ��l
;		bc ..... �]���o�C�g��
;	break)
;		af, bc
; ==============================================================================
		scope	memset_v
memset_v::
		call	grp_setwrt

loop:
		ld		a, d
		out		[vdp_port0], a
		dec		bc
		ld		a, c
		or		a, b
		jp		nz, loop
		ret
		endscope

; ==============================================================================
;	grp_term
;	��ʂ̌�n������
; ==============================================================================
		scope	grp_term
grp_term::
		; �X�v���C�g�W�F�l���[�^�e�[�u���� 0x00 �œh��Ԃ�
		ld		hl, 0x3800
		ld		bc, 256 * 8
		ld		d, 0
		call	memset_v

		; �t�@�C�����X�g�̓��e���N���A����
		ld		a, 0
loop0:
		push	af
		call	grp_clear_line
		pop		af
		inc		a
		cp		a, 11
		jr		nz, loop0

		; ��ʂ̃t�F�[�h�A�E�g����
		ld		de, 79							; ���z���Ă��d�Ȃ�Ȃ��悤�� 1�`767�͈̔͂̑f���ɂ���
		ld		hl, 0x1800 + 373
		ld		b, 64
loop1:
		push	bc
		ld		b, 12
loop2:
		push	bc
		; ���ڃA�h���X�� 141 ����������
		push	de
		push	hl
		ld		a, 114
		ld		ix, WRTVRM
		ld		iy, [exptbl - 1]
		call	CALSLT
		pop		hl
		pop		de
		; ���̃A�h���X���v�Z
		add		hl, de
		ld		a, h
		cp		a, 0x1B
		jr		c, skip1
		sub		a, 0x3
		ld		h, a
skip1:
		pop		bc
		djnz	loop2
		; ���荞�ݑ҂�
		halt
		pop		bc
		djnz	loop1

		; 0.1�b �ҋ@
		halt
		halt
		halt
		halt
		halt
		halt

		; ��ʃ��[�h��߂�
		ld		a, [oldscr]
		ld		ix, CHGMOD
		ld		iy, [exptbl - 1]
		call	CALSLT

		; MSX2�ȏ�Ȃ�p���b�g��������
		ld		hl, 0x002D
		ld		a, [exptbl]
		call	RDSLT
		or		a, a
		ret		z

		ld		ix, sub_iniplt
		ld		iy, [exbrsa - 1]
		jp		CALSLT
		endscope

; ==============================================================================
;	grp_update_scroll_bar
; ==============================================================================
		scope	grp_update_scroll_bar
grp_update_scroll_bar::
		ld		hl, 0x2000 + (256 + 251) * 8
		call	grp_setwrt

		; �t�@�C���E�f�B���N�g���̉��}�� 12 �ɖ����Ȃ��ꍇ�̓X�N���[���o�[�͕\�����Ȃ� (no_scroll)
		ld		a, [fl_files]			; �t�@�C���E�f�B���N�g���̑���
		cp		a, 12
		jr		c, no_scroll

		; �X�N���[���o�[�̑S���� 88[dot]
		ld		c, a
		ld		a, [grp_top_file]
		call	grp_calc_scroll_pos		; A = grp_top_file[file] * 88[dot] / fl_files[file]
		ld		[save_a], a
		or		a, a
		jr		z, skip1
		ld		b, a
		ld		c, vdp_port0
		ld		a, [grp_color_scroll_bar_blank]
loop2:
		nop								; VDP�҂�
		nop								; VDP�҂�
		nop								; VDP�҂�
		out		[c], a
		djnz	loop2
skip1:
		; �X�N���[���o�[�̂܂݂̃T�C�Y�� 11[file] * 88[dot] / fl_files[file]
		ld		a, [fl_files]
		ld		c, a
		ld		a, 11
		call	grp_calc_scroll_pos
		ld		b, a
		ld		a, [save_a]
		add		a, b
		ld		[save_a], a
		ld		c, vdp_port0
		ld		a, [grp_color_scroll_bar_knob]
loop3:
		nop								; VDP�҂�
		nop								; VDP�҂�
		nop								; VDP�҂�
		out		[c], a
		djnz	loop3

		ld		a, [save_a]
		ld		b, a
		ld		a, 88
		sub		a, b
		ret		c
		ret		z
		ld		b, a
		ld		c, vdp_port0
		ld		a, [grp_color_scroll_bar_blank]
loop4:
		nop								; VDP�҂�
		nop								; VDP�҂�
		nop								; VDP�҂�
		out		[c], a
		djnz	loop4
		ret

		; �X�N���[�����Ȃ��ꍇ
no_scroll:
		ld		b, 11 * 8
		ld		c, vdp_port0
		ld		a, [grp_color_scroll_bar_none]
loop1:
		nop								; VDP�҂�
		nop								; VDP�҂�
		nop								; VDP�҂�
		out		[c], a
		djnz	loop1
		ret
save_a:
		db		0
		endscope

; ==============================================================================
;	a = a * 88 / c : a = 0�`191, c = 0�`191, �K�� a <= c
;	break)
;	af, bc, de, hl
; ==============================================================================
		scope	grp_calc_scroll_pos
grp_calc_scroll_pos::
		; HL = a * 88 = a * 8 * (8 + 1 + 1 + 1)
		ld		l, a
		ld		h, 0
		add		hl, hl
		add		hl, hl
		add		hl, hl
		ld		d, h		; DE = A * 8
		ld		e, l
		add		hl, hl
		add		hl, hl
		add		hl, hl		; HL = A * 64
		add		hl, de		; HL = A * 72
		add		hl, de		; HL = A * 80
		add		hl, de		; HL = A * 88
		; HL / C
		ld		a, l
		ld		l, h
		ld		h, 0
		ld		e, c
		ld		d, h
		; C = HL / DE, ��88���z���邱�Ƃ͂Ȃ�
		ld		b, 8		; H �� 8bit
		ld		c, h		; �����i�[���郌�W�X�^
loop1:
		sla		a			; HL.A �� 1bit ���V�t�g
		rl		l
		rl		h			; �K�� Cy = 0 �ɂȂ�
		sbc		hl, de		; �����Ɉ����Ă݂�
		jr		nc, skip1	; �������ꍇ�� skip1 ��
		add		hl, de		; �����Ȃ�����(MSB���؂肪��������:Cy=1)�ꍇ�͑����߂�
skip1:
		rl		c			; �������ꍇ�� C��LSB�� 0, �����Ȃ������ꍇ�� 1 ������
		djnz	loop1
		ld		a, c
		cpl					; �ebit �́A�������ꍇ�� 1�A�����Ȃ������ꍇ�� 0 �ɂ������̂Ŕ��]
		ret
		endscope

; ==============================================================================
;	grp_update_speed
;	�Đ����x�\�����X�V����
; ==============================================================================
		scope	grp_update_speed
grp_update_speed::
		ld		a, [song_speed]

		; 100�̈�
		ld		l, '0'
		cp		a, 100
		jp		c, skip1
		inc		l
		sub		a, 100
skip1:
		cp		a, 100
		jp		c, skip2
		inc		l
		sub		a, 100
skip2:
		; 10�̈�
		ld		h, '0'
		cp		a, 50
		jp		c, skip10
		inc		h
		inc		h
		inc		h
		inc		h
		inc		h
		sub		a, 50
skip10:
		cp		a, 30
		jp		c, skip20
		inc		h
		inc		h
		inc		h
		sub		a, 30
skip20:
		cp		a, 20
		jp		c, skip30
		inc		h
		inc		h
		sub		a, 20
skip30:
		cp		a, 10
		jp		c, skip40
		inc		h
		sub		a, 10
skip40:
		; 1�̈�
		add		a, '0'
		ld		[mgsp_speed_value], hl
		ld		[mgsp_speed_value + 2], a
		; �`�揈��
		ld		hl, 197 * 8
		ld		de, mgsp_speed_value
		call	draw_string
		ret
		endscope

; ==============================================================================
;	grp_update_master_volume
;	�}�X�^�[�{�����[���\�����X�V����
;	input)
;		a ..... �}�X�^�[�{�����[�� (0���ő�, 15���ŏ�)
; ==============================================================================
		scope	grp_update_master_volume
grp_update_master_volume::
		add		a, a
		ld		l, a
		ld		h, 0
		ld		de, grp_volume_table
		add		hl, de
		ld		d, [hl]
		inc		hl
		ld		e, [hl]

		ld		hl, 192 * 8
		ld		bc, 8
		call	memset_v

		ld		hl, 193 * 8
		ld		bc, 8
		ld		d, e
		jp		memset_v
		endscope

; ==============================================================================
;	grp_begin_progress_bar
;	�v���O���X�o�[��\������
; ==============================================================================
		scope	grp_begin_progress_bar
grp_begin_progress_bar::
		; �i���o�[�X�v���C�g�̐F���w��
		ld		a, 15
		ld		[mgsp_progress_bar +  0 + 3], a
		ld		[mgsp_progress_bar +  4 + 3], a
		ld		a, 1
		ld		[mgsp_progress_bar +  8 + 3], a
		ld		[mgsp_progress_bar + 12 + 3], a
		xor		a, a
		ld		[mgsp_progress_bar_state], a
		; �w�肵���A�g���r���[�g�� VRAM �փR�s�[
		ld		hl, 0x1B00 + 16 * 4
		ld		de, mgsp_progress_bar
		ld		bc, 4 * 4
		jp		memcpy_m2v
		endscope

; ==============================================================================
;	grp_end_progress_bar
;	�v���O���X�o�[���B��
; ==============================================================================
		scope	grp_end_progress_bar
grp_end_progress_bar::
		; �i���o�[�X�v���C�g�̐F���w��
		xor		a, a
		ld		[mgsp_progress_bar +  0 + 3], a
		ld		[mgsp_progress_bar +  4 + 3], a
		ld		[mgsp_progress_bar +  8 + 3], a
		ld		[mgsp_progress_bar + 12 + 3], a
		; �w�肵���A�g���r���[�g�� VRAM �փR�s�[
		ld		hl, 0x1B00 + 16 * 4
		ld		de, mgsp_progress_bar
		ld		bc, 4 * 4
		jp		memcpy_m2v
		endscope

; ==============================================================================
;	grp_update_progress_bar
;	�v���O���X�o�[���X�V
; ==============================================================================
		scope	grp_update_progress_bar
grp_update_progress_bar::
		; �i���o�[�̃p�^�[����I��
		ld		a, [mgsp_progress_bar_state]
		and		a, 0xFC
		ld		l, a
		ld		h, 0
		ld		de, mgsp_progress_bar_point
		add		hl, de
		ex		de, hl
		; �i���o�[�̃p�^�[���� VRAM �ɏ�������
		ld		hl, 0x3800 + 72 * 8
		call	grp_setwrt
		call	vpoke
		ld		hl, 0x3800 + 74 * 8
		call	grp_setwrt
		call	vpoke
		ld		hl, 0x3800 + 76 * 8
		call	grp_setwrt
		call	vpoke
		ld		hl, 0x3800 + 78 * 8
		call	grp_setwrt
		call	vpoke
		; �i���o�[�̏�Ԃ�J��
		ld		a, [mgsp_progress_bar_state]
		inc		a
		ld		[mgsp_progress_bar_state], a
		cp		a, 11 * 4
		ret		c
		xor		a, a
		ld		[mgsp_progress_bar_state], a
		ret
vpoke:
		ld		a, [de]
		out		[vdp_port0], a
		nop
		nop
		nop
		inc		de
		out		[vdp_port0], a
		nop
		nop
		nop
		ret
		endscope

; ==============================================================================
;	grp_update_file_list
;	�t�@�C���ꗗ�\�����X�V����
;	input)
;		a ................... 0: �ʏ�, 1: �����S���t���b�V��
;		[fl_files] .......... �ꗗ�\�Ɋi�[����Ă���t�@�C����
;		[fl_select_file] .... �I�𒆂̃t�@�C���̔ԍ� (�ꗗ�\�̒��̉��Ԗڂ�)
; ==============================================================================
		scope	grp_update_file_list
grp_update_file_list::
		push	af
		; ��[�I���s���I��\���ɂ���
		call	grp_unselect_playing_line
		call	grp_unselect_line
		; �t�@�C�������݂���ꍇ�A�ꗗ�̈�ԏ�ɕ\�������G���g���ԍ������߂�
		call	grp_get_top_entry_number
		push	af
		call	grp_playing_line
		pop		af
		ld		b, a

		or		a, a
		jp		z, skip_do_update_check

		pop		af
		or		a, a
		jr		nz, do_update			; fource update
		push	af

skip_do_update_check:
		pop		af
		ld		a, b
		or		a, a
		jp		z, clear_space
		dec		a
		jp		z, grp_select_line

do_update:
		ld		a, [grp_top_file]
		ld		b, 0
		ld		c, a
loop:
		push	bc
		ld		a, c
		call	get_current_file_entry
		push	hl
		; grp_draw_file_line �� ' '�Ńt�B��
		ld		hl, grp_draw_file_line
		ld		de, grp_draw_file_line + 1
		ld		bc, 62
		ld		a, ' '
		ld		[hl], a
		ldir
		xor		a, a
		ld		[de], a
		; �Ȗ��ǂ�łȂ���Γǂ�
		pop		de
		push	de
		call	get_mgs_song_title
		; �f�B���N�g�����H MGS�t�@�C�����H
		pop		ix
		ld		a, [ix + FENT_MGS_TITLE_ADDRESS]
		or		a, [ix + FENT_MGS_TITLE_ADDRESS + 1]
		jp		z, draw_directory
		; MGS�t�@�C���̏ꍇ
draw_mgs_file:
		; -- �Ȗ��\�����[�h���H �t�@�C�����\�����[�h���H
		ld		a, [grp_file_list_mode]					; 0: �Ȗ��\�����[�h, 1: �t�@�C�����\�����[�h
		or		a, a
		jp		nz, draw_mgs_file_name
		; -- �Ȗ����o�b�t�@�փR�s�[����
		ld		l, [ix + FENT_MGS_TITLE_ADDRESS]
		ld		h, [ix + FENT_MGS_TITLE_ADDRESS + 1]
		jp		skip1
draw_mgs_file_name:
		push	ix
		pop		hl
skip1:
		; -- �Ȗ������݂��邩�m�F
		ld		a, [hl]
		cp		a, ' '
		jr		nc, do_title_copy

		; -- �Ȗ������݂��Ȃ��ꍇ�͑���̕������\������ "No title (file name)"
		push	ix
		ld		hl, 0x2020
		ld		[grp_no_title_file_name + 0], hl
		ld		[grp_no_title_file_name + 2], hl
		ld		[grp_no_title_file_name + 4], hl
		ld		[grp_no_title_file_name + 6], hl
		pop		hl
		ld		de, grp_no_title_file_name
		ld		b, 8
filename_copy_loop:
		ld		a, [hl]
		cp		a, '.'
		jr		z, filename_copy_loop_exit
		ld		[de], a
		inc		hl
		inc		de
		djnz	filename_copy_loop
filename_copy_loop_exit:
		ld		hl, grp_no_title

do_title_copy:
		ld		de, grp_draw_file_line
		ld		b, 62
title_copy_loop:
		ld		a, [hl]
		cp		a, ' '
		jr		c, title_copy_loop_exit
		ld		[de], a
		inc		hl
		inc		de
		djnz	title_copy_loop
title_copy_loop_exit:

		; �`�悷��
		pop		bc
		push	bc
		ld		a, b
		call	grp_get_line_address
		ld		de, grp_draw_file_line
		call	draw_string
		pop		bc
		inc		c
		inc		b
		ld		a, c
		ld		hl, fl_files
		cp		a, [hl]
		ld		a, b
		jr		z, clear_space
		cp		a, 11
		jp		c, loop
clear_space_exit:
		call	grp_select_line
		jp		grp_update_scroll_bar
clear_space::
		cp		a, 11					; 0�`10���L�����C��, ������z������I��
		jp		nc, clear_space_exit
		push	af
		call	grp_clear_line
		pop		af
		inc		a
		jr		clear_space

		; �f�B���N�g���̏ꍇ
draw_directory:
		; -- �L�����o�b�t�@�փR�s�[����
		ld		hl, grp_directory_mark
		ld		de, grp_draw_file_line
		ld		bc, 6
		ldir
		push	ix
		pop		hl
		ld		b, 62 - 6
		jr		title_copy_loop
		endscope

; ==============================================================================
;	grp_get_top_entry_number
;	��ԏ�ɕ\������G���g���̔ԍ������߂�
;	input)
;		[fl_files] .......... �ꗗ�\�Ɋi�[����Ă���t�@�C����
;		[grp_select_file] ... �I�𒆂̃t�@�C���̔ԍ� (�ꗗ�\�̒��̉��Ԗڂ�)
;		[grp_top_file] ...... ���݈�ԏ�ɕ\������Ă���t�@�C���̔ԍ�
;	output)
;		[grp_top_file] ......... ��ԏ�̃t�@�C���̔ԍ�
;		[grp_select_line_no] ... �I�𒆂̃��C���ԍ�
;		Zf ..................... 1: �t�@�C�����P���Ȃ�, 0: �ʏ�
;		a ...................... 0: �t�@�C��������, 1: �X�N���[�����Ȃ�, 2: ��ɃX�N���[��, 3: ���ɃX�N���[��
; ==============================================================================
		scope	grp_get_top_entry_number
grp_get_top_entry_number::
		ld		a, [fl_files]
		or		a, a
		ret		z
		; �ꗗ�ɑ��݂���t�@�C���� 11�ȉ��̏ꍇ�A�������ɑS���\������
		ld		a, [grp_top_file]
		ld		b, a
		ld		a, [grp_select_file]
		cp		a, b				; [grp_select_file] < [grp_top_file]
		jr		c, up_move

		; [grp_select_file] >= [grp_top_file] �̏ꍇ
		ld		c, a
		ld		a, b
		add		a, 10
		cp		a, c				; ([grp_top_file] + 10) < [grp_select_file]
		jr		c, down_move

		; [grp_select_file] >= [grp_top_file] && ([grp_top_file] + 10) >= [grp_select_file] �̏ꍇ (�X�N���[�����Ȃ��ꍇ)
		ld		a, [grp_top_file]
		ld		b, a
		ld		a, c
		sub		a, b
		ld		[grp_select_line_no], a
		inc		a
		ld		a, 1
		ret							; Zf = 0

		; [grp_select_file] < [grp_top_file] �̏ꍇ�́A [grp_top_file] = [grp_select_file] �ɂ���
up_move:
		ld		[grp_top_file], a
		xor		a, a
		ld		[grp_select_line_no], a
		inc		a
		ld		a, 2
		ret							; Zf = 0

		; ([grp_top_file] + 10) < [grp_select_file] �̏ꍇ�́A [grp_top_file] = [grp_select_file] - 10 �ɂ���
down_move:
		ld		a, c
		sub		a, 10
		ld		[grp_top_file], a
		ld		a, 10
		ld		[grp_select_line_no], a
		ld		a, 3
		ret							; Zf = 0
		endscope

; ==============================================================================
;	���[�v�J�E���g�̕\�����X�V����
;	input)
;		a ..... ���[�v�J�E���g
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope	grp_update_loop_count
grp_update_loop_count::
		ld		hl, 243 * 8
		jp		draw_number
		endscope

; ==============================================================================
;	���[�h�\�����X�V����
;	input)
;		a ..... ���[�h�ԍ� (0: Normal, 1: Random, 2: Repeat)
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope	grp_update_mode_info
grp_update_mode_info::
		add		a, a
		add		a, a
		add		a, a
		ld		l, a
		ld		h, 0
		ld		de, mgsp_normal_mode
		add		hl, de
		ex		de, hl
		ld		hl, 186 * 8
		jp		draw_string
		endscope

; ==============================================================================
;	�\�[�g���[�h�\�����X�V����
;	input)
;		a ..... ���[�h�ԍ�
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope	grp_update_sort_mode_info
grp_update_sort_mode_info::
		add		a, a
		add		a, a
		add		a, a
		ld		l, a
		ld		h, 0
		ld		de, mgsp_order_entry
		add		hl, de
		ex		de, hl
		ld		hl, 178 * 8
		jp		draw_string
		endscope

; ==============================================================================
;	draw_number
;	���l��`�悷��
;	input)
;		hl .... �`�悷��p�^�[���W�F�l���[�^�[�e�[�u���̃A�h���X
;		a ..... �`�悷�鐔�l (0�`99)
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope	draw_number
draw_number::
		ld		b, 0
		cp		a, 50
		jp		c, skip1
		sub		a, 50
		ld		b, 5
skip1:
		cp		a, 30
		jp		c, skip2
		sub		a, 30
		inc		b
		inc		b
		inc		b
skip2:
		cp		a, 20
		jp		c, skip3
		sub		a, 20
		inc		b
		inc		b
skip3:
		cp		a, 10
		jp		c, skip4
		sub		a, 10
		inc		b
skip4:
		add		a, '0'
		ld		[s_number + 1], a
		ld		a, b
		ld		b, '0'
		or		a, a
		jp		nz, skip_number
		ld		b, ' '
skip_number:
		add		a, b
		ld		[s_number], a
		ld		de, s_number
		jp		draw_string
s_number:
		db		0, 0, 0
		endscope

; ==============================================================================
;	draw_string
;	�������`�悷��
;	input)
;		hl .... �`�悷��p�^�[���W�F�l���[�^�[�e�[�u���̃A�h���X
;		de .... �`�悷�镶���� (MAX 30����, ASCIIZ)
;	output)
;		a ..... 0: �I�[, 1�`255: ���̕��� (kanji_work �Ɏ��܂�Ȃ�����)
;	break)
;		all
; ==============================================================================
		scope	draw_string
draw_string::
		call	grp_setwrt
		call	put_string
		dec		b
		inc		b
		ret		z						; ���� 0 �Ȃ甲����
		ld		c, vdp_port0
transfer_loop:
		outi
		jr		nz, transfer_loop		; OTIR���Ƒ�������
		ret
		endscope

; ==============================================================================
;	grp_draw_keyboard_spot
;	�L�[�{�[�h�̋P�_��`�悷��
; ==============================================================================
		scope	grp_draw_keyboard_spot
grp_draw_keyboard_spot::
		ld		hl, 0x3800
		call	grp_setwrt

		ld		hl, mgsp_keyboard_spot_pattern
		ld		bc, (4 << 8) | vdp_port0
		ld		d, 0
loop_row:
		push	bc
		ld		b, 7
loop_column:
		ld		a, [hl]
		out		[c], a
		inc		hl
		push	bc
		ld		b, 14
		out		[c], a
loop_blank:
		nop						; VDP�҂�
		nop						; VDP�҂�
		nop						; VDP�҂�
		out		[c], d
		djnz	loop_blank
		pop		bc
		djnz	loop_column

		ld		b, 16
loop_right_blank:
		nop						; VDP�҂�
		nop						; VDP�҂�
		nop						; VDP�҂�
		out		[c], d
		djnz	loop_right_blank
		pop		bc
		djnz	loop_row
		ret
		endscope

; ==============================================================================
;	grp_update_keyboard_spot
;	�L�[�{�[�h�̋P�_���X�V����
;	input)
;		track_work_area .. �g���b�N���[�N�G���A�̐擪�A�h���X
;		track_size ....... �g���b�N���[�N�G���A��1�g���b�N���̃o�C�g��
;	output)
;		a ................ ���t���̃g���b�N�̐�
; ==============================================================================
		scope	grp_update_keyboard_spot
grp_update_keyboard_spot::
		call	change_mgsdrv_slot
		ld		iy, [mgs_id_trwadr]
		; �S�N���A
		ld		hl, mgsp_keyboard_spot_pattern
		ld		de, mgsp_keyboard_spot_pattern + 1
		ld		bc, 28 - 1
		xor		a, a
		ld		[hl], a
		ldir

		; �g�[�����𓾂�
		ld		b, 17								; 17[tracks]
		ld		d, 0
track_loop:
		ld		a, [iy + mgs_twa_track_state]		; 0:OFF, 1:ON, 2:MUTE
		dec		a
		jp		nz, track_end						; OFF �܂��� ���� �Ȃ� track_end ��

		ld		a, [iy + mgs_twa_gate_time_cnt + 1]
		or		a, a
		jp		m, track_end						; GATE�^�C���J�E���^�����Ȃ� track_end ��
		or		a, [iy + mgs_twa_gate_time_cnt + 0]
		jp		z, track_end						; GATE�^�C���J�E���^�� 0�Ȃ� track_end ��

		ld		a, [iy + mgs_twa_note_no]
		cp		a, 12								; �x��
		jp		nc, track_end
		ld		c, a

		ld		a, [iy + 0x15]						; �I�N�^�[�u (0�`7)

		; A = 12 * A = (2 * 2 * 2 + 2 * 2) * A
		add		a, a
		add		a, a
		ld		e, a
		add		a, a
		add		a, e

		add		a, c								; A = ����: 0�`95
		ld		e, a

		ld		hl, mgsp_tone_to_keyboard
		add		hl, de
		add		hl, de

		ld		e, [hl]
		inc		hl
		ld		a, [hl]

		ld		hl, mgsp_keyboard_spot_pattern
		add		hl, de
		or		a, [hl]
		ld		[hl], a

track_end:
		ld		de, [mgs_id_trwsiz]
		add		iy, de
		djnz	track_loop
		call	grp_draw_keyboard_spot
		call	grp_update_track_volume
		ret
		endscope

; ==============================================================================
;	grp_get_line_address
;	�t�@�C���ꗗ��ʂ̃p�^�W�F�l�A�h���X�����߂�
;	input)
;		a ....... �s�ԍ� 0~10
;	output)
;		hl ...... �p�^�W�F�l�̃A�h���X
;	break)
;		f, de
; ==============================================================================
		scope	grp_get_line_address
grp_get_line_address::
		ld		l, a
		ld		h, 0
		ld		de, mgsp_filename_line
		add		hl, de
		ld		l, [hl]
		ld		h, 0
		add		hl, hl
		add		hl, hl
		add		hl, hl
		ld		de, 0x800
		add		hl, de
		cp		a, 5
		ret		c
		add		hl, de
		ret
		endscope

; ==============================================================================
;	grp_set_line_address
;	�t�@�C���ꗗ��ʂ̃p�^�W�F�l�A�h���X��VDP�ɃZ�b�g����
;	input)
;		a ....... �s�ԍ� 0~10
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_set_line_address
grp_set_line_address::
		call	grp_get_line_address
		call	grp_setwrt
		ret
		endscope

; ==============================================================================
;	grp_clear_line
;	�t�@�C���ꗗ��ʂ̎w�胉�C�����N���A����
;	input)
;		a ....... �s�ԍ� 0~10
;	output)
;		--
;	break)
;		af, bc, de, hl, ix, iy
; ==============================================================================
		scope	grp_clear_line
grp_clear_line::
		call	grp_get_line_address
		; �p�^�W�F�l�� 0x00�N���A
		ld		bc, 31 * 8
		ld		d, 0
		call	memset_v
		; �J���[�e�[�u���� 0xF0�N���A
		ld		bc, 0x2000
		add		hl, bc
		ld		bc, 31 * 8
		ld		d, 0xF0
		call	memset_v
		ret
		endscope

; ==============================================================================
;	grp_show_exit_dialog
;	�I���_�C�A���O��\��
; ==============================================================================
		scope	grp_show_exit_dialog
grp_show_exit_dialog::
		ld		hl, 0x2000 + (256 + 201) * 8
		ld		de, grp_color_exit_dialog_top
		ld		b, 8
		call	transfer8

		ld		hl, 0x2000 + (256 + 256 + 49) * 8
		ld		de, grp_color_exit_dialog_bottom
		ld		b, 8
		call	transfer8

		ld		hl, 0x2000 + (256 + 232) * 8
		ld		bc, 8
		ld		a, [grp_color_exit_dialog_middle]
		ld		d, a
		call	memset_v

		ld		hl, 0x2000 + (256 + 239) * 8
		ld		bc, 8
		ld		a, [grp_color_exit_dialog_middle]
		ld		d, a
		call	memset_v

		ld		hl, 0x2000 + (256 + 256 + 18) * 8
		ld		bc, 8
		ld		a, [grp_color_exit_dialog_middle]
		ld		d, a
		call	memset_v

		ld		hl, 0x2000 + (256 + 256 + 25) * 8
		ld		bc, 8
		ld		a, [grp_color_exit_dialog_middle]
		ld		d, a
		call	memset_v

		ld		hl, (256 + 233) * 8
		ld		de, grp_mgs_exit_dialog1
		call	draw_string

		ld		hl, (256 + 256 + 19) * 8
		ld		de, grp_mgs_exit_dialog2
		call	draw_string

		ld		a, 1
		ld		[grp_yes_no], a
		call	grp_update_exit_dialog_cursor
		ret

transfer8:
		push	bc
		push	de
		push	hl
		ld		bc, 8
		call	memcpy_m2v
		pop		hl
		ld		bc, 8
		add		hl, bc
		pop		de
		pop		bc
		djnz	transfer8
		ret
		endscope

; ==============================================================================
;	grp_update_exit_dialog_cursor
;	�I���_�C�A���O�� YES/NO �J�[�\���̕\�����X�V����
; ==============================================================================
		scope	grp_update_exit_dialog_cursor
grp_update_exit_dialog_cursor::
		; Yes
		ld		a, [grp_yes_no]
		or		a, a
		ld		a, 0xF1
		jr		nz, skip1
		ld		a, [grp_color_cursor]
skip1:
		ld		hl, 0x2000 + (256 + 256 + 19) * 8
		ld		d, a
		ld		bc, 3 * 8
		call	memset_v

		; No
		ld		a, [grp_yes_no]
		or		a, a
		ld		a, 0xF1
		jr		z, skip2
		ld		a, [grp_color_cursor]
skip2:
		ld		hl, 0x2000 + (256 + 256 + 22) * 8
		ld		d, a
		ld		bc, 3 * 8
		jp		memset_v
		endscope

; ==============================================================================
;	grp_show_help
;	�w���v��\��
; ==============================================================================
		scope	grp_show_help
grp_show_help::
		xor		a, a
		ld		[grp_select_line_on], a
clear_loop:
		push	af
		call	grp_clear_line
		pop		af
		inc		a
		cp		a, 11
		jr		nz, clear_loop

		xor		a, a
		ld		hl, grp_help_table
loop1:
		push	af
		ld		e, [hl]
		inc		hl
		ld		d, [hl]
		inc		hl
		push	hl
		push	de
		call	grp_get_line_address
		pop		de
		call	draw_string
		pop		hl
		pop		af
		inc		a
		cp		a, 11
		jp		nz, loop1
		ret
		endscope

; ==============================================================================
;	grp_select_line
;	�t�@�C���ꗗ��ʂ̎w��̍s��I��\���ɕύX����
;	input)
;		[grp_select_line_no] ... ���݂̑I���s
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_select_line
grp_select_line::
		ld		a, [fl_files]
		or		a, a
		ret		z
		ld		a, [grp_select_line_on]
		or		a, a
		ret		z
		ld		a, [grp_select_line_no]
		call	grp_get_line_address
		ld		de, 0x2000
		add		hl, de

		ld		a, [grp_top_file]
		ld		b, a
		ld		a, [grp_play_file]
		sub		a, b
		ld		c, a
		ld		a, [grp_select_line_no]
		cp		a, c

		; �I����Ԃ̐F�� �O�i ��, �w�i ���C�g�C�G���[
		ld		a, [grp_color_cursor]
		ld		d, a
		jr		nz, skip1

		; �I����Ԃ��Đ����̐F�� �O�i ��, �w�i ���C�g���b�h
		ld		a, [grp_color_cursor_playing]
		ld		d, a

skip1:
		ld		bc, 31 * 8
		jp		memset_v
		endscope

; ==============================================================================
;	grp_playing_line
;	�t�@�C���ꗗ��ʂ̍Đ����̋Ȃ̍s�������\���ɕύX����
;	input)
;		[grp_play_file] ... ���ݍĐ����̋Ȕԍ� (���I���o�[�̈ʒu�Ȃ牽�����Ȃ�)
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_playing_line
grp_playing_line::
		ld		a, [fl_files]
		or		a, a
		ret		z
		ld		a, [grp_select_line_on]
		or		a, a
		ret		z
		ld		a, [grp_top_file]
		ld		b, a
		ld		a, [grp_play_file]
		sub		a, b
		ld		c, a
		ld		a, [grp_select_line_no]
		cp		a, c
		ret		z
		ld		a, c
		cp		a, 11
		ret		nc

		call	grp_get_line_address
		ld		de, 0x2000
		add		hl, de

		; �Đ����̐F�� �O�i ��, �w�i �_�[�N���b�h
		ld		a, [grp_color_playing]
		ld		d, a
		ld		bc, 31 * 8
		jp		memset_v
		endscope

; ==============================================================================
;	grp_unselect_playing_line
;	�t�@�C���ꗗ��ʂ̍Đ����̋Ȃ̍s�������\���ɕύX����
;	input)
;		[grp_play_file] ... ���ݍĐ����̋Ȕԍ� (���I���o�[�̈ʒu�Ȃ牽�����Ȃ�)
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_unselect_playing_line
grp_unselect_playing_line::
		ld		a, [grp_top_file]
		ld		b, a
		ld		a, [grp_play_file]
		sub		a, b
		ld		c, a
		ld		a, [grp_select_line_no]
		cp		a, c
		ret		z
		ld		a, c
		cp		a, 11
		ret		nc

		call	grp_get_line_address
		ld		de, 0x2000
		add		hl, de

		; �Đ����̐F�� �O�i ��, �w�i ��
		ld		d, 0xF0
		ld		bc, 31 * 8
		jp		memset_v
		endscope

; ==============================================================================
;	grp_unselect_line
;	�t�@�C���ꗗ��ʂ̎w��̍s���I��\���ɕύX����
;	input)
;		[grp_select_line_no] ... ���݂̑I���s
;	output)
;		--
;	break)
;		af, de, ix, iy
; ==============================================================================
		scope	grp_unselect_line
grp_unselect_line::
		ld		a, [grp_select_line_no]
		call	grp_get_line_address
		ld		de, 0x2000
		add		hl, de

		ld		bc, 31 * 8
		; �I����Ԃ̐F�� �O�i ��, �w�i ��
		ld		d, 0xF0
		jp		memset_v
		endscope

; ==============================================================================
;	grp_update_track_volume
;	�g���b�N���Ƃ̉��ʕ\�����X�V
;	input)
;		track_work_area .. �g���b�N���[�N�G���A�̐擪�A�h���X
;		track_size ....... �g���b�N���[�N�G���A��1�g���b�N���̃o�C�g��
;	output)
;		a ................ ���t���̃g���b�N�̐�
; ==============================================================================
		scope	grp_update_track_volume
grp_update_track_volume::
		ld		b, 17				; 17[tracks]
		ld		iy, [mgs_id_trwadr]
		ld		ix, grp_track_volume

		; �g�[�����𓾂�
track_loop:
		ld		e, [iy + mgs_twa_track_state]		; track status  0:OFF, 1:ON, 2:MUTE
		ld		d, [iy + mgs_twa_track_volume]		; track volume
		dec		e
		jp		nz, track_key_off

		ld		a, [iy + mgs_twa_flag]				; �t���O
		ld		e, a
		and		a, 0xE7
		ld		[iy + mgs_twa_flag], a
		bit		4, e								; bit4 is key on flag
		jp		nz, track_key_on
track_decay:
		ld		a, [ix + 0]							; current volume
		or		a, a
		jp		z, track_key_off
		dec		a
		ld		[ix + 0], a							; update current volume
		jp		skip1

track_key_off:
		xor		a, a
		ld		[ix + 0], a
		jp		skip1

track_key_on:						; key on, off �̃t���O�͌��Օ\���X�V�� track_note_off �ŃN���A
		ld		a, d				; track volume
		ld		[ix + 0], a			; current volume
skip1:
		ld		[ix + 1], d			; track volume level
		ld		de, [mgs_id_trwsiz]
		add		iy, de
		inc		ix
		inc		ix
		djnz	track_loop

		; Update volume level display. �\�����͍̂��E�̂ǂ��炩����������������
		ld		c, vdp_port0
		ld		hl, 0x0000
		call	grp_setwrt
		ld		b, 17				; 17[tracks]
		ld		hl, grp_track_volume

grp_update_track_volume_sub:
		push	bc
		ld		b, [hl]				; current volume level
		inc		hl
		ld		d, [hl]				; track volume level
		inc		hl
		inc		b
		ld		a, 15
draw_track_volume_loop:
		ld		e, 0xDE
		cp		a, d
		jp		z, draw_track_volume_skip1
		cp		a, b
		jp		c, draw_track_volume_skip1
		ld		e, 0xC0
draw_track_volume_skip1:
		out		[c], e
		ld		e, 0
		nop							; VDP�҂�
		dec		a
		out		[c], e
		jp		p, draw_track_volume_loop
		pop		bc
		djnz	grp_update_track_volume_sub

		; track on/off switch
		ld		hl, 0x1800 + (5 * 32 + 15)
		call	grp_setwrt

		ld		c, vdp_port0
		ld		iy, [mgs_id_trwadr]
		ld		de, [mgs_id_trwsiz]
		ld		b, 17				; 17[tracks]
		ld		h, 0
track_sw_loop:
		ld		a, [iy + mgs_twa_track_state]		; track status  0:OFF, 1:ON, 2:MUTE
		or		a, a
		jp		z, track_no_active
		inc		h
track_no_active:
		add		a, 68
		out		[c], a
		add		iy, de
		djnz	track_sw_loop
		ld		a, h
		ret
		endscope

; ==============================================================================
;	BIOS SETWRT Compatible Routine
;	input)
;		hl ...... Target VRAM address
;	output)
;		None
;	break)
;		af
; ==============================================================================
		scope	grp_setwrt
grp_setwrt::
		ld		a, l
		di
		out		[vdp_port1], a
		ld		a, h
		or		a, 0x40
		out		[vdp_port1], a
		ei
		ret
		endscope

; ==============================================================================
;	Decompress pattern name table
; ==============================================================================
		scope	grp_decompress_pattern_name_table
grp_decompress_pattern_name_table::
		ld		de, mgsp_compressed_pattern_name_table
		ld		hl, grp_decompress_area
loop1:
		; get number of times
		ld		a, [de]
		or		a, a
		ret		z
		ld		b, a
		dec		a
		jr		z, skip1
		; get step
		inc		de
		ld		a, [de]
		ld		c, a
		; get initial value
skip1:
		inc		de
		ld		a, [de]
		inc		de
loop2:
		ld		[hl], a
		add		a, c
		inc		hl
		djnz	loop2
		jr		loop1
		endscope