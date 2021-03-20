; ==============================================================================
;   INI file parser
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

; ==============================================================================
;	load_ini_file
;	input)
;		de .... file name (ASCIIZ)
;	output)
;		a ..... 0: success, 1: error
;	break)
;		all
; ==============================================================================
		scope		load_ini_file
load_ini_file::
		call		mmap_change_to_tpa
		ld			de, s_ini_name
		call		open_file_on_path_env
		dec			a
		ret			nz

		ld			a, [file_handle]
		ld			b, a
		call		load_ini

		ld			c, D2F_CLOSE
		ld			a, [file_handle]
		ld			b, a
		call		safe_bdos

		xor			a, a
		ret
s_ini_name:
		ds			"MGSP.INI"
		db			0
		endscope

; ==============================================================================
;	load_ini
;	input)
;		b ..... file handle
;		hl .... address of ini item list
;	output)
;		a ..... 0: success, 1: error
;	break)
;		all
; ==============================================================================
		scope		load_ini
load_ini::
		; initialize work area
		xor			a, a
		ld			[_next_character], a
		ld			a, 128
		ld			[_read_buffer_index], a

loop:
		; <variable> = <number> �����߁Bs_word = "<variable>", HL = <number>
		call		_get_word
		ret			c

		call		_check_equal
		ret			c

		call		_get_number
		ret			c
		ld			[value], hl

		call		_search_word
		jr			loop
		endscope

; ==============================================================================
;	_get_one
;	input)
;		file_handle .... file handle
;	output)
;		a ..... character code
;		Cy .... 0: success, 1: EOF/error
;	break)
;		all
; ==============================================================================
		scope		_get_one
_get_one::
		; Is _next_character active?
		ld			a, [_next_character]
		or			a, a
		jr			z, _next_character_is_not_active

		ld			b, a
		xor			a, a						; Cy = 0, A = 0
		ld			[_next_character], a
		ld			a, b
		ret

_next_character_is_not_active:
		ld			a, [_read_buffer_index]
		or			a, a
		jp			m, _read_disk

		ld			c, a
		ld			b, 0
		ld			hl, _read_buffer
		add			hl, bc						; Cy = 0

		inc			a
		ld			[_read_buffer_index], a

		ld			a, [hl]
		ret

_read_disk:
		ld			hl, _read_buffer
		ld			b, 128
		xor			a, a
zero_fill_loop:
		ld			[hl], a
		inc			hl
		djnz		zero_fill_loop

		inc			a
		ld			[_read_buffer_index], a

		ld			a, [file_handle]
		ld			b, a
		ld			c, D2F_READ
		ld			de, _read_buffer
		ld			hl, 128
		call		safe_bdos

		cp			a, D1E_EOF
		jp			z, eof_exit

		or			a, a
		jp			nz, error_exit

		ld			a, [error_status]
		or			a, a					; Cy = 0
		jr			nz, error_exit

		ld			a, [_read_buffer]
		ret

eof_exit:
error_exit:
		scf
		ret
		endscope

; ==============================================================================
;	_rewind
;	input)
;		a ..... character code
;	output)
;		none
;	break)
;		all
; ==============================================================================
		scope		_rewind
_rewind::
		ld			[_next_character], a
		ret
		endscope

; ==============================================================================
;	_skip_white_space
;	input)
;		none
;	output)
;		none
;	break)
;		all
;	comment)
;		���̗L���ȕ����܂ł̋󔒂�ǂݔ�΂��B
; ==============================================================================
		scope		_skip_white_space
_skip_white_space::
		; get 1 character
		call		_get_one
		ret			c							; error �� eof �Ȃ� Cy = 1 �Ŕ�����

		; Is this space?
		call		isspace
		jr			c, _skip_white_space		; space �Ȃ玟�̕�����

		; Is this comment?
		cp			a, ';'						; �R�����g�J�n�L�� ';'
		jp			nz, skip1

		; Skip comment
skip_comment:
		call		_get_one
		ret			c							; error �� eof �Ȃ� Cy = 1 �Ŕ�����

		cp			a, '\n'
		jr			nz, skip_comment
		jr			_skip_white_space

skip1:
		call		_rewind						; ���߂��Ă��܂���������߂�
		or			a, a						; Cy = 0 �ɂ��Ĕ�����
		ret
		endscope

; ==============================================================================
;	_get_word
;	input)
;		none
;	output)
;		s_word .... Retrieved word
;		Cy ........ 0: Success, 1: Failed
;	break)
;		all
;	comment)
;		s_word �ɂ́A�ő� 16�����̒P�ꖼ���擾���Ċi�[���܂��B
;		17�����ȏ�̏ꍇ�́A�P��̋�؂�ڂ܂œǂݎ̂Ă܂��B
;		�P��́A�A���t�@�x�b�g�E�����E�A���_�[�X�R�A�ō\������Ă���A
;		�召�����̋�ʂ͂���܂���Bs_word �ɂ͑啶���ɕϊ�����Ċi�[����܂��B
; ==============================================================================
		scope		_get_word
_get_word::
		; �`���̃z���C�g�X�y�[�X��R�����g��ǂݔ�΂�
		call		_skip_white_space
		ret			c							; error �� eof �Ȃ� Cy = 1 �Ŕ�����

		ld			hl, s_word
		xor			a, a
		ld			[hl], a
loop1:
		push		hl
		call		_get_one
		pop			hl
		ret			c							; error �� eof �Ȃ� Cy = 1 �Ŕ�����

		cp			a, '_'
		jr			z, detect

		call		isalpha
		jr			c, detect

		call		isdigit
		jr			c, detect

		; �P��ł͂Ȃ��������o�Ă���
		call		_rewind
		xor			a, a						; A = 0, Cy = 0
		ld			[hl], a
		ret										; Cy = 0, Success

detect:
		; �P��̕������o�Ă���
		call		toupper
		ld			[hl], a
		inc			hl
		ld			a, l
		cp			a, (s_word + 16) & 255
		jr			nz, loop1

		; 16�����𒴂������͓ǂݎ̂Ă�
loop2:
		call		_get_one
		ret			c
		cp			a, '_'
		jr			z, loop2

		call		isalpha
		jr			c, loop2

		call		isdigit
		jr			c, loop2
		ret										; Cy = 0, Success
		endscope

; ==============================================================================
;	_check_equal
;	input)
;		none
;	output)
;		s_word .... Retrieved word
;		Cy ........ 0: Success, 1: Failed
;	break)
;		all
;	comment)
;		= �����邩�ǂ������`�F�b�N����
; ==============================================================================
		scope		_check_equal
_check_equal::
		; �`���̃z���C�g�X�y�[�X��R�����g��ǂݔ�΂�
		call		_skip_white_space
		ret			c							; error �� eof �Ȃ� Cy = 1 �Ŕ�����

		call		_get_one
		ret			c							; error �� eof �Ȃ� Cy = 1 �Ŕ�����

		cp			a, '='
		ret			z							; '=' �Ȃ� Cy = 0 �Ŕ�����
		scf
		ret										; Cy = 1, Failed
		endscope

; ==============================================================================
;	_get_number
;	input)
;		none
;	output)
;		hl ........ value
;		Cy ........ 0: Success, 1: Failed
;	break)
;		all
;	comment)
;		= �����邩�ǂ������`�F�b�N����
; ==============================================================================
		scope		_get_number
_get_number::
		; �`���̃z���C�g�X�y�[�X��R�����g��ǂݔ�΂�
		call		_skip_white_space
		ret			c							; error �� eof �Ȃ� Cy = 1 �Ŕ�����

		ld			hl, 0
loop:
		push		hl
		call		_get_one
		pop			hl
		ret			c							; error �� eof �Ȃ� Cy = 1 �Ŕ�����

		cp			a, ';'
		jp			nz, skip					; ';' �Ȃ� Cy = 0, Success �Ŕ�����

		call		_rewind						; ';' ��߂�
		or			a, a
		ret										; Cy = 0, Success
skip:
		call		isspace
		ccf
		ret			nc							; �X�y�[�X�������� Cy = 0, Success �Ŕ�����

		call		isdigit
		ccf
		ret			c							; �����łȂ���� Cy = 1, Failed �Ŕ�����

		; HL = HL * 10 + A - '0'
		sub			a, '0'
		add			hl, hl
		ld			d, h
		ld			e, l
		add			hl, hl
		add			hl, hl
		add			hl, de
		add			a, l
		ld			l, a
		ld			a, 0
		adc			a, h
		ld			h, a
		jr			loop
		endscope

; ==============================================================================
;	_search_word
;	input)
;		s_word ...... variable name
;		value ....... update value
;		ini_target .. Table of INI update target variable
;	output)
;		none
;	break)
;		all
; ==============================================================================
		scope		_search_word
_search_word::
		ld			de, ini_target
loop1:
		; ini_target_item �����������ꍇ�͔�����
		ld			a, [de]
		or			a, a
		ret			z

		; ini_target_item::s_name �� s_word ���r
		ld			hl, s_word
		push		de
		call		strcmp
		pop			de
		jp			z, detect_item

		; �s��v�̏ꍇ�A���� ini_target_item ��
		call		get_next_pos		; HL �ɕ�����̎��̃A�h���X���Ԃ�
		ld			de, 2 + 2			; max_value = 2byte, target_address = 2byte
		add			hl, de
		ex			de, hl
		jr			loop1

detect_item:
		call		get_next_pos		; HL �ɕ�����̎��̃A�h���X���Ԃ�
		; BC = max_value, DE = target_address
		ld			c, [hl]
		inc			hl
		ld			b, [hl]
		inc			hl
		ld			e, [hl]
		inc			hl
		ld			d, [hl]
		inc			hl

		; value ���ő�l�𒴂��Ă����ꍇ�́A�ő�l�ɒu������
		ld			hl, [value]
		xor			a, a
		sbc			hl, bc
		jr			c, skip2
		ld			l, c
		ld			h, b
		ld			[value], hl
skip2:
		ld			hl, [value]
		; ���� 1byte ����������
		ex			de, hl
		ld			[hl], e
		; taget �� 1byte �Ȃ甲����
		or			a, b
		ret			z
		; ��� 1byte ����������
		inc			hl
		ld			[hl], d
		ret

get_next_pos:
		ex			de, hl
loop2:
		ld			a, [hl]
		inc			hl
		or			a, a
		ret			z
		jr			loop2
		endscope

; ==============================================================================
;	work area
; ==============================================================================
_read_buffer::
		space		128

_read_buffer_index::
		db			0							; 0..127: index of _read_buffer, 128: read request

_next_character::
		db			0							; 0: none, 1..255: character code

s_word::
		space		16
		db			0

value::
		dw			0

ini_target_item		macro	s_name, max_value, target_address
		ds			s_name
		db			0							; terminator
		dw			max_value					; maximum value (0�`255 �Ȃ� target_address �� 1byte�l�ƌ��Ȃ�)
		dw			target_address
		endm

ini_target::
		; s_name �̍ő�� 16����
		ini_target_item		"SORT_MODE", 2, sort_mode
		ini_target_item		"PLAY_MODE", 2, play_mode
		ini_target_item		"LOOP", 63, loop_counter
		ini_target_item		"MASTER_VOLUME", 15, master_volume
		ini_target_item		"FADEOUT_SPEED", 128, fadeout_speed
		ini_target_item		"COLOR_SCHEME", 3, theme_code
		ini_target_item		"LOAD_TIME", 1, show_cpu_load_time
		ini_target_item		"AUTO_START", 1, option_p
		ini_target_item		"KEY_REPEAT_WAIT_1ST", 255, key_repeat_begin_wait
		ini_target_item		"KEY_REPEAT_WAIT", 255, key_repeat_wait
		ini_target_item		"PRELOAD_TRY_CNT", 192, preload_try_count
		ini_target_item		"PRELOAD_PGCHG", 192, preload_try_count_for_page_change
		ini_target_item		"PRELOAD_PLY_EN", 192, playing_preload_en
		ini_target_item		"PRELOAD_WAIT", 255, preload_wait
		db			0