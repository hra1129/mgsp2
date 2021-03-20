; ==============================================================================
;	MGSDRV API ENTRY
; ==============================================================================

; ==============================================================================
;	ジャンプテーブル
; ==============================================================================
mgs_stay_addr	:=	0x6000

;	最初の初期化
mgs_sysck		:=	0x0010 + mgs_stay_addr

;	演奏停止＆初期化
mgs_initm		:=	0x0013 + mgs_stay_addr

;	演奏開始
mgs_plyst		:=	0x0016 + mgs_stay_addr

;	トラック状態の変更
mgs_tmst1		:=	0x0019 + mgs_stay_addr

;	トラック状態の変更(PSG専用)
mgs_tmst2		:=	0x001c + mgs_stay_addr

;	割り込みルーチンの入り口
mgs_inter		:=	0x001f + mgs_stay_addr

;	マスターボリュームをセットする
mgs_msvst		:=	0x0022 + mgs_stay_addr

;	OPLLレジスタへの書き込み
mgs_wrtfm		:=	0x0025 + mgs_stay_addr

;	演奏データのヘッダを調べる
mgs_datck		:=	0x0028 + mgs_stay_addr

;	早送り用ウェイト待ち
mgs_ffwat		:=	0x002b + mgs_stay_addr

; ==============================================================================
;	MIB
; ==============================================================================
mgs_mib_fm_slt	:=  0		; fm音源のスロット番号(無しの場合は0ffh)
mgs_mib_sc_slt	:=  1		; scc音源のスロット番号(無しの場合は0ffh)
mgs_mib_maxchn	:=  2		; 演奏トラック数(15又は、17)
mgs_mib_psgenf	:=  3		; psgレジスタ6,11,12,13への書き込みフラグ
mgs_mib_masvol	:=  4		; 現在のマスタボリウム値
mgs_mib_loopct	:=  5		; ループカウンタ
mgs_mib_jumpct	:=  6		; "j"コマンドの通過カウンタ
mgs_mib_solwfg	:=  7		; スローモーションフラグ
mgs_mib_playfg	:=  8		; 演奏中の総トラック数
mgs_mib_cntstr	:= 10		; 制御文字列アドレス
mgs_mib_fadefg	:= 12		; @fコマンド通過カウンタ

; ==============================================================================
;	Track workarea offset
; ==============================================================================
mgs_twa_track_state		:= 0x00		; 1byte, Track State (0:OFF, 1:ON, 2:MUTE)
mgs_twa_gate_time_cnt	:= 0x01		; 2bytes, Gate time counter (signed)
mgs_twa_step_time_cnt	:= 0x03		; 2bytes, Step time counter
mgs_twa_freq_data		:= 0x07		; 2bytes, Frequency data
mgs_twa_detune			:= 0x09		; 2bytes, Detune
mgs_twa_flag			:= 0x16		; 1byte, Flag : bit4=1 is Key ON, bit3=1 is Key OFF
mgs_twa_track_volume	:= 0x17		; 1byte, Track volume
mgs_twa_note_no			:= 0x3A		; 1bytes, 0～11 = C,C#, ... ,B : 12,13 = R
