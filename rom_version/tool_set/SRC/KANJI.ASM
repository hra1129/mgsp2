; ==============================================================================
;	Kanji Driver
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
;	2020/9/26	t.hara	1.0		1st release
; ==============================================================================

; ==============================================================================
;	kanji_init
;	�����t�H���g�`�惋�[�`���� page3 �֓]������
;	input)
;		--
;	output)
;		--
;	break)
;		all
; ==============================================================================
		scope		kanji_init
kanji_init::
		; page3 �� kanji_driver ��]������
		ld			hl, kanji_driver_on_rom
		ld			de, kanji_driver_top
		ld			bc, kanji_driver_size
		ldir
		ret
		endscope

; ==============================================================================
kanji_driver_on_rom::
		org		kanji_driver
kanji_driver_top::

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
		call	SETWRT
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
;	put_string
;	input)
;		de .... �`�悷�镶���� (ASCIIZ), MAX62����
;	output)
;		hl ........... kanji_work
;		kanji_work ... �`�悷�镶��
;		b ............ �]������byte��
;		a ............ ���̕���
; ==============================================================================
		scope	put_string
put_string::
		; Page1, Page2 ���J�[�g���b�W�̃X���b�g�ɕύX����
		push	de
		ld		h, 0x40
		ld		a, [my_slot_no]
		call	enaslt				; ����
		ld		h, 0x80
		ld		a, [my_slot_no]
		call	enaslt				; ����
		pop		de

		ld		hl, kanji_work
		xor		a, a				; Cy = 0
		ld		[rom_bank0], a		; HELP �� �e��\��������� Bank#0 �ɂ���̂ŁABank0 �� Bank#0 �ɖ߂��Ă���
loop:
		push	hl
		ld		bc, kanji_work_end
		sbc		hl, bc
		pop		hl
		jp		nc, exit_put_string	; �I�[�ɓ���
		or		a, a
		jp		nz, skip_4sft		; a = 0 �Ȃ� �Y��Ȉʒu, ��0 �Ȃ� 4�h�b�g�V�t�g�ʒu

		; �Y��Ȉʒu�ɕ`��
		push	hl
		call	put_kanji
		pop		hl
		or		a, a
		jp		z, exit_put_string_term
		dec		a
		dec		a
		jp		nz, loop			; ���p�`�悵���ꍇ�� hl �͐i�߂� a = -1 �ɂ���
		ld		bc, 8				; �S�p�`�悵���ꍇ�� hl ��i�߂� a = 0 �ɂ���
		add		hl, bc				; Cy = 0
		jp		loop

skip_4sft:
		; 4�h�b�g�V�t�g�����ʒu�ɕ`��
		push	hl
		call	put_kanji_4sft
		pop		hl
		ld		bc, 8				; ���p�ł��S�p�ł� hl �͐i�߂�
		add		hl, bc				; ���p�������ꍇ���Y��Ȉʒu ( a = 0 ) �ɂ��� , ���ł� Cy = 0
		or		a, a
		jp		z, exit_put_string_term
		dec		a
		jp		loop				; �S�p�������ꍇ��4�h�b�g�V�t�g�ʒu ( a = 1 ) �ɂ���

exit_put_string:
		ld		a, [de]				; ���̕���
exit_put_string_term:
		push	af
		push	hl
		ld		a, 0x3F
		ld		[scc_bank2], a		; Konami8K SCC �̏ꍇ�ASCC���W�X�^���o�������Ă����BASCII8K �̏ꍇ�A�Ӗ������� ROM �� 3Fh �������ށB
		ld		h, 0x40
		ld		a, [page1_slot]
		call	enaslt				; ����
		ld		h, 0x80
		ld		a, [page2_slot]
		call	enaslt				; ����
		ei
		pop		hl
		pop		af

		ld		de, kanji_work
		sbc		hl, de
		ld		b, l
		ex		de, hl
		ret
		endscope

; ==============================================================================
;	put_kanji
;	�ꕶ���`�悷��
;	input)
;		de ... �������i�[����Ă���A�h���X (ShiftJIS)
;		hl ... �`�惁�����̃A�h���X
;	output)
;		de ... ���̕����̊i�[�A�h���X
;		a .... 0: �I�[����������
;		       1: ���p����������
;		       2: �S�p����������
;	break)
;		all
; ==============================================================================
		scope	put_kanji
put_kanji::
		ld		[kanji_target_address], hl
		ld		a, [de]
		cp		a, ' '
		jp		nc, skip1
		xor		a, a
		ret
skip1:
		inc		de
		call	issjis1st
		jp		nc, put_half_size

		; �S�p�����̕`��
		cp		a, 0xE0
		jp		c, skip_pfs1
		sub		a, 0x40			; 0xE0..0xFF --> 0xA0..0xBF
skip_pfs1:
		cp		a, 0x88
		jp		c, skip_pfs2
		sub		a, 0x03			; 0x88..0xBF --> 0x85..0xBC
skip_pfs2:
		sub		a, 0x81			; A = 0x00..0x3A
		; 192�{ = 3 * 64�{  ��3�{�� 8bit ���z���Ȃ�
		ld		b, a
		add		a, a
		add		a, b
		ld		l, a
		ld		h, 0
		ld		b, h
		ld		c, 159
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, bc
		; 2byte��
		ld		a, [de]
		inc		de
		push	de
		sub		a, 0x40
		ld		c, a
		add		hl, bc
		; 1����8byte
		add		hl, hl
		add		hl, hl
		add		hl, hl
		push	hl
		; �K�v�ȃo���N(HL�̏��3bit)�ɐ؂�ւ���
		ld		a, h
		rlca
		rlca
		rlca
		and		a, 0b0000_0111
		add		a, KANJI_BANK
		ld		[rom_bank2], a
		; �o���N���A�h���X�����߂�
		pop		hl
		ld		a, h
		and		a, 0b0001_1111
		or		a, 0x80
		ld		h, a
		ld		de, [kanji_target_address]
		ld		a, 2
		jp		transfer
		; ���p�����̕`��
put_half_size:
		push	de
		; 32�`127, 161�`223 �� 0�`158 �ɕϊ�
		sub		a, 32
		cp		a, 96
		jr		c, skip_phs1
		sub		a, 33
skip_phs1:
		ex		de, hl
		; �A�h���X�ɕϊ�
		ld		l, a
		ld		h, 0
		add		hl, hl
		add		hl, hl
		add		hl, hl
		ld		a, KANJI_BANK
		ld		[rom_bank2], a
		ld		a, 0x80
		add		a, h
		ld		h, a
		ld		a, 1
transfer:
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		pop		de
		ret
		endscope

; ==============================================================================
;	put_kanji_4sft
;	�ꕶ���`�悷�� (4��f�V�t�g)
;	input)
;		de ... �������i�[����Ă���A�h���X (ShiftJIS)
;		hl ... �`�惁�����̃A�h���X
;	output)
;		de ... ���̕����̊i�[�A�h���X
;		a .... 0: �I�[����������
;		       1: ���p����������
;		       2: �S�p����������
;	break)
;		all
; ==============================================================================
		scope	put_kanji_4sft
put_kanji_4sft::
		ld		[kanji_target_address], hl
		ld		a, [de]
		cp		a, ' '
		jp		nc, skip1
		xor		a, a
		ret
skip1:
		inc		de
		call	issjis1st
		jp		nc, put_half_size

		; �S�p�����̕`��
		cp		a, 0xE0
		jp		c, skip_pfs1
		sub		a, 0x40			; 0xE0..0xFF --> 0xA0..0xBF
skip_pfs1:
		cp		a, 0x88
		jp		c, skip_pfs2
		sub		a, 0x03			; 0x88..0xBF --> 0x85..0xBC
skip_pfs2:
		sub		a, 0x81			; A = 0x00..0x3A
		; 192�{ = 3 * 64�{  ��6�{�� 8bit ���z���Ȃ�
		ld		b, a
		add		a, a
		add		a, b
		ld		l, a
		ld		h, 0
		ld		b, h
		ld		c, 159
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, hl
		add		hl, bc
		; 2byte��
		ld		a, [de]
		inc		de
		push	de
		sub		a, 0x40
		ld		c, a
		add		hl, bc
		; 1����8byte
		add		hl, hl
		add		hl, hl
		add		hl, hl
		push	hl
		; �K�v�ȃo���N(HL�̏��3bit)�ɐ؂�ւ���
		ld		a, h
		rlca
		rlca
		rlca
		and		a, 0b0000_0111
		add		a, KANJI_BANK
		ld		[rom_bank2], a
		; �o���N���A�h���X�����߂�
		pop		hl
		ld		a, h
		and		a, 0b0001_1111
		or		a, 0x80
		ld		h, a
		ld		de, [kanji_target_address]
		; �������̕`��
		push	hl
		ld		b, 8
loop_pfs1:
		ld		a, [hl]
		rrca
		rrca
		rrca
		rrca
		and		a, 0x0F
		ex		de, hl
		or		a, [hl]
		ld		[hl], a
		ex		de, hl
		inc		hl
		inc		de
		djnz	loop_pfs1
		pop		hl
		; �E�����̕`��
		ld		b, 8
loop_pfs2:
		ld		a, [hl]
		rrca
		rrca
		rrca
		rrca
		and		a, 0xF0
		ld		[de], a
		inc		hl
		inc		de
		djnz	loop_pfs2
		pop		de
		ld		a, 2
		ret

		; ���p�����̕`��
put_half_size:
		push	de
		; 32�`127, 161�`223 �� 0�`158 �ɕϊ�
		sub		a, 32
		cp		a, 96
		jr		c, skip_phs1
		sub		a, 33
skip_phs1:
		ex		de, hl
		; �A�h���X�ɕϊ�
		ld		l, a
		ld		h, 0
		add		hl, hl
		add		hl, hl
		add		hl, hl
		ld		a, KANJI_BANK
		ld		[rom_bank2], a
		ld		a, 0x80
		add		a, h
		ld		h, a
		ld		b, 8
loop_phs1:
		ld		a, [hl]
		rrca
		rrca
		rrca
		rrca
		and		a, 0x0F
		ex		de, hl
		or		a, [hl]
		ld		[hl], a
		ex		de, hl
		inc		hl
		inc		de
		djnz	loop_phs1
		pop		de
		ld		a, 1
		ret
		endscope

; ==============================================================================
;	issjis1st
;	input)
;		a ..... Character code
;	output)
;		Cy .... 0: ASCII�R�[�h/���ȕ����R�[�h, 1: �}���`�o�C�g1byte��
;	break)
;		f
;	comment)
;		�����R�[�h A ���AShiftJIS �̃}���`�o�C�g1byte�ڂ��ǂ����𔻒肷��
; ==============================================================================
		scope	issjis1st
issjis1st::
		or		a, a
		ret		p			; 0�`127 �� ASCII�R�[�h
		cp		a, 161
		ret		c			; 128�`160 �� �}���`�o�C�g1byte��
		cp		a, 224
		ccf					; 161�`223 �� ���ȕ����R�[�h, 224�`255 �̓}���`�o�C�g1byte��
		ret
		endscope

kanji_target_address:
		dw		0

grp_draw_file_line::
sort_song_title1::
		space	64
sort_song_title2::
		space	64
target_file_name::				; �Ȗ��\��(�X�N���[������)�̂��߂ɁA�Ȗ���ێ�����̈�
		space		128
target_file_name_end::
		db			0, 0

kanji_driver_bottom::
kanji_driver_size	:= kanji_driver_bottom - kanji_driver_top
		org		kanji_driver_on_rom + kanji_driver_size