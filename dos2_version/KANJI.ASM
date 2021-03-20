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
;	�����t�H���g��ǂݍ���ŏ���������
;	input)
;		--
;	output)
;		a .... �G���[�ԍ�: 0: Success, 1: Not enough memory, 2: Read error
;	break)
;		all
; ==============================================================================
		scope		kanji_init
kanji_init::
		call		mmap_change_to_tpa
		; Search target mapper
		ld			hl, [mmap_table_ptr]
		ld			de, 6
search_mapper_slot::
		inc			hl
		inc			hl
		ld			a, [hl]			; ���g�p��16KB�Z�O�����g�̐�
		cp			a, 4
		jr			nc, detect_mapper_slot
		add			hl, de			; ���̃}�b�p�[��
		ld			a, [hl]			; ���̃}�b�p�[��������� 0
		or			a, a			; 0���H
		jr			nz, search_mapper_slot
		inc			a				; �G���[1: 4�Z�O�����g�ȏ�󂢂Ă�}�b�p�[������
		ret
detect_mapper_slot::
		dec			hl
		dec			hl
		ld			a, [hl]			; �}�b�p�[�̃X���b�g
		ld			[kanji_ram_slot], a

		; TPA (page2) �̃Z�O�����g�ԍ����o���Ă���
		call		mapper_get_p2
		ld			[tpa_page2_segment], a

		; Allocate memory mapper for kanji data
		ld			a, [kanji_ram_slot]
		ld			b, a			; B = Slot#
		xor			a, a			; A = 0: Allocate User Segment
		call		mapper_all_seg
		ld			[kanji_ram0_seg], a
		ld			a, 1
		ret			c

		ld			a, [kanji_ram_slot]
		ld			b, a			; B = Slot#
		xor			a, a			; A = 0: Allocate User Segment
		call		mapper_all_seg
		ld			[kanji_ram1_seg], a
		ld			a, 1
		ret			c

		ld			a, [kanji_ram_slot]
		ld			b, a			; B = Slot#
		xor			a, a			; A = 0: Allocate User Segment
		call		mapper_all_seg
		ld			[kanji_ram2_seg], a
		ld			a, 1
		ret			c

		ld			a, [kanji_ram_slot]
		ld			b, a			; B = Slot#
		xor			a, a			; A = 0: Allocate User Segment
		call		mapper_all_seg
		ld			[kanji_ram3_seg], a
		ld			a, 1
		ret			c

		; load KFONT.BIN
		ld			de, s_font_name
		call		open_file_on_path_env
		or			a, a
		jp			z, error_exit1

		ld			de, msg_load_kfont
		call		puts

		ld			a, [kanji_ram0_seg]
		call		load_1segment
		jr			c, error_exit2

		ld			a, [kanji_ram1_seg]
		call		load_1segment
		jr			c, error_exit2

		ld			a, [kanji_ram2_seg]
		call		load_1segment
		jr			c, error_exit2

		ld			a, [kanji_ram3_seg]
		call		load_1segment
		jr			c, error_exit2

		ld			de, s_crlf
		call		puts

		; close
close_file:
		ld			c, D2F_CLOSE
		ld			a, [file_handle]
		ld			b, a
		call		bdos
		xor			a, a
		ret
error_exit2:
		call		close_file
error_exit1:
		ld			de, s_crlf
		call		puts
		ld			a, 2
		ret

		; 1segment���ǂݏo��
load_1segment:
		push		af

		ld			de, progress_bar
		call		puts

		; -- read 1st 8KB
		ld			c, D2F_READ
		ld			a, [file_handle]
		ld			b, a
		ld			de, 0x6000				; load address (TPA)
		ld			hl, 0x2000				; size
		call		bdos
		or			a, a
		jp			nz, error_load_1segment

		ld			de, progress_bar
		call		puts

		; -- �ꎞ�I�� page2 ������RAM�p�������ɐ؂�ւ���
		ld			h, 0x80
		ld			a, [kanji_ram_slot]
		call		enaslt

		pop			af
		push		af
		call		mapper_put_p2

		ld			hl, 0x6000
		ld			de, 0x8000
		ld			bc, 0x2000
		ldir

		; -- page2 �� TPA �ɖ߂�
		ld			h, 0x80
		ld			a, [ramad2]
		call		enaslt

		ld			a, [tpa_page2_segment]
		call		mapper_put_p2
		ei

		; -- read 2nd 8KB
		ld			c, D2F_READ
		ld			a, [file_handle]
		ld			b, a
		ld			de, 0x6000				; load address (TPA)
		ld			hl, 0x2000				; size
		call		bdos
		or			a, a
		jp			nz, error_load_1segment

		ld			de, progress_bar
		call		puts

		; -- �ꎞ�I�� page2 ������RAM�p�������ɐ؂�ւ���
		ld			h, 0x80
		ld			a, [kanji_ram_slot]
		call		enaslt

		pop			af
		call		mapper_put_p2

		ld			hl, 0x6000
		ld			de, 0xA000
		ld			bc, 0x2000
		ldir

		; -- page2 �� TPA �ɖ߂�
		ld			h, 0x80
		ld			a, [ramad2]
		call		enaslt

		ld			a, [tpa_page2_segment]
		call		mapper_put_p2
		ei

		or			a, a
		ret

error_load_1segment:
		pop			af
		scf
		ret


file_handle:
		db			0
msg_load_kfont:
		ds			"Load KFONT.BIN: "
		db			0
progress_bar:
		ds			"*"
		db			0
s_crlf:
		db			0x0d, 0x0a, 0
tpa_page2_segment:
		db			0
s_font_name:
		ds			"KFONT.BIN"
		db			0
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
		; �K�v�ȃZ�O�����g�ɐ؂�ւ���
		ld		a, h
		rlca
		rlca
		and		a, 3
		ld		l, a
		ld		h, 0
		ld		de, kanji_ram0_seg
		add		hl, de
		ld		a, [hl]
		call	mapper_put_p2
		; �Z�O�����g���A�h���X�����߂�
		pop		hl
		ld		a, h
		and		a, 0x3F
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
		ld		a, [kanji_ram0_seg]			; ���p�����͕K�� kanji_ram0
		call	mapper_put_p2
		ld		a, h
		or		a, 0x80
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
		; �K�v�ȃZ�O�����g�ɐ؂�ւ���
		ld		a, h
		rlca
		rlca
		and		a, 3
		ld		l, a
		ld		h, 0
		ld		de, kanji_ram0_seg
		add		hl, de
		ld		a, [hl]
		call	mapper_put_p2
		; �Z�O�����g���A�h���X�����߂�
		pop		hl
		ld		a, h
		and		a, 0x3F
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
		ld		a, [kanji_ram0_seg]			; ���p�����͕K�� kanji_ram0
		call	mapper_put_p2
		ld		a, h
		or		a, 0x80
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
		; Change to kanji-ram mapper slot
		push	de
		ld		h, 0x80
		ld		a, [kanji_ram_slot]
		call	enaslt
		ei
		pop		de

		ld		hl, kanji_work
		xor		a, a				; Cy = 0
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
		ei
		ld		de, kanji_work
		sbc		hl, de
		ld		b, l
		ex		de, hl
		ret
		endscope

; ==============================================================================
;	WORKAREA
; ==============================================================================
kanji_target_address:
		dw		0
kanji_ram_slot:
		db		0
kanji_ram0_seg:
		db		0
kanji_ram1_seg:
		db		0
kanji_ram2_seg:
		db		0
kanji_ram3_seg:
		db		0

kanji_work		:= s_path_env
kanji_work_end	:= s_path_env_end