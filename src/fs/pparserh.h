#ifndef KERNEL_PPARSERH_H
#define KERNEL_PPARSERH_H

#include "string.h"

struct path_root {
    int drive_no;
    struct path_part* first;
};

struct path_part {
    const char* part;
    struct path_part* next;
};

#endif //KERNEL_PPARSERH_H
