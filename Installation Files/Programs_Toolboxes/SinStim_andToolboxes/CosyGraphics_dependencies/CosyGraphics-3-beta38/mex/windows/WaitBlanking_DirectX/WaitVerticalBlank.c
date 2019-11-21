#include "mex.h"
#include "windows.h"

typedef int (* InterfaceCommon)( void );

#define MESSAGE_LENGTH 200

InterfaceCommon InitialiseDevice;
InterfaceCommon UninitialiseDevice;
InterfaceCommon ResetDevice;
InterfaceCommon WaitVerticalBlank;

HINSTANCE handle = NULL;
INT WaitResult;
UINT WaitCount = 0;
BOOL IsInitialised = false;
BOOL MessageEnable = false;

char InfoMsg[ MESSAGE_LENGTH ] = "No info.";
char ErrorMsg[ MESSAGE_LENGTH ]= "No error.";

int Initialise( const char * path )
{
	char fullpath1[256] = { 0 };
	char fullpath2[256] = { 0 };

	strcat( fullpath1, path );
	strcat( fullpath1, "\\msvcr100.dll");

	handle = LoadLibrary( fullpath1 );
	
	if ( !handle )
		return -1;
	
	strcat( fullpath2, path );
	strcat( fullpath2, "\\WaitVerticalBlank_msv100.dll");

	handle = LoadLibrary( fullpath2 );
	
	if ( !handle )
		return -2;

	InitialiseDevice = 
		(InterfaceCommon) GetProcAddress( handle, "InitialiseDevice" );

	if ( ! InitialiseDevice )
	{
		FreeLibrary( handle );
		return -3;
	}

	ResetDevice = 
		(InterfaceCommon) GetProcAddress( handle, "ResetDevice" );

	if ( ! ResetDevice )
	{
		FreeLibrary( handle );
		return -3;
	}

	UninitialiseDevice = 
		(InterfaceCommon) GetProcAddress( handle, "UninitialiseDevice" );

	if ( ! UninitialiseDevice )
	{
		FreeLibrary( handle );
		return -3;
	}
	
	WaitVerticalBlank = (InterfaceCommon) GetProcAddress( handle, "WaitVerticalBlank" );
	
	if ( ! WaitVerticalBlank )
	{
		FreeLibrary( handle );
		return -3;
	}

	return 1;
}

void PrintInfo( const char * info )
{
	strcpy( InfoMsg, info );
	if ( MessageEnable ) mexPrintf( InfoMsg );
}

void PrintError( const char * error )
{
	strcpy( ErrorMsg, error );
	mexErrMsgTxt( ErrorMsg );
}

void mexFunction( int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{	
	char
		* argument1,
		* argument2;
	int i;

	if ( nrhs == 0 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU MUST PROVIDE A LEAST ONE ARGUMENT.");
	
	argument1 = mxArrayToString(prhs[0]);

	for ( i = 0; i < strlen( argument1 ) ; ++i )
		 argument1[i] = toupper(argument1[i]); 

	if ( strcmp( argument1, "LASTINFO" ) == 0 )
	{
		if ( nlhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN THE RESULT TO MORE THAN ONE VALUE.");
		if ( nrhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : THERE IS NOT A SECOND ARGUMENT.");
		plhs[0] = mxCreateString( InfoMsg );
		return;
	}
	else if ( strcmp( argument1, "LASTERROR" ) == 0 )
	{
		if ( nlhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN THE RESULT TO MORE THAN ONE VALUE.");
		if ( nrhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : THERE IS NOT A SECOND ARGUMENT.");
		plhs[0] = mxCreateString( ErrorMsg );
		return;
	}

	sprintf( InfoMsg, "No info." );
	sprintf( ErrorMsg, "No error." );

	if ( strcmp( argument1, "WAIT") == 0 )
	{
		if ( nlhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN THE RESULT TO MORE THAN ONE VALUE.");
		if ( nrhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : THERE IS NOT A SECOND ARGUMENT.");

		if ( handle != NULL )
		{	
			WaitResult = WaitVerticalBlank();
			
			if ( WaitResult == 1 ) 
			{
				PrintInfo("WAIT_VERTICAL_BLANK INFO : WAIT BLANKING WAS OK.\n");
				plhs[0] = mxCreateScalarDouble( 1 );
			}
			else if ( WaitResult == -1 ) 
			{
				PrintError("WAIT_VERTICAL_BLANK WARNING : CALL WITH 'WAIT' THE DIRECTX DEVICE WAS LOST. WAIT BLANKING WAS AFFECTED");
				plhs[0] = mxCreateScalarDouble( -1 );
			}
			else if ( WaitResult == -2 ) 
			{
				PrintError("WAIT_VERTICAL_BLANK WARNING : CALL WITH 'WAIT' THE DIRECTX DEVICE WAS RESET DUE TO A LOST STATE. WAIT BLANKING COULD BE AFFECTED");
				plhs[0] = mxCreateScalarDouble( -2 );
			}
		}
		else 
		{
			PrintInfo("WAIT_VERTICAL_BLANK INFO : NO NEED TO WAIT BECAUSE IT IS NOT INITIALISED.\n"); 
			plhs[0] = mxCreateScalarDouble( 0 );
		}
	}
	else if ( strcmp( argument1, "ISINIT" ) == 0 )
	{
		if ( nlhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN THE RESULT TO MORE THAN ONE VALUE.");
		if ( nrhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : THERE IS NOT A SECOND ARGUMENT.");

		if ( handle != NULL )
		{
			PrintInfo("WAIT_VERTICAL_BLANK INFO : IT IS INITIALISED.\n");
			plhs[0] = mxCreateLogicalScalar( TRUE );		
		}
		else 
		{
			PrintInfo("WAIT_VERTICAL_BLANK INFO : IT IS NOT INITIALISED.\n");
			plhs[0] = mxCreateLogicalScalar( FALSE );	
		}
	}
	else if ( strcmp( argument1, "INFO" ) == 0 )
	{
		if ( nlhs > 0 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN A RESULT WITH THIS CALL.");
		if ( nrhs != 2 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU MUST PROVIDE TWO ARGUMENTS.");

		argument2 = mxArrayToString(prhs[1]);
		
		for ( i = 0; i < strlen( argument2 ) ; ++i )
			argument2[i] = toupper(argument2[i]); 

		if ( strcmp( argument2, "TRUE" ) == 0 )
			MessageEnable = TRUE;
		else if ( strcmp( argument2, "FALSE" ) == 0 )
			MessageEnable = FALSE;
		else PrintError("THE SECOND ARGUMENT IS NOT CORRECT");
	}
	else if ( strcmp( argument1, "INIT") == 0 )
	{
		if ( nlhs > 0 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN A RESULT WITH THIS CALL.");
		if ( nrhs != 2 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU MUST PROVIDE TWO ARGUMENTS.");
		
		argument2 = mxArrayToString(prhs[1]);

		if ( handle == NULL )
		{
			int resultInitialise = Initialise( argument2 );
			int resultInitialiseDevice;

			if ( resultInitialise == -1 )
			{
				handle = NULL;
				PrintError("WAIT_VERTICAL_BLANK ERROR : THE MSVCR100.DLL FILE COULD NOT BE LOADED."); 
			}

			if ( resultInitialise == -2 )
			{
				handle = NULL;
				PrintError("WAIT_VERTICAL_BLANK ERROR : THE WAITVERTICALBLANK_MSV100.DLL FILE COULD NOT BE LOADED."); 
			}

			if ( resultInitialise == -3 ) 
			{
				handle = NULL;
				PrintError("WAIT_VERTICAL_BLANK ERROR : SOME INTERFACE(S) IN THE WAITVERTICALBLANK_MSV100.DLL FILE COULD NOT BE LOADED."); 
			}
			
			PrintInfo("WAIT_VERTICAL_BLANK INFO : DLL FILES INITIALISATION OK.\n"); 

			resultInitialiseDevice = InitialiseDevice();
			
			switch( resultInitialiseDevice )
			{
				case 1 :
				{
					PrintInfo("WAIT_VERTICAL_BLANK INFO : DIRECTX DEVICE INITIALISATION OK.\n"); 
					break;
				}
				case -2 :
				{
					handle = NULL;
					PrintError("WAIT_VERTICAL_BLANK ERROR : THE DLL WAS LOADED BUT WINDOWS COULD NOT REGISTER A WINDOW CLASS.\n");
					break;
				}
				case -3 :
				{
					handle = NULL;
					PrintError("WAIT_VERTICAL_BLANK ERROR : THE DLL WAS LOADED BUT WINDOW COULD NOT CREATE A WINDOW.\n");
					break;
				}
				case -4 :
				{
					handle = NULL;
					PrintError("WAIT_VERTICAL_BLANK ERROR : THE DLL WAS LOADED BUT DIRECTX COULD NOT BE INITIALISED.\n");
					break;
				}
				case -5 :
				{
					handle = NULL;
					PrintError("WAIT_VERTICAL_BLANK ERROR : THE DLL WAS LOADED BUT DIRECTX COULD NOT CREATE A DIRECT3D DEVICE.\n");
					break;
				}
				default :
				{
					break;
				}
			}
		}
		else PrintInfo("WAIT_VERTICAL_BLANK INFO : NO NEED TO INITIALISE BECAUSE IT IS ALREADY INITIALISED.\n"); 
	}
	else if ( strcmp( argument1, "RESET") == 0 ) 
	{
		if ( nlhs > 0 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN A RESULT WITH THIS CALL.");
		if ( nrhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : THERE IS NOT A SECOND ARGUMENT.");

		if ( handle != NULL )
		{
			ResetDevice(); 
			PrintInfo("WAIT_VERTICAL_BLANK INFO : RESET OK !!!\n"); 
		}
		else PrintInfo("WAIT_VERTICAL_BLANK INFO : NO NEED TO RESET BECAUSE IT IS NOT INITIALISED.\n"); 
	}
	else if ( strcmp( argument1, "UNINIT") == 0 )
	{
		if ( nlhs > 0 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN A RESULT WITH THIS CALL.");
		if ( nrhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : THERE IS NOT A SECOND ARGUMENT.");

		if ( handle != NULL )
		{
			UninitialiseDevice(); 
			FreeLibrary( handle ); 
			handle = NULL; 
			PrintInfo("WAIT_VERTICAL_BLANK INFO : UNINITIALISE OK !!!\n");  
		}
		else PrintInfo("WAIT_VERTICAL_BLANK INFO : NO NEED TO UNINITIALISE BECAUSE IT WAS ALREADY UNINITIALISED.\n");  
	}
	else if ( strcmp( argument1, "VERSION") == 0 )
	{
		if ( nlhs > 0 ) PrintError("WAIT_VERTICAL_BLANK ERROR : YOU CANNOT ASSIGN A RESULT WITH THIS CALL.");
		if ( nrhs > 1 ) PrintError("WAIT_VERTICAL_BLANK ERROR : THERE IS NOT A SECOND ARGUMENT.");

		mexPrintf("WAIT_VERTICAL_BLANK INFO : VERSION 1.0\n");  
	}
	else PrintError("WAIT_VERTICAL_BLANK ERROR : THE ARGUMENT IS NOT CORRECT");
}


