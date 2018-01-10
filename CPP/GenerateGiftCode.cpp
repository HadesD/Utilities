#include <iostream>
#include <string>
#include <vector>
#include <fstream>

#include <cstdlib>
#include <ctime>

char getRandChar()
{
	char fromC = 'A';
	char endC = 'z';

	int diff = endC - fromC + 1;

	int randC;
	while (true)
	{
		randC = fromC + (std::rand() % (diff));
		if ((randC <= 90) || (randC >= 97))
		{
			break;
		}
	}

	return static_cast<char>(randC);
}

int getRandNumeric()
{
	return std::rand() % 10;
}

bool createGiftCode(const char codeType, const int genCount)
{
	std::ofstream listGiftFile("ListGiftCode.txt", std::ios::app | std::ios::out);
	if (!listGiftFile.is_open())
	{
		return false;
	}

	const std::string filePath = "Var/GiftCode";
	const int maxGiftCodeLenght = 18;

	for (int i = 0; i < genCount; i++)
	{
		std::string fileName;
		std::string randStr;

		while (true)
		{
			for (int l = 0; l < maxGiftCodeLenght - 1; l++)
			{
				std::string oneRand;
				if ((std::rand() % 2) == 0)
				{
					oneRand = getRandChar();
				}
				else
				{
					oneRand = std::to_string(getRandNumeric());
				}
				randStr += oneRand;
			}

			fileName = codeType + randStr;

			// Check GiftCode exits
			std::ifstream giftFileCheck(filePath + "/" + fileName);
			if (!giftFileCheck.good())
			{
				break;
			}
		}

		std::ofstream giftFile(filePath + "/" + fileName, std::ios::app | std::ios::out);

		if (giftFile.is_open())
		{
			giftFile.close();

			listGiftFile << fileName << std::endl;

			std::cout << "Created GiftCode <" << fileName << ">" << std::endl;
		}
	}

	listGiftFile.close();

	return true;
}

int main()
{
	std::srand(static_cast<unsigned int>(std::time(nullptr)));
	std::cout << "Type one character to make giftcode: " << std::endl;
	char codeType; //Ok con de
	std::cin >> codeType;
	std::cout << "Type numbers of code will be generated: " << std::endl;
	int genCount;
	std::cin >> genCount;

	::createGiftCode(codeType, genCount);

	system("pause");
	std::cin.get();

	return 0;
}
