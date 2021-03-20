; ==============================================================================
;	MGSDRV API ENTRY
; ==============================================================================

; ==============================================================================
;	�W�����v�e�[�u��
; ==============================================================================
mgs_stay_addr	:=	0x6000

;	�ŏ��̏�����
mgs_sysck		:=	0x0010 + mgs_stay_addr

;	���t��~��������
mgs_initm		:=	0x0013 + mgs_stay_addr

;	���t�J�n
mgs_plyst		:=	0x0016 + mgs_stay_addr

;	�g���b�N��Ԃ̕ύX
mgs_tmst1		:=	0x0019 + mgs_stay_addr

;	�g���b�N��Ԃ̕ύX(PSG��p)
mgs_tmst2		:=	0x001c + mgs_stay_addr

;	���荞�݃��[�`���̓����
mgs_inter		:=	0x001f + mgs_stay_addr

;	�}�X�^�[�{�����[�����Z�b�g����
mgs_msvst		:=	0x0022 + mgs_stay_addr

;	OPLL���W�X�^�ւ̏�������
mgs_wrtfm		:=	0x0025 + mgs_stay_addr

;	���t�f�[�^�̃w�b�_�𒲂ׂ�
mgs_datck		:=	0x0028 + mgs_stay_addr

;	������p�E�F�C�g�҂�
mgs_ffwat		:=	0x002b + mgs_stay_addr

; ==============================================================================
;	MIB
; ==============================================================================
mgs_mib_fm_slt	:=  0		; fm�����̃X���b�g�ԍ�(�����̏ꍇ��0ffh)
mgs_mib_sc_slt	:=  1		; scc�����̃X���b�g�ԍ�(�����̏ꍇ��0ffh)
mgs_mib_maxchn	:=  2		; ���t�g���b�N��(15���́A17)
mgs_mib_psgenf	:=  3		; psg���W�X�^6,11,12,13�ւ̏������݃t���O
mgs_mib_masvol	:=  4		; ���݂̃}�X�^�{���E���l
mgs_mib_loopct	:=  5		; ���[�v�J�E���^
mgs_mib_jumpct	:=  6		; "j"�R�}���h�̒ʉ߃J�E���^
mgs_mib_solwfg	:=  7		; �X���[���[�V�����t���O
mgs_mib_playfg	:=  8		; ���t���̑��g���b�N��
mgs_mib_cntstr	:= 10		; ���䕶����A�h���X
mgs_mib_fadefg	:= 12		; @f�R�}���h�ʉ߃J�E���^

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
mgs_twa_note_no			:= 0x3A		; 1bytes, 0�`11 = C,C#, ... ,B : 12,13 = R