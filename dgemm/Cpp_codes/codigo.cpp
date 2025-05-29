#include <iostream>
#include <random>
#include <chrono>
using namespace std;

int A[8192][8192] ;
int B[8192][8192]; 
int C[8192][8192];



int cria(){
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(1, 8192);
    for (int i=0 ; i<8192; i++){
        for (int j=0; j <8192; j++){
            A[i][j] = distrib(gen);
        }
    }
    for (int i=0 ; i<8192; i++){
        for (int j=0; j <8192; j++){
            B[i][j] = distrib(gen);
        }
    }
    auto start = chrono::high_resolution_clock::now();
    for (int i =0; i<8192; i++){
        for (int j =0; j<8192; j++){
            for (int k=0; k<8192; k++){
                C[i][j] += A[i][k]*B[k][j];
            }
        }
    }
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double,std::milli> duration = end - start;
    cout << duration.count() << endl;
}
int main(){
    for (int i=0; i<5; i++){
        cria();
    }
    return 0;
}
