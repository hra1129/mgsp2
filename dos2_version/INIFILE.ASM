; ==============================================================================
;   INI file parser
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
		; <variable> = <number> を解釈。s_word = "<variable>", HL = <number>
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
;		次の有効な文字までの空白を読み飛ばす。
; ==============================================================================
		scope		_skip_white_space
_skip_white_space::
		; get 1 character
		call		_get_one
		ret			c							; error か eof なら Cy = 1 で抜ける

		; Is this space?
		call		isspace
		jr			c, _skip_white_space		; space なら次の文字へ

		; Is this comment?
		cp			a, ';'						; コメント開始記号 ';'
		jp			nz, skip1

		; Skip comment
skip_comment:
		call		_get_one
		ret			c							; error か eof なら Cy = 1 で抜ける

		cp			a, '\n'
		jr			nz, skip_comment
		jr			_skip_white_space

skip1:
		call		_rewind						; 取り過ぎてしまった文字を戻す
		or			a, a						; Cy = 0 にして抜ける
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
;		s_word には、最大 16文字の単語名を取得して格納します。
;		17文字以上の場合は、単語の区切り目まで読み捨てます。
;		単語は、アルファベット・数字・アンダースコアで構成されており、
;		大小文字の区別はありません。s_word には大文字に変換されて格納されます。
; ==============================================================================
		scope		_get_word
_get_word::
		; 冒頭のホワイトスペースやコメントを読み飛ばす
		call		_skip_white_space
		ret			c							; error か eof なら Cy = 1 で抜ける

		ld			hl, s_word
		xor			a, a
		ld			[hl], a
loop1:
		push		hl
		call		_get_one
		pop			hl
		ret			c							; error か eof なら Cy = 1 で抜ける

		cp			a, '_'
		jr			z, detect

		call		isalpha
		jr			c, detect

		call		isdigit
		jr			c, detect

		; 単語ではない文字が出てきた
		call		_rewind
		xor			a, a						; A = 0, Cy = 0
		ld			[hl], a
		ret										; Cy = 0, Success

detect:
		; 単語の文字が出てきた
		call		toupper
		ld			[hl], a
		inc			hl
		ld			a, l
		cp			a, (s_word + 16) & 255
		jr			nz, loop1

		; 16文字を超えた分は読み捨てる
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
;		= があるかどうかをチェックする
; ==============================================================================
		scope		_check_equal
_check_equal::
		; 冒頭のホワイトスペースやコメントを読み飛ばす
		call		_skip_white_space
		ret			c							; error か eof なら Cy = 1 で抜ける

		call		_get_one
		ret			c							; error か eof なら Cy = 1 で抜ける

		cp			a, '='
		ret			z							; '=' なら Cy = 0 で抜ける
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
;		= があるかどうかをチェックする
; ==============================================================================
		scope		_get_number
_get_number::
		; 冒頭のホワイトスペースやコメントを読み飛ばす
		call		_skip_white_space
		ret			c							; error か eof なら Cy = 1 で抜ける

		ld			hl, 0
loop:
		push		hl
		call		_get_one
		pop			hl
		ret			c							; error か eof なら Cy = 1 で抜ける

		cp			a, ';'
		jp			nz, skip					; ';' なら Cy = 0, Success で抜ける

		call		_rewind						; ';' を戻す
		or			a, a
		ret										; Cy = 0, Success
skip:
		call		isspace
		ccf
		ret			nc							; スペースが来たら Cy = 0, Success で抜ける

		call		isdigit
		ccf
		ret			c							; 数字でなければ Cy = 1, Failed で抜ける

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
		; ini_target_item がもう無い場合は抜ける
		ld			a, [de]
		or			a, a
		ret			z

		; ini_target_item::s_name と s_word を比較
		ld			hl, s_word
		push		de
		call		strcmp
		pop			de
		jp			z, detect_item

		; 不一致の場合、次の ini_target_item へ
		call		get_next_pos		; HL に文字列の次のアドレスが返る
		ld			de, 2 + 2			; max_value = 2byte, target_address = 2byte
		add			hl, de
		ex			de, hl
		jr			loop1

detect_item:
		call		get_next_pos		; HL に文字列の次のアドレスが返る
		; BC = max_value, DE = target_address
		ld			c, [hl]
		inc			hl
		ld			b, [hl]
		inc			hl
		ld			e, [hl]
		inc			hl
		ld			d, [hl]
		inc			hl

		; value が最大値を超えていた場合は、最大値に置換する
		ld			hl, [value]
		xor			a, a
		sbc			hl, bc
		jr			c, skip2
		ld			l, c
		ld			h, b
		ld			[value], hl
skip2:
		ld			hl, [value]
		; 下位 1byte を書き込む
		ex			de, hl
		ld			[hl], e
		; taget が 1byte なら抜ける
		or			a, b
		ret			z
		; 上位 1byte を書き込む
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
		dw			max_value					; maximum value (0～255 なら target_address は 1byte値と見なす)
		dw			target_address
		endm

ini_target::
		; s_name の最大は 16文字
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
