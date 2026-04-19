#include <stdio.h>      // input/output
#include <dlfcn.h>      // dlopen, dlsym, dlclose

int main() {
    char funcName[32];      // operation name
    int x, y;               // operands

    while (scanf("%s %d %d", funcName, &x, &y) == 3) {
        char libPath[64];                       // library path
        sprintf(libPath, "./lib%s.so", funcName);

        void *libHandle = dlopen(libPath, RTLD_LAZY);
        if (!libHandle) {
            printf("library not found\n");
            continue;
        }

        int (*operation)(int, int);             // function pointer
        operation = (int (*)(int, int)) dlsym(libHandle, funcName);

        int result = operation(x, y);           // call function
        printf("%d\n", result);

        dlclose(libHandle);                     // close library
    }

    return 0;
}
