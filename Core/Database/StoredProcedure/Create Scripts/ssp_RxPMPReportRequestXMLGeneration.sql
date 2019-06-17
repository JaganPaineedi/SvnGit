 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RxPMPReportRequestXMLGeneration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RxPMPReportRequestXMLGeneration]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RxPMPReportRequestXMLGeneration]        ******/
SET ANSI_NULLS ON
GO       
        
 CREATE PROCEDURE [dbo].[ssp_RxPMPReportRequestXMLGeneration]          
 (          
   @ClientId INT,        
   @StaffID  INT 
   ,@XMLData Varchar(Max) OUTPUT                           
 )                   
/*********************************************************************/                
/* Procedure: ssp_RxPMPReportRequestXMLGeneration            */                
/*                                                                   */                
/* Purpose: Creating RequestXML for the webservice call */                 
/*                                                                   */                
/* Parameters: @ClientId int                           */                
/*                                                                   */                
/*                                                                   */                
/* Returns/Results: Returns a XML for the webservice call */                
/*                                                                   */                
/* Created By: Anto                                       */                
/*                                                                   */                
/* Created Date: 05-July-2018                                          */                
/*                                                                   */                
/* Revision History:                                                 */ 
/* 30 July 2018	   Anto    Modified the sp by formatting @PatientDOB making it compatible with 2008 SQL Server database - Multi-Customer Project: #2 */ 
                
/*********************************************************************/          
AS           
 BEGIN                 
                
  BEGIN TRY          
     
    DECLARE @results TABLE          
     (                                            
     /* Patient Details */        
     PatientFirstName Varchar(250),        
     PatientLastName Varchar(250),        
     PatientGender   Char(1),        
     PatientDOB  varchar(50),        
     PatientAddressline1  Varchar(250),        
     PatientCity1    Varchar(500),        
     PatientState1   Varchar(100),        
     PatientZipcode1   Varchar(100),        
     PatientAddressline2  Varchar(250),           
     PatientSSN    Varchar(100),             
               
     /* Staff Details */        
     StaffDEANumber   Varchar(50),        
     NationalProviderId   Varchar(100),        
     StaffAddressline1    Varchar(250),        
     StaffFirstName       Varchar(100),        
     StaffLastName  Varchar(100),               
     StaffCity   Varchar(100),        
     StaffState   Varchar(50),        
     StaffZip    Varchar(50)                     
     )    
       
       
     /* Patient Details */        
       DECLARE @PatientFirstName Varchar(250)        
       DECLARE @PatientLastName Varchar(250)        
       DECLARE @PatientGender   Char(1)        
       DECLARE @PatientDOB  varchar(50)        
       DECLARE @PatientAddressline1  Varchar(250)        
       DECLARE @PatientCity1   Varchar(500)        
       DECLARE @PatientState1   Varchar(100)        
       DECLARE @PatientZipcode1   Varchar(100)        
       DECLARE @PatientAddressline2  Varchar(250)            
       DECLARE @PatientSSN    Varchar(100)        
               
       /* Staff Details */        
       DECLARE @StaffDEANumber   Varchar(50)        
       DECLARE @NationalProviderId   Varchar(100)        
       DECLARE @StaffAddressline1    Varchar(250)        
       DECLARE @StaffFirstName       Varchar(100)        
       DECLARE @StaffLastName   Varchar(100)               
       DECLARE @StaffCity    Varchar(100)        
       DECLARE @StaffState    Varchar(50)        
       DECLARE @StaffZip    Varchar(50)        
                
               
       SELECT @PatientFirstName = Firstname,        
       @PatientLastName = Lastname,        
       @PatientGender = Sex,        
       @PatientDOB  = CONVERT(char(10), DOB,126),        
       @PatientSSN = SSN        
       FROM Clients WHERE         
       ISNULL(Recorddeleted,'N') = 'N' AND        
       ISNULL(Active,'Y') = 'Y' AND        
       ClientId = @ClientId        
               
       SELECT TOP 1         
       @PatientAddressline1 = Address,        
       @PatientCity1= City,        
       @PatientState1 = State,        
       @PatientZipcode1 = Zip        
       FROM ClientAddresses where         
       ISNULL(Recorddeleted,'N') = 'N' AND               
       ClientId = @ClientId        
               
                     
       SELECT @StaffDEANumber = DEANumber,        
       @NationalProviderId = NationalProviderId,        
       @StaffFirstName =  FirstName,        
       @StaffLastName = LastName,        
       @StaffAddressline1 = Address,        
       @StaffCity = City,        
       @StaffState = State,        
       @StaffZip = Zip                               
       FROM STAFF         
       Where StaffID = @StaffID AND        
       ISNULL(Recorddeleted,'N') = 'N' AND         
       ISNULL(Active,'Y') = 'Y'     
       
       
       DECLARE @StaffRole varchar(100)    
       DECLARE @StaffPrescriber  Char(1)    
        
       SELECT @StaffPrescriber = Prescriber FROM STAFF     
       Where StaffId = @StaffId AND    
       ISNULL(Recorddeleted,'N') = 'N' AND     
       ISNULL(Active,'Y') = 'Y'    
           
       IF @StaffPrescriber = 'Y'     
       SET @StaffRole = 'Physician'    
       ELSE    
       SET @StaffRole = ''   
       
              
      /* Location Details */  
      DECLARE @LocationName   Varchar(250)  	       
	  DECLARE @LocationNPINumber  Varchar(100)      	       
	  DECLARE @LocationStreet1   Varchar(500)  
	  DECLARE @LocationStreet2   Varchar(500)  
	  DECLARE @LocationCity         Varchar(150)  
	  DECLARE @LocationState    Varchar(50)  
	  DECLARE @LocationZipCode      Varchar(50)  
	  DECLARE @LocationZipPlusFour  Varchar(50)    
	  
	  

		  SELECT @LocationName = AgencyName,            
				 @LocationNPINumber = NationalProviderId,             
				 @LocationStreet1 =  Address,      
				 @LocationCity = City,  
				 @LocationState =  State ,  
				 @LocationZipCode =  Zipcode
				 FROM Agency       
      
		        
         
       INSERT INTO @results Values(       
		@PatientFirstName,                               
		@PatientLastName,        
		@PatientGender,            
		@PatientDOB,          
		@PatientAddressline1,          
		@PatientCity1,           
		@PatientState1,           
		@PatientZipcode1,           
		@PatientAddressline2,             
		@PatientSSN,        
		@StaffDEANumber,        
		@NationalProviderId,        
		@StaffAddressline1,        
		@StaffFirstName,        
		@StaffLastName,        
		@StaffCity,        
		@StaffState ,        
		@StaffZip        
    )        
        
    SET @XMLData = ''     
          
    IF @XMLData = ''           
    BEGIN         
            
    SET @XMLData =          
    (SELECT(        
     SELECT  (        
       SELECT  (        
          SELECT  @StaffRole         
          FROM  @results              
       FOR  XML PATH('Role') ,  TYPE              
                 )    
       ,( SELECT  (        
          SELECT  @StaffFirstName         
          FROM  @results         
       FOR  XML PATH('FirstName') ,  TYPE              
                 ) )    
       ,( SELECT  (        
          SELECT  @StaffLastName         
          FROM  @results         
       FOR  XML PATH('LastName') ,  TYPE              
                 ) )                
       ,(SELECT  (        
          SELECT  @StaffDEANumber         
          FROM  @results              
       FOR  XML PATH('DEANumber') ,  TYPE              
                 ))         
        ,( SELECT  (        
          SELECT  @NationalProviderId         
          FROM  @results         
       FOR  XML PATH('NPINumber') ,  TYPE              
                 ) )                
         
      
      FROM  @results              
      FOR  XML PATH('Provider') ,  TYPE        
     )                                                                                                                                                              
                                        
     ,(       
     SELECT  (        
      SELECT  @LocationName         
      FROM  @results              
      FOR  XML PATH('Name') ,  TYPE        
     ) 
     ,( SELECT  (        
          SELECT  @StaffDEANumber         
          FROM  @results         
       FOR  XML PATH('DEANumber') ,  TYPE              
                 ) ) 
	  ,( SELECT  (        
          SELECT  @LocationNPINumber         
          FROM  @results         
       FOR  XML PATH('NPINumber') ,  TYPE              
                 ) )                                                                         
     , (        
       SELECT  (        
       SELECT  (        
        SELECT  @LocationStreet1         
        FROM  @results              
        FOR  XML PATH('Street') ,  TYPE        
       )        
       , ( SELECT  (        
          SELECT  @LocationStreet2         
        FROM  @results              
       FOR  XML PATH('Street') ,  TYPE              
                 ) )                        
       , ( SELECT  (        
          SELECT  @LocationCity         
          FROM  @results              
       FOR  XML PATH('City') ,  TYPE              
                 ) )        
       , ( SELECT  (        
          SELECT  @LocationState        
          FROM  @results              
       FOR  XML PATH('StateCode') ,  TYPE              
                 ) )         
       , ( SELECT  (        
          SELECT  @LocationZipCode         
          FROM  @results              
       FOR  XML PATH('ZipCode') ,  TYPE              
                 ) )                                                                                                                
       FROM  @results              
       FOR  XML PATH('Address') ,  TYPE        
       ))          
    FROM @results            
    FOR  XML PATH('Location') ,  TYPE        
   )                        
             
     FROM @results            
    FOR  XML PATH('Requester') ,  TYPE        
    )        
        
   FOR XML PATH('ReportRequest'))         
               
     
  END  
       
 DECLARE @MessageHeader Varchar(250)  
                          
 SET @MessageHeader = '<?xml version="1.0" encoding="UTF-8"?>'   
    
 SET @XMLData = @MessageHeader + @XMLData           
    
 SET @XMLData = REPLACE(@XMLData, '<ReportRequest>', '<ReportRequest xmlns="http://xml.appriss.com/gateway/v5_1">');        
  

                                     
  
  END TRY          
           
  BEGIN CATCH          
   DECLARE @Error VARCHAR(8000)                                 
   SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'    
    + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'    
    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),    
       'ssp_RxPMPReportRequestXMLGeneration') + '*****'    
    + CONVERT(VARCHAR, ERROR_LINE()) + '*****'    
    + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'    
    + CONVERT(VARCHAR, ERROR_STATE())                                                              
   RAISERROR                                                               
  (                                                              
   @Error, -- Message text.                                                          
   16, -- Severity.                                                              
   1 -- State.                                                              
  );                      
  END CATCH          
        
 END    
  
  