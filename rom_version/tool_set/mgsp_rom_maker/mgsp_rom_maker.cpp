// --------------------------------------------------------------------
//	MGSP ROM version generator
// ====================================================================
//	YYYY/MM/DD Author
//	2020/12/27 t.hara
// --------------------------------------------------------------------

#include <cstdio>
#include <cctype>
#include <cstring>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <algorithm>

using namespace std;

// --------------------------------------------------------------------
struct FL_ENTRY_T {
	char			s_file_name[ 9 ];
	unsigned char	bank_num;
	unsigned short	address_in_bank;
	unsigned short	file_size;
	unsigned char	index;
	vector<char>	file_image;
};

struct KANJI_CODE_T {
	unsigned short	original_code;			//	KanjiROM内の連番に変換済み
	unsigned short	new_code;				//	KanjiROM内の連番に変換済み

	bool operator()( const KANJI_CODE_T &a, const KANJI_CODE_T &b ) noexcept{
		return a.original_code < b.original_code;
	}
};

// --------------------------------------------------------------------
bool is_sjis1st( unsigned char c ){
	if( 0x81 <= c && c <= 0x9F ){
		return true;
	}
	if( 0xE0 <= c && c <= 0xEF ){
		return true;
	}
	return false;
}

// --------------------------------------------------------------------
int sjis_to_krom_address( const char *p, unsigned short &code ){		//	返値は、消費したbyte数 (1 か 2)
	unsigned char c;

	if( is_sjis1st( p[ 0 ] ) ){
		//	2byte文字の場合
		c = (unsigned char)p[ 0 ];
		if( c >= 0xE0 ){
			c -= 0x40;
		}
		if( c >= 0x88 ){
			c -= 0x03;
		}
		c -= 0x81;
		code = c * 192 + 159;
		c = (unsigned char)p[ 1 ];
		c -= 0x40;
		code = code + c;
	}
	else{
		//	1byte文字の場合
		c = (unsigned char)p[ 0 ];
		c -= 32;
		if( c >= 96 ){
			c -= 33;
		}
		code = c;
		return 1;
	}
	return 2;
}

// --------------------------------------------------------------------
string krom_address_to_rsjis( unsigned short code ){
	unsigned char c;
	string r;

	if( code < 159 ){
		//	1byte文字の場合
		c = (unsigned char)code;
		if( c >= 96 ){
			c += 33;
		}
		c += 32;
		r = (char)c;
	}
	else{
		//	2byte文字の場合
		code = code - 159;
		c = (unsigned char)( code / 192 ) + 0x81;
		if( c >= ( 0x88 - 0x03 ) ){
			c += 0x03;
		}
		if( c >= ( 0xE0 - 0x40 ) ){
			c += 0x40;
		}
		r = (char)c;
		c = (unsigned char)( code % 192 ) + 0x40;
		r = r + (char)c;
	}
	return r;
}

// --------------------------------------------------------------------
#if 0
void test( void ){
	unsigned short code;
	int result;

	result = sjis_to_krom_address( "s", code );
	printf( "code : %04X\n", (int)code );
	printf( "res. : %0d\n", result );
	string s = krom_address_to_rsjis( code );
	printf( "rev. : %s\n", s.c_str() );
}
#endif

// --------------------------------------------------------------------
vector<string> get_mgs_file_list( void ){
	ifstream file( "../mgs/mgslist.txt" );
	if( !file ){
		printf( "[ERROR] Cannot read mgslist.txt.\n" );
		exit( 1 );
	}

	vector<string> list;
	for( ;; ){
		string s;
		getline( file, s );
		if( file.eof() ){
			break;
		}
		if( !isdigit( s[ 0 ] ) ){
			continue;
		}
		if( s.length() < 36 ){
			continue;
		}
		s = s.c_str() + 36;
		list.push_back( s );
	}
	return list;
}

// --------------------------------------------------------------------
//	指定の code は使っていることにする
void add_kanji_code( vector<KANJI_CODE_T> &kanji_code_list, unsigned short code ){
	KANJI_CODE_T add_code;
	add_code.original_code = code;
	add_code.new_code = code;

	for( auto kanji_code = kanji_code_list.begin(); kanji_code != kanji_code_list.end(); kanji_code++ ){
		if( code == kanji_code->original_code ){
			//	すでに存在するコードなので追加しない
			return;
		}
		if( code < kanji_code->original_code ){
			//	挿入する (挿入ソート)	: MGSP内のファイル名順ソート・曲名順ソートの結果が崩れないように文字コードの前後関係は維持する必要あり。そのためのソート。
			kanji_code_list.insert( kanji_code, add_code );
			return;
		}
	}
	//	最初の１個は単純追加
	kanji_code_list.push_back( add_code );
}

// --------------------------------------------------------------------
//	文字幅が半分になる半角文字の数が変わると面倒なので、半角は全部使ってることにする
void add_1byte_code( vector<KANJI_CODE_T> &kanji_code_list ){
	unsigned short i;

	for( i = 0; i < 159; i++ ){
		add_kanji_code( kanji_code_list, i );
	}
}

// --------------------------------------------------------------------
void regist_string( vector<KANJI_CODE_T> &kanji_code_list, const string s ){
	const char *p;
	unsigned short code;

	p = s.c_str();
	while( *p ){
		if( (unsigned char)*p < 32 ){
			p++;
			continue;
		}
		p += sjis_to_krom_address( p, code );
		add_kanji_code( kanji_code_list, code );
	}
}

// --------------------------------------------------------------------
void regist_mgs_file( vector<KANJI_CODE_T> &kanji_code_list, const vector<char> file_image ){
	const char *p;
	unsigned short code;

	p = file_image.data() + 8;
	while( ((unsigned char)*p) >= 32 ){
		p += sjis_to_krom_address( p, code );
		add_kanji_code( kanji_code_list, code );
	}
}

// --------------------------------------------------------------------
void regist_source_file( vector<KANJI_CODE_T> &kanji_code_list, const char *p_file_name ){
	ifstream file( p_file_name );
	string s;
	size_t i;
	bool is_string;

	if( !file ){
		printf( "[ERROR] Cannot read the %s.\n", p_file_name );
		exit( 0 );
	}
	for( ;; ){
		getline( file, s );
		if( file.eof() ){
			break;
		}
		//	コメントを削除する
		is_string = false;
		for( i = 0; i < s.length(); i++ ){
			if( !is_string && s[ i ] == ';' ){
				s = s.substr( 0, i );
				break;
			}
			else if( s[ i ] == '"' ){
				is_string = !is_string;
			}
		}
		//	使用文字として登録する
		regist_string( kanji_code_list, s );
	}
	file.close();
}

// --------------------------------------------------------------------
void get_file_name( FL_ENTRY_T &entry, string &s_file_name ){
	const char *p;
	int i;
	bool sjis1st = false;

	p = s_file_name.c_str();
	for( i = 0; i < 8; i++ ){
		if( p[ i ] == '\0' || p[ i ] == '.' ){
			break;
		}
		if( !sjis1st && is_sjis1st( p[ i ] ) ){
			if( i == 7 ){
				//	7byte目が SJIS 1byte目の場合、中途半端にならないようにそのコードを捨てる
				break;
			}
			sjis1st = true;
		}
		else if( sjis1st ){
			sjis1st = false;
		}
		entry.s_file_name[ i ] = p[ i ];
	}
}

// --------------------------------------------------------------------
vector<char> get_optimized_kfont( vector<KANJI_CODE_T> &kanji_code_list ){
	ifstream file( "../TOOL/KFONT.BIN", ios::binary );
	vector<char> kfont;
	vector<char> optimized_kfont;
	unsigned short code, address;

	if( !file ){
		printf( "[ERROR] Cannot read KFONT.BIN.\n" );
		exit( 1 );
	}
	file.seekg( 0, ios::end );
	size_t size = (size_t)file.tellg();
	file.seekg( 0, ios::beg );
	if( size > 65536 ){
		printf( "[ERROR] File size is too big. (KFONT.BIN)\n" );
		exit( 1 );
	}
	kfont.resize( size );
	file.read( kfont.data(), size );
	file.close();

	int i = 0;

	for( auto &kanji_code : kanji_code_list ) {
		code = i;
		kanji_code.new_code = code;
		i++;

		for( address = 0; address < 8; address++ ){
			optimized_kfont.push_back( kfont[ kanji_code.original_code * 8 + address ] );
		}
	}
	printf( "KFONT Optimization : %dbytes --> %dbytes.\n", (int)kfont.size(), (int)optimized_kfont.size() );
	return optimized_kfont;
}

// --------------------------------------------------------------------
vector<FL_ENTRY_T> get_fl_entry_list( const vector<string> &mgs_file_list, vector<KANJI_CODE_T> &kanji_code_list ){
	vector<FL_ENTRY_T> fl_entry;
	int i;

	i = 0;
	for( auto mgs_file : mgs_file_list ){
		FL_ENTRY_T entry;
		memset( &entry, 0, sizeof( entry ) );
		get_file_name( entry, mgs_file );
		regist_string( kanji_code_list, entry.s_file_name );

		ifstream file( "../MGS/" + mgs_file, ios::binary );
		if( !file ){
			printf( "[ERROR] Cannot read %s.\n", mgs_file.c_str() );
			exit( 1 );
		}
		file.seekg( 0, ios::end );
		size_t size = (size_t)file.tellg();
		file.seekg( 0, ios::beg );
		if( size > 16384 ){
			printf( "[ERROR] File size is too big. (%s)\n", mgs_file.c_str() );
			exit( 1 );
		}
		entry.file_image.resize( size );
		entry.file_size = (unsigned short) size;
		entry.index = i;
		i++;
		file.read( entry.file_image.data(), size );
		file.close();
		fl_entry.push_back( entry );
		regist_mgs_file( kanji_code_list, entry.file_image );
	}
	return fl_entry;
}

// --------------------------------------------------------------------
void replace_kanji_code( char *p, size_t size, const vector<KANJI_CODE_T> &kanji_code_list, unsigned char under_code = 32 ){
	unsigned short original_code;
	unsigned short new_code;
	string s_new_code;

	for( size_t i = 0; i < size; i++ ){
		if( (unsigned char)p[ 0 ] < under_code ){
			break;
		}
		if( (unsigned char)p[ 0 ] < 32 ){
			p++;
			continue;
		}
		sjis_to_krom_address( p, original_code );
		new_code = 0;
		for( auto kanji_code : kanji_code_list ){
			if( kanji_code.original_code == original_code ){
				new_code = kanji_code.new_code;
				break;
			}
		}
		s_new_code = krom_address_to_rsjis( new_code );
		if( new_code < 159 ){
			p[ 0 ] = s_new_code[ 0 ];
			p++;
		}
		else{
			p[ 0 ] = s_new_code[ 0 ];
			p[ 1 ] = s_new_code[ 1 ];
			p += 2;
			i++;
		}
	}
}

// --------------------------------------------------------------------
void replace_source_file( vector<KANJI_CODE_T> &kanji_code_list, const char *p_infile_name, const char *p_outfile_name ){
	ifstream infile( p_infile_name );
	vector<char> line_image;
	string s, c;
	size_t i;
	bool is_string;

	if( !infile ){
		printf( "[ERROR] Cannot read the %s.\n", p_infile_name );
		exit( 0 );
	}

	ofstream outfile( p_outfile_name );
	if( !outfile ){
		printf( "[ERROR] Cannot create the %s.\n", p_outfile_name );
		exit( 0 );
	}
	for( ;; ){
		getline( infile, s );
		if( infile.eof() ){
			break;
		}
		c = "";
		//	コメントを削除する
		is_string = false;
		for( i = 0; i < s.length(); i++ ){
			if( !is_string && s[ i ] == ';' ){
				c = s.substr( i );
				s = s.substr( 0, i );
				break;
			}
			else if( s[ i ] == '"' ){
				is_string = !is_string;
			}
		}
		//	置換する
		line_image.clear();
		for( i = 0; i < s.length(); i++ ){
			line_image.push_back( s[ i ] );
		}
		replace_kanji_code( line_image.data(), line_image.size(), kanji_code_list, 1 );
		for( i = 0; i < c.length(); i++ ){
			line_image.push_back( c[ i ] );
		}
		line_image.push_back( '\n' );
		outfile.write( line_image.data(), line_image.size() );
	}
	infile.close();
	outfile.close();
}

// --------------------------------------------------------------------
void matching_kfont( const vector<KANJI_CODE_T> &kanji_code_list, vector<FL_ENTRY_T> &fl_entry ){

	for( auto &entry : fl_entry ){
		replace_kanji_code( entry.s_file_name, sizeof( entry.s_file_name ), kanji_code_list );
		replace_kanji_code( entry.file_image.data() + 8, entry.file_image.size() - 8, kanji_code_list );
	}
}

// --------------------------------------------------------------------
void makeup_kfont_rom( const vector<char> &kfont ){

	ofstream file( "./KFONT_ROM.BIN", ios::binary );
	if( !file ){
		printf( "[ERROR] Cannot create KFONT_ROM.BIN.\n" );
		exit( 1 );
	}
	file.write( kfont.data(), kfont.size() );
	file.close();
}

// --------------------------------------------------------------------
void refresh_address_in_fl_entry( vector<FL_ENTRY_T> &fl_entry, const vector<char> &kfont ){
	int address, bank_num, offset;

	address = 8192 * 3 + kfont.size() + fl_entry.size() * 16;		//	KFONT は BANK_NUM=3 に置かれる。FL_ENTRY はその次。
	for( auto &entry : fl_entry ){
		bank_num = address / 8192;
		offset = address % 8192;
		entry.bank_num = bank_num;
		entry.address_in_bank = offset;
		address += entry.file_size;
	}
}

// --------------------------------------------------------------------
// fl_entry	macro; 16bytes
//		ds		" " * 9		; +0 , 9bytes: file name( ASCIIZ )
//		db		0			; +9 , 1byte : Bank number where the file resides
//		dw		0			; +10, 2bytes: Address in the bank where the file resides
//		dw		0			; +12, 2bytes: file size
//		db		0			; +14, 1byte : Directory entry index
//		db		0			; +15, 1byte : Reserved
// endm
void makeup_fl_entry( const vector<FL_ENTRY_T> &fl_entry, const vector<char> &kfont ){

	ofstream file( "./FL_ENTRY.ASM" );
	if( !file ){
		printf( "[ERROR] Cannot create FL_ENTRY.ASM.\n" );
		exit( 1 );
	}
	if( fl_entry.size() < 1 ){
		printf( "[ERROR] Cannot found the MGS file.\n" );
		exit( 1 );
	}
	if( fl_entry.size() > 192 ){
		printf( "[ERROR] Too many MGS Files.\n" );
		exit( 1 );
	}
	int address = 8192 * 3 + kfont.size();
	file << "fl_entry_table_init_bank := " << (int)( address / 8192 ) << endl;
	file << "fl_entry_table_init_offset := " << (int)( address % 8192 ) << endl;
	file << "fl_files := " << (int)fl_entry.size() << endl << endl;
	file << "fl_entry_table_init::" << endl;
	for( auto &entry : fl_entry ){
		file << "\t; entry " << (int)entry.index << endl;
		file << "\tdb\t";
		for( int i = 0; i < 9; i++ ){
			if( i > 0 ){
				file << ", ";
			}
			file.width( 2 );
			file.fill( '0' );
			file << "0x" << hex << (int)(unsigned char)entry.s_file_name[ i ];
		}
		file << "\t; +0 , 9bytes: file name( ASCIIZ )" << endl;
		file.width( 0 );
		file << dec;
		file << "\tdb\t" << (int)entry.bank_num << "\t\t\t; +9 , 1byte : Bank number where the file resides" << endl;
		file << "\tdw\t" << entry.address_in_bank << "\t\t\t; +10, 2bytes: Address in the bank where the file resides" << endl;
		file << "\tdw\t" << entry.file_size << "\t\t\t; +12, 2bytes: file size" << endl;
		file << "\tdb\t" << (int)entry.index << "\t\t\t; +14, 1byte : Directory entry index" << endl;
		file << "\tdb\t0\t\t\t; +15, 1byte : Reserved" << endl;
	}
	file.close();

	printf( "MGS File: %d files.\n", (int)fl_entry.size() );
}

// --------------------------------------------------------------------
void makeup_mgs_pack( const vector<FL_ENTRY_T> &fl_entry ){
	unsigned int total_size;

	ofstream file( "./MGS_PACK.BIN", ios::binary );
	if( !file ){
		printf( "[ERROR] Cannot create MGS_PACK.BIN.\n" );
		exit( 1 );
	}
	total_size = 0;
	for( auto &entry : fl_entry ){
		file.write( entry.file_image.data(), entry.file_size );
		total_size += entry.file_size;
	}
	file.close();
	printf( "MGS PACK DATA: %u bytes.\n", total_size );
}

// --------------------------------------------------------------------
int main( int argc, char *argv[] ){
	printf( "MGSP-ROM ver generator\n" );
	printf( "=========================================================\n" );
	printf( "(C)2020 HRA!\n" );

	//test();

	vector<KANJI_CODE_T> kanji_code_list;
	add_1byte_code( kanji_code_list );
	regist_source_file( kanji_code_list, "BASE_GRAPHIC_RO_DATA.ASM" );
	regist_source_file( kanji_code_list, "BASE_CUSTOM.ASM" );

	vector<string> mgs_file_list = get_mgs_file_list();
	vector<FL_ENTRY_T> fl_entry = get_fl_entry_list( mgs_file_list, kanji_code_list );
	vector<char> kfont = get_optimized_kfont( kanji_code_list );
	matching_kfont( kanji_code_list, fl_entry );
	refresh_address_in_fl_entry( fl_entry, kfont );
	makeup_kfont_rom( kfont );
	makeup_fl_entry( fl_entry, kfont );
	makeup_mgs_pack( fl_entry );
	replace_source_file( kanji_code_list, "BASE_GRAPHIC_RO_DATA.ASM", "GRAPHIC_RO_DATA.ASM" );
	replace_source_file( kanji_code_list, "BASE_CUSTOM.ASM", "CUSTOM.ASM" );
	return 0;
}
