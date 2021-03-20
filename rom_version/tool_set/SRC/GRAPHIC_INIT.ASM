; ==============================================================================
;	Graphic initializer
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
		ld		a, 2
		call	CHGMOD

		; MSX2�ȏ�Ȃ�p���b�g��������
		ld		a, [0x002D]
		or		a, a
		call	nz, palette_init

		; �p�^�[���l�[�v�e�[�u�����u�����N�p�[�c�Ŗ��ߐs����
		ld		hl, 0x1800
		ld		bc, 768
		ld		a, 114
		call	FILVRM

		; �X�v���C�g2�{�p���[�h, 16x16���[�h
		ld		a, [rg1sav]
		or		a, 3
		ld		c, 1
		ld		b, a
		call	WRTVDP

		; VDP R#7 = 0x00  (�w�i����������)
		ld		c, 7
		ld		b, 0
		call	WRTVDP

		; Color Table �� 0xF0 �œh��Ԃ�
		ld		hl, 0x2000
		ld		bc, 256 * 8 * 3
		ld		a, 0xF0
		call	FILVRM

		; �X�v���C�g�W�F�l���[�^�e�[�u���� 0x00 �œh��Ԃ�
		ld		hl, 0x3800
		ld		bc, 256 * 8
		xor		a, a
		call	FILVRM

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
		; Speed������
		ld		hl, mgsp_speed_value_init
		ld		de, mgsp_speed_value
		ld		bc, 5
		ldir
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

		; �X�N���[���o�[��������
		ld		hl, 0x2000 + (256 + 251) * 8
		ld		bc, 11 * 8
		ld		a, grp_color_scroll_bar_blank
		call	FILVRM

		ld		hl, 0x0000 + (256 + 251) * 8
		ld		bc, 11 * 8
		ld		a, 0x81
		call	FILVRM

		; PCG�p�[�c���� VRAM�֓]������
		ld		hl, grp_vram_transfer_table
		call	memcpy_transfer_data

		; ���k���ꂽ�p�^�[���l�[���e�[�u�����������֓W�J����
		call	grp_decompress_pattern_name_table

		; �\�����ʕt���Ńp�^�[���l�[���e�[�u��������������VRAM�֓]������
		ei
		ld		b, 32			; for B = 32 to 1 step -1
grp_startup_effect_loop1:
		push	bc
		ld		a, b
		dec		a				; 	HL = (B - 1) * 32 + grp_decompress_area - 8 * 32: DE = (B - 1) * 32 + 0x1800 - 8 * 32
		add		a, a			;			A = (B - 1) * 8
		add		a, a
		add		a, a
		ld		l, a
		ld		h, 0
		add		hl, hl			;			HL = A * 4
		add		hl, hl
		ld		e, l			;			DE = HL
		ld		d, h
		ld		bc, 0x1800 - 8 * 32	;		HL = HL + 0x1800 - 8 * 32
		add		hl, bc
		ex		de, hl			;			swap DE, HL
		ld		bc, grp_decompress_area - 8 * 32
		add		hl, bc			;			HL = HL + grp_decompress_area - 8 * 32

		ld		b, 8
grp_startup_effect_loop2:
		push	bc
		push	de
		push	hl
		ld		bc, 4
		ld		a, 0x17
		cp		a, d
		jr		nc, grp_startup_effect_skip
		ld		a, 0x1A
		cp		a, d
		call	nc, LDIRVM
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
		push	hl
		push	de
		push	bc
		ld		b, 0
		ex		de, hl
		call	LDIRVM			; RAM(hl), VRAM(de), SIZE(bc)
		pop		bc
		pop		de
		pop		hl
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