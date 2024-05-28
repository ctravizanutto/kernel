#ifndef KERNEL_STRING_H
#define KERNEL_STRING_H

#include <stdbool.h>
#include <stddef.h>

size_t strlen(const char* str);
size_t strnlen(const char* str, const size_t max);
bool isdigit(char c);
int tonumericdigit(char c);
#endif //KERNEL_STRING_H
