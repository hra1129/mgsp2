mgsdrv_h_timi_rel	:= 0xC000						; 0x400 bytes : H.TIMI�������[�`���u����
my_slot_no			:= 0xC400						; 1byte : ���� ROM �����݂���X���b�g�ԍ� e00YYyy
													;         yy = page1 primary slot, YY = page1 secondary slot, e = expanded
timer_counter		:= my_slot_no + 1				; 1byte
song_speed			:= timer_counter + 1			; 2bytes
song_speed_counter	:= song_speed + 2				; 2bytes
save_a				:= song_speed_counter + 2		; 1byte
page1_slot			:= save_a + 1					; 1byte
page2_slot			:= page1_slot + 1				; 1byte
file_name_copy		:= page2_slot + 1				; 9bytes
mgsp_speed_value	:= file_name_copy + 9			; 5bytes
s_number			:= mgsp_speed_value + 5			; 3bytes

grp_decompress_area	:= 0xD000						; 768bytes : �N�����̃p�^�[���l�[���e�[�u���W�J�p
kanji_work			:= grp_decompress_area			; 248bytes : �����`��p���[�N
kanji_work_end		:= kanji_work + 248
kanji_driver		:= grp_decompress_area + 768	; ???bytes : �����h���C�o�u����