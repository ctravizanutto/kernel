#include "kernel.h"

#include <stdint.h>
#include <stddef.h>

#include "idt/idt.h"

void kernel_main()
{
    idt_init();
    
}