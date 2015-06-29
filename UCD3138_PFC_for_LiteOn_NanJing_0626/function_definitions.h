void char_out_0(char data);
void char_out_1(char data);
void byte_out_1(char data);
void init_dpwm0(void);
void init_dpwm1(void);
void init_dpwm2(void);
void init_dpwm3(void);
void init_dpwms(void);
void init_fault_mux(void);
void init_Filter0(void);
void init_Filter1(void);
void init_Filter2(void);
void init_Filters(void);
void init_front_end0(void);
void init_front_end1(void);
void init_front_end2(void);
void init_front_ends(void);
void init_loop_mux(void);
void init_uart(void);
void init_watchdog(void);
void init_pmbus(void);
void pmbus_handler(void);
void pmbus_idle_handler(void);
void pmbus_read_block_handler(void);
void pmbus_write_block_handler(void);
void pmbus_read_wait_for_eom_handler(void);
void set_new_switching_frequency(void);
void process_uart_rx_data(void);
int pmbus_read_setup_id(void);
int pmbus_read_device_id(void);
Uint8 pmbus_read_cmd_dcdc_paged(void);
Uint8 pmbus_read_cmd_dcdc_nonpaged(void);
Uint8 pmbus_read_cmd_pfc(void);
Uint8 pmbus_write_store_default_all(void);
Uint8 pmbus_write_restore_default_all(void);
Uint32 calculate_dflash_checksum(Uint8 *start_addr, Uint8 *end_addr);
void copy_configuration_to_registers(volatile struct FILTER_REGS *dest);
void copy_configuration_to_ram(volatile struct FILTER_REGS *source);
Uint8 calc_flash_segments(const void* dest_ptr, Uint16 byte_count, Uint8* first_segment);
Uint32 calculate_dflash_checksum(Uint8 *start_addr, Uint8 *end_addr);
Uint8 start_erase_task(const void* dest_ptr, Uint16 byte_count);
Uint8 update_data_flash(void* dest_ptr, const void* src_ptr, Uint16 byte_count) ;
void erase_task(void);
void turn_off_pfc(void);
void byte_out_pri_sec_com(Uint8 byte);
unsigned usqr_simple(unsigned d, unsigned N);





//standard_interrupt.c
void poll_adc(void);
void turn_on_pfc(void);
void standard_interrupt(void);


//main.c
void handle_serial_in(char rx_byte);
void main();
void c_int00(void);


//init_miscellaneous.c
void init_adc_polled(void);
void init_timer_interrupt(void);
void init_miscellaneous(void);
void reinit_miscellaneous(void);

//uart.c
void init_uart0(void);
void init_uart1(void);
void nybble_out_0(char nybble);
void byte_out_0(char data);
void short_out_0(unsigned short data);
void word_out_0(unsigned int data);
void byte_out_space_0(char data);
void short_out_space_0(Uint16 data);
void word_out_space_0(Uint32 data);
void decimal_out_4_digits_0(int32 data);
void decimal_out_4_digits_tenths_0(int32 data);
void decimal_out_5_digits_0(int32 data);
void decimal_out_6_digits_0(int32 data);
void decimal_out_8_digits_0(int32 data);
void decimal_out_3_digits_0(int32 data);
void on_off_out_0(int value);
void nybble_out_1(char nybble);
void short_out_1(unsigned short data);
void word_out_1(unsigned int data);
void byte_out_space_1(char data);
void short_out_space_1(Uint16 data);
void word_out_space_1(Uint32 data);
void decimal_out_4_digits_1(int32 data);
void decimal_out_4_digits_tenths_1(int32 data);
void decimal_out_5_digits_1(int32 data);
void decimal_out_6_digits_1(int32 data);
void decimal_out_3_digits_1(int32 data);
void on_off_out_1(int value);
void string_out_0(char string[]);



//primary_secondary_communication.c
Uint8 translate_nybble_in(Uint8 nyb);
void translate_text_to_raw(void);
int32 u_to_s(Uint8 u);
void store_calibration_data(void);
void output_ram_calibration_data(void);
void flash_wait(void);
void write_calibration_data(void);
void expand_vac_calibration_data(void);
void expand_power_calibration_data(void);
void expand_calibration_data(void);
void get_calibration_from_flash(void);
void output_ram_calibration_values(void);
void running_calibration_message_test(void);
void test_calibration_message(void);
void output_primary_secondary_message(void);


//pmbus_coefficients.c
Uint8 pmbus_write_pi_coefficients(void);
Uint8 pmbus_read_pi_coefficients(void);


//pmbus.c
Uint8 pmbus_write_parm_info(void);
Uint8 pmbus_read_parm_info(void);
Uint8 pmbus_write_parm_value(void);
Uint8 send_string_memcpy(const char *string, Uint32 length);
Uint8 pmbus_read_parm_value(void);
void watchdog_reset(void);
int32 pmbus_write_rom_mode(void);
int32 pmbus_read_one_byte_handler(Uint8 value);
int32 pmbus_read_two_byte_handler(Uint16 value);
Uint8 pmbus_write_vout_cmd(void);
Uint8 pmbus_read_vout_cmd(void);
int32 pmbus_read_vout_handler(void);
int32 pmbus_read_iin(void);
int32 pmbus_read_pin(void);
Uint8 pmbus_write_vout_ov_fault_limit(void);
Uint8 pmbus_read_vout_ov_fault_limit(void);
int32 pmbus_mfr_id_handler(void);
int32 pmbus_mfr_model_handler(void);
int32 pmbus_mfr_revision_handler(void);
Uint8 pmbus_read_debug_buffer(void);
int pmbus_read_gui_constant(void);
Uint8 pmbus_write_gui_constant(void);
Uint8 pmbus_write_user_ram_00(void);
Uint8 pmbus_read_user_ram_00(void);
int32 sign_extend(int value, int number_of_bits);
int32 simple_translate();
Uint8 pmbus_write_frequency(void);
int32 pmbus_write_message(void);
int32 pmbus_read_message(void);


//interrupts.c
void undefined_instruction_exception(void);
void software_interrupt(Uint32 arg1, Uint32 arg2, Uint32 arg3, Uint8 swi_number);
void abort_prefetch_exception(void);
void abort_data_fetch_exception(void);
void fast_interrupt(void);


//init_filters.c
void init_filter0(void);
void init_filter1(void);
void init_filter2(void);
void init_filters(void);


//flash.c
void write_program_flash_word(int * address, int data);
void look_for_interrupted_dflash_erase(void);
Uint8 update_data_flash(void* dest_ptr, const void* src_ptr, Uint16 byte_count);
void erase_one_section(int first_segment, int byte_count);

void e_metering(void);
void input_power_calculation(void);
void input_current_calculation(void);
void input_voltage_calculation(void);
void input_power_measurement(void);


inline void float_to_L11(float input_val);
void match_baud(Uint32 bit_time);
void measure_baud(void);

void CMD_GEN_CAL_W_Handler(void);


