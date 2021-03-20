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
;	2021/1/10	t.hara	1.0		1st release, separated from GRAPHIC.ASM
; ==============================================================================

; ==============================================================================
;	WORKAREA (Read only)
; ==============================================================================
		;		 0         1         2         3         4         5         6
		;		 0123456789012345678901234567890123456789012345678901234567890
grp_help_line1::
		ds		"<< Keyboard >>"
		db		0
grp_help_line2::
		ds		"[�M]-[�K],[SFT]+[�M][�N]:Sel.File. [1]-[9][Q]-[I]:T-Mute."
		db		0
grp_help_line3::
		ds		"[A]-[F]:Sort/Shuffle. [^][\\]:LoopCount. [Z][X]:Back/Next."
		db		0
grp_help_line4::
		ds		"[M]-[\]:Speed. [SPC][RET]:Play. [HOME]:Mode. [INS][DEL]:Vol."
		db		0
grp_help_line5::
		ds		"[F2]:Stop. [F3]:Fade. [F4][BS]:UpDir. [F5]:Help. [ESC]:Exit."
		db		0
grp_help_line6::
		ds		"[F6]:PlayMem."
		db		0
grp_help_line7::
		ds		"<< Joypad >>"
		db		0
grp_help_line8::
		ds		"[�M][�N],[A]+[�M][�N]:Sel.File. [�L]:UpDir. [�K]:Play."
		db		0
grp_help_line9::
		ds		"[A]+[�L][�K]:Vol. [B]+[�M][�N]:LoopCount."
		db		0
grp_help_line10::
		ds		"[B]+[�L]:Stop. [B]+[�K]:PlayMem. [A]+[B]+[�M]:Exit"
		db		0
grp_help_line11::
		ds		"[A]+[B]+[�K][�L]:Sort"
		db		0

		;		 0         1         2         3         4         5         6
		;		 0123456789012345678901234567890123456789012345678901234567890
grp_license_line1::
		ds		PRM_LICENSE_LINE1
		db		0
grp_license_line2::
		ds		PRM_LICENSE_LINE2
		db		0
grp_license_line3::
		ds		PRM_LICENSE_LINE3
		db		0
grp_license_line4::
		ds		"MGSDRV version 3.20 Copyright(c) 1991-94 by Ain"
		db		0
grp_license_line5::
		ds		"    Copyright(c) 1997-2001 GIGAMIX"
		db		0
grp_license_line6::
		ds		"    https://gigamix.hatenablog.com/entry/mgsdrv/"
		db		0
grp_license_line7::
		ds		"���΁������� BDF �� (Misaki Font BDF Version)"
		db		0
grp_license_line8::
		ds		"    Copyright(C) 2002-2019 Num Kadoma"
		db		0
grp_license_line9::
		ds		"    http://littlelimit.net/"
		db		0
grp_license_line10::
		ds		"MGSP Version 2.1.2R Copyright(C) 2021 HRA!"
		db		0
grp_license_line11::
		ds		"    http://hraroom.s602.xrea.com/msx/software/mgsp.html"
		db		0


mgsp_order_entry::			; 8bytes
		ds		"Entry  "
		db		0
mgsp_order_title::			; 8bytes
		ds		"Title  "
		db		0
mgsp_order_filename::		; 8bytes
		ds		"F.Name "
		db		0
mgsp_order_shuffle::		; 8bytes
		ds		"Shuffle"
		db		0
mgsp_normal_mode::			; 8bytes
		ds		"Normal"
		db		0, 0
mgsp_random_mode::			; 8bytes
		ds		"Random"
		db		0, 0
mgsp_repeat_mode::			; 8bytes
		ds		"Repeat"
		db		0, 0