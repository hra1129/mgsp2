; ==============================================================================
;	Memory Mapper
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

; ==============================================================================
;	MapperSupportRoutine's table offset (This area is reference only)
; ==============================================================================
mmap_slot		:= 0			; 1byte, �}�b�p�[RAM�̃X���b�g�ԍ�
mmap_total_seg	:= 1			; 1byte, ���Z�O�����g��
mmap_free_seg	:= 2			; 1byte, ���g�p�Z�O�����g��
mmap_sys_seg	:= 3			; 1byte, �V�X�e���Ɋ��蓖�Ă�ꂽ�Z�O�����g��
mmap_user_seg	:= 4			; 1byte, ���[�U�[�Ɋ��蓖�Ă�ꂽ�Z�O�����g��
mmap_reserved	:= 5			; 3byte, �\��̈�

; ==============================================================================
;	mmap_init
;	input)
;		--
;	output)
;		Zf ................. 1: MemoryMapper�T�|�[�g���[�`�������݂��Ȃ�
;		[mmap_table_ptr] ... �}�b�p�[�e�[�u���̃A�h���X
;	break)
;		all
; ==============================================================================
		scope	mmap_init
mmap_init::
		ld		c, D2F_DOSVER	; DOS�o�[�W�������`�F�b�N
		call	bdos
		or		a, a			; A != 0 �� DOS �ł͂Ȃ�
		jp		nz, mmap_error_exit
		ld		a, b
		cp		a, 2			; B < 2 �̏ꍇ MSX-DOS1 �ł���
		jp		c, mmap_error_exit

		ld		a, [hokvld]
		and		a, 1
		ret		z				; �g��BIOS�����݂��Ȃ��ꍇ�̓G���[(Zf=1)

		; get MapperSupportRoutine's table
		xor		a, a
		ld		de, 0x0401		; D=MemoryMapperSupportRoutine ID, E=01h
		call	extbio
		or		a, a
		ret		z				; �}�b�p�[�T�|�[�g���[�`�������݂��Ȃ��ꍇ�̓G���[(Zf=1)
		ld		[mmap_table_ptr], hl

		; get jump table
		ld		de, 0x0402		; D=MemoryMapperSupportRoutine ID, E=02h
		call	extbio
		ld		de, mapper_jump_table
		ld		bc, 16 * 3
		ldir

		; get current segment on page1
		call		mapper_get_p1
		ld			[mapper_segment_p1], a
		call		mapper_get_p2
		ld			[mapper_segment_p2], a

		xor		a, a
		inc		a
		ret						; ����I�� (Zf=0)
mmap_error_exit:
		xor		a, a
		ret
		endscope

; ==============================================================================
;	�X���b�g�\���� TPA �ɖ߂�
; ==============================================================================
		scope		mmap_change_to_tpa
mmap_change_to_tpa::
		; change slot of page1
		ld			h, 0x40
		ld			a, [ramad1]
		call		enaslt

		; change slot of page2
		ld			h, 0x80
		ld			a, [ramad2]
		call		enaslt

		; change mapper segment of page1
		ld			a, [mapper_segment_p1]
		call		mapper_put_p1

		; change mapper segment of page2
		ld			a, [mapper_segment_p2]
		call		mapper_put_p2
		ei
		ret
		endscope

; ==============================================================================
;		WORKAREA
; ==============================================================================
mmap_table_ptr::
		dw			0				; �}�b�p�[�e�[�u���̃A�h���X���i�[�����
mapper_segment_p1:
		db			0				; �N������ page1 �̃Z�O�����g�ԍ�
mapper_segment_p2:
		db			0				; �N������ page2 �̃Z�O�����g�ԍ�

mapper_jump_table::
mapper_all_seg::	; +00h
		db			0xc9, 0xc9, 0xc9
mapper_fre_seg::	; +03h
		db			0xc9, 0xc9, 0xc9
mapper_rd_seg::		; +06h
		db			0xc9, 0xc9, 0xc9
mapper_wr_seg::		; +09h
		db			0xc9, 0xc9, 0xc9
mapper_cal_seg::	; +0Ch
		db			0xc9, 0xc9, 0xc9
mapper_calls::		; +0Fh
		db			0xc9, 0xc9, 0xc9
mapper_put_ph::		; +12h
		db			0xc9, 0xc9, 0xc9
mapper_get_ph::		; +15h
		db			0xc9, 0xc9, 0xc9
mapper_put_p0::		; +18h
		db			0xc9, 0xc9, 0xc9
mapper_get_p0::		; +1Bh
		db			0xc9, 0xc9, 0xc9
mapper_put_p1::		; +1Eh
		db			0xc9, 0xc9, 0xc9
mapper_get_p1::		; +21h
		db			0xc9, 0xc9, 0xc9
mapper_put_p2::		; +24h
		db			0xc9, 0xc9, 0xc9
mapper_get_p2::		; +27h
		db			0xc9, 0xc9, 0xc9
mapper_put_p3::		; +2Ah
		db			0xc9, 0xc9, 0xc9
mapper_get_p3::		; +2Dh
		db			0xc9, 0xc9, 0xc9