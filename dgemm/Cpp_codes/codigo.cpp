#include <iostream>
#include <random>
#include <chrono>
using namespace std;

int A[1024][1024] ;
int B[1024][1024]; 
int C[1024][1024];



int cria(){
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(1, 100);
    for (int i=0 ; i<1024; i++){
        for (int j=0; j <1024; j++){
            A[i][j] = distrib(gen);
        }
    }
    for (int i=0 ; i<1024; i++){
        for (int j=0; j <1024; j++){
            B[i][j] = distrib(gen);
        }
    }
    auto start = chrono::high_resolution_clock::now();
    for (int i =0; i<1024; i++){
        for (int j =0; j<1024; j++){
            for (int k=0; k<1024; k++){
                C[i][j] += A[i][k]*B[k][j];
            }
        }
    }
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double,std::milli> duration = end - start;
     cout << "Tempo de execução: " << duration.count() << " milisegundos: " << endl;
}
int main(){
    cria();
    return 0;
}
