mgsdrv_h_timi_rel	:= 0xC000								; 0x400 bytes : H.TIMI処理ルーチン置き場
my_slot_no			:= 0xC200								; 1byte : この ROM が存在するスロット番号 e00YYyy
															;         yy = page1 primary slot, YY = page1 secondary slot, e = expanded
timer_counter		:= my_slot_no + 1						; 1byte
song_speed			:= timer_counter + 1					; 2bytes
song_speed_counter	:= song_speed + 2						; 2bytes
save_a				:= song_speed_counter + 2				; 1byte
page1_slot			:= save_a + 1							; 1byte
page2_slot			:= page1_slot + 1						; 1byte
file_name_copy		:= page2_slot + 1						; 9bytes
mgsp_speed_value	:= file_name_copy + 9					; 5bytes
s_number			:= mgsp_speed_value + 5					; 3bytes
kanji_driver		:= s_number + 3							; ???bytes : 漢字ドライバ置き場
kanji_work			:= kanji_driver + kanji_driver_size		; 248bytes : 漢字描画用ワーク
kanji_work_end		:= kanji_work + 248

grp_decompress_area	:= 0xD000								; 768bytes : 起動時のパターンネームテーブル展開用
mgs_transfer_buffer	:= grp_decompress_area					; 8192bytes: MGSファイル転送用の一時バッファ。 ※下位8bit は 0 でなければならない
