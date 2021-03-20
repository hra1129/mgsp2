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
; ==============================================================================
		scope	init_mgsdrv
init_mgsdrv::
		; MGSDRV������������
		call		mgs_sysck
		ld			[mgs_id_mgsver], hl
		ld			[mgs_id_mibadr], ix
		ld			[mgs_id_trwadr], iy
		ld			[mgs_id_trwsiz], bc

		; H.TIMI���荞�݂��t�b�N����
		ld			a, 0xC3					; JP xxxx ����
		ld			[h_timi], a
		ld			hl, mgsdrv_h_timi_start
		ld			[h_timi + 1], hl

		; ���[�N������������
		call		clear_mgsdrv_track_work
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
;	load_mgs_file
;	input)
;		hl .... �t�@�C���G���g���̃A�h���X
;	output)
;		Zf .... 1: ����, 0: ���s
; ==============================================================================
		scope		load_mgs_file
load_mgs_file::
		push		hl
		call		stop_song
		pop			hl
		call		copy_mgs_data
		; check song data
		ld			hl, 0x8000
		call		mgs_datck
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
stop_song		:= mgs_initm

; ==============================================================================
;	WORKAREA
; ==============================================================================
file_name_address::
		dw		0

mgs_parameter_block::
mgs_id_mgsver::			; 2bytes: MGSDRV�̃o�[�W����
		dw			0
mgs_id_mibadr::			; 2bytes: MIB�ւ̃A�h���X
		dw			0
mgs_id_trwadr::			; 2bytes: �g���b�N���[�N�̃A�h���X
		dw			0
mgs_id_trwsiz::			; 2bytes: �g���b�N���[�N�̃T�C�Y
		dw			0