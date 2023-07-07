; ==============================================================================
;	Graphic datas
;
;  Copyright (C) 2020 Takayuki Hara (HRA!)
;  All rights reserved.
;                                              https://github.com/hra1129/mgsp2
;
;  本ソフトウェアおよび本ソフトウェアに基づいて作成された派生物は、以下の条件を
;  満たす場合に限り、再頒布および使用が許可されます。
;
;  1.ソースコード形式で再頒布する場合、上記の著作権表示、本条件一覧、および下記
;    免責条項をそのままの形で保持すること。
;  2.バイナリ形式で再頒布する場合、頒布物に付属のドキュメント等の資料に、上記の
;    著作権表示、本条件一覧、および下記免責条項を含めること。
;  3.書面による事前の許可なしに、本ソフトウェアを販売、および商業的な製品や活動
;    に使用しないこと。
;
;  本ソフトウェアは、著作権者によって「現状のまま」提供されています。著作権者は、
;  特定目的への適合性の保証、商品性の保証、またそれに限定されない、いかなる明示
;  的もしくは暗黙な保証責任も負いません。著作権者は、事由のいかんを問わず、損害
;  発生の原因いかんを問わず、かつ責任の根拠が契約であるか厳格責任であるか（過失
;  その他の）不法行為であるかを問わず、仮にそのような損害が発生する可能性を知ら
;  されていたとしても、本ソフトウェアの使用によって発生した（代替品または代用サ
;  ービスの調達、使用の喪失、データの喪失、利益の喪失、業務の中断も含め、またそ
;  れに限定されない）直接損害、間接損害、偶発的な損害、特別損害、懲罰的損害、ま
;  たは結果損害について、一切責任を負わないものとします。
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
		ds		"[↑]-[→],[SFT]+[↑][↓]:Sel.File. [1]-[9][Q]-[I]:T-Mute."
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
		ds		"[↑][↓],[A]+[↑][↓]:Sel.File. [←]:UpDir. [→]:Play."
		db		0
grp_help_line9::
		ds		"[A]+[←][→]:Vol. [B]+[↑][↓]:LoopCount."
		db		0
grp_help_line10::
		ds		"[B]+[←]:Stop. [B]+[→]:PlayMem. [A]+[B]+[↑]:Exit"
		db		0
grp_help_line11::
		ds		"[A]+[B]+[→][←]:Sort"
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
		ds		"美咲フォント BDF 版 (Misaki Font BDF Version)"
		db		0
grp_license_line8::
		ds		"    Copyright(C) 2002-2019 Num Kadoma"
		db		0
grp_license_line9::
		ds		"    http://littlelimit.net/"
		db		0
grp_license_line10::
		ds		"MGSP Version 2.1.13R Copyright(C) 2021-2023 HRA!"
		db		0
grp_license_line11::
		ds		"    https://github.com/hra1129/mgsp2"
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
