#include "idt.h"

#include <stddef.h>

#include "config.h"
#include "memory.h"

struct idt_desc idt_descriptors[TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptors;

extern void idt_load(struct idtr_desc* ptr);

void idt_zero()
{
    return;
}

void idt_set(int int_no, void* addr)
{
    struct idt_desc* desc = &idt_descriptors[int_no];
    desc->offset_1 = (uint32_t)addr & 0xFFFF;
    desc->selector = KERNEL_CODE_SELECTOR;
    desc->zero = 0x0;
    desc->type_attr = 0xEE;
    desc->offset_2 = (uint32_t)addr >> 16;

}

void idt_init()
{
    memset(idt_descriptors, 0, sizeof(idt_descriptors));
    idtr_descriptors.limit = sizeof(idt_descriptors) - 1;
    idtr_descriptors.base = (uint32_t) idt_descriptors;

    idt_set(0, idt_zero);

    idt_load(&idtr_descriptors);
}