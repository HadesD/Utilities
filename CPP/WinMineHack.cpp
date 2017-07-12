// Game http://www.minesweeper.info/downloads/WinmineXP.html
#include <windows.h>
#include <iostream>
#include <stdio.h>
#include <conio.h>

//Address
#define addNumRow      0x010056A8
#define addNumCol      0x010056AC
#define addNumFlagLeft 0x01005194
#define addNumBomb     0x01005330
#define addTimer       0x0100579C
//End Define Address

//Array Flag
#define isSafe 0xF
#define isBomb 0x8F
#define isOpen 0x40
#define is1bomb 0x41
#define is2bomb 0x42
#define is3bomb 0x43
#define is4bomb 0x44
#define is5bomb 0x45
#define is6bomb 0x46
#define is7bomb 0x47
#define is8bomb 0x48
#define isFlag 0x8E
#define unKnown 0x8D
#define isExploded 0xCC
#define isRevealed 0x8A
//End Define Array Flag

using namespace std;
void setTextColor(int k)//Change Text Color
{

  HANDLE  hConsole;
  hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(hConsole, k);

}
BYTE readBYTE(DWORD address) {
  BYTE value = 0; //Result will go here
  DWORD pid;
  HWND hwnd;
  hwnd = FindWindow(NULL, "Minesweeper");
  if (!hwnd)
  {
      cout << "Window not found!\n";
      cin.get();
  }
  else
  {
      GetWindowThreadProcessId(hwnd, &pid);
      HANDLE phandle = OpenProcess(PROCESS_VM_READ, 0, pid); //Tao handle va Xin phep quyen Doc
      if (!phandle) //Unsuccess
      {
          cout << "Could not get handle!\n";
          cin.get();//Type any key to reget the HANDLE
      }
      else
      {
          ReadProcessMemory(phandle, (void*)address, &value, sizeof(value), 0);
      }
  }
  return value;
}
DWORD readDWORD(DWORD address) {
  DWORD value = 0; //Result will go here
  DWORD pid;
  HWND hwnd;
  hwnd = FindWindow(NULL, "Minesweeper");
  if (!hwnd)
  {
      cout << "Window not found!\n";
  }
  else
  {
      GetWindowThreadProcessId(hwnd, &pid);
      HANDLE phandle = OpenProcess(PROCESS_VM_READ, 0, pid); //Tao handle va Xin phep quyen Doc
      if (!phandle)  //Unsuccess
      {
          cout << "Could not get handle!\n";
          cin.get();//Type any key to reget the HANDLE
      }
      else
      {
              ReadProcessMemory(phandle, (void*)address, &value, sizeof(value), 0);
      }
  }
  return value;
}
DWORD getAdressOfXY(DWORD row, DWORD col) {
  return (row << 5) + col + 0x1005340;
}

DWORD main()
{
  DWORD numRow;
  DWORD numCol;
  DWORD numFlagLeft;
  DWORD numBomb;
  DWORD timer;
  BYTE res;

  while ( !_kbhit() )
  {
    numRow = readDWORD(addNumRow);
    numCol = readDWORD(addNumCol);
    numFlagLeft = readDWORD(addNumFlagLeft);
    numBomb = readDWORD(addNumBomb);
    timer = readDWORD(addTimer);
    printf("Row: %d Col: %d Bomb: %d Flag Left: %d Time: %d\n", numRow, numCol, numBomb, numFlagLeft, timer );
    for (DWORD r = 1; r <= numRow; r++) {
      for (DWORD c = 1; c <= numCol; c++) {

        res = readBYTE(getAdressOfXY(r, c));
        switch (res)
        {
          case isSafe:
              printf(". ");
              break;
          case isBomb:
              setTextColor(12);
              printf("* ");
              setTextColor(15);
              break;
          case isFlag:
              setTextColor(10);
              printf("F ");
              setTextColor(15);
              break;
          case is1bomb:
              printf("1 ");
              break;
          case is2bomb:
              printf("2 ");
              break;
          case is3bomb:
              printf("3 ");
              break;
          case is4bomb:
              printf("4 ");
              break;
          case is5bomb:
              printf("5 ");
              break;
          case is6bomb:
              printf("6 ");
              break;
          case is7bomb:
              printf("7 ");
              break;
          case is8bomb:
              printf("8 ");
              break;
          case isOpen:
              printf("  ");
              break;
          case isExploded:
              setTextColor(14);
              printf("* ");
              setTextColor(15);
              break;
          case isRevealed:
              setTextColor(12);
              printf("* ");
              setTextColor(15);
              break;                 
          default:
            printf("? ");
            break;
        }//End switch
      } //end for j
      cout << "\n";
    } //end for i

    Sleep(1000);
    system("cls");
  }//end while
  cin.get();
  return 0;
}//end main
