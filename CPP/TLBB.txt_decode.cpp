#include <stdio.h>
#include <cstdlib>
#include <vector>
using namespace std;
 
typedef struct txt_header {
	int flag;
	int column; //so cot cua bang
	int row; // so dong
	int data_text; //do dai cua text
				   //size = 16 bytes
};
 
typedef struct data_comment {
	int size_data_comment; //do dai cua block nay = column*4
	int value_type;// loai du lieu : 0:INT; 1:FLOAT;2:STRING
};
 
typedef struct data {
	double size_data; //= column*row*4
	double value;
};
//-------------------------------Ket thuc khai bao cau truc du lieu-----------------
 
 
 
 
void convertfile(FILE *fi, FILE *fo) {
	int column, row, data_text, i, j, pos_data;
	int tab = 9;
	int newline = 2573;
 
	//---------------------------------doc so cot, dong, data_text
	// seek ve dau file
	fseek(fi, 4, SEEK_SET);
	//doc du lieu
	fread(&column, 4, 1, fi);
	fread(&row, 4, 1, fi);
	fread(&data_text, 4, 1, fi);
	// ---------------------------------ket thuc doc so cot, dong, data_text
 
	//--------------------------doc dinh nghia cot
	if (column < 1) { printf("Error in reading column! Exit."); return; }
	//int value_column[column];
	vector<int> value_column(column);
	for (i = 0; i < column; i++)
	{
		fread(&value_column[i], 4, 1, fi);
	}
	value_column[0] = 0;
	value_column[1] = 2;
	//--------------------------ket thuc doc dinh nghia cot
 
	//--------------------------doc du lieu theo dong
	if (row <1) { printf("Error in reading row! Exit."); return; }
	vector<int> value_row(row);
	for (j = 0; j < row; j++)
	{
		for (i = 0; i < column; i++)
		{
			pos_data = 16 + column * 4 + i * 4 + column*j * 4;
			fseek(fi, pos_data, SEEK_SET);
			fread(&value_row[i], 4, 1, fi);
			if (value_column[i] == 0) 
			{
				int temp = value_row[i];
				char buf[sizeof(int) * 8 + 1];
				itoa(temp, buf, 10);
				fprintf(fo, "%s", buf);
				if (i == column - 1) fprintf(fo, "\n"); else fprintf(fo, "\t");
			}
 
			if (value_column[i] == 2) 
			{
				int pos_data_text = 16 + column * 4 + column*row * 4 + value_row[i];
				fseek(fi, pos_data_text, SEEK_SET);
				char text_data;
				fread(&text_data, 1, 1, fi);
				while (text_data != '\0')
				{
					fprintf(fo, "%c", text_data);
					fread(&text_data, 1, 1, fi);
				}
				if (i == column - 1) fprintf(fo, "\n"); else fprintf(fo, "\t");
			}
		}
 
	}
}
 
//----------------------------------ham doc du lieu------------------------------
void convert(FILE *fi, FILE *fo) {
	//f = fopen("test.txt","rb");
	convertfile(fi, fo);
 
}
 
 
 
//*******************************Ham MAIN******************************************
int main(int n, char **a) {
	FILE *fi, *fo;
 
	if (n != 3) { printf("Usage: %s [txt_tlbb_file] [txt_file]", a[0]); return 0; }
 
	fi = fopen(a[1], "rb");
	fo = fopen(a[2], "wt");
	if (fo == NULL) { printf("\nError in writing file %s", a[2]); return 0; }
	if (fi == NULL) { printf("\nError in reading file %s", a[1]); return 0; }
	printf("\nTxt converter Tool for TLBB - 12:08 12-01-2011 GMT+7\
\nAuthor : huuduyen_05 - http://c...content-available-to-author-only...n.com - http://g...content-available-to-author-only...e.vn\
");
	printf("\nWorking....");
 
	convert(fi, fo);
 
	fclose(fi);
	fclose(fo);
	//write_header(foutput);
	printf("Done!\n");
	//getch();
}
