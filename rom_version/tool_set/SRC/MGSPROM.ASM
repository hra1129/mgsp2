; ==============================================================================
;   MGSP ROM version
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
		include		"MSXBIOS.ASM"
		include		"MGSDRV_API.ASM"
		include		"ROM_BANK.ASM"
		include		"MGSP_WORK.ASM"
		include		"CUSTOM.ASM"

BOOT_BANK		:= 0
MGSDRV_BANK		:= 1
MGSP_BANK		:= 2
KANJI_BANK		:= 3

		org			0x4000
; ==============================================================================
;	ROM Header
; ==============================================================================
rom_header_id:
		ds			"AB"
rom_header_init:
		dw			entry
rom_header_statement:
		dw			0
rom_header_device:
		dw			0
rom_header_text:
		dw			0
rom_header_reserved:
		space		0x0010 - 0x000A, 0

; ==============================================================================
;	Initializer
; ==============================================================================
		scope		entry_point
entry::
		di
		; �X�^�b�N�|�C���^��������
		ld			hl, [himem]
		ld			de, diskve
		or			a, a
		sbc			hl, de
		ld			sp, diskve
		jp			nc, skip1
		ld			sp, [himem]
skip1:
		; ���̑��̏�����
		call		init_memory_mapper
		call		get_rom_slot
		call		search_page1_dram_slot
		call		search_page2_dram_slot
		call		transfer_to_ram
		call		other_init
		call		kanji_init
		call		grp_init
		jp			go_mgsp_body
		endscope

; ==============================================================================
;	Memory Mapper ������������
;
;	�������}�b�p�[�͎g��Ȃ����Apage0�`3 �����ׂĈقȂ�Z�O�����g�ɂȂ��Ă��Ȃ���
;	�s�s�����ł�BMSX1 �ł� BIOS �Ƀ}�b�p�[�������������܂܂�Ă��炸�A
;	�������}�b�p�[RAM���A�Z�O�����g���W�X�^�������������A�S�y�[�W�����Z�O�����g��
;	�Ȃ��Ă���P�[�X������B
;	����� MSX2 �� BIOS �ɃZ�O�����g���W�X�^�����������鏈�����܂܂�Ă���A
;	page3, 2, 1, 0 �̏��� 0, 1, 2, 3 ������t����B
;	����ɍ��킹�� page3, 2, 1, 0 �̏��� 0, 1, 2, 3 �ɏ��������Ă��܂����ƂŁA
;	�Ⴆ�� page1 �� 2 �ɓ����Z�O�����g������āA�Е��ɏ����Ƃ����Е������������
;	�Ƃ����󋵂������B
; ==============================================================================
		scope		init_memory_mapper
init_memory_mapper::
		xor			a, a
		out			[0xFF], a
		inc			a
		out			[0xFE], a
		inc			a
		out			[0xFD], a
		inc			a
		out			[0xFC], a

		ld			a, [0x002D]
		cp			a, 3					; MSXturboR or later?
		ret			c						; Return when this system is MSX1/2/2+.

		ld			a, 0x81					; R800 ROM Mode
		call		chgcpu
		ret
		endscope

; ==============================================================================
;	���� ROM�J�[�g���b�W�����݂���X���b�g�ԍ������߂�
; ==============================================================================
		scope		get_rom_slot
get_rom_slot::
		di
		; ��{�X���b�g�؂�ւ�: page3 �� page1 �Ɠ����X���b�g�ɐ؂�ւ���
		in			a, [0xA8]
		ld			d, a						; ��{�X���b�g���W�X�^ 0xA8 �� D �Ƀo�b�N�A�b�v
		ld			c, a
		and			a, 0b00_11_11_11
		ld			b, a						; B = 00zzyyxx : xx=page0slot, yy=page1slot, zz=page2slot
		ld			a, c
		and			a, 0b00_00_11_00			; A = 0000yy00 : yy=page1slot
		rrca
		rrca
		ld			c, a						; C = 000000yy : yy=page1slot
		rrca
		rrca
		or			a, b						; A = yyzzyyxx : xx=page0slot, yy=page1slot, zz=page2slot

		ld			b, 0
		ld			hl, exptbl
		add			hl, bc
		ld			b, [hl]						; B = �g���X���b�g�̗L��

		; ��{�X���b�g��؂�ւ���
		out			[0xA8], a					; page3 �� page1 �Ɠ�����{�X���b�g�ԍ����w��

		; �g���X���b�g�����݂��邩�m�F����
		ld			a, b
		and			a, 0x80
		jr			z, page1_is_not_expanded

		; �g���X���b�g�ǂݎ��
		ld			a, [0xFFFF]
		cpl
		and			a, 0b00_00_11_00			; page1 �̊g���X���b�g�ԍ�
		or			a, 0x80						; �g���X���b�g�t���O
		or			a, c
		ld			c, a						; C = e000YYyy : yy = page1 primary slot, YY = page1 secondary slot, e = expanded
page1_is_not_expanded:

		; ��{�X���b�g�����ɖ߂�
		ld			a, d
		out			[0xA8], a

		; ���߂��X���b�g�ԍ���ۑ�
		ld			a, c
		ld			[my_slot_no], a

		; page2 �����߂��X���b�g�ɕύX����
		ld			h, 0x80
		call		enaslt

		; ROM Bank �� 0,1,0,1 �ɂ��� (rom_bank0 �͂��̃R�[�h�������Ă鎞�_�� 0 �ɂȂ��Ă���)
		xor			a, a
		ld			[rom_bank2], a
		inc			a
		ld			[rom_bank1], a
		ld			[rom_bank3], a
		ei
		ret
		endscope

; ==============================================================================
;	Page1 �� DRAM�X���b�g�����o���� RAMAD1 �ɃZ�b�g����
;		���̃R�[�h�́Apage2 �ŉғ�����B
; ==============================================================================
		org			$ + 0x4000
		scope		search_page1_dram_slot
search_page1_dram_slot::
		di
		ld			a, [exptbl + 0]
		and			a, 0x80
		call		search_page1_sub
		ret			nc

		ld			a, [exptbl + 1]
		and			a, 0x80
		or			a, 0x01
		call		search_page1_sub
		ret			nc

		ld			a, [exptbl + 2]
		and			a, 0x80
		or			a, 0x02
		call		search_page1_sub
		ret			nc

		ld			a, [exptbl + 3]
		and			a, 0x80
		or			a, 0x03
		call		search_page1_sub
		ret			nc

not_enough_memory:
		; SCREEN 1
		ld			a, 1
		call		CHGMOD

		ld			hl, error_message
		ld			de, 0x1800				; Pattern name table
		ld			bc, error_message_end - error_message
		call		LDIRVM
		di
		halt
error_message:
					;01234567890123456789012345678901
		ds			"Not enough memory.              "
		ds			"At least 64KB is required."
error_message_end:

search_page1_sub:
		push		af
		; page1 �̃X���b�g��؂�ւ���
		ld			h, 0x40
		call		enaslt
		; page1 �� RAM���ǂ������ׂ�
		ld			hl, 0x4000
		ld			de, 0x4000
loop:
		ld			a, [hl]
		cpl
		ld			[hl], a
		cp			a, [hl]
		cpl
		ld			[hl], a
		jr			nz, no_match
		inc			hl
		dec			de
		ld			a, d
		or			a, e
		jr			nz, loop
match:
		pop			af
		ld			[ramad1], a
		; page1 �̃X���b�g��؂�ւ���
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt
		ei
		or			a, a						; Cy = 0
		ret

no_match:
		pop			af
		or			a, a
		jp			p, not_found
		add			a, 0b0000_01_00
		bit			4, a
		jp			z, search_page1_sub

not_found:
		scf
		ret										; Cy = 1
		endscope
		org			$ - 0x4000

; ==============================================================================
;	page2 �� DRAM�X���b�g�����o���� RAMAD1 �ɃZ�b�g����
;		���̃R�[�h�́Apage2 �ŉғ�����B
; ==============================================================================
		scope		search_page2_dram_slot
search_page2_dram_slot::
		di
		ld			a, [exptbl + 0]
		and			a, 0x80
		call		search_page2_sub
		ret			nc

		ld			a, [exptbl + 1]
		and			a, 0x80
		or			a, 0x01
		call		search_page2_sub
		ret			nc

		ld			a, [exptbl + 2]
		and			a, 0x80
		or			a, 0x02
		call		search_page2_sub
		ret			nc

		ld			a, [exptbl + 3]
		and			a, 0x80
		or			a, 0x03
		call		search_page2_sub
		ret			nc

not_enough_memory:
		di
		halt

search_page2_sub:
		push		af
		; page2 �̃X���b�g��؂�ւ���
		ld			h, 0x80
		call		enaslt
		; page2 �� RAM���ǂ������ׂ�
		ld			hl, 0x8000
		ld			de, 0x4000
loop:
		ld			a, [hl]
		cpl
		ld			[hl], a
		cp			a, [hl]
		cpl
		ld			[hl], a
		jr			nz, no_match
		inc			hl
		dec			de
		ld			a, d
		or			a, e
		jr			nz, loop
match:
		pop			af
		ld			[ramad2], a
		; page2 �̃X���b�g��؂�ւ���
		ld			a, [my_slot_no]
		ld			h, 0x80
		call		enaslt
		ei
		or			a, a						; Cy = 0
		ret

no_match:
		pop			af
		or			a, a
		jp			p, not_found
		add			a, 0b0000_01_00
		bit			4, a
		jp			z, search_page2_sub

not_found:
		scf
		ret										; Cy = 1
		endscope

; ==============================================================================
; �e��u���b�N�]��
; ==============================================================================
		scope		transfer_to_ram
transfer_to_ram::
		; page2 �փW�����v����
		jp			transfer_to_ram_sub

		org			$ + 0x4000
transfer_to_ram_sub:
		; page1 �� RAM �ɐ؂�ւ���
		ld			a, [ramad1]
		ld			h, 0x40
		call		enaslt

		; MGSDRV �� page1 (6000h-7fffh) �֓]������ (�� rom_bank3 �����ł� MGSDRV_BANK)
		ld			hl, 0xA000			; rom_bank3
		ld			de, 0x6000
		ld			bc, 0x2000
		ldir

		; page1 �� ROM �ɐ؂�ւ���
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt

		; rom_bank3 �� MGSP_BANK �ɐ؂�ւ���
		ld			a, MGSP_BANK
		ld			[rom_bank3], a

		; page1 �� RAM �ɐ؂�ւ���
		ld			a, [ramad1]
		ld			h, 0x40
		call		enaslt

		; MGSP �� page1 (4000h-5fffh) �֓]������
		ld			hl, 0xA000			; rom_bank3
		ld			de, 0x4000
		ld			bc, 0x2000
		ldir

		; page1 �� ROM �ɐ؂�ւ���
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt

		; H.TIMI���[�`���� page3 �֓]������ (���܂��t�b�N�͂����Ȃ�)
		ld			hl, mgsdrv_h_timi
		ld			de, mgsdrv_h_timi_rel
		ld			bc, mgsdrv_h_timi_size
		ldir

		ld			hl, h_timi
		ld			de, old_h_timi
		ld			bc, 5
		ldir

		ld			a, [my_slot_no]
		ld			[page1_slot], a
		ld			[page2_slot], a
		ret
		endscope

; ==============================================================================
;	page3�œ��삷�郋�[�`��
; ==============================================================================

; ==============================================================================
;	go_mgsp_body
;		MGSP.ASM �̐擪�ɂ��� mgsp_body (page1 �� RAM) �փW�����v���郋�[�`��
; ==============================================================================
		scope		mgsdrv_h_timi
mgsdrv_h_timi::
		org			mgsdrv_h_timi_rel
go_mgsp_body::
		di
		; page1 �� RAM�X���b�g�ɐ؂�ւ���
		ld			a, [ramad1]
		ld			h, 0x40
		ld			[page1_slot], a
		call		enaslt					; ����
		; page2 �� RAM�X���b�g�ɐ؂�ւ���
		ld			a, [ramad2]
		ld			h, 0x80
		ld			[page2_slot], a
		call		enaslt					; ����
		; MGSDRV������������
		call		init_mgsdrv
		ei
		jp			mgsp_body
		endscope

; ==============================================================================
;	copy_mgs_data
;		page2 �� RAM �� MGS�t�@�C���C���[�W��]�����郋�[�`��
;	input)
;		HL ........ �t�@�C���G���g���̃A�h���X
; ==============================================================================
		scope		copy_mgs_data
copy_mgs_data::
		ld			de, FENT_MGS_BANK_ADDRESS
		add			hl, de
		ld			a, [hl]					; +9 : A=�o���N�ԍ�
		ld			[bank_num], a
		inc			hl
		ld			e, [hl]
		inc			hl
		ld			d, [hl]					; +10, +11 : DE=�I�t�Z�b�g�A�h���X
		ld			[offset_address], de
		inc			hl
		ld			e, [hl]
		inc			hl
		ld			d, [hl]					; +12, +13 : DE=�t�@�C���T�C�Y
		ld			[file_size], de
		; page1 �� ROM�X���b�g�ɐ؂�ւ���
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt					; ����
		; page2 �� RAM�X���b�g�ɐ؂�ւ���
		ld			a, [ramad2]
		ld			h, 0x80
		call		enaslt					; ����
		; �A�h���X�v�Z
		ld			hl, [offset_address]
		ld			a, h
		or			a, 0x40
		ld			h, a
		; �T�C�Y�v�Z
		ld			bc, [file_size]
		ld			a, b
		cp			a, 0x20
		jp			nc, over_2000h
		; bank0 (page1) �����]�̃t�@�C�����u���Ă���o���N�ɐ؂�ւ���
		ld			a, [bank_num]
		ld			[rom_bank0], a
		inc			a
		ld			[rom_bank1], a
		; page1 --> page2 �u���b�N�]�� (8192byte�����̏ꍇ)
		ld			de, 0x8000
		ldir
		jp			exit_copy_mgs_data
over_2000h:
		; bank0 (page1) �����]�̃t�@�C�����u���Ă���o���N�ɐ؂�ւ���
		ld			a, [bank_num]
		ld			[rom_bank0], a
		inc			a
		ld			[rom_bank1], a
		; �܂��O�� 8192byte ��]��
		push		hl
		ld			bc, 0x2000
		ld			de, 0x8000
		ldir
		pop			hl
		; �o���N�؂�ւ�
		ld			[rom_bank0], a
		inc			a
		ld			[rom_bank1], a
		; �c���]��
		ld			bc, [file_size]
		ld			a, b
		sub			a, 0x20
		ld			b, a
		ld			de, 0xA000
		ldir
exit_copy_mgs_data:
		; page1 �� ���X���b�g�ɐ؂�ւ���
		ld			a, [page1_slot]
		ld			h, 0x40
		call		enaslt					; ����
		; page2 �� ���X���b�g�ɐ؂�ւ���
		ld			a, [page2_slot]
		ld			h, 0x80
		call		enaslt					; ����
		ret
bank_num:
		db			0
offset_address:
		dw			0
file_size:
		dw			0
		endscope

; ==============================================================================
;	enble_page2_bank
;		page2 �� ROM�X���b�g �ɐ؂�ւ��āApage2 �� ROM ���w��̃o���N�ɐ؂�ւ���
;	input)
;		A ........ bank2 �̃o���N�ԍ�
;	comment)
;		bank2 �� A, bank3 �� A+1 �̃o���N�ɐ؂�ւ���� page2 �Ɍ����B
;		���ւ̂܂ܖ߂�
; ==============================================================================
		scope		enble_page2_bank
enble_page2_bank::							; page2��ROM�X���b�g�ɐ؂�ւ��Ďw��̃o���N�ɐ؂�ւ���
		push		af						; DI �̂܂ܖ߂�
		; page1 �� ROM�X���b�g�ɐ؂�ւ���
		ld			a, [my_slot_no]
		ld			h, 0x40
		call		enaslt					; ����
		; page2 �� ROM�X���b�g�ɐ؂�ւ���
		ld			a, [my_slot_no]
		ld			h, 0x80
		call		enaslt					; ����
		pop			af
		ld			[rom_bank2], a
		inc			a
		ld			[rom_bank3], a
		inc			a
		; page1 �� ���X���b�g�ɐ؂�ւ���
		ld			a, [page1_slot]
		ld			h, 0x40
		call		enaslt					; ����
		ret
		endscope

; ==============================================================================
;	mgsdrv_h_timi_start
;		H.TIMI �������[�`��
; ==============================================================================
		scope		mgsdrv_h_timi_start
mgsdrv_h_timi_start::
		; MGSP���ŗ��p����J�E���^�[
		ld			a, [timer_counter]
		inc			a
		ld			[timer_counter], a

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
old_h_timi::
		ret
		ret
		ret
		ret
		ret
mgsdrv_h_timi_end::

mgsdrv_h_timi_size	:= mgsdrv_h_timi_end - mgsdrv_h_timi_rel

		if mgsdrv_h_timi_size >= 0x400
			error "MGSDRV_H_TIMI is too big!"
		endif

		org			mgsdrv_h_timi + mgsdrv_h_timi_size - 0x4000
		endscope

; ==============================================================================
; Graphic ���������[�`��
; ==============================================================================
		include		"GRAPHIC_INIT.ASM"
		include		"GRAPHIC_INIT_DATA.ASM"
		include		"GRAPHIC_RO_DATA.ASM"
		include		"KANJI.ASM"

; ==============================================================================
; ���̑��̏��������[�`��
; ==============================================================================
		scope		other_init
other_init::
		; �L�[�N���b�N�� OFF
		xor			a, a
		ld			[cliksw], a
		; �萔��������
		ld			[timer_counter], a
		ld			hl, 100
		ld			[song_speed], hl
		ret
		endscope

end_of_boot_code:
		space		(0x6000 - 13) - $, 0

; ==============================================================================
; MGSDRV.COM �������Ƀ����N����
; ==============================================================================
mgsdrv_address::
		binary_link	"../MGSDRV/MGSDRV.COM"

; ==============================================================================
; MGSP�{�� (MGSDRV.COM �� 8192 align �����z���Ă���̂� 0x4000�҂�����ɂ͂Ȃ�Ȃ�)
; ==============================================================================
		org			($ % 8192) + 0x4000
mgsp_address::
		include		"MGSP.ASM"
		align		8192

; ==============================================================================
; ����ROM
; ==============================================================================
kanji_address::
		binary_link	"KFONT_ROM.BIN"

; ==============================================================================
; �t�@�C�����
; ==============================================================================
		include		"FL_ENTRY.ASM"

; ==============================================================================
; MGS�t�@�C��
; ==============================================================================
		binary_link	"MGS_PACK.BIN"
		align		8192
end_of_program::