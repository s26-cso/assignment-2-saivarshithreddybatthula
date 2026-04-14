#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

int main() {
    char op[10];
    int num1, num2;

    while (scanf("%s %d %d", op, &num1, &num2) == 3) {

        char libname[20] = "lib";
        strcat(libname, op);
        strcat(libname, ".so");

        void* handle = dlopen(libname, RTLD_LAZY);
        int (*func)(int, int) = dlsym(handle, op);

        printf("%d\n", func(num1, num2));

        dlclose(handle);
    }

    return 0;
}