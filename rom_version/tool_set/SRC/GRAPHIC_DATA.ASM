; ==============================================================================
;	Graphic datas
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
;	2020/10/25	t.hara	1.0		1st release, separated from GRAPHIC.ASM
; ==============================================================================

; ==============================================================================
;	WORKAREA (Read/Write)
; ==============================================================================
grp_select_line_on::			; 0: undisplay, 1: display
		db		1
grp_file_list_mode::			; 0: �Ȗ��\�����[�h, 1: �t�@�C�����\�����[�h
		db		0
grp_top_file::					; �t�@�C�����X�g�̈�ԏ�ɕ\������Ă���t�@�C���̃C���f�b�N�X (255�͔�\��)
		db		255
grp_select_file::				; �J�[�\���̈ʒu�̃t�@�C���̃C���f�b�N�X
		db		0
grp_play_file::					; �Đ����̃t�@�C���̃C���f�b�N�X (255�͒�~��)
		db		255
grp_select_line_no::			; �J�[�\���̈ʒu�̍s�ԍ� (0�`10)
		db		0
grp_no_title::					; �Ȗ������܂܂Ȃ�MGS�t�@�C���̏ꍇ�̈ꗗ�\����
		ds		"No title ["
grp_no_title_file_name::		; �������̓t�@�C�����ŏ㏑�������
		ds		"        "
		ds		"]"
		db		0
grp_track_volume:				; +0: current volume level, +1: track volume level
		db		0, 0			; track 1
		db		0, 0			; track 2
		db		0, 0			; track 3
		db		0, 0			; track 4
		db		0, 0			; track 5
		db		0, 0			; track 6
		db		0, 0			; track 7
		db		0, 0			; track 8
		db		0, 0			; track 9
		db		0, 0			; track A
		db		0, 0			; track B
		db		0, 0			; track C
		db		0, 0			; track D
		db		0, 0			; track E
		db		0, 0			; track F
		db		0, 0			; track G
		db		0, 0			; track H
grp_yes_no:
		db		0				; 0: Yes, 1: No

; ==============================================================================
;	WORKAREA (Read only)
; ==============================================================================
grp_help_table::			; �w���v���b�Z�[�W���X�g
		dw		grp_help_line1, grp_help_line2, grp_help_line3, grp_help_line4
		dw		grp_help_line5, grp_help_line6, grp_help_line7, grp_help_line8
		dw		grp_help_line9, grp_help_line10, grp_help_line11

grp_license_table::			; ���C�Z���X���b�Z�[�W���X�g
		dw		grp_license_line1, grp_license_line2, grp_license_line3, grp_license_line4
		dw		grp_license_line5, grp_license_line6, grp_license_line7, grp_license_line8
		dw		grp_license_line9, grp_license_line10, grp_license_line11

mgsp_progress_bar::
		db		94 - 1, 97,72, 0		; �i���o�[(�P�_1)
		db		94 - 1,129,76, 0		; �i���o�[(�P�_2)
		db		92 - 1, 97,64, 0		; �i���o�[(����1)
		db		92 - 1,129,68, 0		; �i���o�[(����2)
mgsp_progress_bar_state::
		db		0
mgsp_progress_bar_point::
		db		0b00000000, 0b00000000, 0b00000000, 0b00000000	; #0
		db		0b01100000, 0b00000000, 0b00000000, 0b00000000	; #1
		db		0b01101100, 0b00000000, 0b00000000, 0b00000000	; #2
		db		0b01101101, 0b10000000, 0b00000000, 0b00000000	; #3
		db		0b01101101, 0b10110000, 0b00000000, 0b00000000	; #4
		db		0b01101101, 0b10110110, 0b00000000, 0b00000000	; #5
		db		0b01101101, 0b10110110, 0b11000000, 0b00000000	; #6
		db		0b01101101, 0b10110110, 0b11011000, 0b00000000	; #7
		db		0b01101101, 0b10110110, 0b11011011, 0b00000000	; #8
		db		0b01101101, 0b10110110, 0b11011011, 0b01100000	; #9
		db		0b01101101, 0b10110110, 0b11011011, 0b01101100	; #10
mgsp_filename_line::		; �t�@�C���ꗗ�̍s�ɑΉ����鍶�[�� PCG�ԍ�
		db		96, 127, 158, 189, 220, 6, 37, 68, 99, 130, 161
grp_volume_table::			; MasterVolume�ɑ΂���ݒ�l (0���ő�) �ɑΉ����鉹�ʕ\���p�^�[��
		db		0b11111111, 0b11111111
		db		0b11111111, 0b11111110
		db		0b11111111, 0b11111100
		db		0b11111111, 0b11111000
		db		0b11111111, 0b11110000
		db		0b11111111, 0b11100000
		db		0b11111111, 0b11000000
		db		0b11111111, 0b10000000
		db		0b11111111, 0b00000000
		db		0b11111110, 0b00000000
		db		0b11111100, 0b00000000
		db		0b11111000, 0b00000000
		db		0b11110000, 0b00000000
		db		0b11100000, 0b00000000
		db		0b11000000, 0b00000000
		db		0b10000000, 0b00000000

mgsp_keyboard_spot_pattern::
		db		0xAA				; ��i���� +0
		db		0xAA				; ��i���� +1
		db		0xAA				; ��i���� +2
		db		0xAA				; ��i���� +3
		db		0xAA				; ��i���� +4
		db		0xAA				; ��i���� +5
		db		0xAA				; ��i���� +6
		db		0xA2				; ��i���� +7
		db		0xA2				; ��i���� +8
		db		0x8A				; ��i���� +9
		db		0x8A				; ��i���� +10
		db		0x2A				; ��i���� +11
		db		0x28				; ��i���� +12
		db		0xA8				; ��i���� +13
		db		0xAA				; ���i���� +14
		db		0xAA				; ���i���� +15
		db		0xAA				; ���i���� +16
		db		0xAA				; ���i���� +17
		db		0xAA				; ���i���� +18
		db		0xAA				; ���i���� +19
		db		0xAA				; ���i���� +20
		db		0xA2				; ���i���� +21
		db		0xA2				; ���i���� +22
		db		0x8A				; ���i���� +23
		db		0x8A				; ���i���� +24
		db		0x2A				; ���i���� +25
		db		0x28				; ���i���� +26
		db		0xA8				; ���i���� +27

mgsp_tone_to_keyboard::
		db		0    , 0x80			; O0C  --> ��i����
		db		7    , 0x80			; O0C# --> ��i����
		db		0    , 0x20			; O0D  --> ��i����
		db		7    , 0x20			; O0D# --> ��i����
		db		0    , 0x08			; O0E  --> ��i����
		db		0    , 0x02			; O0F  --> ��i����
		db		7    , 0x02			; O0F# --> ��i����
		db		1    , 0x80			; O0G  --> ��i����
		db		8    , 0x80			; O0G# --> ��i����
		db		1    , 0x20			; O0A  --> ��i����
		db		8    , 0x20			; O0A# --> ��i����
		db		1    , 0x08			; O0B  --> ��i����
		db		1    , 0x02			; O1C  --> ��i����
		db		8    , 0x02			; O1C# --> ��i����
		db		2    , 0x80			; O1D  --> ��i����
		db		9    , 0x80			; O1D# --> ��i����
		db		2    , 0x20			; O1E  --> ��i����
		db		2    , 0x08			; O1F  --> ��i����
		db		9    , 0x08			; O1F# --> ��i����
		db		2    , 0x02			; O1G  --> ��i����
		db		9    , 0x02			; O1G# --> ��i����
		db		3    , 0x80			; O1A  --> ��i����
		db		10   , 0x80			; O1A# --> ��i����
		db		3    , 0x20			; O1B  --> ��i����
		db		3    , 0x08			; O2C  --> ��i����
		db		10   , 0x08			; O2C# --> ��i����
		db		3    , 0x02			; O2D  --> ��i����
		db		10   , 0x02			; O2D# --> ��i����
		db		4    , 0x80			; O2E  --> ��i����
		db		4    , 0x20			; O2F  --> ��i����
		db		11   , 0x20			; O2F# --> ��i����
		db		4    , 0x08			; O2G  --> ��i����
		db		11   , 0x08			; O2G# --> ��i����
		db		4    , 0x02			; O2A  --> ��i����
		db		11   , 0x02			; O2A# --> ��i����
		db		5    , 0x80			; O2B  --> ��i����
		db		5    , 0x20			; O3C  --> ��i����
		db		12   , 0x20			; O3C# --> ��i����
		db		5    , 0x08			; O3D  --> ��i����
		db		12   , 0x08			; O3D# --> ��i����
		db		5    , 0x02			; O3E  --> ��i����
		db		6    , 0x80			; O3F  --> ��i����
		db		13   , 0x80			; O3F# --> ��i����
		db		6    , 0x20			; O3G  --> ��i����
		db		13   , 0x20			; O3G# --> ��i����
		db		6    , 0x08			; O3A  --> ��i����
		db		13   , 0x08			; O3A# --> ��i����
		db		6    , 0x02			; O3B  --> ��i����

		db		0 +14, 0x80			; O4C  --> ���i����
		db		7 +14, 0x80			; O4C# --> ���i����
		db		0 +14, 0x20			; O4D  --> ���i����
		db		7 +14, 0x20			; O4D# --> ���i����
		db		0 +14, 0x08			; O4E  --> ���i����
		db		0 +14, 0x02			; O4F  --> ���i����
		db		7 +14, 0x02			; O4F# --> ���i����
		db		1 +14, 0x80			; O4G  --> ���i����
		db		8 +14, 0x80			; O4G# --> ���i����
		db		1 +14, 0x20			; O4A  --> ���i����
		db		8 +14, 0x20			; O4A# --> ���i����
		db		1 +14, 0x08			; O4B  --> ���i����
		db		1 +14, 0x02			; O5C  --> ���i����
		db		8 +14, 0x02			; O5C# --> ���i����
		db		2 +14, 0x80			; O5D  --> ���i����
		db		9 +14, 0x80			; O5D# --> ���i����
		db		2 +14, 0x20			; O5E  --> ���i����
		db		2 +14, 0x08			; O5F  --> ���i����
		db		9 +14, 0x08			; O5F# --> ���i����
		db		2 +14, 0x02			; O5G  --> ���i����
		db		9 +14, 0x02			; O5G# --> ���i����
		db		3 +14, 0x80			; O5A  --> ���i����
		db		10+14, 0x80			; O5A# --> ���i����
		db		3 +14, 0x20			; O5B  --> ���i����
		db		3 +14, 0x08			; O6C  --> ���i����
		db		10+14, 0x08			; O6C# --> ���i����
		db		3 +14, 0x02			; O6D  --> ���i����
		db		10+14, 0x02			; O6D# --> ���i����
		db		4 +14, 0x80			; O6E  --> ���i����
		db		4 +14, 0x20			; O6F  --> ���i����
		db		11+14, 0x20			; O6F# --> ���i����
		db		4 +14, 0x08			; O6G  --> ���i����
		db		11+14, 0x08			; O6G# --> ���i����
		db		4 +14, 0x02			; O6A  --> ���i����
		db		11+14, 0x02			; O6A# --> ���i����
		db		5 +14, 0x80			; O6B  --> ���i����
		db		5 +14, 0x20			; O7C  --> ���i����
		db		12+14, 0x20			; O7C# --> ���i����
		db		5 +14, 0x08			; O7D  --> ���i����
		db		12+14, 0x08			; O7D# --> ���i����
		db		5 +14, 0x02			; O7E  --> ���i����
		db		6 +14, 0x80			; O7F  --> ���i����
		db		13+14, 0x80			; O7F# --> ���i����
		db		6 +14, 0x20			; O7G  --> ���i����
		db		13+14, 0x20			; O7G# --> ���i����
		db		6 +14, 0x08			; O7A  --> ���i����
		db		13+14, 0x08			; O7A# --> ���i����
		db		6 +14, 0x02			; O7B  --> ���i����