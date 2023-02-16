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

gled_c_cmd_st			:= 0x43					;        CMD�X�^�[�g���ʎq (Service���[�`���g�p���͕s�v�j
gled_cl_debugen			:= ( 0 << 1) | 1		; 1byte : LED Debug UART On
gled_cl_off				:= ( 1 << 1) | 1		; 1byte : LED OFF/DEMO STOP
gled_cl_draw			:= ( 2 << 1) | 1		; 1byte : LED draw
gled_cl_pos				:= ( 3 << 1) | 1		; 2byte : LED position setting
gled_cl_pat				:= ( 4 << 1) | 1		; 2byte : LED pattern setting
gled_cl_eepinit			:= ( 5 << 1) | 1		; 1byte : EEPROM Init
gled_cl_demo			:= ( 6 << 1) | 1		; 4byte : LED DEMO
gled_cl_real			:= ( 7 << 1) | 1		; 9byte : LED REAL Test
gled_cl_c_rgb			:= ( 8 << 1) | 1		; 4byte : RGB Coler code
gled_cl_c_hue			:= ( 9 << 1) | 1		; 9byte : HSV Coler code hue
gled_cl_c_sat			:= (10 << 1) | 1		; 9byte : HSV Coler code sat
gled_cl_c_val			:= (11 << 1) | 1		; 9byte : HSV Coler code val
gled_cl_p_hue			:= (12 << 1) | 1		; 9byte : Gradation Pattern hue step value
gled_cl_p_rep			:= (13 << 1) | 1		; 2byte : LED pattern repeat value
gled_cl_a_ena			:= (14 << 1) | 1		; 1byte : LED Animation enable
gled_cl_a_dis			:= (15 << 1) | 1		; 1byte : LED Animation disable
gled_cl_a_hue			:= (16 << 1) | 1		; 9byte : HSV Animation hue
gled_cl_a_sat			:= (17 << 1) | 1		; 9byte : HSV Animation sat
gled_cl_a_val			:= (18 << 1) | 1		; 9byte : HSV Animation val
gled_cl_a_pos			:= (19 << 1) | 1		; 9byte : HSV Animation pos
gled_cl_a_moden			:= (20 << 1) | 1		; 2byte : HSV AnimationMode hue
gled_cl_a_modes			:= (21 << 1) | 1		; 2byte : HSV AnimationMode sat
gled_cl_a_modev			:= (22 << 1) | 1		; 2byte : HSV AnimationMode val
gled_cl_a_modep			:= (23 << 1) | 1		; 2byte : HSV AnimationMode val
gled_cl_p_sat			:= (24 << 1) | 1		; 9byte : Gradation Pattern sat step value
gled_cl_p_val			:= (25 << 1) | 1		; 9byte : Gradation Pattern val step value
gled_cl_p_aval			:= (26 << 1) | 1		; 9byte : Gradation Pattern all val value
gled_cl_ee_set			:= (27 << 1) | 1		; 2byte : EEPROM Write
gled_cl_ee_get			:= (28 << 1) | 1		; 2byte : EEPROM Read
gled_cl_ee_cnf			:= (29 << 1) | 1		; 1byte : EEPROM Config set
gled_cl_a_pause			:= (30 << 1) | 1		; 2byte : AnimationMode pause
gled_cl_p_rgb			:= (31 << 1) | 1		; 5byte : Color Parameter Set (RGB format)
gled_cl_p_hsv			:= (32 << 1) | 1		; 6byte : Color Parameter Set (HSV format)
gled_cl_null			:= (33 << 1) | 1		; gled_c_cmd_st
gled_cl_p_rgball		:= (34 << 1) | 1		; 31byte: ALL Color Parameter set & Draw(RGB)
gled_cl_p_hsvall		:= (35 << 1) | 1		; 41byte: ALL Color Parameter set & Draw(HSV)

gled_command_port		:= 0x7F00
gled_signature			:= 0x4010
gled_send_command		:= 0x4020				; GamingLED Service routine

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
		ld			b, a							; �X���b�g�ԍ����o�b�N�A�b�v
		add			a, exptbl & 0x0FF
		ld			h, exptbl >> 8
		ld			l, a
		ld			a, [hl]
		or			a, a							; �����r�b�g������
		ld			a, b							; �X���b�g�ԍ��𕜌��A�t���O�s��
		jp			p, have_not_secondary_slot_1	; �����r�b�g�������Ă��Ȃ����(���̒l�Ȃ��)�g���X���b�g����
		; �g���X���b�g�����݂���ꍇ
		or			a, 0x80
	loop_for_secondary_slot:
		; 1�X���b�g�̃`�F�b�N
	have_not_secondary_slot_1:
		ld			[game_led_slot], a				; �X���b�g�ԍ�������
		push		af								; enaslt �Ŕj�󂳂�Ȃ��悤�� A ���X�^�b�N�֑Ҕ�
		; �w��̃X���b�g�ɐ؂�ւ��� +4010h: "MSXLED" �̑��݂��m���߂�
		ld			h, 0x40
		call		enaslt							; page1 ���w��̃X���b�g�ɕς���
		; - �V�O�l�`�� MSXLED �̑��݊m�F
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
		call		gled_wait
		ld			a, gled_cl_off
		ld			b, 1
		ld			hl, command1
		call		gled_send_command				; _LED_OFF : �f�����~�߂�
		call		gled_wait

		ld			a, gled_cl_pat
		ld			b, 2
		ld			hl, command1
		call		gled_send_command				; _LED_PAT(4) : �P���w�胂�[�h
		call		gled_wait

		ld			a, gled_cl_draw
		ld			b, 1
		ld			hl, command1
		call		gled_send_command				; _LED_DRAW

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

	gled_wait:
		ei
		ld			a, [jiffy]
		ld			b, a
	wait_loop:
		ld			a, [jiffy]
		cp			a, b
		jp			z, wait_loop
		di
		ret

	s_signature:
		db			"MSXLED"
	command1:
		db			4
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

		; ���ʏ����X�V
		ld			c, (0 << 1) | 1
		ld			hl, parameter_rgb1
		ld			de, grp_track_volume
		call		update_volume		; LED1  : ch1, 2, 3
		call		update_volume		; LED2  : ch4, 5, 6
		call		update_volume		; LED3  : ch7, 8, 9
		call		update_volume		; LED4  : ch10, 11, 12
		call		update_volume		; LED5  : ch13, 14, 15
		call		update_volume		; LED6  : ch16, 17, dummy
		ld			de, grp_track_volume
		call		update_volume		; LED7  : ch1, 2, 3
		call		update_volume		; LED8  : ch4, 5, 6
		call		update_volume		; LED9  : ch7, 8, 9
		call		update_volume		; LED10 : ch10, 11, 12

	send_command:
		; �R�}���h�𑗐M����
		ld			a, gled_cl_p_rgball
		ld			b, 31
		ld			hl, command
		rst			0x30
	game_led_slot::
		db			0
		dw			gled_send_command
		ret

	update_volume:
		ld			b, 3
	update_volume_loop:
		ld			a, [de]
		add			a, a				; 0�`15 �� 0�`120
		add			a, a
		add			a, a
		ld			[hl], a
		inc			de
		inc			de
		inc			hl
		djnz		update_volume_loop
		ret

	command:
	parameter_rgb1:
		db			0, 0, 0											; R, G, B
	parameter_rgb2:
		db			0, 0, 0											; R, G, B
	parameter_rgb3:
		db			0, 0, 0											; R, G, B
	parameter_rgb4:
		db			0, 0, 0											; R, G, B
	parameter_rgb5:
		db			0, 0, 0											; R, G, B
	parameter_rgb6:
		db			0, 0, 0											; R, G, B
	parameter_rgb7:
		db			0, 0, 0											; R, G, B
	parameter_rgb8:
		db			0, 0, 0											; R, G, B
	parameter_rgb9:
		db			0, 0, 0											; R, G, B
	parameter_rgb10:
		db			0, 0, 0											; R, G, B
		endscope
