#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <map>

using namespace std;

string convert(const string& code, const map<string, string>& machine)
{
    auto it = machine.find(code);
    if (it != machine.end())
    {
        return it->second;
    }
    return code;
}
                /*Converting Decimal to binary*/
string dec_to_bin(int decimal)
{
    string binary;
   // bool negative = (decimal < 0);

    if (decimal < 0) 
    {
        // Perform two's complement for negative numbers
        decimal = 65536 + decimal; // Get positive value for conversion
    }

        while (decimal > 0) {
            int bit = decimal % 2;
            binary = to_string(bit) + binary;
            decimal /= 2;
        }

        // Pad with ones to make it 15 bits
        while (binary.length() < 16) {
            binary = "0" + binary;
        }

        return binary; // Negative numbers have a leading 1 for the sign bit
    }
    /*else {
        // For positive numbers
        while (decimal > 0) {
            int bit = decimal % 2;
            binary = to_string(bit) + binary;
            decimal /= 2;
        }

        // Pad with zeros to make it 16 bits
        while (binary.length() < 16) {
            binary = "0" + binary;
        }

        return "0" + binary; // Positive numbers have a leading 0 for the sign bit
    }*/
    
    /* string binary;
    for (int i = 0; i < 16; ++i) //making sure the binary value is only 16 bits wide
    {
        int bit = (decimal >> (15 - i)) & 1;
        binary += to_string(bit);
    }
    return binary;*/


int main() 
{
                    /*opening the file*/
    ifstream MIPSfile("assembler.txt");
    ofstream Machinefile("machine_code.txt");

    if (!MIPSfile.is_open())
    {
        cerr << "Cannot open file.\n";
        return 1;
    }

    if (!Machinefile.is_open())
    {
        cerr << "Cannot create this file.\n";
        return 1;
    }
                /*Mapping the instructions to binary*/
    map<string, string>convert_code = {
        {"LI", "0"},
        {"MAL", "10000"},
        {"MAH", "10001"},
        {"MSL", "10010"},
        {"MSH", "10011"},
        {"LMAL", "10100"},
        {"LMAH", "10101"},
        {"LMSL", "10110"},
        {"LMSH", "10111"},
        {"NOP", "1100000000"},
        {"SHRHI", "1100000001"},
        {"AU","1100000010"},
        {"CNT1H", "1100000011"},
        {"AHS", "1100000100"},
        {"OR", "1100000101"},
        {"BCW", "1100000110"},
        {"MAXWS", "1100000111"},
        {"MINWS", "1100001000"},
        {"MLHU", "1100001001"},
        {"MLHSS", "1100001010"},
        {"AND", "1100001011"},
        {"INVB", "1100001100"},
        {"ROTW", "1100001101"},
        {"SFWU", "1100001110"},
        {"SFHS", "1100001111"},
        {"$0", "00000"},
        {"$1", "00001"},
        {"$2", "00010"},
        {"$3", "00011"},
        {"$4", "00100"},
        {"$5", "00101"},
        {"$6", "00110"},
        {"$7", "00111"},
        {"$8", "01000"},
        {"$9", "01001"},
        {"$10", "01010"},
        {"$11", "01011"},
        {"$12", "01100"},
        {"$13", "01101"},
        {"$14", "01110"}, 
        {"$15", "01111"},
        {"$16", "10000"},
        {"$17", "10001"},
        {"$18", "10010"},
        {"$19", "10011"},
        {"$20", "10100"},
        {"$21", "10101"}, 
        {"$22", "10110"},
        {"$23", "10111"},
        {"$24", "11000"},
        {"$25", "11001"},
        {"$26", "11010"},
        {"$27", "11011"},
        {"$28", "11100"},
        {"$29", "11101"},
        {"$30", "11110"},
        {"$31", "11111"},
        {"!0", "000"},
        {"!1", "001"},
        {"!2", "010"},
        {"!3", "011"}, 
        {"!4", "100"},
        {"!5", "101"}, 
        {"!6", "110"},
        {"!7", "111"},
    };

    string line;
    while (getline(MIPSfile, line))
    {
       // if (line.length() < 25) //making sure each line is only 25 bits
       // {
            istringstream iss(line);
            string word;
            string add_0s;
            while (iss >> word)
            {
                bool number = true;
                for (char c : word)
                {
                    if (!isdigit(c) && c!= '-')
                    {
                        number = false;
                        break;
                    }
                }

                if (number) //if there is a number, convert it into binary
                {
                    int decimal = stoi(word);
                    string binary = dec_to_bin(decimal);
                   add_0s += binary;
                   // Machinefile << binary;
                }
                else
                {
                    string converted_code = convert(word, convert_code);
                    add_0s += converted_code;
                    //Machinefile << converted_code;
                }

                // Machinefile << " ";

                //add_0s.resize(25, '0');
            }
            add_0s.resize(25, '0'); // if the line is less than 25, add in 0s to make it 25 bits long
            Machinefile << add_0s << "\n";
        //}
       /* else //if it is already at 25 bits, just output the translation
        {
            Machinefile << line << "\n";
        }*/
    }

    cout << "File translation finished.\n";

    MIPSfile.close();
    Machinefile.close();

    return 0;
}