// INHO LEE @95105502 & JINNIE CHOI @65406900

#include <iostream>
#include <random>
#include <string>
#include <sstream>
#include <iomanip>
using namespace std;


void displayCenteredString(string s);
double calculateMean(double* sample, int numOfSamples);
double calculateSampleStdDev(double* sample, double sampleMean, int numOfSamples);
double calculateScaledDev(double sampleStdDev, int numOfSamples);
void printTable1_1(int rounds, int numOfSamples);
void printTable1_2(int rounds, int numOfSamples);
void printTable2_1(int rounds, int numOfSamples);
void printTable2_2(int rounds, int numOfSamples);
bool ray(double* x, double* w);
void printTable3(int rounds, int numOfSamples);


struct Point {
    double x;
    double y;
    double z;
};


namespace my {
    string to_string( double d ) {
        ostringstream stm ;
        stm << fixed;
        stm << setprecision(1) << d ;
        return stm.str() ;
    }
}


int main() {
    
    int numOfSamples = 100000;
    int rounds = 10;
    
    // Display Task 1-1
    cout << "-------------------------\n";
    displayCenteredString("Task 1-1");
    cout << "-------------------------\n";
    printTable1_1(rounds, numOfSamples);
    
    // Display Task 1-2
    cout << "-------------------------\n";
    displayCenteredString("Task 1-2");
    cout << "-------------------------\n";
    printTable1_2(rounds, numOfSamples);
    
    // Display Task 2-1
    cout << "-------------------------\n";
    displayCenteredString("Task 2-1");
    cout << "-------------------------\n";
    printTable2_1(rounds, numOfSamples);
    
    // Display Task 2-2
    cout << "-------------------------\n";
    displayCenteredString("Task 2-2");
    cout << "-------------------------\n";
    printTable2_2(rounds, numOfSamples);
    
    // Display Task 3
    cout << "-------------------------\n";
    displayCenteredString("Task 3");
    cout << "-------------------------\n";
    printTable3(rounds, numOfSamples);
    
    return 0;
    
}


void displayCenteredString(string s) {
    printf("%*s%*s\n",int(12+s.length()/2),s.c_str(),int(12-s.length()/2),"");
}


double calculateMean(double* sample, int numOfSamples) {
    double sampleSummation = 0.0;
    for (int j = 0; j < numOfSamples; j++) { sampleSummation += sample[j]; }
    return sampleSummation/double(numOfSamples);
}


double calculateSampleStdDev(double* sample, double sampleMean, int numOfSamples) {
    double sampleSummation = 0.0;
    for (int j = 0; j < numOfSamples; j++) { sampleSummation += pow((sample[j] - sampleMean),2.0); }
    return sqrt( sampleSummation/(double(numOfSamples)-1.0) );
}


double calculateScaledDev(double sampleStdDev, int numOfSamples) {
    return (2.0*sampleStdDev)/sqrt(numOfSamples);
}


// MARK: - Task 1-1
void printTable1_1(int rounds, int numOfSamples) {
    
    // Variables
    double sample[numOfSamples];
    double sampleMean, sampleStdDev, scaledDev;
    
    // Display column titles
    printf("| %5s | %5s | %5s |\n", "Round", "bar_I", "bar_s");
    cout << "-------------------------\n";
    
    // Calculate and print tuples
    for (int i = 1; i <= rounds; i++) {
        
        // Random Generator
        random_device rd;
        mt19937 gen(rd());
        uniform_real_distribution<> dis(-2, 2); // [-2,2)
        
        // Generate 100,000 samples (Ij)
        for (int j = 0; j < numOfSamples; j++) { sample[j] = exp(-pow(dis(gen),2.0)/2.0)/0.25; }
        
        // Use samples to calculate ->
        sampleMean = calculateMean(sample, numOfSamples);
        sampleStdDev = calculateSampleStdDev(sample, sampleMean, numOfSamples);
        scaledDev = calculateScaledDev(sampleStdDev, numOfSamples);
        
        // Display tuple
        printf("|   %-4i| %5.3f | %5.3f |\n", i, sampleMean, scaledDev);
    }
    // Display seperator
    cout << "-------------------------\n";
}


// MARK: - Task 1-2
void printTable1_2(int rounds, int numOfSamples) {

    // Constants
    const double lambda[3] = {0.1, 1.0, 10.0};
    
    // Variables
    double sample[numOfSamples];
    double x, density, sampleMean, sampleStdDev, scaledDev;
    string lambdaString = "";
    
    // Print 3 charts for different lambda values
    for (int k = 0; k < 3; k++) {
    
        // Display lambda Value (centered)
        lambdaString = "Lambda = " + my::to_string(lambda[k]);
        displayCenteredString(lambdaString);
        cout << "-------------------------\n";
        
        // Display column titles
        printf("| %5s | %5s | %5s |\n", "Round", "bar_I", "bar_s");
        cout << "-------------------------\n";
        
        // Calculate and print tuples
        for (int i = 1; i <= rounds; i++) {
            
            // Random Generator
            random_device rd;
            mt19937 gen(rd());
            uniform_real_distribution<> dis(0, 1); // [0, 1)
            
            // Generate 100,000 samples (Ij)
            for (int j = 0; j < numOfSamples; j++) {
                x = 1.0 - (log(dis(gen))/lambda[k]);
                density = lambda[k] * exp(-lambda[k]*(x-1.0));
                sample[j] = exp(-pow(x,2.0)/2.0)/density;
            }
            
            // Use samples to calculate ->
            sampleMean = calculateMean(sample, numOfSamples);
            sampleStdDev = calculateSampleStdDev(sample, sampleMean, numOfSamples);
            scaledDev = calculateScaledDev(sampleStdDev, numOfSamples);
            
            // Display tuple
            printf("|   %-4i| %5.3f | %5.3f |\n", i, sampleMean, scaledDev);
        }
        // Display separator
        cout << "-------------------------\n";
    }
}


// MARK: - Task 2-1
void printTable2_1(int rounds, int numOfSamples) {
    
    // Constants
    const double density = 1.0/pow(M_PI,2.0);
    
    // Variables
    double sample[numOfSamples];
    double x, sampleMean, sampleStdDev, scaledDev;

    // Display column titles
    printf("| %5s | %5s | %5s |\n", "Round", "bar_I", "bar_s");
    cout << "-------------------------\n";
    
    // Calculate and print tuples
    for (int i = 1; i <= rounds; i++) {
        
        // Random Generator
        random_device rd;
        mt19937 gen(rd());
        uniform_real_distribution<> dis(0, 1); // [0,1)
        
        // Generate 100,000 samples (Ij)
        for (int j = 0; j < numOfSamples; j++) {
            x = sin((M_PI/2.0) * dis(gen));
            sample[j] = x/density;
        }
        
        // Use samples to calculate ->
        sampleMean = calculateMean(sample, numOfSamples);
        sampleStdDev = calculateSampleStdDev(sample, sampleMean, numOfSamples);
        scaledDev = calculateScaledDev(sampleStdDev, numOfSamples);
        
        // Display tuple
        printf("|   %-4i| %5.3f | %5.3f |\n", i, sampleMean, scaledDev);
    }
    // Display seperator
    cout << "-------------------------\n";
}


// MARK: - Task 2-2
void printTable2_2(int rounds, int numOfSamples) {
    
    // Constants
    const double density = 1.0/(2.0*M_PI);
    
    // Variables
    double sample[numOfSamples];
    double theta, phi, sampleMean, sampleStdDev, scaledDev;

    // Display column titles
    printf("| %5s | %5s | %5s |\n", "Round", "bar_I", "bar_s");
    cout << "-------------------------\n";
    
    // Calculate and print tuples
    for (int i = 1; i <= rounds; i++) {
        
        // Two Random Generators
        random_device rd;
        mt19937 gen1(rd()), gen2(rd());
        uniform_real_distribution<> dis(0, 1); // [0,1)
        
        // Generate 100,000 samples (Ij)
        for (int j = 0; j < numOfSamples; j++) {
            theta = acos(dis(gen1));
            phi = 2.0 * M_PI * dis(gen2);
            sample[j] = ( pow(cos(theta)*sin(theta)*cos(phi),2.0) * sin(M_PI/2.0) )/density;
        }
        
        // Use samples to calculate ->
        sampleMean = calculateMean(sample, numOfSamples);
        sampleStdDev = calculateSampleStdDev(sample, sampleMean, numOfSamples);
        scaledDev = calculateScaledDev(sampleStdDev, numOfSamples);
        
        // Display tuple
        printf("|   %-4i| %5.3f | %5.3f |\n", i, sampleMean, scaledDev);
    }
    // Display seperator
    cout << "-------------------------\n";
    
}

// Task 3 helper function
bool rayHitsSource(double* x, double* w) {
    
    const double radius = 1.0;
    
    Point source = {1.0,1.0,5.0};
    double L1 = source.z / cos(w[0]);
    double L2 = L1 * sin(w[0]);
    double L3 = L2 * sin(w[1]);
    double L4 = L2 * cos(w[1]);
    
    Point translatedSource = {
        .x = 1.0 - L3,
        .y = 1.0 - L4,
        .z = 0.0
    };

    double rayLocation = sqrt(pow(x[0]-translatedSource.x, 2.0) + pow(x[1]-translatedSource.y, 2.0));
    bool rayHitsSource = ( rayLocation <= pow(radius,2.0) );
    if (rayHitsSource)
        return true;
        
    return false;
}


// MARK: - Task 3
void printTable3(int rounds, int numOfSamples) {
    
    // Constants
    const double density = 1.0/(2.0*M_PI);
    const double L = 100.0;
    
    // Variables
    numOfSamples *= 5; // 500,000 samples
    double sample[numOfSamples], x[2], w[2];
    double theta, phi, sampleMean, sampleStdDev, scaledDev;
    int indicatorFunc;
    
    // Display column titles
    printf("| %5s | %5s | %5s |\n", "Round", "bar_I", "bar_s");
    cout << "-------------------------\n";
    
    // Calculate and display tuples
    for (int i = 1; i <= rounds; i++) {
        
        // Four Random Generators
        random_device rd;
        mt19937 gen1(rd()), gen2(rd()), gen3(rd()), gen4(rd());
        uniform_real_distribution<> dis1(-0.5, 0.5); // [-0.5,0.5)
        uniform_real_distribution<> dis2(0, 1); // [0,1)
      
        // Generate 500,000 samples (Ij)
        for (int j = 0; j < numOfSamples; j++) {
            // x
            x[0] = dis1(gen1);
            x[1] = dis1(gen2);
            
            // w
            theta = acos(dis2(gen3));
            phi = 2.0 * M_PI * dis2(gen4);
            w[0] = theta;
            w[1] = phi;
            
            // Indicator function
            (rayHitsSource(x,w)) ? indicatorFunc = 1 : indicatorFunc = 0;
            
            sample[j] = ( L * double(indicatorFunc) * cos(theta) * sin(M_PI/2.0) )/density;
        }
        
        // Use samples to calculate ->
        sampleMean = calculateMean(sample, numOfSamples);
        sampleStdDev = calculateSampleStdDev(sample, sampleMean, numOfSamples);
        scaledDev = calculateScaledDev(sampleStdDev, numOfSamples);
        
        // Display tuple
        printf("|   %-4i| %5.3f | %5.3f |\n", i, sampleMean, scaledDev);
    }
    // Display seperator
    cout << "-------------------------\n";
}
