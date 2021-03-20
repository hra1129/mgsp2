; =============================================================================
;  Memory Mapper ���� 1segment allocate ����v���O����
; =============================================================================

		include		"../msxbios.asm"
		include		"../msxdos1.asm"
		include		"../msxdos2.asm"

		org		0x100

entry::
		; ������
		ld			sp, [TPA_BOTTOM]
		call		mmap_init

		; �N�����b�Z�[�W
		ld			de, msg_entry
		call		puts

		; �}�b�p�[�`�F�b�N
		ld			hl, [mmap_table_ptr]
		ld			de, 8 - 2
search_mapper_slot::
		inc			hl
		inc			hl
		ld			a, [hl]			; ���g�p��16KB�Z�O�����g�̐�
		or			a, a
		jr			nz, detect_mapper_slot
		add			hl, de			; ���̃}�b�p�[��
		ld			a, [hl]			; ���̃}�b�p�[��������� 0
		or			a, a			; 0���H
		jr			nz, search_mapper_slot
		ld			de, msg_not_enough_memory
		jp			error_exit
detect_mapper_slot:
		ld			[mapper_remain_segment], a
		dec			hl
		dec			hl
		ld			a, [hl]			; �}�b�p�[�̃X���b�g
		ld			[mapper_slot], a

		; Allocate memory mapper for kanji data
		ld			b, a			; B = Slot#
		ld			a, 1			; A = 1: Allocate System Segment
		call		mapper_all_seg
		ld			[mapper_segment], a
		ld			de, msg_allocate_error
		jp			c, error_exit

		; �m�ۂ����������}�b�p�[�̃X���b�g�ԍ���\��
		ld			de, msg_remain
		call		puts
		ld			a, [mapper_remain_segment]
		call		dec2hex
		ld			de, msg_crlf
		call		puts

		ld			de, msg_slot
		call		puts
		ld			a, [mapper_slot]
		call		dec2hex
		ld			de, msg_crlf
		call		puts

		ld			de, msg_segment
		call		puts
		ld			a, [mapper_segment]
		call		dec2hex
		ld			de, msg_crlf
		call		puts
		jp			success_exit

error_exit::
		; �G���[���b�Z�[�W�\��
		call		puts

success_exit::
		; �I��
		ld			b, 0
		ld			c, D2F_TERM
		jp			bdos

		; A���W�X�^�̒l�� 16�i���_���v����
dec2hex::
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
		ld			[hex2byte], a
		ld			a, b
		and			a, 0x0F
		add			a, '0'
		cp			a, '9' + 1
		jr			c, skip2
		add			a, 'A' - '0' - 10
skip2:
		ld			[hex2byte + 1], a
		ld			de, hex2byte
		call		puts
		ret

hex2byte::
		ds			"00"
		db			0

mapper_slot::
		db			0
mapper_segment::
		db			0
mapper_remain_segment::
		db			0

msg_remain::
		ds			"Total Seg. 0x"
		db			0
msg_slot::
		ds			"Slot 0x"
		db			0
msg_segment::
		ds			"Seg. 0x"
		db			0
msg_not_enough_memory::
		ds			"Not enough memory!!"
msg_crlf::
		db			0x0D, 0x0A, 0
msg_allocate_error::
		ds			"Allocate Error!!"
		db			0x0D, 0x0A, 0
msg_entry::
		ds			"Allocate 1 segment from MemoryMapper"
		db			0x0D, 0x0A
		ds			"================================"
		db			0x0D, 0x0A
		ds			"Programmed by HRA!"
		db			0x0D, 0x0A, 0

		include		"../stdio.asm"
		include		"../memmapper.asm"