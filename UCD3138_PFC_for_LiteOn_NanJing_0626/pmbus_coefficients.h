//pmbus_coefficients.h

struct PFC_SETPOINT_STRUCT	//for PFC configuration
{
	Uint32 VOUT_COMMAND;
	Uint32 VOUT_OV_LIMIT;
	Uint32 FREQUENCY;
};

struct PFC_CAL_STRUCT	//for PFC calibration
{
	Uint32 VOUT_CAL_OFFSET;
};

struct PI_GAINS_STRUCT 		//for voltage loop coefficients
{
	int32 KP;
	int32 KI;
	int32 KP_NL;
	int32 KI_NL;
	int32 NL_THRESHOLD;
};

struct FILTER_MISC_REG_BITS
{
    Uint32 rsvd0:27;                	// 31:5  Reserved
    Uint32 NL_MODE:1;          			// 4     NL_MODE - stored in Filter Control Register
	Uint32 AFE_GAIN:2;					// 3:2	`AFE Gain
	Uint32 SAMPLE_TRIG1_OVERSAMPLE:2;  	// 1:0   Configures Oversampling function
};

union FILTER_MISC_REG
{
    struct FILTER_MISC_REG_BITS bit;
    Uint32                 		all;
};

typedef struct 	//for current loop coefficients
{
	struct PFC_SETPOINT_STRUCT	PFC_SETPOINT;		// PFC setpoint configuration
	struct PFC_CAL_STRUCT		PFC_CAL;			// PFC calibration
	struct PI_GAINS_STRUCT		PI_GAINS;			// voltage loop gains
	union COEFCONFIG_REG        COEFCONFIG;         // Coefficient Configuration Register
	union FILTERKPCOEF0_REG     FILTERKPCOEF0;      // Filter KP Coefficient 0 Register
	union FILTERKPCOEF1_REG     FILTERKPCOEF1;      // Filter KP Coefficient 1 Register
	union FILTERKICOEF0_REG     FILTERKICOEF0;      // Filter KI Coefficient 0 Register
	union FILTERKICOEF1_REG     FILTERKICOEF1;      // Filter KI Coefficient 1 Register
	union FILTERKDCOEF0_REG     FILTERKDCOEF0;      // Filter KD Coefficient 0 Register
	union FILTERKDCOEF1_REG     FILTERKDCOEF1;      // Filter KD Coefficient 1 Register
	union FILTERKDALPHA_REG     FILTERKDALPHA;      // Filter KD Alpha Register
	union FILTERNL0_REG         FILTERNL0;          // Filter Non-Linear Limit 0 Register
	union FILTERNL1_REG         FILTERNL1;          // Filter Non-Linear Limit 1 Register
	union FILTERNL2_REG         FILTERNL2;          // Filter Non-Linear Limit 2 Register
	union FILTER_MISC_REG		FILTERMISC;			// Nonlinear mode,AFE gain,oversample 
}PFC_CONFIG_STRUCT;

EXTERN PFC_CONFIG_STRUCT pfc_config_in_ram;

#define PFC_CAL_DEFAULT	{0}
//							 KP,		ki			kp_nl		ki-nl,		nonlinear threshold		
//#define PI_GAINS_DEFAULT	{50000,	    200,		180000,	    0x0500,		15}
//#define PI_GAINS_DEFAULT	{0x06000,	0x00F5,		180000,		0x0500,		20}
#define PI_GAINS_DEFAULT	{0x7000,	0x0e0,		0x20000,	0x0500,		20}//[Ken Zhang]modified 20150327
//						reserved BIN6ALPHA BIN6CONFIG BIN5ALPHA BIN5CONFIG BIN4ALPHA BIN4CONFIG BIN3ALPHA BIN3CONFIG BIN2ALPHA BIN2CONFIG BIN1ALPHA BIN1CONFIG BIN0ALPHA BIN0CONFIG
#define COEFCONFIG_DEFAULT 	{0,		0,		  0,		 0,			0,		   0,		0,			0,		  0,		0,			0,		  0,		0,		  0,		0}

//								researved	KP_COEF_2
//#define FILTERKPCOEF1_DEFAULT	{0,			1600}

//								KI_COEF_3	KI_COEF_2
//#define FILTERKICOEF1_DEFAULT	{0,			290}

//								researved	KD_COEF_2
//#define FILTERKDCOEF1_DEFAULT	{0,			-1}
//								researved	KP_COEF_2//[Ken Zhang]modified 20150326
#define FILTERKPCOEF1_DEFAULT	{0,			15000}

//								KI_COEF_3	KI_COEF_2//[Ken Zhang]modified 20150326
#define FILTERKICOEF1_DEFAULT	{0,			150}

//								researved	KD_COEF_2//[Ken Zhang]modified 20150326
#define FILTERKDCOEF1_DEFAULT	{0,			-1}

//								researved	LIMIT1		researved 	LIMIT0
#define FILTERNL0_DEFAULT		{0,			16, 			0,			8}

//								researved	LIMIT3		researved 	LIMIT2
#define FILTERNL1_DEFAULT		{0,			32,			0,			24}

//								researved	LIMIT5		researved 	LIMIT4
#define FILTERNL2_DEFAULT		{0,			48, 		0,			40}

	//								vout_command,	vout_ov_limit, 	frequency		
#if V360
	#define PFC_SETPOINT_DEFAULT	{360,           420, 			70}
#else
	//#define PFC_SETPOINT_DEFAULT	{410,           450, 			65}
	#define PFC_SETPOINT_DEFAULT	{410,           450, 			55}//[Ken Zhang]change to 400,20150421
#endif
#if 0//org
//								KP_COEF_1	KP_COEF_0
#define FILTERKPCOEF0_DEFAULT	{7005,		2000}//3000

//								KI_COEF_1	KI_COEF_0
#define FILTERKICOEF0_DEFAULT	{206,		35}//92

//								KD_COEF_1	KD_COEF_0
#define FILTERKDCOEF0_DEFAULT	{333,		-1}//-64,-217,0

//								researved	KD_ALPHA_1	researved 	KD_ALPHA_0
#define FILTERKDALPHA_DEFAULT	{0,			66, 		0,			0}//{0,-1,0,150} 201,0

#else
#if 0
#define FILTERKPCOEF0_DEFAULT	{4000,		2000}//3000
//								KI_COEF_1	KI_COEF_0
#define FILTERKICOEF0_DEFAULT	{206,		35}//92
//								KD_COEF_1	KD_COEF_0
#define FILTERKDCOEF0_DEFAULT	{-1,		-1}//-64,-217,0
//								researved	KD_ALPHA_1	researved 	KD_ALPHA_0
#define FILTERKDALPHA_DEFAULT	{0,			0, 		0,			0}//{0,-1,0,150} 201,0
#else
//#define FILTERKPCOEF0_DEFAULT	{3500,		2000}//1200,1600,3500
//								KI_COEF_1	KI_COEF_0
//#define FILTERKICOEF0_DEFAULT	{290,		35}//150
//								KD_COEF_1	KD_COEF_0
//#define FILTERKDCOEF0_DEFAULT	{-1,		-1}//0

//								researved	KD_ALPHA_1	researved 	KD_ALPHA_0
//#define FILTERKDALPHA_DEFAULT	{0,			0, 		0,			0}//{0,-1,0,150} 201,0
//								KP_COEF_1	KP_COEF_0
#define FILTERKPCOEF0_DEFAULT	{20000,		15000}//20000//1200,1600,3500[Ken Zhang]modified 20150326
//								KI_COEF_1	KI_COEF_0
#define FILTERKICOEF0_DEFAULT	{500,		50}//250//150[Ken Zhang]modified 20150326
//								KD_COEF_1	KD_COEF_0
#define FILTERKDCOEF0_DEFAULT	{-1,		-1}//0[Ken Zhang]modified 20150326

//								researved	KD_ALPHA_1	researved 	KD_ALPHA_0
#define FILTERKDALPHA_DEFAULT	{0,			0, 		0,			0}//{0,-1,0,150} 201,0

#endif


#endif
	//								researved	NL_MODE		AFE_GAIN 	SAMPLE_TRIG1_OVERSAMPLE
#define FILTERMISC_DEFAULT		{0,			1, 			0,			3}

#define PFC_CONFIG_DEFAULT \
{\
	PFC_SETPOINT_DEFAULT,\
	PFC_CAL_DEFAULT,\
	PI_GAINS_DEFAULT,\
	COEFCONFIG_DEFAULT,\
	FILTERKPCOEF0_DEFAULT,\
	FILTERKPCOEF1_DEFAULT,\
	FILTERKICOEF0_DEFAULT,\
	FILTERKICOEF1_DEFAULT,\
	FILTERKDCOEF0_DEFAULT,\
	FILTERKDCOEF1_DEFAULT,\
	FILTERKDALPHA_DEFAULT,\
	FILTERNL0_DEFAULT,\
	FILTERNL1_DEFAULT,\
	FILTERNL2_DEFAULT,\
	FILTERMISC_DEFAULT\
}


