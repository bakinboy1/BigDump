#include "windows.h"
#include <iostream> 
#include <string>
#include <vector>
using namespace std;

int main()
{
	cout << "Hello World! ";
	
	return 0;
};
class bunny {
private:
	int bunnyID;
	bool gender;
	int age;
	string name;
	string color;
	boolean mutant;
public:
	void setID(int ID);
	int getID(void);
	void setGender(bool gen);
	bool getGender(void);
	void setAge(int ag);
	int getAge(void);
	void setName(string nam);
	string getName(void);
	void setColor(string col);
	string getColor(void);
	void setMutant(bool mut);
	bool getMutant(void);
};
bunny::bunny(void) {
	void bunny::setID(int ID) {
		bunnyID = ID;
	}
	int bunny::getID(void){
		cout << "ID: " << bunnyID;
	}
	void bunny::setGender(bool gen) {
		gender = gen;
	}
	bool bunny::getGender(void) {
		cout << "sex: " << gender;
	}
	void bunny::setAge(int ag) {
		age = ag;
	}
	int bunny::getAge(void) {
		cout << "age: " << age;
	}
	void bunny::setName(string nam) {
		name = nam;
	}
	string bunny::getName(void) {
		cout << "name: " << name;
	}
	void bunny::setColor(string col) {
		color = col;
	}
	string bunny::getColor(void) {
		cout << "color: " << color;
	}
	void bunny::setMutant(bool mut) {
		mutant = mut;
	}
	bool bunny:i:getMutant(void) {
		cout << "is a mutant? " << mutant;
	}
};
Names() {
	std::vector<std::string> nameList;
	//add string name to nameList
	// nameList.push_back("example");
	nameList.push_back("Thumper");
	nameList.push_back("Fifel");
	nameList.push_back("MACHO MAN RANDY SAVAGE");
	nameList.push_back("carrot");
	nameList.push_back("spot");
	nameList.push_back("tulip");
	nameList.push_back("poro");
	nameList.push_back("atilla");
	nameList.push_back("hamtaro");
	nameList.push_back("floppy");
	nameList.push_back("poof");
	nameList.push_back("RICK FLAIR NATURE BOY WILSON");
}