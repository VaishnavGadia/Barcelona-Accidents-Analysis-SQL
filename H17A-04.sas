/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Monday, 31 July 2023     TIME: 1:02:35 PM
PROJECT: Group_H17A_04_SAS_FINAL
PROJECT PATH: H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp
---------------------------------------- */

/* Library assignment for Local.NUCLEUS */
Libname NUCLEUS BASE 'H:\MyProject\NucleusDB' ;

/* Conditionally delete set of tables or views, if they exists          */
/* If the member does not exist, then no action is performed   */
%macro _eg_conditional_dropds /parmbuff;
	
   	%local num;
   	%local stepneeded;
   	%local stepstarted;
   	%local dsname;
	%local name;

   	%let num=1;
	/* flags to determine whether a PROC SQL step is needed */
	/* or even started yet                                  */
	%let stepneeded=0;
	%let stepstarted=0;
   	%let dsname= %qscan(&syspbuff,&num,',()');
	%do %while(&dsname ne);	
		%let name = %sysfunc(left(&dsname));
		%if %qsysfunc(exist(&name)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;

			%end;
				drop table &name;
		%end;

		%if %sysfunc(exist(&name,view)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;
			%end;
				drop view &name;
		%end;
		%let num=%eval(&num+1);
      	%let dsname=%qscan(&syspbuff,&num,',()');
	%end;
	%if &stepstarted %then %do;
		quit;
	%end;
%mend _eg_conditional_dropds;


/* ---------------------------------- */
/* MACRO: enterpriseguide             */
/* PURPOSE: define a macro variable   */
/*   that contains the file system    */
/*   path of the WORK library on the  */
/*   server.  Note that different     */
/*   logic is needed depending on the */
/*   server type.                     */
/* ---------------------------------- */
%macro enterpriseguide;
%global sasworklocation;
%local tempdsn unique_dsn path;

%if &sysscp=OS %then %do; /* MVS Server */
	%if %sysfunc(getoption(filesystem))=MVS %then %do;
        /* By default, physical file name will be considered a classic MVS data set. */
	    /* Construct dsn that will be unique for each concurrent session under a particular account: */
		filename egtemp '&egtemp' disp=(new,delete); /* create a temporary data set */
 		%let tempdsn=%sysfunc(pathname(egtemp)); /* get dsn */
		filename egtemp clear; /* get rid of data set - we only wanted its name */
		%let unique_dsn=".EGTEMP.%substr(&tempdsn, 1, 16).PDSE"; 
		filename egtmpdir &unique_dsn
			disp=(new,delete,delete) space=(cyl,(5,5,50))
			dsorg=po dsntype=library recfm=vb
			lrecl=8000 blksize=8004 ;
		options fileext=ignore ;
	%end; 
 	%else %do; 
        /* 
		By default, physical file name will be considered an HFS 
		(hierarchical file system) file. 
		*/
		%if "%sysfunc(getoption(filetempdir))"="" %then %do;
			filename egtmpdir '/tmp';
		%end;
		%else %do;
			filename egtmpdir "%sysfunc(getoption(filetempdir))";
		%end;
	%end; 
	%let path=%sysfunc(pathname(egtmpdir));
    %let sasworklocation=%sysfunc(quote(&path));  
%end; /* MVS Server */
%else %do;
	%let sasworklocation = "%sysfunc(getoption(work))/";
%end;
%if &sysscp=VMS_AXP %then %do; /* Alpha VMS server */
	%let sasworklocation = "%sysfunc(getoption(work))";                         
%end;
%if &sysscp=CMS %then %do; 
	%let path = %sysfunc(getoption(work));                         
	%let sasworklocation = "%substr(&path, %index(&path,%str( )))";
%end;
%mend enterpriseguide;

%enterpriseguide


/* save the current settings of XPIXELS and YPIXELS */
/* so that they can be restored later               */
%macro _sas_pushchartsize(new_xsize, new_ysize);
	%global _savedxpixels _savedypixels;
	options nonotes;
	proc sql noprint;
	select setting into :_savedxpixels
	from sashelp.vgopt
	where optname eq "XPIXELS";
	select setting into :_savedypixels
	from sashelp.vgopt
	where optname eq "YPIXELS";
	quit;
	options notes;
	GOPTIONS XPIXELS=&new_xsize YPIXELS=&new_ysize;
%mend _sas_pushchartsize;

/* restore the previous values for XPIXELS and YPIXELS */
%macro _sas_popchartsize;
	%if %symexist(_savedxpixels) %then %do;
		GOPTIONS XPIXELS=&_savedxpixels YPIXELS=&_savedypixels;
		%symdel _savedxpixels / nowarn;
		%symdel _savedypixels / nowarn;
	%end;
%mend _sas_popchartsize;


ODS PROCTITLE;
OPTIONS DEV=PNG;
GOPTIONS XPIXELS=0 YPIXELS=0;
FILENAME EGSRX TEMP;
ODS tagsets.sasreport13(ID=EGSRX) FILE=EGSRX
    STYLE=HtmlBlue
    STYLESHEET=(URL="file:///C:/Program%20Files/SASHome/SASEnterpriseGuide/7.1/Styles/HtmlBlue.css")
    NOGTITLE
    NOGFOOTNOTE
    GPATH=&sasworklocation
    ENCODING=UTF8
    options(rolap="on")
;

/*   START OF NODE: Assign Project Library (NUCLEUS)   */
%LET _CLIENTTASKLABEL='Assign Project Library (NUCLEUS)';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';

GOPTIONS ACCESSIBLE;
LIBNAME NUCLEUS BASE "H:\MyProject\NucleusDB" ;

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2014_abt.xlsx[2014_ACCIDENTS_TIPUS_GU_BCN_201])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Saturday, 29 July 2023 at 11:33:19 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2014_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2014_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2014_abt.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 21
        Neighborhood     $ 44
        Street           $ 30
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day_of_month       8
        Turn             $ 9
        Accident_type    $ 35 ;
    KEEP
        S_No
        District
        Neighborhood
        Street
        Day_of_week
        Year
        Month
        Day_of_month
        Turn
        Accident_type ;
    FORMAT
        S_No             BEST12.
        District         $CHAR21.
        Neighborhood     $CHAR44.
        Street           $CHAR30.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_type    $CHAR35. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR21.
        Neighborhood     $CHAR44.
        Street           $CHAR30.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_type    $CHAR35. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2014_abt-68bbb251697e4fd5b70b4702b06816eb.txt'
        LRECL=264
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        File_number      : $1.
        District_code    : $1.
        District         : $CHAR21.
        'Neighborhood code'n : $1.
        Neighborhood_code : $1.
        Neighborhood     : $CHAR44.
        'Street code'n   : $1.
        Street_code      : $1.
        Street           : $CHAR30.
        'Postal number caption'n : $1.
        Postal_number_caption : $1.
        Day_of_week      : $CHAR9.
        'day week'n      : $1.
        'Day type description'n : $1.
        Year             : BEST32.
        'month of year'n : $1.
        Month            : $CHAR9.
        Day_of_month     : BEST32.
        'time of day'n   : $1.
        Turn             : $CHAR9.
        Accident_type    : $CHAR35.
        'UTM coordinate (Y)'n : $1.
        'UTM coordinate (X)'n : $1.
        'UTM_coordinate (Y)'n : $1.
        'UTM_coordinate (Y)_0001'n : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2014_pvn.csv)   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Monday, 31 July 2023 at 1:53:57 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2014_pvn.csv
   Server:      Local File System
   
   Output data: NUCLEUS.2014_pvn.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2014_pvn.sas7bdat'n;
    LENGTH
        S_No               8
        Year               8
        District_Name    $ 20
        Neighbourhood_Name $ 45
        Proprietary_nationality $ 7
        Number_of_tourists   8 ;
    DROP
        District_Code
        'Neighbourhood code'n ;
    FORMAT
        S_No             BEST3.
        Year             BEST4.
        District_Name    $CHAR20.
        Neighbourhood_Name $CHAR45.
        Proprietary_nationality $CHAR7.
        Number_of_tourists BEST5. ;
    INFORMAT
        S_No             BEST3.
        Year             BEST4.
        District_Name    $CHAR20.
        Neighbourhood_Name $CHAR45.
        Proprietary_nationality $CHAR7.
        Number_of_tourists BEST5. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\107\SEG20512\2014_pvn-8de9cb49e769498faed6997fbcc6a3d7.txt'
        LRECL=84
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : ?? BEST3.
        Year             : ?? BEST4.
        District_Code    : $1.
        District_Name    : $CHAR20.
        'Neighbourhood code'n : $1.
        Neighbourhood_Name : $CHAR45.
        Proprietary_nationality : $CHAR7.
        Number_of_tourists : ?? BEST5. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2014_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Saturday, 29 July 2023 at 11:44:39 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2014_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2014_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2014_via.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 21
        Neighborhood     $ 40
        Street           $ 27
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day                8
        Turn             $ 9
        pedestrian_cause $ 34
        Vehicle_Type     $ 22
        Model            $ 23
        Brand            $ 15
        Color            $ 13 ;
    DROP
        Card
        Card_age ;
    FORMAT
        S_No             BEST12.
        District         $CHAR21.
        Neighborhood     $CHAR40.
        Street           $CHAR27.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR34.
        Vehicle_Type     $CHAR22.
        Model            $CHAR23.
        Brand            $CHAR15.
        Color            $CHAR13. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR21.
        Neighborhood     $CHAR40.
        Street           $CHAR27.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR34.
        Vehicle_Type     $CHAR22.
        Model            $CHAR23.
        Brand            $CHAR15.
        Color            $CHAR13. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2014_via-47366aa720a94ad7afc3ebcd0a3fa213.txt'
        LRECL=194
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        District         : $CHAR21.
        Neighborhood     : $CHAR40.
        Street           : $CHAR27.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Turn             : $CHAR9.
        pedestrian_cause : $CHAR34.
        Vehicle_Type     : $CHAR22.
        Model            : $CHAR23.
        Brand            : $CHAR15.
        Color            : $CHAR13.
        Card             : $1.
        Card_age         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2015_abt.xlsx[2015_ACCIDENTS_TIPUS_GU_BCN_201])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 5:36:02 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2015_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2015_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2015_abt.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 29
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day_of_month       8
        Turn             $ 9
        Accident_Type    $ 31 ;
    KEEP
        S_No
        District
        Neighborhood
        Street
        Day_of_week
        Year
        Month
        Day_of_month
        Turn
        Accident_Type ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR29.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR31. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR29.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR31. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\151\SEG23476\2015_abt-5ab7a3ac456a43a2801bb9db0a24b634.txt'
        LRECL=263
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        'File number'n   : $1.
        'District code'n : $1.
        S_No             : BEST32.
        File_number      : $1.
        District_code    : $1.
        District         : $CHAR19.
        Neighborhood_code : $1.
        Neighborhood_code_0001 : $1.
        Neighborhood     : $CHAR44.
        'Street code'n   : $1.
        Street_code      : $1.
        Street           : $CHAR29.
        'Postal number caption'n : $1.
        Postal_number_caption : $1.
        Day_of_week      : $CHAR9.
        'day week'n      : $1.
        'Day type description'n : $1.
        'Day type description_0001'n : $1.
        Year             : BEST32.
        'month of year'n : $1.
        Month            : $CHAR9.
        Day_of_month     : BEST32.
        'time of day'n   : $1.
        Turn             : $CHAR9.
        Accident_Type    : $CHAR31.
        'UTM coordinate (Y)'n : $1.
        'UTM coordinate (X)'n : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2015_pvn.csv)   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Monday, 31 July 2023 at 1:54:26 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2015_pvn.csv
   Server:      Local File System
   
   Output data: NUCLEUS.2015_pvn.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2015_pvn.sas7bdat'n;
    LENGTH
        S_No               8
        Year               8
        District_Name    $ 20
        Neighbourhood_Name $ 45
        Proprietary_nationality $ 7
        Number_of_tourists   8 ;
    DROP
        District_Code
        'Neighbourhood code'n ;
    FORMAT
        S_No             BEST3.
        Year             BEST4.
        District_Name    $CHAR20.
        Neighbourhood_Name $CHAR45.
        Proprietary_nationality $CHAR7.
        Number_of_tourists BEST5. ;
    INFORMAT
        S_No             BEST3.
        Year             BEST4.
        District_Name    $CHAR20.
        Neighbourhood_Name $CHAR45.
        Proprietary_nationality $CHAR7.
        Number_of_tourists BEST5. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\107\SEG20512\2015_pvn-a8ee655d9190428ca360b7cde5ed2c21.txt'
        LRECL=84
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : ?? BEST3.
        Year             : ?? BEST4.
        District_Code    : $1.
        District_Name    : $CHAR20.
        'Neighbourhood code'n : $1.
        Neighbourhood_Name : $CHAR45.
        Proprietary_nationality : $CHAR7.
        Number_of_tourists : ?? BEST5. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2015_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Saturday, 29 July 2023 at 11:49:25 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2015_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2015_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2015_via.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 40
        Street           $ 33
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day                8
        Turn             $ 9
        pedestrian_cause $ 37
        Vehicle_type     $ 21
        Model            $ 27
        Brand            $ 20
        Color            $ 12 ;
    DROP
        Card
        Card_age ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR40.
        Street           $CHAR33.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_type     $CHAR21.
        Model            $CHAR27.
        Brand            $CHAR20.
        Color            $CHAR12. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR40.
        Street           $CHAR33.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_type     $CHAR21.
        Model            $CHAR27.
        Brand            $CHAR20.
        Color            $CHAR12. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2015_via-b235f6f668ee4382ac90a308cd4f285f.txt'
        LRECL=199
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        District         : $CHAR19.
        Neighborhood     : $CHAR40.
        Street           : $CHAR33.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Turn             : $CHAR9.
        pedestrian_cause : $CHAR37.
        Vehicle_type     : $CHAR21.
        Model            : $CHAR27.
        Brand            : $CHAR20.
        Color            : $CHAR12.
        Card             : $1.
        Card_age         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2016_abt.xlsx[2016_accidents_tipus_gu_bcn_])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Saturday, 29 July 2023 at 11:51:45 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2016_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2016_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2016_abt.sas7bdat'n;
    LENGTH
        'S.No.'n           8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 51
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day_of_month       8
        Turn             $ 9
        Accident_Type    $ 31 ;
    KEEP
        'S.No.'n
        District
        Neighborhood
        Street
        Day_of_week
        Year
        Month
        Day_of_month
        Turn
        Accident_Type ;
    FORMAT
        'S.No.'n         BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR51.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR31. ;
    INFORMAT
        'S.No.'n         BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR51.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR31. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2016_abt-4805b1b99950445896859c142f8c9a86.txt'
        LRECL=239
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        file_number      : $1.
        district_code    : $1.
        'S.No.'n         : BEST32.
        District         : $CHAR19.
        Area_code        : $1.
        Neighborhood     : $CHAR44.
        street_code      : $1.
        Street           : $CHAR51.
        Num_postal_caption : $1.
        Day_of_week      : $CHAR9.
        week_day         : $1.
        Description_type_day : $1.
        Year             : BEST32.
        Month_year       : $1.
        Month            : $CHAR9.
        Day_of_month     : BEST32.
        'Day time'n      : $1.
        Turn             : $CHAR9.
        Accident_Type    : $CHAR31.
        X_UTM_Coordinate : $1.
        Coordinate_UTM_Y : $1.
        Length           : $1.
        latitude         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2016_pvn.csv)   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Monday, 31 July 2023 at 1:42:45 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2016_pvn.csv
   Server:      Local File System
   
   Output data: NUCLEUS.2016_pvn.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2016_pvn.sas7bdat'n;
    LENGTH
        S_No               8
        Year               8
        District_Name    $ 19
        Neighbourhood_name $ 45
        census_section   $ 3
        Vehicle_types    $ 10
        Proprietary_nationality $ 19
        Number_of_tourists   8 ;
    DROP
        District_Code
        Neighbourhood_code ;
    FORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\107\SEG20512\2016_pvn-0d5da81173fd4a37a98dd16282727bb6.txt'
        LRECL=112
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : ?? BEST4.
        Year             : ?? BEST4.
        District_Code    : $1.
        District_Name    : $CHAR19.
        Neighbourhood_code : $1.
        Neighbourhood_name : $CHAR45.
        census_section   : $CHAR3.
        Vehicle_types    : $CHAR10.
        Proprietary_nationality : $CHAR19.
        Number_of_tourists : ?? BEST4. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2016_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 7:30:47 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2016_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2016_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2016_via.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 45
        Street           $ 50
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day                8
        Turn             $ 9
        pedestrian_cause $ 37
        Vehicle_type     $ 22
        Model            $ 27
        Brand            $ 19
        Color            $ 12 ;
    DROP
        Card
        Card_age ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR45.
        Street           $CHAR50.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_type     $CHAR22.
        Model            $CHAR27.
        Brand            $CHAR19.
        Color            $CHAR12. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR45.
        Street           $CHAR50.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_type     $CHAR22.
        Model            $CHAR27.
        Brand            $CHAR19.
        Color            $CHAR12. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\28\SEG18244\2016_via-e334199efd674343a3ad11b388673714.txt'
        LRECL=225
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        District         : $CHAR19.
        Neighborhood     : $CHAR45.
        Street           : $CHAR50.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Turn             : $CHAR9.
        pedestrian_cause : $CHAR37.
        Vehicle_type     : $CHAR22.
        Model            : $CHAR27.
        Brand            : $CHAR19.
        Color            : $CHAR12.
        Card             : $1.
        Card_age         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2017_abt.xlsx[ 2017_accidents_tipus_gu_bcn_])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Saturday, 29 July 2023 at 11:55:20 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2017_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2017_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2017_abt.sas7bdat'n;
    LENGTH
        'S.No.'n           8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 51
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day_of_month       8
        Turn             $ 9
        Accident_type    $ 42 ;
    KEEP
        'S.No.'n
        District
        Neighborhood
        Street
        Day_of_week
        Year
        Month
        Day_of_month
        Turn
        Accident_type ;
    FORMAT
        'S.No.'n         BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR51.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_type    $CHAR42. ;
    INFORMAT
        'S.No.'n         BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR51.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_type    $CHAR42. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2017_abt-de73c7bbab05480db8951550d1514ae6.txt'
        LRECL=254
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        file_number      : $1.
        district_code    : $1.
        'S.No.'n         : BEST32.
        District         : $CHAR19.
        Area_code        : $1.
        Neighborhood     : $CHAR44.
        street_code      : $1.
        Street           : $CHAR51.
        Num_postal_caption : $1.
        Day_of_week      : $CHAR9.
        week_day         : $1.
        Description_type_day : $1.
        Year             : BEST32.
        Month_year       : $1.
        Month            : $CHAR9.
        Day_of_month     : BEST32.
        'Day time'n      : $1.
        Turn             : $CHAR9.
        Accident_type    : $CHAR42.
        X_UTM_Coordinate : $1.
        Coordinate_UTM_Y : $1.
        Length           : $1.
        latitude         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2017_pvn.csv)   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 7:57:03 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2017_pvn.csv
   Server:      Local File System
   
   Output data: NUCLEUS.2017_pvn.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2017_pvn.sas7bdat'n;
    LENGTH
        S_No               8
        Year               8
        District_Name    $ 19
        Neighbourhood_name $ 45
        census_section   $ 3
        Vehicle_types    $ 10
        Proprietary_nationality $ 18
        Number_of_tourists   8 ;
    DROP
        District_Code
        Neighbourhood_code ;
    FORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR18.
        Number_of_tourists BEST4. ;
    INFORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR18.
        Number_of_tourists BEST4. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\28\SEG18244\2017_pvn-4bc08d7f48b243c4af9b4457270b7ec3.txt'
        LRECL=110
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : ?? BEST4.
        Year             : ?? BEST4.
        District_Code    : $1.
        District_Name    : $CHAR19.
        Neighbourhood_code : $1.
        Neighbourhood_name : $CHAR45.
        census_section   : $CHAR3.
        Vehicle_types    : $CHAR10.
        Proprietary_nationality : $CHAR18.
        Number_of_tourists : ?? BEST4. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2017_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Saturday, 29 July 2023 at 11:57:57 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2017_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2017_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2017_via.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 51
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day                8
        Turn             $ 9
        pedestrian_cause $ 37
        Vehicle_Type     $ 29
        Model            $ 27
        Brand            $ 16
        Color            $ 13 ;
    DROP
        Card
        Card_age ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR51.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR29.
        Model            $CHAR27.
        Brand            $CHAR16.
        Color            $CHAR13. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR51.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR29.
        Model            $CHAR27.
        Brand            $CHAR16.
        Color            $CHAR13. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2017_via-c8b1df13a0c04257b6d19dde71bb01dc.txt'
        LRECL=229
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        District         : $CHAR19.
        Neighborhood     : $CHAR44.
        Street           : $CHAR51.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Turn             : $CHAR9.
        pedestrian_cause : $CHAR37.
        Vehicle_Type     : $CHAR29.
        Model            : $CHAR27.
        Brand            : $CHAR16.
        Color            : $CHAR13.
        Card             : $1.
        Card_age         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2018_abt.xlsx[ 2018_accidents_tipus_gu_bcn_])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Saturday, 29 July 2023 at 11:59:38 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2018_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2018_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2018_abt.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 53
        Day_of_week      $ 9
        Year               8
        Month_0001       $ 9
        Day_of_month       8
        Turn             $ 9
        Accident_Type    $ 42 ;
    KEEP
        S_No
        District
        Neighborhood
        Street
        Day_of_week
        Year
        Month_0001
        Day_of_month
        Turn
        Accident_Type ;
    LABEL
        Month_0001       = "Month" ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR53.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR42. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR53.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR42. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2018_abt-004546d967b549a4b51158b4d171137e.txt'
        LRECL=266
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        file_code        : $1.
        district_code    : $1.
        S_No             : BEST32.
        District         : $CHAR19.
        Area_code        : $1.
        Neighborhood     : $CHAR44.
        street_code      : $1.
        Street           : $CHAR53.
        postal_num       : $1.
        Day_of_week      : $CHAR9.
        Weekday_ID       : $1.
        day_type         : $1.
        Year             : BEST32.
        Month            : $1.
        Month_0001       : $CHAR9.
        Day_of_month     : BEST32.
        'Time of Day'n   : $1.
        Turn             : $CHAR9.
        Accident_Type    : $CHAR42.
        X_UTM_Coordinate : $1.
        Coordinate_UTM_Y : $1.
        Length           : $1.
        latitude         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2018_pvn.csv)   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 7:57:51 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2018_pvn.csv
   Server:      Local File System
   
   Output data: NUCLEUS.2018_pvn.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2018_pvn.sas7bdat'n;
    LENGTH
        S_No               8
        Year               8
        District_Name    $ 19
        Neighbourhood_name $ 45
        census_section   $ 3
        Vehicle_types    $ 10
        Proprietary_nationality $ 19
        Number_of_tourists   8 ;
    DROP
        District_Code
        Neighbourhood_code ;
    FORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\28\SEG18244\2018_pvn-598668ccb035474793b6ac402a08aad3.txt'
        LRECL=111
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : ?? BEST4.
        Year             : ?? BEST4.
        District_Code    : $1.
        District_Name    : $CHAR19.
        Neighbourhood_code : $1.
        Neighbourhood_name : $CHAR45.
        census_section   : $CHAR3.
        Vehicle_types    : $CHAR10.
        Proprietary_nationality : $CHAR19.
        Number_of_tourists : ?? BEST4. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2018_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 12:01:29 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2018_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2018_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2018_via.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 47
        Street           $ 52
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day                8
        Turn             $ 9
        Day_time           8
        pedestrian_cause $ 37
        Vehicle_Type     $ 35
        Model            $ 23
        Brand            $ 19
        Color            $ 13 ;
    DROP
        Card
        Card_age ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR47.
        Street           $CHAR52.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        Day_time         BEST12.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR35.
        Model            $CHAR23.
        Brand            $CHAR19.
        Color            $CHAR13. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR47.
        Street           $CHAR52.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        Day_time         BEST12.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR35.
        Model            $CHAR23.
        Brand            $CHAR19.
        Color            $CHAR13. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2018_via-a2b491cd6c6c4df38b88867066f55292.txt'
        LRECL=277
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        District         : $CHAR19.
        Neighborhood     : $CHAR47.
        Street           : $CHAR52.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Turn             : $CHAR9.
        Day_time         : BEST32.
        pedestrian_cause : $CHAR37.
        Vehicle_Type     : $CHAR35.
        Model            : $CHAR23.
        Brand            : $CHAR19.
        Color            : $CHAR13.
        Card             : $1.
        Card_age         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2019_abt.xlsx[ 2019_accidents_tipus_gu_bcn_])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 12:02:51 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2019_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2019_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2019_abt.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 51
        Day_of_week      $ 9
        Year               8
        Month_0001       $ 9
        Day_of_month       8
        Turn             $ 9
        Accident_Type    $ 42 ;
    KEEP
        S_No
        District
        Neighborhood
        Street
        Day_of_week
        Year
        Month_0001
        Day_of_month
        Turn
        Accident_Type ;
    LABEL
        Month_0001       = "Month" ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR51.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR42. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR51.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR42. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2019_abt-f0b296ea41224e24bc87fbf5f9e0f81e.txt'
        LRECL=264
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        file_number      : $1.
        district_code    : $1.
        S_No             : BEST32.
        District         : $CHAR19.
        Area_code        : $1.
        Neighborhood     : $CHAR44.
        street_code      : $1.
        Street           : $CHAR51.
        postal_num       : $1.
        Day_of_week      : $CHAR9.
        Weekday_ID       : $1.
        day_type         : $1.
        Year             : BEST32.
        Month            : $1.
        Month_0001       : $CHAR9.
        Day_of_month     : BEST32.
        'Time of Day'n   : $1.
        Turn             : $CHAR9.
        Accident_Type    : $CHAR42.
        X_UTM_Coordinate : $1.
        Coordinate_UTM_Y : $1.
        Length           : $1.
        latitude         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2019_pvn.csv)   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 7:58:31 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2019_pvn.csv
   Server:      Local File System
   
   Output data: NUCLEUS.2019_pvn.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2019_pvn.sas7bdat'n;
    LENGTH
        S_No               8
        Year               8
        District_Name    $ 19
        Neighbourhood_name $ 45
        census_section   $ 3
        Vehicle_types    $ 10
        Proprietary_nationality $ 19
        Number_of_tourists   8 ;
    DROP
        District_Code
        Neighbourhood_code ;
    FORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\28\SEG18244\2019_pvn-add56719b5b848f28e5ef979c905fd58.txt'
        LRECL=111
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : ?? BEST4.
        Year             : ?? BEST4.
        District_Code    : $1.
        District_Name    : $CHAR19.
        Neighbourhood_code : $1.
        Neighbourhood_name : $CHAR45.
        census_section   : $CHAR3.
        Vehicle_types    : $CHAR10.
        Proprietary_nationality : $CHAR19.
        Number_of_tourists : ?? BEST4. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2019_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 12:05:26 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2019_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2019_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2019_via.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 45
        Street           $ 41
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day                8
        Turn             $ 9
        Day_time           8
        pedestrian_cause $ 37
        Vehicle_Type     $ 35
        Model            $ 30
        Brand            $ 23
        Color            $ 13 ;
    DROP
        Card
        Card_age ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR45.
        Street           $CHAR41.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        Day_time         BEST12.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR35.
        Model            $CHAR30.
        Brand            $CHAR23.
        Color            $CHAR13. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR45.
        Street           $CHAR41.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        Day_time         BEST12.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR35.
        Model            $CHAR30.
        Brand            $CHAR23.
        Color            $CHAR13. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2019_via-6bcf3960e10d436d9b807bbef1cc3e46.txt'
        LRECL=233
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        District         : $CHAR19.
        Neighborhood     : $CHAR45.
        Street           : $CHAR41.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Turn             : $CHAR9.
        Day_time         : BEST32.
        pedestrian_cause : $CHAR37.
        Vehicle_Type     : $CHAR35.
        Model            : $CHAR30.
        Brand            : $CHAR23.
        Color            : $CHAR13.
        Card             : $1.
        Card_age         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2020_abt.xlsx[2020_accidents_tipus_gu_bcn])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 12:08:04 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2020_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2020_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2020_abt.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 27
        Day_of_week      $ 9
        Year               8
        Month_0001       $ 8
        Day_of_month       8
        Turn             $ 9
        Accident_Type    $ 35 ;
    KEEP
        S_No
        District
        Neighborhood
        Street
        Day_of_week
        Year
        Month_0001
        Day_of_month
        Turn
        Accident_Type ;
    LABEL
        Month_0001       = "Month" ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR27.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR8.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR35. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR27.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR8.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR35. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2020_abt-3f52ef119a124346adee84c829c04f48.txt'
        LRECL=246
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        file_number      : $1.
        district_code    : $1.
        S_No             : BEST32.
        District         : $CHAR19.
        Area_code        : $1.
        Neighborhood     : $CHAR44.
        street_code      : $1.
        Street           : $CHAR27.
        postal_num       : $1.
        Day_of_week      : $CHAR9.
        Weekday_ID       : $1.
        day_type         : $1.
        Year             : BEST32.
        Month            : $1.
        Month_0001       : $CHAR8.
        Day_of_month     : BEST32.
        'Time of Day'n   : $1.
        Turn             : $CHAR9.
        Accident_Type    : $CHAR35.
        X_UTM_Coordinate : $1.
        Coordinate_UTM_Y : $1.
        Length           : $1.
        latitude         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2020_pvn.csv)   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 7:59:10 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2020_pvn.csv
   Server:      Local File System
   
   Output data: NUCLEUS.2020_pvn.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2020_pvn.sas7bdat'n;
    LENGTH
        S_No               8
        Year               8
        District_Name    $ 19
        Neighbourhood_name $ 45
        census_section   $ 3
        Vehicle_types    $ 10
        Proprietary_nationality $ 19
        Number_of_tourists   8 ;
    DROP
        District_Code
        Neighbourhood_code ;
    FORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\28\SEG18244\2020_pvn-4edd2ea04b174847abefb7e341aff4de.txt'
        LRECL=111
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : ?? BEST4.
        Year             : ?? BEST4.
        District_Code    : $1.
        District_Name    : $CHAR19.
        Neighbourhood_code : $1.
        Neighbourhood_name : $CHAR45.
        census_section   : $CHAR3.
        Vehicle_types    : $CHAR10.
        Proprietary_nationality : $CHAR19.
        Number_of_tourists : ?? BEST4. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2020_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 12:10:46 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2020_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2020_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2020_via.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 27
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day                8
        Turn             $ 9
        pedestrian_cause $ 37
        Vehicle_Type     $ 34
        Model            $ 24
        Brand            $ 23
        Color            $ 13 ;
    DROP
        Card
        Card_age ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR27.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR34.
        Model            $CHAR24.
        Brand            $CHAR23.
        Color            $CHAR13. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR27.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR34.
        Model            $CHAR24.
        Brand            $CHAR23.
        Color            $CHAR13. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2020_via-6bcd3ce9700b4f56af5d3ebb5a106c55.txt'
        LRECL=233
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        District         : $CHAR19.
        Neighborhood     : $CHAR44.
        Street           : $CHAR27.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Turn             : $CHAR9.
        pedestrian_cause : $CHAR37.
        Vehicle_Type     : $CHAR34.
        Model            : $CHAR24.
        Brand            : $CHAR23.
        Color            : $CHAR13.
        Card             : $1.
        Card_age         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2021_abt.xlsx[ 2021_accidents_tipus_gu_bcn])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 12:22:56 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2021_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2021_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2021_abt.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 28
        Day_of_week      $ 9
        Year               8
        Month_0001       $ 9
        Day_of_month       8
        Turn             $ 9
        Accident_Type    $ 42 ;
    KEEP
        S_No
        District
        Neighborhood
        Street
        Day_of_week
        Year
        Month_0001
        Day_of_month
        Turn
        Accident_Type ;
    LABEL
        Month_0001       = "Month" ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR28.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR42. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR28.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR42. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2021_abt-b27068814e924ac6ab85e65965a9ddab.txt'
        LRECL=245
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        file_number      : $1.
        district_code    : $1.
        S_No             : BEST32.
        District         : $CHAR19.
        Area_code        : $1.
        Neighborhood     : $CHAR44.
        street_code      : $1.
        Street           : $CHAR28.
        postal_num       : $1.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $1.
        Month_0001       : $CHAR9.
        Day_of_month     : BEST32.
        'Time of Day'n   : $1.
        Turn             : $CHAR9.
        Accident_Type    : $CHAR42.
        Turn_0001        : $1.
        Accident_Type_0001 : $1.
        Length_WGS84     : $1.
        Latitude_WGS84   : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2021_pvn.csv)   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 7:59:51 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2021_pvn.csv
   Server:      Local File System
   
   Output data: NUCLEUS.2021_pvn.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2021_pvn.sas7bdat'n;
    LENGTH
        S_No               8
        Year               8
        District_Name    $ 19
        Neighbourhood_name $ 45
        census_section   $ 3
        Vehicle_types    $ 10
        Proprietary_nationality $ 19
        Number_of_tourists   8 ;
    DROP
        District_Code
        Neighbourhood_code ;
    FORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFORMAT
        S_No             BEST4.
        Year             BEST4.
        District_Name    $CHAR19.
        Neighbourhood_name $CHAR45.
        census_section   $CHAR3.
        Vehicle_types    $CHAR10.
        Proprietary_nationality $CHAR19.
        Number_of_tourists BEST4. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\28\SEG18244\2021_pvn-a72146d137114ac4a00db54d8b3b9149.txt'
        LRECL=112
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : ?? BEST4.
        Year             : ?? BEST4.
        District_Code    : $1.
        District_Name    : $CHAR19.
        Neighbourhood_code : $1.
        Neighbourhood_name : $CHAR45.
        census_section   : $CHAR3.
        Vehicle_types    : $CHAR10.
        Proprietary_nationality : $CHAR19.
        Number_of_tourists : ?? BEST4. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2021_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 12:25:29 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2021_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2021_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2021_via.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 20
        Neighborhood     $ 45
        Street           $ 41
        Day_of_week      $ 9
        Year               8
        Month            $ 9
        Day                8
        Turn             $ 9
        pedestrian_cause $ 37
        Vehicle_Type     $ 35
        Model            $ 25
        Brand            $ 23
        Color            $ 12 ;
    DROP
        Card
        Card_age ;
    FORMAT
        S_No             BEST12.
        District         $CHAR20.
        Neighborhood     $CHAR45.
        Street           $CHAR41.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR35.
        Model            $CHAR25.
        Brand            $CHAR23.
        Color            $CHAR12. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR20.
        Neighborhood     $CHAR45.
        Street           $CHAR41.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Turn             $CHAR9.
        pedestrian_cause $CHAR37.
        Vehicle_Type     $CHAR35.
        Model            $CHAR25.
        Brand            $CHAR23.
        Color            $CHAR12. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2021_via-5814748fe657428ebfcafe5ec1e2b23b.txt'
        LRECL=221
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        S_No             : BEST32.
        District         : $CHAR20.
        Neighborhood     : $CHAR45.
        Street           : $CHAR41.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Turn             : $CHAR9.
        pedestrian_cause : $CHAR37.
        Vehicle_Type     : $CHAR35.
        Model            : $CHAR25.
        Brand            : $CHAR23.
        Color            : $CHAR12.
        Card             : $1.
        Card_age         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2022_abt.xlsx[ 2022_accidents_tipus_gu_bcn])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 12:28:14 AM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2022_abt.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2022_abt.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2022_abt.sas7bdat'n;
    LENGTH
        S_No               8
        District         $ 19
        Neighborhood     $ 44
        Street           $ 52
        Day_of_week      $ 9
        Year               8
        Month_0001       $ 9
        Day_of_month       8
        Turn             $ 9
        Accident_Type    $ 42
        Turn_0001          8
        Accident_Type_0001   8 ;
    DROP
        file_number
        district_code
        Area_code
        street_code
        postal_num
        Month
        'Time of Day'n
        Length
        latitude ;
    LABEL
        Month_0001       = "Month"
        Turn_0001        = "Turn"
        Accident_Type_0001 = "Accident_Type" ;
    FORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR52.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR42.
        Turn_0001        BEST12.
        Accident_Type_0001 BEST12. ;
    INFORMAT
        S_No             BEST12.
        District         $CHAR19.
        Neighborhood     $CHAR44.
        Street           $CHAR52.
        Day_of_week      $CHAR9.
        Year             BEST12.
        Month_0001       $CHAR9.
        Day_of_month     BEST12.
        Turn             $CHAR9.
        Accident_Type    $CHAR42.
        Turn_0001        BEST12.
        Accident_Type_0001 BEST12. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\48\SEG14300\2022_abt-4ecded5b3ada44dbb29ccac6fc60ee00.txt'
        LRECL=269
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        file_number      : $1.
        district_code    : $1.
        S_No             : BEST32.
        District         : $CHAR19.
        Area_code        : $1.
        Neighborhood     : $CHAR44.
        street_code      : $1.
        Street           : $CHAR52.
        postal_num       : $1.
        Day_of_week      : $CHAR9.
        Year             : BEST32.
        Month            : $1.
        Month_0001       : $CHAR9.
        Day_of_month     : BEST32.
        'Time of Day'n   : $1.
        Turn             : $CHAR9.
        Accident_Type    : $CHAR42.
        Turn_0001        : BEST32.
        Accident_Type_0001 : BEST32.
        Length           : $1.
        latitude         : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Import Data (2022_via.xlsx[Sheet1])   */

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on Sunday, 30 July 2023 at 7:23:47 PM
   By task:     Import Data Wizard
   
   Source file: H:\MyProject\NucleusDB\2022_via.xlsx
   Server:      Local File System
   
   Output data: NUCLEUS.2022_via.sas7bdat
   Server:      Local
   -------------------------------------------------------------------- */

/* --------------------------------------------------------------------
   This DATA step reads the data values from a temporary text file
   created by the Import Data wizard. The values within the temporary
   text file were extracted from the Excel source file.
   -------------------------------------------------------------------- */

DATA NUCLEUS.'2022_via.sas7bdat'n;
    LENGTH
        'S.No.'n           8
        District         $ 20
        Neighborhood     $ 45
        Street           $ 52
        'Day of week'n   $ 9
        Year               8
        Month            $ 9
        Day                8
        Return           $ 9
        'Description of pedestrian cause'n $ 37
        Vehicle_Type     $ 35
        Model            $ 30
        Brand            $ 23
        'Color description'n $ 12 ;
    DROP
        'Card description'n
        'Card age'n ;
    FORMAT
        'S.No.'n         BEST12.
        District         $CHAR20.
        Neighborhood     $CHAR45.
        Street           $CHAR52.
        'Day of week'n   $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Return           $CHAR9.
        'Description of pedestrian cause'n $CHAR37.
        Vehicle_Type     $CHAR35.
        Model            $CHAR30.
        Brand            $CHAR23.
        'Color description'n $CHAR12. ;
    INFORMAT
        'S.No.'n         BEST12.
        District         $CHAR20.
        Neighborhood     $CHAR45.
        Street           $CHAR52.
        'Day of week'n   $CHAR9.
        Year             BEST12.
        Month            $CHAR9.
        Day              BEST12.
        Return           $CHAR9.
        'Description of pedestrian cause'n $CHAR37.
        Vehicle_Type     $CHAR35.
        Model            $CHAR30.
        Brand            $CHAR23.
        'Color description'n $CHAR12. ;
    INFILE 'C:\Users\z5407735\AppData\Local\Temp\28\SEG18244\2022_via-9069512820e2438d956baeee007d828c.txt'
        LRECL=260
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        'S.No.'n         : BEST32.
        District         : $CHAR20.
        Neighborhood     : $CHAR45.
        Street           : $CHAR52.
        'Day of week'n   : $CHAR9.
        Year             : BEST32.
        Month            : $CHAR9.
        Day              : BEST32.
        Return           : $CHAR9.
        'Description of pedestrian cause'n : $CHAR37.
        Vehicle_Type     : $CHAR35.
        Model            : $CHAR30.
        Brand            : $CHAR23.
        'Color description'n : $CHAR12.
        'Card description'n : $1.
        'Card age'n      : $1. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Q1   */
%LET _CLIENTTASKLABEL='Q1';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;

LIBNAME NUCLEUS BASE "H:\MyProject\NucleusDB" ;
/*
PROC SQL;
SELECT Accident_Type,count(*) as accident_count from NUCLEUS.'2014_ABT.SAS7BDAT'N group by Accident_Type;
QUIT; */
PROC SQL;
create table work.combined as
select Accident_Type from NUCLEUS.'2014_abt.sas7bdat'n
UNION ALL 
SELECT Accident_Type from NUCLEUS.'2015_ABT.SAS7BDAT'N
union all
select Accident_Type from nucleus.'2016_abt.sas7bdat'n
union all 
select Accident_Type from nucleus.'2017_abt.sas7bdat'n
union all	
select Accident_Type from nucleus.'2018_abt.sas7bdat'n
union all 
select Accident_Type from nucleus.'2019_abt.sas7bdat'n
union all	
select Accident_Type from nucleus.'2020_abt.sas7bdat'n
union all	
select Accident_Type from nucleus.'2021_abt.sas7bdat'n
union all	
select Accident_Type from nucleus.'2022_abt.sas7bdat'n
QUIT;

PROC SQL outobs=10;
CREATE TABLE work.accident_counts as 
select Accident_Type, count(*) as accident_count
from work.combined
group by Accident_Type
order by accident_count desc;
QUIT;





GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Descriptive Analytics 2   */

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, July 31, 2023 at 12:02:04 AM
   By task: Summary Statistics (2)

   Input Data: Local:WORK.ACCIDENT_COUNTS
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:WORK.ACCIDENT_COUNTS
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.accident_count
	FROM WORK.ACCIDENT_COUNTS as T
;
QUIT;
/* -------------------------------------------------------------------
   Run the Means Procedure
   ------------------------------------------------------------------- */
TITLE;
TITLE1 "Summary Statistics";
TITLE2 "Results";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC MEANS DATA=WORK.SORTTempTableSorted
	FW=12
	PRINTALLTYPES
	CHARTYPE
	VARDEF=DF 	
		MEAN 
		STD 
		MIN 
		MAX 
		N	;
	VAR accident_count;

RUN;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Distribution Analysis   */

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, July 31, 2023 at 12:03:20 AM
   By task: Distribution Analysis

   Input Data: Local:WORK.ACCIDENT_COUNTS
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:WORK.ACCIDENT_COUNTS
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.accident_count
	FROM WORK.ACCIDENT_COUNTS as T
;
QUIT;
TITLE;
TITLE1 "Distribution analysis of: accident_count";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
	ODS EXCLUDE EXTREMEOBS MODES MOMENTS QUANTILES;
PROC UNIVARIATE DATA = WORK.SORTTempTableSorted
		CIBASIC(TYPE=TWOSIDED ALPHA=0.05)
		MU0=0
;
	VAR accident_count;
	HISTOGRAM / NOPLOT ;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Bar Chart   */

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, July 31, 2023 at 12:14:23 AM
   By task: Bar Chart

   Input Data: Local:WORK.ACCIDENT_COUNTS
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:WORK.ACCIDENT_COUNTS
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.Accident_type, T.accident_count
	FROM WORK.ACCIDENT_COUNTS as T
;
QUIT;
Axis1
	STYLE=1
	WIDTH=1
	MINOR=NONE


;
Axis2
	STYLE=1
	WIDTH=1


;
TITLE;
TITLE1 "Bar Chart";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GCHART DATA=WORK.SORTTempTableSorted
;
	VBAR 
	 Accident_type
 /
	SUMVAR=accident_count
	CLIPREF
FRAME	TYPE=SUM
	COUTLINE=BLACK
	RAXIS=AXIS1
	MAXIS=AXIS2
;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Q2   */
%LET _CLIENTTASKLABEL='Q2';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='H:\MyProject\Programs\Q2.sas';
%LET _SASPROGRAMFILEHOST='AP2ACXMC01T03';

GOPTIONS ACCESSIBLE;

LIBNAME NUCLEUS BASE "H:\MyProject\NucleusDB" ;

PROC SQL;
create table work.combined as
select Day_of_week from NUCLEUS.'2014_abt.sas7bdat'n
UNION ALL 
SELECT Day_of_week from NUCLEUS.'2015_ABT.sas7bdat'N
union all
select Day_of_week from nucleus.'2016_abt.sas7bdat'n
union all 
select Day_of_week from nucleus.'2017_abt.sas7bdat'n
union all	
select Day_of_week from nucleus.'2018_abt.sas7bdat'n
union all 
select Day_of_week from nucleus.'2019_abt.sas7bdat'n
union all	
select Day_of_week from nucleus.'2020_abt.sas7bdat'n
union all	
select Day_of_week from nucleus.'2021_abt.sas7bdat'n
union all	
select Day_of_week from nucleus.'2022_abt.sas7bdat'n;
QUIT;

PROC SQL;
CREATE TABLE work.day_counts as 
select Day_of_week, count(*) as day_count
from work.combined
group by Day_of_week
order by day_count desc;
QUIT;

/*
PROC SQL;
    CREATE TABLE work.temp1 AS SELECT Day_of_week FROM NUCLEUS.'2014_abt.sas7bdat'n;
    CREATE TABLE work.temp2 AS SELECT Day_of_week FROM NUCLEUS.'2015_abt.sas7bdat'n;
    CREATE TABLE work.temp3 AS SELECT Day_of_week FROM NUCLEUS.'2016_abt.sas7bdat'n;
	CREATE TABLE work.temp4 AS SELECT Day_of_week FROM NUCLEUS.'2017_abt.sas7bdat'n;
	CREATE TABLE work.temp5 AS SELECT Day_of_week FROM NUCLEUS.'2018_abt.sas7bdat'n;
	CREATE TABLE work.temp6 AS SELECT Day_of_week FROM NUCLEUS.'2019_abt.sas7bdat'n;
	CREATE TABLE work.temp7 AS SELECT Day_of_week FROM NUCLEUS.'2020_abt.sas7bdat'n;
	CREATE TABLE work.temp8 AS SELECT Day_of_week FROM NUCLEUS.'2021_abt.sas7bdat'n;
	CREATE TABLE work.temp9 AS SELECT Day_of_week FROM NUCLEUS.'2022_abt.sas7bdat'n;
  
    
    CREATE TABLE work.combined AS
    SELECT * FROM work.temp1
    UNION ALL 
    SELECT * FROM work.temp2
    UNION ALL 
    SELECT * FROM work.temp3
	UNION ALL 
    SELECT * FROM work.temp4
	UNION ALL 
    SELECT * FROM work.temp5
	UNION ALL 
    SELECT * FROM work.temp6
	UNION ALL 
    SELECT * FROM work.temp7
	UNION ALL 
    SELECT * FROM work.temp8
	UNION ALL 
    SELECT * FROM work.temp9
   
;
QUIT;

PROC SQL;
CREATE TABLE work.day_counts as 
select Day_of_week, count(*) as day_count
from work.combined
group by Day_of_week
order by day_count desc;
QUIT;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Bar Chart (2)   */

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, July 31, 2023 at 12:24:49 AM
   By task: Bar Chart (2)

   Input Data: Local:WORK.DAY_COUNTS
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:WORK.DAY_COUNTS
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.Day_of_week, T.day_count
	FROM WORK.DAY_COUNTS as T
;
QUIT;
Axis1
	STYLE=1
	WIDTH=1


;
Axis2
	STYLE=1
	WIDTH=1
	MINOR=NONE


;
TITLE;
TITLE1 "Bar Chart";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GCHART DATA=WORK.SORTTempTableSorted
;
	HBAR 
	 Day_of_week
 /
	SUMVAR=day_count
	CLIPREF
FRAME	TYPE=SUM
	NOLEGEND
	COUTLINE=BLACK
	MAXIS=AXIS1
	RAXIS=AXIS2
PATTERNID=MIDPOINT
;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Q3   */
%LET _CLIENTTASKLABEL='Q3';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
LIBNAME NUCLEUS BASE "H:\MyProject\NucleusDB" ;

PROC SQL;
create table work.combined as 
select 2014 as year, count(*) as accidents 
from nucleus.'2014_abt.sas7bdat'n
union all 
select 2015 as year, count(*) as accidents 
from NUCLEUS.'2015_abt.sas7bdat'n
union all
select 2016 as year, count(*) as accidents 
from NUCLEUS.'2016_abt.sas7bdat'n
union all
select 2017 as year, count(*) as accidents 
from NUCLEUS.'2017_abt.sas7bdat'n
union all
select 2018 as year, count(*) as accidents 
from NUCLEUS.'2018_abt.sas7bdat'n
union all
select 2019 as year, count(*) as accidents 
from NUCLEUS.'2019_abt.sas7bdat'n
union all
select 2020 as year, count(*) as accidents 
from NUCLEUS.'2020_abt.sas7bdat'n
union all
select 2021 as year, count(*) as accidents 
from NUCLEUS.'2021_abt.sas7bdat'n
union all
select 2022 as year, count(*) as accidents 
from NUCLEUS.'2022_abt.sas7bdat'n;
quit;





GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: *case changes made in abt files*   */
%LET _CLIENTTASKLABEL='*case changes made in abt files*';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;

%_eg_conditional_dropds(WORK.FILTER_FOR_2022_ABT_SAS7BDAT);

PROC SQL;
   CREATE TABLE WORK.FILTER_FOR_2022_ABT_SAS7BDAT AS 
   SELECT t1.Day_of_week
      FROM NUCLEUS.'2022_ABT.SAS7BDAT'n t1
      WHERE t1.Day_of_week = 'sunday';
QUIT;

DATA NUCLEUS.'2014_abt.sas7bdat'n;
SET nucleus.'2014_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;

DATA NUCLEUS.'2015_abt.sas7bdat'n;
SET nucleus.'2015_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;

DATA NUCLEUS.'2016_abt.sas7bdat'n;
SET nucleus.'2016_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;

DATA NUCLEUS.'2017_abt.sas7bdat'n;
SET nucleus.'2017_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;

DATA NUCLEUS.'2018_abt.sas7bdat'n;
SET nucleus.'2018_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;

DATA NUCLEUS.'2019_abt.sas7bdat'n;
SET nucleus.'2019_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;

DATA NUCLEUS.'2020_abt.sas7bdat'n;
SET nucleus.'2020_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;

DATA NUCLEUS.'2021_abt.sas7bdat'n;
SET nucleus.'2021_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;

DATA NUCLEUS.'2022_abt.sas7bdat'n;
SET nucleus.'2022_abt.sas7bdat'n;
IF day_of_week = 'sunday' THEN day_of_week = 'Sunday';
RUN;




GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Filter and Sort   */
%LET _CLIENTTASKLABEL='Filter and Sort';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';

GOPTIONS ACCESSIBLE;
%_eg_conditional_dropds(WORK.FILTER_FOR_2022_ABT_SAS7BDAT);

PROC SQL;
   CREATE TABLE WORK.FILTER_FOR_2022_ABT_SAS7BDAT AS 
   SELECT t1.Day_of_week
      FROM NUCLEUS.'2022_ABT.SAS7BDAT'n t1
      WHERE t1.Day_of_week = 'sunday';
QUIT;

GOPTIONS NOACCESSIBLE;


%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Q4   */
%LET _CLIENTTASKLABEL='Q4';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
LIBNAME NUCLEUS BASE "H:\MyProject\NucleusDB" ;


/* ************* To prove correlation that tourism_vehicles are the most accident prone vehicles with tourism vehicles as the most no of accident vehicles****************** */

PROC SQL;
create table work.combined as
select Vehicle_Type from NUCLEUS.'2014_via.sas7bdat'n
UNION ALL 
SELECT Vehicle_Type from NUCLEUS.'2015_via.sas7bdat'n
union all
select Vehicle_Type from nucleus.'2016_via.sas7bdat'n
union all 
select Vehicle_Type from nucleus.'2017_via.sas7bdat'n
union all	
select Vehicle_Type from nucleus.'2018_via.sas7bdat'n
union all 
select Vehicle_Type from nucleus.'2019_via.sas7bdat'n
union all	
select Vehicle_Type from nucleus.'2020_via.sas7bdat'n
union all	
select Vehicle_Type from nucleus.'2021_via.sas7bdat'n
union all	
select Vehicle_Type from nucleus.'2022_via.sas7bdat'n;
QUIT;

/*  **************TO FIND THE ERRORS IN THE COLUMN NAMES**************
PROC SQL;
    CREATE TABLE work.temp1 AS SELECT Vehicle_Type FROM NUCLEUS.'2014_via.sas7bdat'n;
    CREATE TABLE work.temp2 AS SELECT Vehicle_Type FROM NUCLEUS.'2015_via.sas7bdat'n;
    CREATE TABLE work.temp3 AS SELECT Vehicle_Type FROM NUCLEUS.'2016_via.sas7bdat'n;
	CREATE TABLE work.temp4 AS SELECT Vehicle_Type FROM NUCLEUS.'2017_via.sas7bdat'n;
	CREATE TABLE work.temp5 AS SELECT Vehicle_Type FROM NUCLEUS.'2018_via.sas7bdat'n;
	CREATE TABLE work.temp6 AS SELECT Vehicle_Type FROM NUCLEUS.'2019_via.sas7bdat'n;
	CREATE TABLE work.temp7 AS SELECT Vehicle_Type FROM NUCLEUS.'2020_via.sas7bdat'n;
	CREATE TABLE work.temp8 AS SELECT Vehicle_Type FROM NUCLEUS.'2021_via.sas7bdat'n;
	CREATE TABLE work.temp9 AS SELECT Vehicle_Type FROM NUCLEUS.'2022_via.sas7bdat'n;
  
    
    CREATE TABLE work.combined AS
    SELECT * FROM work.temp1
    UNION ALL 
    SELECT * FROM work.temp2
    UNION ALL 
    SELECT * FROM work.temp3
	UNION ALL 
    SELECT * FROM work.temp4
	UNION ALL 
    SELECT * FROM work.temp5
	UNION ALL 
    SELECT * FROM work.temp6
	UNION ALL 
    SELECT * FROM work.temp7
	UNION ALL 
    SELECT * FROM work.temp8
	UNION ALL 
    SELECT * FROM work.temp9
   
;
QUIT;
*/



PROC SQL OUTOBS=5;
CREATE TABLE work.vehicle_counts as 
select Vehicle_Type, count(*) as vehicle_count
from work.combined
group by Vehicle_Type
order by vehicle_count desc
;
QUIT;







/************ED Datasets*****************/

PROC SQL;
create table work.combined as
select Vehicle_Types, Proprietary_nationality from NUCLEUS.'2014_pvn.sas7bdat'n
UNION ALL 
SELECT Vehicle_Types, Proprietary_nationality from NUCLEUS.'2015_pvn.sas7bdat'n
union all
select Vehicle_Types, Proprietary_nationality from nucleus.'2016_pvn.sas7bdat'n
union all 
select Vehicle_Types, Proprietary_nationality from nucleus.'2017_pvn.sas7bdat'n
union all	
select Vehicle_Types, Proprietary_nationality from nucleus.'2018_pvn.sas7bdat'n
union all 
select Vehicle_Types, Proprietary_nationality from nucleus.'2019_pvn.sas7bdat'n
union all	
select Vehicle_Types, Proprietary_nationality from nucleus.'2020_pvn.sas7bdat'n
union all	
select Vehicle_Types, Proprietary_nationality from nucleus.'2021_pvn.sas7bdat'n;
QUIT;

/*  **************TO FIND THE ERRORS IN THE COLUMN NAMES************** */
PROC SQL;
    CREATE TABLE work.temp3 AS SELECT Proprietary_nationality FROM NUCLEUS.'2016_pvn.sas7bdat'n;
	CREATE TABLE work.temp4 AS SELECT Proprietary_nationality FROM NUCLEUS.'2017_pvn.sas7bdat'n;
	CREATE TABLE work.temp5 AS SELECT Proprietary_nationality FROM NUCLEUS.'2018_pvn.sas7bdat'n;
	CREATE TABLE work.temp6 AS SELECT Proprietary_nationality FROM NUCLEUS.'2019_pvn.sas7bdat'n;
	CREATE TABLE work.temp7 AS SELECT Proprietary_nationality FROM NUCLEUS.'2020_pvn.sas7bdat'n;
	CREATE TABLE work.temp8 AS SELECT Proprietary_nationality FROM NUCLEUS.'2021_pvn.sas7bdat'n;
    
    CREATE TABLE work.combined AS
    SELECT * FROM work.temp1
    UNION ALL 
    SELECT * FROM work.temp2
    UNION ALL 
    SELECT * FROM work.temp3
	UNION ALL 
    SELECT * FROM work.temp4
	UNION ALL 
    SELECT * FROM work.temp5
	UNION ALL 
    SELECT * FROM work.temp6
	UNION ALL 
    SELECT * FROM work.temp7
	UNION ALL 
    SELECT * FROM work.temp8
	UNION ALL 
    SELECT * FROM work.temp9
   
;
QUIT;




PROC SQL;
CREATE TABLE work.nationality_counts as 
select Proprietary_nationality, count(*) as nationality_count
from work.combined
group by Proprietary_nationality
order by nationality_count desc
;
QUIT;



GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Descriptive Analytics 1   */

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Sunday, July 30, 2023 at 6:56:33 PM
   By task: Summary Statistics

   Input Data: Local:WORK.COMBINED
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set WORK.COMBINED
   ------------------------------------------------------------------- */
PROC SORT
	DATA=WORK.COMBINED(KEEP=accidents year)
	OUT=WORK.SORTTempTableSorted
	;
	BY year;
RUN;
/* -------------------------------------------------------------------
   Run the Means Procedure
   ------------------------------------------------------------------- */
TITLE;
TITLE1 "Summary Statistics";
TITLE2 "Results";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC MEANS DATA=WORK.SORTTempTableSorted
	FW=12
	PRINTALLTYPES
	CHARTYPE
	VARDEF=DF 	
		MEAN 
		STD 
		MIN 
		MAX 
		N	;
	VAR accidents;
	BY year;

RUN;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Area Plot   */

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, July 31, 2023 at 12:35:30 AM
   By task: Area Plot

   Input Data: Local:WORK.COMBINED
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set WORK.COMBINED
   ------------------------------------------------------------------- */
PROC SORT
	DATA=WORK.COMBINED(KEEP=year accidents)
	OUT=WORK.SORTTempTableSorted
	;
	BY year;
RUN;
Legend1
	FRAME
	;
SYMBOL1 INTERPOL=JOIN;
PATTERN1 VALUE=MS;
Axis1
	STYLE=1
	WIDTH=1
	MINOR=NONE


 ;
Axis2
	STYLE=1
	WIDTH=1
	MINOR=NONE


 ;
TITLE;
TITLE1 "Area Plot";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GPLOT DATA=WORK.SORTTempTableSorted
;
	PLOT accidents * year  /
	AREAS=1
FRAME	VAXIS=AXIS1

	HAXIS=AXIS2

;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;
GOPTIONS RESET = SYMBOL;
GOPTIONS RESET = PATTERN;

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Tile Chart   */

GOPTIONS ACCESSIBLE;
/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, 31 July 2023 at 12:41:04 AM
   By task: Tile Chart

   Input Data: WORK.VEHICLE_COUNTS   Server:  Local
   ------------------------------------------------------------------- */


%LET _EG_ACTIVEX_DEV=;
DATA _NULL_;
	IF EOF NE 1 THEN
		DO;
		SET SASHELP.VOPTION( WHERE=(OPTNAME="DEVICE")) END=EOF;

	IF NOT ( SETTING IN ("ACTIVEX", "JAVA", "ACTXIMG", "JAVAIMG") ) THEN
		CALL SYMPUT("_EG_ACTIVEX_DEV", " OPTIONS DEVICE=ACTIVEX;");
		END;
STOP;
RUN;

&_EG_ACTIVEX_DEV


TITLE1 "Tile Chart";
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";

proc gtile data=WORK.VEHICLE_COUNTS;
	FLOW vehicle_count
	tileby=( Vehicle_Type)
	/
	;
run;
quit;
/* -------------------------------------------------------------------
   End of task code.
   ------------------------------------------------------------------- */
RUN;
QUIT;

TITLE;
FOOTNOTE;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;


/*   START OF NODE: Blackspot Analysis   */
%LET _CLIENTTASKLABEL='Blackspot Analysis';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
LIBNAME NUCLEUS BASE "H:\MyProject\NucleusDB" ;

/* ***Streets with the Highest no. of accidents*** */

PROC SQL;
create table NUCLEUS.combined as
select Street, Neighborhood, District from NUCLEUS.'2014_via.sas7bdat'n
UNION ALL 
SELECT Street, Neighborhood, District from NUCLEUS.'2015_via.sas7bdat'n
union all
select Street, Neighborhood, District from nucleus.'2016_via.sas7bdat'n
union all 
select Street, Neighborhood, District from nucleus.'2017_via.sas7bdat'n
union all	
select Street, Neighborhood, District from nucleus.'2018_via.sas7bdat'n
union all 
select Street, Neighborhood, District from nucleus.'2019_via.sas7bdat'n
union all	
select Street, Neighborhood, District from nucleus.'2020_via.sas7bdat'n
union all	
select Street, Neighborhood, District from nucleus.'2021_via.sas7bdat'n
union all	
select Street, Neighborhood, District from nucleus.'2022_via.sas7bdat'n;
QUIT;

/* **********************ACCIDENTS BY STREET: STREET ANALYSIS********************* */
proc sql outobs=7;
TITLE Accidents by Street;
CREATE TABLE result_data as
SELECT Street as Street_Type, count(*) as Total_Accidents
FROM NUCLEUS.combined
group by Street_Type
order by Total_Accidents DESC;
quit;

/* ************************ACCIDENTS BY STREET: BAR CHART***************************** */
proc sgplot;
    /* Create a bar chart using the 'result_data' dataset */
    title 'Accidents by Street';
    vbar Street_Type / response=Total_Accidents;
    xaxis display=(nolabel);
    yaxis label='Total Accidents';
run;








/* ************** DISTRICT ANALYSIS ******************** */

proc sql outobs=5;
TITLE District Analysis;
SELECT District, count(*) as Total_Accidents
FROM NUCLEUS.combined
group by District
order by Total_Accidents DESC;
quit;


/* Query to find the district with the most accidents */
/*PROC SQL;
    TITLE District Analysis;
    SELECT District, COUNT(*) AS Total_Accidents
    FROM work.combined
    GROUP BY District
    ORDER BY Total_Accidents DESC
    ;
QUIT;
*/



/* ********Query to find neighborhood analysis within the district with the most accidents********** */
PROC SQL outobs=5;
    TITLE Neighborhoods within the District having Most Accidents;
	CREATE TABLE result2_data as
    SELECT c.Neighborhood, COUNT(*) AS Total_Accidents
    FROM NUCLEUS.combined AS c
    WHERE c.District IN (
        SELECT District
        FROM NUCLEUS.combined
        GROUP BY District
        HAVING COUNT(*) = (
            SELECT MAX(Total_Accidents)
            FROM (
                SELECT District, COUNT(*) AS Total_Accidents
                FROM NUCLEUS.combined
                GROUP BY District
            ) AS sub
        )
    )
    GROUP BY c.Neighborhood
    ORDER BY Total_Accidents DESC
    ;
QUIT;








/* ***********NEIGHBORHOOD ANALYSIS********** */

proc sql outobs=5;
TITLE Neighborhood Analysis;
CREATE TABLE result3_data as
SELECT Neighborhood, count(*) as Total_Accidents
FROM NUCLEUS.combined
group by Neighborhood
order by Total_Accidents DESC;
quit;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Accident Type Frequency_Bar   */
%LET _CLIENTTASKLABEL='Accident Type Frequency_Bar';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;

/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, July 31, 2023 at 12:14:23 AM
   By task: Bar Chart

   Input Data: Local:WORK.ACCIDENT_COUNTS
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:WORK.ACCIDENT_COUNTS
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.Accident_type, T.accident_count
	FROM WORK.ACCIDENT_COUNTS as T
;
QUIT;
Axis1
	STYLE=1
	WIDTH=1
	MINOR=NONE


;
Axis2
	STYLE=1
	WIDTH=1


;
TITLE;
TITLE1 "ACCIDENT TYPE FREQUENCY";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GCHART DATA=WORK.SORTTempTableSorted
;
	VBAR 
	 Accident_type
 /
	SUMVAR=accident_count
	CLIPREF
FRAME	TYPE=SUM
	COUTLINE=BLACK
	RAXIS=AXIS1
	MAXIS=AXIS2
;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;




GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Accident by Day_Bar 2   */
%LET _CLIENTTASKLABEL='Accident by Day_Bar 2';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;

/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, July 31, 2023 at 12:24:49 AM
   By task: Bar Chart (2)

   Input Data: Local:WORK.DAY_COUNTS
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set Local:WORK.DAY_COUNTS
   ------------------------------------------------------------------- */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.Day_of_week, T.day_count
	FROM WORK.DAY_COUNTS as T
;
QUIT;
Axis1
	STYLE=1
	WIDTH=1


;
Axis2
	STYLE=1
	WIDTH=1
	MINOR=NONE


;
TITLE;
TITLE1 "Accidents by Day";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GCHART DATA=WORK.SORTTempTableSorted
;
	HBAR 
	 Day_of_week
 /
	SUMVAR=day_count
	CLIPREF
FRAME	TYPE=SUM
	NOLEGEND
	COUTLINE=BLACK
	MAXIS=AXIS1
	RAXIS=AXIS2
PATTERNID=MIDPOINT
;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;




GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Accidents by Year_Area Plot   */
%LET _CLIENTTASKLABEL='Accidents by Year_Area Plot';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;

/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, July 31, 2023 at 12:35:30 AM
   By task: Area Plot

   Input Data: Local:WORK.COMBINED
   Server:  Local
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.SORTTempTableSorted);
/* -------------------------------------------------------------------
   Sort data set WORK.COMBINED
   ------------------------------------------------------------------- */
PROC SORT
	DATA=WORK.COMBINED(KEEP=year accidents)
	OUT=WORK.SORTTempTableSorted
	;
	BY year;
RUN;
Legend1
	FRAME
	;
SYMBOL1 INTERPOL=JOIN;
PATTERN1 VALUE=MS;
Axis1
	STYLE=1
	WIDTH=1
	MINOR=NONE


 ;
Axis2
	STYLE=1
	WIDTH=1
	MINOR=NONE


 ;
TITLE;
TITLE1 "Accidents by Year";
FOOTNOTE;
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";
PROC GPLOT DATA=WORK.SORTTempTableSorted
;
	PLOT accidents * year  /
	AREAS=1
FRAME	VAXIS=AXIS1

	HAXIS=AXIS2

;
/* -------------------------------------------------------------------
   End of task code
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.SORTTempTableSorted);
TITLE; FOOTNOTE;
GOPTIONS RESET = SYMBOL;
GOPTIONS RESET = PATTERN;



GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Accidents by Vehicle Type_Title   */
%LET _CLIENTTASKLABEL='Accidents by Vehicle Type_Title';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;

/* -------------------------------------------------------------------
   Code generated by SAS Task

   Generated on: Monday, 31 July 2023 at 12:41:04 AM
   By task: Tile Chart

   Input Data: WORK.VEHICLE_COUNTS   Server:  Local
   ------------------------------------------------------------------- */


%LET _EG_ACTIVEX_DEV=;
DATA _NULL_;
	IF EOF NE 1 THEN
		DO;
		SET SASHELP.VOPTION( WHERE=(OPTNAME="DEVICE")) END=EOF;

	IF NOT ( SETTING IN ("ACTIVEX", "JAVA", "ACTXIMG", "JAVAIMG") ) THEN
		CALL SYMPUT("_EG_ACTIVEX_DEV", " OPTIONS DEVICE=ACTIVEX;");
		END;
STOP;
RUN;

&_EG_ACTIVEX_DEV


TITLE1 "Accidents by Vehicle Type";
FOOTNOTE1 "Generated by the SAS System (&_SASSERVERNAME, &SYSSCPL) on %TRIM(%QSYSFUNC(DATE(), NLDATE20.)) at %TRIM(%SYSFUNC(TIME(), TIMEAMPM12.))";

proc gtile data=WORK.VEHICLE_COUNTS;
	FLOW vehicle_count
	tileby=( Vehicle_Type)
	/
	;
run;
quit;
/* -------------------------------------------------------------------
   End of task code.
   ------------------------------------------------------------------- */
RUN;
QUIT;

TITLE;
FOOTNOTE;
RUN;




GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Program   */
%LET _CLIENTTASKLABEL='Program';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='H:\MyProject\Projects\Group_H17A_04_SAS_FINAL.egp';
%LET _CLIENTPROJECTPATHHOST='AP2ACXMC01T03';
%LET _CLIENTPROJECTNAME='Group_H17A_04_SAS_FINAL.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
LIBNAME NUCLEUS BASE "H:\MyProject\NucleusDB" ;


PROC SQL;
create table work.combined as
select Proprietary_nationality from NUCLEUS.'2014_pvn.sas7bdat'n
UNION ALL 
SELECT Proprietary_nationality from NUCLEUS.'2015_pvn.sas7bdat'n
union all
select Proprietary_nationality from nucleus.'2016_pvn.sas7bdat'n
union all 
select Proprietary_nationality from nucleus.'2017_pvn.sas7bdat'n
union all	
select Proprietary_nationality from nucleus.'2018_pvn.sas7bdat'n
union all 
select Proprietary_nationality from nucleus.'2019_pvn.sas7bdat'n
union all	
select Proprietary_nationality from nucleus.'2020_pvn.sas7bdat'n
union all	
select Proprietary_nationality from nucleus.'2021_pvn.sas7bdat'n;
QUIT;




PROC SQL;
    CREATE TABLE work.temp3 AS SELECT Proprietary_nationality FROM NUCLEUS.'2016_pvn.sas7bdat'n;
	CREATE TABLE work.temp4 AS SELECT Proprietary_nationality FROM NUCLEUS.'2017_pvn.sas7bdat'n;
	CREATE TABLE work.temp5 AS SELECT Proprietary_nationality FROM NUCLEUS.'2018_pvn.sas7bdat'n;
	CREATE TABLE work.temp6 AS SELECT Proprietary_nationality FROM NUCLEUS.'2019_pvn.sas7bdat'n;
	CREATE TABLE work.temp7 AS SELECT Proprietary_nationality FROM NUCLEUS.'2020_pvn.sas7bdat'n;
	CREATE TABLE work.temp8 AS SELECT Proprietary_nationality FROM NUCLEUS.'2021_pvn.sas7bdat'n;
    
    CREATE TABLE work.combined AS
    SELECT * FROM work.temp1
    UNION ALL 
    SELECT * FROM work.temp2
    UNION ALL 
    SELECT * FROM work.temp3
	UNION ALL 
    SELECT * FROM work.temp4
	UNION ALL 
    SELECT * FROM work.temp5
	UNION ALL 
    SELECT * FROM work.temp6
	UNION ALL 
    SELECT * FROM work.temp7
	UNION ALL 
    SELECT * FROM work.temp8
	UNION ALL 
    SELECT * FROM work.temp9
   
;
QUIT;




PROC SQL;
CREATE TABLE work.nationality_counts as 
select Proprietary_nationality, count(*) as nationality_count
from work.combined
group by Proprietary_nationality
order by nationality_count desc
;
QUIT;

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;

;*';*";*/;quit;run;
ODS _ALL_ CLOSE;
