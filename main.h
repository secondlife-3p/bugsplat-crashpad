#ifndef MAIN_H
#define MAIN_H

#include <string>

// BugSplat Configuration
#define BUGSPLAT_DATABASE "fred"
#define BUGSPLAT_APP_NAME "MyCMakeCrasher"
#define BUGSPLAT_APP_VERSION "1.0"

// Function declarations
std::string getExecutableDir();
bool initializeCrashpad(std::string dbName, std::string appName, std::string appVersion);
void generateExampleCallstackAndCrash();
void func0();
void func1();
void func2();

#endif // MAIN_H 