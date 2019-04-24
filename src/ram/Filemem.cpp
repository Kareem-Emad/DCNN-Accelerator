#include <iostream>
#include <fstream>
using namespace std;


int main(){

freopen ("myfile.txt","w",stdout);

int addr=39000;
for(int j=5; j<28+5; j++){


    for( int i=1; i<29; i++){
        
        if(i*int(j/5)<10)
        cout<< addr<<" => X"<<'"'<<"000"<<i*int(j/5)<<'"'<<','<<endl;
        else if(i*int(j/5)<100)
        cout<< addr<<" => X"<<'"'<<"00"<<i*int(j/5)<<'"'<<','<<endl;
        else 
        cout<< addr<<" => X"<<'"'<<"0"<<i*int(j/5)<<'"'<<','<<endl;

        addr++;
    }
}



}