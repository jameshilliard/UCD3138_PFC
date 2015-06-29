#include "include.h"

//software_interrupts.h
void erase_data_flash_segment(Uint8 segment)
{
     swi_single_entry(segment,0,0,0);
}


void erase_dflash_segment_no_delay(Uint8 segment)
{
     swi_single_entry(segment,0,0,1);
}


void write_data_flash_word(Uint32 address,unsigned long data)
{
     swi_single_entry(address,data,0,3);
}


void enable_fast_interrupt(void)
{
     swi_single_entry(0,0,0,4);
}


void disable_fast_interrupt(void)
{
     swi_single_entry(0,0,0,5);
}


void enable_interrupt(void)
{
     swi_single_entry(0,0,0,6);
}


void disable_interrupt(void)
{
     swi_single_entry(0,0,0,7);
}


void write_firqpr(unsigned long value)
{
     swi_single_entry(value,0,0,8);
}


void write_reqmask(unsigned long value)
{
     swi_single_entry(value,0,0,9);
}


void clear_integrity_word(void)
{
     swi_single_entry(0,0,0,12);
}

void write_data_flash_block(Uint32 dest_ptr, Uint32  src_ptr, Uint32 byte_count)
{
	swi_single_entry(dest_ptr, src_ptr, byte_count, 13);
}
#if 0
void write_data_flash_block(void)
{
     swi_single_entry(0,0,0,13);
}
#endif


void set_tfa_mode(void)
{
     swi_single_entry(0,0,0,20);
}


void clear_tfa_mode(void)
{
     swi_single_entry(0,0,0,21);
}


