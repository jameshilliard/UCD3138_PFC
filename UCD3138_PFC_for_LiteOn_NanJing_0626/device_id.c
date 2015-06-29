//------------------------------------------------------------------------------------------
// DEVICE ID STRING
// The device id_string is declared outside that function to make it visible to the
// build tools, even though it only used inside this function function.
//------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
// INCLUDE FILES
//------------------------------------------------------------------------------------------
#include "build.h"
#include "date.h"
#include "Cyclone_Device.h"     // UCD30xx Headers Include File
#include "system_defines.h"
#include "variables.h"
#include "pmbus.h"


//------------------------------------------------------------------------------------------
// DEFINITIONS
//------------------------------------------------------------------------------------------
#define PMBUS_DATA_LENGTH (32)         // the max number of data bytes in a command


//------------------------------------------------------------------------------------------
// MACROS
//------------------------------------------------------------------------------------------
#define min(a,b)  (((a)>(b)) ? (b):(a))


//------------------------------------------------------------------------------------------
// Firmware Release Version Information
//------------------------------------------------------------------------------------------
#define RELEASE_MAJOR   0              // 1-digit decimal (or 4 bits hex)
#define RELEASE_MINOR   0              // 2-digit decimal (or 8 bits hex)


// Create string of leading zeros to pad the build number to four characters.
#if BUILD_NUMBER < 10
    #define ZBLD    "000"
#elif BUILD_NUMBER < 100
    #define ZBLD    "00"
#elif BUILD_NUMBER < 1000
    #define ZBLD    "0"
#else
    #define ZBLD    ""
#endif

// Ugly macros to combine numbers into one big string with proper punctuation.
// Two layers of macros required to force proper substitution.
// Typical result would be "2.04.0.0058"
#define PREMAKE_VERSION_STRING(  maj,    min,     sub,     zbld, bld) \
                                #maj "." #min "." #sub "." zbld #bld

#define    MAKE_VERSION_STRING(maj, min, sub, zbld, bld) \
        PREMAKE_VERSION_STRING(maj, min, sub, zbld, bld)

#define VERSION_STRING \
          MAKE_VERSION_STRING(RELEASE_MAJOR, RELEASE_MINOR, RELEASE_SUB, ZBLD, BUILD_NUMBER)

#define PREMAKE_DEVICE_ID_STRING(__DEVICE_ID__, __BUILD_DATE__) \
          #__DEVICE_ID__ "|" VERSION_STRING "|" #__BUILD_DATE__

#define    MAKE_DEVICE_ID_STRING(__DEVICE_ID__, __BUILD_DATE__) \
        PREMAKE_DEVICE_ID_STRING(__DEVICE_ID__, __BUILD_DATE__)

// Combine hardware device ID, firmware version string, and firmware build date into
// on long string with proper punctuation.  Typical output would be
// "UCD92120|3.8.0.0058|080522"

#define DEVICE_ID_STRING  MAKE_DEVICE_ID_STRING(DEVICE, BUILD_DATE)


#pragma DATA_SECTION (device_id_string, "FixedDeviceID");
const char  device_id_string[] = DEVICE_ID_STRING;


//------------------------------------------------------------------------------------------
// pmbus_read_device_id() returns a string with the controller's model number that
// includes sub-release, build number, and build date.  Uses lots of macros to generate
// string at compile time instead of run time.
//------------------------------------------------------------------------------------------
int pmbus_read_device_id(void)
{
    Uint32 string_len;
	Uint32 byte;

    // Determine the length of the string to send.
    // Do not allow string to overflow the PMBus buffer size.
    string_len = min(sizeof(device_id_string), PMBUS_DATA_LENGTH);

	pmbus_number_of_bytes = string_len + 1;

 	for (byte = 0; byte < string_len; byte++)
	{
	  pmbus_buffer[byte+1] = (Uint8)device_id_string[byte];
	} 
	   
	pmbus_buffer[0] = string_len;

    return PMBUS_SUCCESS;
}
