#include <iostream>
#include <fstream>
using namespace std;


int main(){

freopen ("myfile.txt","w",stdout);

int addr=25;
for(int j=0; j<9; j++){


    for( int i=1; i<11; i++){
        
        if(i<10)
        cout<< addr<<" => X"<<'"'<<"000"<<i<<'"'<<','<<endl;
        else
        cout<< addr<<" => X"<<'"'<<"00"<<i<<'"'<<','<<endl;
        addr++;
    }
}
// for(int j=0; j<5; j++){

    for( int i=0; i<10; i++){
        
        cout<< addr<<" => X"<<'"'<<"0000"<<'"'<<','<<endl;

        addr++;
    }
// }
}