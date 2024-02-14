#include "kheap.h"

#include "kernel.h"
#include "heap.h"
#include "config.h"

struct heap kheap;
struct heap_table kheap_table;

void kheap_init()
{
    int total_table_entries = HEAP_SIZE_BYTES / HEAP_BLOCK_SIZE;
    kheap_table.entries = (HEAP_BLOCK_TABLE_ENTRY*) HEAP_TABLE_ADDRESS;
    kheap_table.total = total_table_entries;

    void* end = (void*)(HEAP_ADDRESS + HEAP_SIZE_BYTES);
    int res = heap_create(&kheap, (void*)(HEAP_ADDRESS), end, &kheap_table);
    if (res < 0) {
        print("FAILED TO CREATE HEAP\n");
    }
}

void* kmalloc(size_t size)
{
    return heap_malloc(&kheap, size);
}

void kfree(void* ptr)
{
    heap_free(&kheap, ptr);
}
