#ifndef KERNEL_PPARSERH_H
#define KERNEL_PPARSERH_H

#include "string.h"
#include "kernel.h"
#include "string.h"
#include "memory.h"
#include "kheap.h"
#include "status.h"

struct path_root {
    int drive_no;
    struct path_part* first;
};

struct path_part {
    const char* part;
    struct path_part* next;
};

struct path_root* pathparser_parse(const char* path, const char* current_directory_path);
void pathparser_free(struct path_root* root);

#endif //KERNEL_PPARSERH_H
