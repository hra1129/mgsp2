; ==============================================================================
;	MGSDRV制御
;
;  Copyright (C) 2020 Takayuki Hara (HRA!)
;  All rights reserved.
;                           http://hraroom.s602.xrea.com/msx/software/mgsp.html
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
;		Zf .... 0: エラー, 1: 正常
;	comment)
;		PATHの通った場所から MGSDRV.COM を見つけ出し、マッパーメモリを確保して
;		メモリに読み込む
; ==============================================================================
		scope	init_mgsdrv
init_mgsdrv::
		; MGSDRVを初期化する
		call		mgs_sysck
		ld			[mgs_id_mgsver], hl
		ld			[mgs_id_mibadr], ix
		ld			[mgs_id_trwadr], iy
		ld			[mgs_id_trwsiz], bc

		; H.TIMI割り込みをフックする
		ld			a, 0xC3					; JP xxxx 命令
		ld			[h_timi], a
		ld			hl, mgsdrv_h_timi_start
		ld			[h_timi + 1], hl

		; ワークを初期化する
		call		clear_mgsdrv_track_work
		ret
		endscope

; ==============================================================================
;	MGSDRVのトラックワークをクリアする
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
;		hl .... ファイルエントリのアドレス
;	output)
;		Zf .... 1: 成功, 0: 失敗
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
;	曲を再生する
;	output)
;		Zf .... 0: 失敗, 1: 成功
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
;	曲を停止する
; ==============================================================================
stop_song		:= mgs_initm

; ==============================================================================
;	WORKAREA
; ==============================================================================
file_name_address::
		dw		0

mgs_parameter_block::
mgs_id_mgsver::			; 2bytes: MGSDRVのバージョン
		dw			0
mgs_id_mibadr::			; 2bytes: MIBへのアドレス
		dw			0
mgs_id_trwadr::			; 2bytes: トラックワークのアドレス
		dw			0
mgs_id_trwsiz::			; 2bytes: トラックワークのサイズ
		dw			0
