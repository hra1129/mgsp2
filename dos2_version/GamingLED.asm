; ==============================================================================
;	Gaming LED control routine
;
;  Copyright (C) 2023 Takayuki Hara (HRA!)
;  All rights reserved.
;                                              https://github.com/hra1129/mgsp2
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
;	2020/9/21	t.hara	1.0		1st release
; ==============================================================================

; ��ATMEGA �̊֐��e�[�u���̃C���f�b�N�X�ɂȂ��Ă��邽�߁A����`�̒l�͎w��s��
gled_c_cmd_st			:= 0x43					;        CMD�X�^�[�g���ʎq (Service���[�`���g�p���͕s�v�j
gled_cl_debugen			:= ( 0 << 1) | 1		; 1byte: LED Debug UART On
gled_cl_off				:= ( 1 << 1) | 1		; 1byte: LED OFF/DEMO STOP
gled_cl_draw			:= ( 2 << 1) | 1		; 1byte: LED draw
gled_cl_pos				:= ( 3 << 1) | 1		; 2byte: LED position setting
gled_cl_pat				:= ( 4 << 1) | 1		; 2byte: LED pattern setting
gled_cl_eepinit			:= ( 5 << 1) | 1		; 1byte: EEPROM Init
gled_cl_demo			:= ( 6 << 1) | 1		; 4byte: LED DEMO
gled_cl_real			:= ( 7 << 1) | 1		; 9byte: LED REAL Test
gled_cl_c_rgb			:= ( 8 << 1) | 1		; 4byte: RGB Coler code
gled_cl_c_hue			:= ( 9 << 1) | 1		; 9byte: HSV Coler code hue
gled_cl_c_sat			:= (10 << 1) | 1		; 9byte: HSV Coler code sat
gled_cl_c_val			:= (11 << 1) | 1		; 9byte: HSV Coler code val
gled_cl_p_hue			:= (12 << 1) | 1		; 9byte: Gradation Pattern hue step value
gled_cl_p_rep			:= (13 << 1) | 1		; 2byte: LED pattern repeat value
gled_cl_a_ena			:= (14 << 1) | 1		; 1byte: LED Animation enable
gled_cl_a_dis			:= (15 << 1) | 1		; 1byte: LED Animation disable
gled_cl_a_hue			:= (16 << 1) | 1		; 9byte: HSV Animation hue
gled_cl_a_sat			:= (17 << 1) | 1		; 9byte: HSV Animation sat
gled_cl_a_val			:= (18 << 1) | 1		; 9byte: HSV Animation val
gled_cl_a_pos			:= (19 << 1) | 1		; 9byte: HSV Animation pos
gled_cl_a_moden			:= (20 << 1) | 1		; 2byte: HSV AnimationMode hue
gled_cl_a_modes			:= (21 << 1) | 1		; 2byte: HSV AnimationMode sat
gled_cl_a_modev			:= (22 << 1) | 1		; 2byte: HSV AnimationMode val
gled_cl_a_modep			:= (23 << 1) | 1		; 2byte: HSV AnimationMode val
gled_cl_p_sat			:= (24 << 1) | 1		; 9byte: Gradation Pattern sat step value
gled_cl_p_val			:= (25 << 1) | 1		; 9byte: Gradation Pattern val step value
gled_cl_p_aval			:= (26 << 1) | 1		; 9byte: Gradation Pattern all val value
gled_cl_ee_set			:= (27 << 1) | 1		; 2byte: EEPROM Write
gled_cl_ee_get			:= (28 << 1) | 1		; 2byte: EEPROM Read
gled_cl_ee_cnf			:= (29 << 1) | 1		; 1byte: EEPROM Config set
gled_cl_a_pause			:= (30 << 1) | 1		; 2byte: AnimationMode pause

gled_command_port		:= 0x7F00
gled_signature			:= 0x4010

; ==============================================================================
;	detect gaming LED
;	input)
;		none
;	output)
;		none
;	break)
;		all
;	comment)
;		���������ꍇ�́Agame_led_slot �ɃX���b�g�ԍ�
;		������Ȃ��ꍇ�́Agame_led_slot �� 0x00
;		�X���b�g��؂�ւ����܂܂Ŗ߂�̂ŗv���ӁB
; ==============================================================================
		scope		detect_gaming_led
detect_gaming_led::
		; ��{�X���b�g�𒲂ׂ�
		xor			a, a
	loop_for_primary_slot:
		; �g���X���b�g�̗L���𒲂ׂ�
		ld			b, a
		add			a, exptbl & 0x0FF
		ld			h, exptbl >> 8
		ld			l, a
		ld			a, [hl]
		or			a, a
		ld			a, b							; �t���O�s��
		ld			[game_led_slot], a				; �t���O�s��
		jp			p, have_not_secondary_slot_1
		; �g���X���b�g�����݂���ꍇ
		or			a, 0x80
	loop_for_secondary_slot:
		; 1�X���b�g�̃`�F�b�N
	have_not_secondary_slot_1:
		push		af
		; �w��̃X���b�g�ɐ؂�ւ��� +4010h: "MSXLED" �̑��݂��m���߂�
		ld			h, 0x40
		call		enaslt

		ld			hl, gled_signature
		ld			de, s_signature
		ld			b, 6
	strcmp:
		ld			a, [de]
		cp			a, [hl]
		jr			nz, no_match
		inc			de
		inc			hl
		djnz		strcmp
	match:
		; �������̂��߂̃R�}���h���M
		ld			hl, command
		ld			b, command_end - command
	send_command_loop:
		xor			a, a
		ld			[gled_command_port], a
		nop
		nop
		nop
		ld			a, [hl]
		ld			[gled_command_port], a
		nop
		nop
		nop
		djnz		send_command_loop

		; ��v�����̂Ŗ߂�
		pop			af
		ret
	no_match:
		pop			af
		; ���̃X���b�g
		or			a, a							; �g���X���b�g�t�����H
		jp			p, have_not_secondary_slot_2
		; ���̊g���X���b�g
		add			a, 0b0_000_01_00
		bit			4, a
		jr			z, loop_for_secondary_slot
		and			a, 0b0_000_00_11
	have_not_secondary_slot_2:
		inc			a
		bit			2, a
		jp			z, loop_for_primary_slot
		; ������Ȃ�����
		xor			a, a
		ld			[game_led_slot], a
		ret
	s_signature:
		db			"MSXLED"
	command:
		; _LED_PT(4)
		db			gled_c_cmd_st
		db			gled_cl_pat, (4 << 1) | 1
	command_end:
		endscope

; ==============================================================================
;	gaming LED 1tick
;	input)
;		none
;	output)
;		none
;	break)
;		all
;	comment)
;		1/60�b��1��̏��������s����
;
;		LED  0    1    2    3    4    5    6    7    8    9
;		R   ch1  ch4  ch7  ch10 ch13 ch16 ch1  ch4  ch7  ch10
;		G   ch2  ch5  ch8  ch11 ch14 ch17 ch2  ch5  ch8  ch11
;		B   ch3  ch6  ch9  ch12 ch15 -    ch3  ch6  ch9  ch12
; ==============================================================================
		scope		gaming_led_1tick
gaming_led_1tick::
		; GamingLED�J�[�g���b�W�����݂��Ȃ���Ή��������ɖ߂�
		ld			a, [game_led_slot]
		or			a, a
		ret			z

		; ���ڂ��Ă���g���b�N���̃A�h���X�����߂�
		ld			a, [game_led_state]
		ld			b, a
		xor			a, a
	address_loop:
		add			a, 3 * 2
		djnz		address_loop
		cp			a, 17
		jr			c, address_skip
		sub			a, 17
	address_skip:
		ld			l, a
		ld			h, 0
		ld			de, grp_track_volume
		add			hl, de

		; LED�|�W�V���������X�V����
		ld			a, [game_led_state]
		add			a, a					; 1��� 2LED �Ȃ̂� 2�{
		add			a, a					; pos �� 2�{+1 ��ݒ�
		inc			a
		ld			[parameter_pos1], a
		add			a, 2
		ld			[parameter_pos2], a

		; ���ʏ��𓾂�
		ld			bc, 2
		ld			de, parameter_rgb1
		call		update_volume
		call		update_volume
		call		update_volume

		ld			de, parameter_rgb2
		call		update_volume
		call		update_volume
		call		update_volume

		; GamingLED�J�[�g���b�W�ɐ؂�ւ���
		ld			h, 0x40
		call		enaslt

		; �R�}���h�𑗐M����
		ld			b, command_end - command_start
		ld			hl, command_start
	send_loop:
		xor			a, a
		ld			[gled_command_port], a
		nop
		nop
		nop
		ld			a, [hl]
		ld			[gled_command_port], a
		inc			hl
		nop
		nop
		nop
		djnz		send_loop

		; ���̃X�e�[�g�֑J��
		ld			a, [game_led_state]
		inc			a
		cp			a, 5
		jr			c, skip_clear_state
		xor			a, a
	skip_clear_state:
		ld			[game_led_state], a

		; �X���b�g��RAM�ɖ߂�
		ld			h, 0x40
		ld			a, [ramad1]
		call		enaslt
		ei
		ret

	update_volume:
		ld			a, [hl]
		xor			a, 15				; 0 ���ő�Ȃ̂Ŕ��]������
		add			a, a				; 0�`15 �� 0�`120
		add			a, a
		add			a, a
		add			a, a				; �R�}���h�� 2�{+1 ���w�肷��
		inc			a
		ld			[de], a
		add			hl, bc
		inc			de
		ret

	command_start:
	command_pos1:
		db			gled_c_cmd_st, gled_cl_pos
	parameter_pos1:
		db			0									; POS
		db			0									; for wait dummy
	command_rgb1:
		db			gled_c_cmd_st, gled_cl_c_rgb
	parameter_rgb1:
		db			0, 0, 0								; R, G, B
		db			0									; for wait dummy
	command_draw1:
		db			gled_c_cmd_st, gled_cl_draw
	command_pos2:
		db			gled_c_cmd_st, gled_cl_pos
	parameter_pos2:
		db			0									; POS
		db			0									; for wait dummy
	command_rgb2:
		db			gled_c_cmd_st, gled_cl_c_rgb
	parameter_rgb2:
		db			0, 0, 0								; R, G, B
		db			0									; for wait dummy
	command_draw2:
		db			gled_c_cmd_st, gled_cl_draw
	command_end:
		endscope

; ==============================================================================
;	gaming LED �ւ̃A�N�Z�X (page0)
;	input)
;		none
;	output)
;		none
;	break)
;		all
;	comment)
;		���̃��[�`���́Apage2 �� page3 �ɒu������
; ==============================================================================
		scope		gaming_led_send
gaming_led_send::
		ret
		endscope

; ==============================================================================
game_led_slot::
		db			0					; GamingLED�J�[�g���b�W�����݂���X���b�g�ԍ��B0x00 �Ȃ瑶�݂��Ȃ��B
game_led_state::
		db			0					; �ǂ�LED�𐧌䂷�邩 0�`4
