   
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_RxPMPClientRequestXMLGeneration]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_RxPMPClientRequestXMLGeneration] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE  PROCEDURE [dbo].[ssp_RxPMPClientRequestXMLGeneration]        
 (        
   @ClientId INT,      
   @StaffId  INT                          
 )                 
/*********************************************************************/              
/* Procedure: ssp_RxPMPClientRequestXMLGeneration     14330, 112       */              
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
/* 30 July 2018	Anto    Modified the sp by formatting @DateRangeBegin,@DateRangeEnd and @PatientDOB making it compatible with 2008 SQL Server database - Multi-Customer Project: #2 */ 
/* 25 Aug  2018 Pranay  Changed @PatientPhone select statement.why- no null check for phonenumbertext column */
/* 1  Oct  2018 Pranay   Fix- When PhoneNumber Text has special Characters.*/             
--21  Jan 2019  Pranay   Fix - Added  LEFT(RTRIM(LTRIM(ZipCode)),5) w.r.t C.E.I 1082
/*********************************************************************/        
AS         
 BEGIN               
              
  BEGIN TRY        
        
    DECLARE @results TABLE        
     (        
     LicenseeRequestId Varchar(100),     
     SenderSoftwareDeveloper  Varchar(250),  
     SenderSoftwareProduct  Varchar(250),  
     SenderSoftwareVersion Varchar(100),   
        
     /* Staff Details */      
     StaffDEANumber   Varchar(50),      
     NationalProviderId   Varchar(100),           
     StaffFirstName       Varchar(100),      
     StaffLastName  Varchar(100),      
           
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
     PatientPhone Varchar(25),  
       
      /* Location Details */  
     LocationName   Varchar(250),  
	 LocationDEANumber  Varchar(50),      
	 LocationNPINumber  Varchar(100),      
	 LocationNCPDPNumber  Varchar(100),      
	 LocationStreet1   Varchar(500),  
	 LocationStreet2   Varchar(500),  
	 LocationCity         Varchar(150),  
	 LocationState    Varchar(50),  
	 LocationZipCode      Varchar(50),  
	 LocationZipPlusFour  Varchar(50)    
                
     )      
      
	   DECLARE @MessageHeader Varchar(250)                      
       DECLARE @LicenseeRequestId Varchar(100)      
       DECLARE @Developer Varchar(100)      
       DECLARE @Product Varchar(100)      
       DECLARE @Version Varchar(100)                 
                                     
       SET @MessageHeader = '<?xml version="1.0" encoding="UTF-8"?>'             
       --SELECT @LicenseeRequestId = Value FROM SystemConfigurationKeys WHERE [Key] = 'MAPSLicenseeRequestId'                          
       --SELECT @Developer = Value FROM SystemConfigurationKeys WHERE [Key] = 'MAPSSenderSoftwareDeveloper'     
       --SELECT @Product = Value FROM SystemConfigurationKeys WHERE [Key] = 'MAPSSenderSoftwareProduct'                
       --SELECT @Version = Value FROM SystemConfigurationKeys WHERE [Key] = 'MAPSSenderSoftwareVersion'   
       
       SET @LicenseeRequestId = NEWID()
       SET @Developer = 'Streamline Healthcare Solutions, LLC'
       SET @Product = 'Smartcare'
       SELECT @Version = Databaseversion FROM systemconfigurations 
                                                                        
        /* Staff Details */      
       DECLARE @StaffDEANumber   Varchar(50)      
       DECLARE @NationalProviderId   Varchar(100)            
       DECLARE @StaffFirstName       Varchar(100)      
       DECLARE @StaffLastName   Varchar(100)        
       DECLARE @UserCode   Varchar(100)       
              
       SELECT @StaffDEANumber = DEANumber,      
       @NationalProviderId = NationalProviderId,      
       @StaffFirstName =  FirstName,      
       @StaffLastName = LastName,       
       @UserCode = UserCode              
       FROM STAFF       
       Where StaffId = @StaffId AND      
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
             
             
       /* Location Details */  
      DECLARE @LocationName   Varchar(250)  
	  DECLARE @LocationDEANumber  Varchar(50)      
	  DECLARE @LocationNPINumber  Varchar(100)      
	  DECLARE @LocationNCPDPNumber  Varchar(100)      
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
	@LocationZipCode =   LEFT(RTRIM(LTRIM(ZipCode)),5)
	FROM Agency       
      
      	

    DECLARE @MonthRange INT  
     DECLARE @FromRange INT
               
     SELECT @MonthRange = NumberOfMonthReport FROM PMPWebServiceConfigurations
     IF(@MonthRange IS NULL)
     BEGIN
     SET @MonthRange = 24   /* fetching the records of past 2 years */
     END
     
     DECLARE @CurrentDate DATETIME
     SET @CurrentDate = GETDATE()
     
     DECLARE @DateRangeBegin DATETIME     
     DECLARE @DateRangeEnd DATETIME   
     
     DECLARE @BeginDate varchar(100)     
     DECLARE @EndDate varchar(100)   
     
     SET @FromRange = @MonthRange - @MonthRange * 2
     
     SELECT @DateRangeBegin = DATEADD(month, @FromRange, GETDATE())
     SELECT @DateRangeEnd = @CurrentDate
     
      SELECT @BeginDate=CONVERT(char(10), @DateRangeBegin,126)  
      SELECT @EndDate = CONVERT(char(10), @DateRangeEnd,126)                   
              
    DECLARE @PatientPhone varchar(50)  
      
    SELECT TOP 1 @PatientPhone = REPLACE(REPLACE(REPLACE(REPLACE(ca3.PhoneNumberText, '-', ''), '(', ''), ')', ''), ' ', '')
    FROM    ClientPhones AS ca3
    WHERE   ca3.ClientId = @ClientId
            AND ISNULL(ca3.PhoneNumber, '') != ''
            AND ISNULL(ca3.RecordDeleted, 'N') != 'Y'
            AND ISNULL(ca3.PhoneNumberText, '') != ''
    ORDER BY CASE WHEN ca3.PhoneType = 30 THEN 1 --Home
                  WHEN ca3.PhoneType = 32 THEN 2 --Home2
                  WHEN ca3.PhoneType = 34 THEN 3 --Mobile
                  WHEN ca3.PhoneType = 35 THEN 4-- Mobile 2
                  WHEN ca3.PhoneType = 31 THEN 5-- Business
                  WHEN ca3.PhoneType = 33 THEN 6-- Business 2
                  WHEN ca3.PhoneType = 37 THEN 7 -- School
                  WHEN ca3.PhoneType = 38 THEN 8 --Other
                  ELSE 9
             END ASC;
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
       @PatientZipcode1 = LEFT(RTRIM(LTRIM(Zip)),5)
       FROM ClientAddresses where       
       ISNULL(Recorddeleted,'N') = 'N' AND             
       ClientId = @ClientId 
              
	   SELECT @PatientSSN = STUFF(STUFF(@PatientSSN,4,0,'-'),7,0,'-')       
                          
       INSERT INTO @results Values(      
    @LicenseeRequestId,   
    @Developer,  
    @Product,  
    @Version,     
    @StaffDEANumber,      
    @NationalProviderId,         
    @StaffFirstName,      
    @StaffLastName ,      
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
    @PatientPhone,              
    @LocationName ,  
    @LocationDEANumber,      
    @LocationNPINumber,      
    @LocationNCPDPNumber,      
    @LocationStreet1,  
    @LocationStreet2,  
    @LocationCity ,  
    @LocationState,  
    @LocationZipCode,  
    @LocationZipPlusFour    
   )      
             
   DECLARE @XMLData Varchar(Max)       
   SET @XMLData = ''      
         
   SET @XMLData =        
   (SELECT  (      
   SELECT  @LicenseeRequestId as LicenseeRequestId      
    ,   (           
     SELECT  (      
      SELECT  @Developer       
      FROM  @results            
      FOR  XML PATH('Developer') ,  TYPE      
     )       
     ,( SELECT  (      
          SELECT  @Product       
          FROM  @results            
       FOR  XML PATH('Product') ,  TYPE            
                 ) )      
     ,( SELECT  (      
          SELECT  @Version       
          FROM  @results            
       FOR  XML PATH('Version') ,  TYPE            
                 ) )                           
     FROM  @results            
     FOR  XML PATH('SenderSoftware') ,  TYPE      
     )       
     ,               
      (           
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
     ,( SELECT  (      
          SELECT  @StaffDEANumber       
          FROM  @results            
       FOR  XML PATH('DEANumber') ,  TYPE            
                 ) )       
     ,( SELECT  (      
          SELECT  @NationalProviderId       
          FROM  @results            
       FOR  XML PATH('NPINumber') ,  TYPE            
                 ) )         
                                  
     FROM  @results            
     FOR  XML PATH('Provider') ,  TYPE      
     )                        
      ,         
     ( SELECT  (      
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
     ,  (SELECT  (      
          SELECT  @LocationStreet1      
          FROM  @results            
       FOR  XML PATH('Street') ,  TYPE            
                 )      
     ,  ( SELECT  (      
          SELECT  @LocationStreet2       
          FROM  @results            
       FOR  XML PATH('Street') ,  TYPE            
                 ) )       
     ,  ( SELECT  (      
          SELECT  @LocationCity       
          FROM  @results            
       FOR  XML PATH('City') ,  TYPE            
                 ) )       
     ,  ( SELECT  (      
          SELECT  @LocationState       
          FROM  @results            
       FOR  XML PATH('StateCode') ,  TYPE            
                 ) )       
     ,  ( SELECT  (      
          SELECT  @LocationZipCode       
          FROM  @results            
       FOR  XML PATH('ZipCode') ,  TYPE            
                 ) )                                                                                              
     FROM  @results            
     FOR  XML PATH('Address') ,  TYPE      
     )                                                                                                     
     FROM  @results            
     FOR  XML PATH('Location') ,  TYPE      
     )         
          
    FROM @results          
    FOR  XML PATH('Requester') ,  TYPE      
       )      
             
     ,(SELECT  (      
          SELECT  (      
          SELECT  @BeginDate       
          FROM  @results            
       FOR  XML PATH('Begin') ,  TYPE            
                 )       
        ,( SELECT  (      
          SELECT  @EndDate       
          FROM  @results            
       FOR  XML PATH('End') ,  TYPE            
                 ) )       
          FROM  @results            
       FOR  XML PATH('DateRange') ,  TYPE            
                 )       
                       
    ,(SELECT(SELECT  (      
     SELECT  (      
      SELECT  @PatientFirstName       
      FROM  @results            
      FOR  XML PATH('First') ,  TYPE      
     )      
     , ( SELECT  (      
        SELECT  @PatientLastName       
        FROM  @results            
        FOR  XML PATH('Last') ,  TYPE            
            ) )       
     FROM  @results            
     FOR  XML PATH('Name') ,  TYPE      
     ) )      
     , @PatientDOB as Birthdate      
     , @PatientGender as SexCode                       
     , (      
       SELECT  (      
       SELECT  (      
        SELECT  @PatientAddressline1       
        FROM  @results            
        FOR  XML PATH('Street') ,  TYPE      
       )      
       , ( SELECT  (      
          SELECT  @PatientAddressline2       
          FROM  @results            
       FOR  XML PATH('Street') ,  TYPE            
                 ) )                      
       , ( SELECT  (      
          SELECT  @PatientCity1       
          FROM  @results            
       FOR  XML PATH('City') ,  TYPE            
                 ) )      
       , ( SELECT  (      
          SELECT  @PatientState1      
          FROM  @results            
       FOR  XML PATH('StateCode') ,  TYPE            
                 ) )       
       , ( SELECT  (      
     SELECT  @PatientZipcode1       
          FROM  @results            
       FOR  XML PATH('ZipCode') ,  TYPE            
                 ) )       
                                                                                              
       FROM  @results            
       FOR  XML PATH('Address') ,  TYPE      
       ))              
      , ( SELECT  (      
          SELECT  @PatientPhone      
          FROM  @results            
       FOR  XML PATH('Phone') ,  TYPE            
                 ) )   
	  , ( SELECT  (      
          SELECT  @PatientSSN      
          FROM  @results            
       FOR  XML PATH('SSN') ,  TYPE            
                 ) )                                                                            
    FROM @results          
    FOR  XML PATH('Patient') ,  TYPE      
   )                   
                       
                           
    FROM @results          
    FOR  XML PATH('PrescriptionRequest') ,  TYPE      
       )      
      
   FOR XML PATH('PatientRequest'))      
         
   SET @XMLData = @MessageHeader + @XMLData       
            
   SET @XMLData = REPLACE(@XMLData, @MessageHeader +'<PatientRequest>', '<PatientRequest xmlns="http://xml.appriss.com/gateway/v5_1">');      
   
   SET @XMLData =  @MessageHeader + @XMLData 
         
              
      DECLARE @PMPConnectionStatus VARCHAR(100)     
          IF ( @XMLData IS NULL )     
            SET @PMPConnectionStatus =     
            'FAILED - Required Request Parameters were not passed'     
          ELSE     
            SET @PMPConnectionStatus = 'PASSED REQUEST'     
    
      DECLARE @PMPAuditTrailId INT                 
    INSERT INTO PMPAuditTrails     
                            (CreatedBy     
                             ,CreatedDate     
                             ,ModifiedBy     
                             ,ModifiedDate     
                             ,StaffId     
                             ,ClientId     
                             ,RequestDateTime     
                             ,RequestMessageXML     
                             ,PMPConnectionStatus)     
          VALUES     ( @UserCode     
                             ,Getdate()     
                             ,@UserCode     
                             ,Getdate()     
                             ,@StaffId     
                             ,@ClientId     
                             ,Getdate()     
                             ,@XMLData     
                             ,@PMPConnectionStatus)     
    
          SET @PMPAuditTrailId = Scope_identity()     
    
   SELECT TOP 1 @PMPAuditTrailId as PMPAuditTrailId, @XMLData as RequestXML, PMPWebServiceURL,    
   UserCode as PMPWebServiceUname, PMPPassword as PMPWebServicePassword, OrganizationCode   
   from PMPWebServiceConfigurations     
   WHERE ISNULL(RecordDeleted,'N') = 'N'    
       
       
      
  END TRY          
           
  BEGIN CATCH          
   DECLARE @Error VARCHAR(8000)                                 
   SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'    
    + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'    
    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),    
       'ssp_RxPMPClientRequestXMLGeneration') + '*****'    
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