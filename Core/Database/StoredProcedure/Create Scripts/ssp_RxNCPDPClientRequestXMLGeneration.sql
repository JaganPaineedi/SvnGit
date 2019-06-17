/****** Object:  StoredProcedure [dbo].[ssp_RxNCPDPClientRequestXMLGeneration]        ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RxNCPDPClientRequestXMLGeneration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RxNCPDPClientRequestXMLGeneration]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RxNCPDPClientRequestXMLGeneration]        ******/
SET ANSI_NULLS ON
GO


 CREATE PROCEDURE [dbo].[ssp_RxNCPDPClientRequestXMLGeneration]  
 (  
   @ClientId INT,
   @StaffID  INT                    
 )           
/*********************************************************************/        
/* Procedure: ssp_RxNCPDPClientRequestXMLGeneration            */        
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
/* Date         Author                 Comments						 */
/* 29/Oct/18    Anto             Modified the sp by adding the logic for Patient consent node */
/* 19 Mar 2019	Anto             Modified the sp by formatting @BenefitsCoordinationEffectivedate and @BenefitsCoordinationExpdate making it compatible with 2008 SQL Server database - Comprehensive-Customizations # 6120.1 */ 

/*********************************************************************/  
AS   
 BEGIN         
        
  BEGIN TRY  
    DECLARE @results TABLE    
       (    
     ToQualifier Varchar(100),  
     FromQualifier Varchar(100),   
     TertiaryIdentifier Varchar(50),   
     Testmessage Varchar(10),  
                          
     /* Patient Details */  
     PatientFirstName Varchar(250),  
     PatientLastName Varchar(250),  
     PatientGender   Char(1),  
     PatientDOB  varchar(50),  
     PatientAddressline1  Varchar(250),  
     PatientCity1    Varchar(500),  
     PatientState1   Varchar(100),  
     PatientZipcode1   Varchar(100),  
     PatientSSN    Varchar(100),         
       
       /* Staff Details */  
     StaffDEANumber   Varchar(50),  
     NationalProviderId   Varchar(100),  
     StaffAddressline1    Varchar(250),  
     StaffFirstName       Varchar(100),  
     StaffLastName  Varchar(100),         
     StaffCity   Varchar(100),  
     StaffState   Varchar(50),  
     StaffZip       Varchar(50)  
  
        )  
          
        DECLARE @resultsXML TABLE    
       (    
		XMLResult  Varchar(Max)  
       )  
         
       /* Header Contents */  
          
       DECLARE @MessageHeader Varchar(250)  
       DECLARE @ToQualifier Varchar(100)  
       DECLARE @FromQualifier Varchar(100)  
       DECLARE @Messageid Varchar(max)  
       DECLARE @Uniqueid Varchar(max)          
       DECLARE @SenderTertiaryIdentification varchar(100)  
       DECLARE @ReceiverTertiaryIdentification varchar(100)  
       DECLARE @Testmessage Varchar(10)  
       DECLARE @TertiaryIdentifier Varchar(100)  
         
                
       SET @MessageHeader = '<?xml version="1.0" encoding="UTF-8"?>'      
       SET @ToQualifier = 'WA-OHP'          
       SELECT @FromQualifier = Value FROM SystemConfigurationKeys WHERE [Key] = 'FromQualifierValue'   
       SET @Uniqueid = NEWID()                     
       SET @Messageid = REPLACE (@Uniqueid,'-','')    
      
    SELECT @SenderTertiaryIdentification = Value FROM SystemConfigurationKeys WHERE [Key] = 'TertiaryIdentificationSenderValue'   
    SELECT @ReceiverTertiaryIdentification = Value FROM SystemConfigurationKeys WHERE [Key] = 'TertiaryIdentificationReceiverValue'  
         
       SELECT @Testmessage = Value FROM SystemConfigurationKeys WHERE [Key] = 'TestmessageValue'  
    SET @TertiaryIdentifier = 'FIL'  
        
  
    /* Patient Details */  
       DECLARE @PatientFirstName Varchar(250)  
       DECLARE @PatientLastName Varchar(250)  
       DECLARE @PatientGender   Char(1)  
       DECLARE @PatientDOB  varchar(50)  
       DECLARE @PatientAddressline1  Varchar(250)  
       DECLARE @PatientCity1   Varchar(500)  
       DECLARE @PatientState1   Varchar(100)  
       DECLARE @PatientZipcode1   Varchar(100)        
       DECLARE @PatientSSN    Varchar(100)  
         
       DECLARE @patientconsent Char(1)  
       DECLARE @BenefitsCoordinationEffectivedate Varchar(100)  
       DECLARE @BenefitsCoordinationExpdate Varchar(100)  
                               
       DECLARE @Todaydate Datetime
	   DECLARE @Startdate Datetime
       DECLARE @Enddate Datetime
	   DECLARE @ClientDOB Datetime
       DECLARE @ClientAge int

       SET @PatientConsent = 'N'
       SET @Todaydate = GETDATE()

       SELECT @ClientDOB= DOB from CLIENTS where ClientId = @ClientId
       SELECT @ClientAge= CONVERT(int,ROUND(DATEDIFF(hour,@ClientDOB,GETDATE())/8766.0,0)) 

       DECLARE @LatestDocumentversionid INT

      SELECT TOP 1 @LatestDocumentversionid = MD.DocumentVersionId FROM MedicationHistoryRequestConsents MD 
	  join Documentversions DV ON DV.Documentversionid = MD.DocumentVersionId
	  join Documents D ON D.Documentid = DV.Documentid 
	  WHERE MD.ClientId = @ClientId AND D.Status = 22  
	  AND ISNULL(MD.Recorddeleted,'N') = 'N'
	  AND ISNULL(DV.Recorddeleted,'N') = 'N'
	  AND ISNULL(D.Recorddeleted,'N') = 'N' order by D.Effectivedate desc,D.modifieddate desc

      SELECT Top 1 @Startdate = StartDate,@Enddate = EndDate
      FROM MedicationHistoryRequestConsents
      WHERE DocumentVersionId = @LatestDocumentversionid and ClientId = @ClientId  
 
      IF (@Todaydate >= @Startdate and (@Todaydate <= @Enddate OR @Enddate IS NULL) AND (@ClientAge >= 18))
      BEGIN
      SET @PatientConsent = 'Y'
      END
      ELSE IF (@Todaydate >= @Startdate and (@Todaydate <= @Enddate OR @Enddate IS NULL) AND (@ClientAge < 18))
      BEGIN
      SET @PatientConsent = 'Z'
      END    

	  SET @BenefitsCoordinationEffectivedate = CONVERT(char(10), DATEADD(YY,-2, GetDate()),126)   
	  SET @BenefitsCoordinationExpdate = CONVERT(char(10), GETDATE(),126)  
                                             
         
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
         
       /* Staff details */  
       DECLARE @StaffCommunicationnumber Varchar(100)  
         
        /* Staff Details */  
       DECLARE @StaffDEANumber   Varchar(50)  
       DECLARE @NationalProviderId   Varchar(100)  
       DECLARE @StaffAddressline1    Varchar(250)  
       DECLARE @StaffFirstName       Varchar(100)  
       DECLARE @StaffLastName   Varchar(100)         
       DECLARE @StaffCity    Varchar(100)  
       DECLARE @StaffState    Varchar(50)  
       DECLARE @StaffZip    Varchar(50)  
         
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
       
       

	SELECT @StaffCommunicationNumber = HomePhone FROM STAFF where staffid = @StaffID
	IF @StaffCommunicationNumber IS NULL
	SELECT @StaffCommunicationNumber = CellPhone FROM STAFF where staffid = @StaffID
	IF @StaffCommunicationNumber IS NULL
	SELECT @StaffCommunicationNumber = officephone1 FROM STAFF where staffid = @StaffID
	IF @StaffCommunicationNumber IS NULL
	SELECT @StaffCommunicationNumber = officephone2 FROM STAFF where staffid = @StaffID
         
  
   INSERT INTO @results Values(  
   @ToQualifier,  
   @FromQualifier,  
   @TertiaryIdentifier,  
   @Testmessage,  
   @PatientFirstName,                         
   @PatientLastName,  
   @PatientGender,      
   @PatientDOB,    
   @PatientAddressline1,    
   @PatientCity1,     
   @PatientState1,     
   @PatientZipcode1,        
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
     
     
   DECLARE @RequestXML Varchar(Max)   
   DECLARE @ResponseXML Varchar(Max)     
     
   SET @RequestXML =                      
   (SELECT  (  
   SELECT  @ToQualifier as ToQualifier  
    ,   @FromQualifier as FromQualifier  
    ,   @Messageid as MessageID  
    ,   GETDATE() as SentTime  
    ,   ( 
    SELECT  (  
     SELECT  (  
      SELECT  @StaffFirstName   
      FROM  @results        
      FOR  XML PATH('Username') ,  TYPE  
     )  
     FROM  @results        
     FOR  XML PATH('UsernameToken') ,  TYPE  
     )                
     ,(SELECT  (   
      SELECT  @SenderTertiaryIdentification   
      FROM  @results        
      FOR  XML PATH('TertiaryIdentification') ,  TYPE  
     )  
     FROM  @results        
     FOR  XML PATH('Sender') ,  TYPE  
     )          
     ,(SELECT  (  
     SELECT  (  
      SELECT  @ReceiverTertiaryIdentification   
      FROM  @results        
      FOR  XML PATH('TertiaryIdentification') ,  TYPE  
     )  
     FROM  @results        
     FOR  XML PATH('Receiver') ,  TYPE  
     ))     
                 
     FROM   @results       
     FOR XML PATH('Security') , TYPE      
    )     
    ,@Testmessage as TestMessage   
    ,@TertiaryIdentifier as TertiaryIdentifier    
    FROM @results      
    FOR  XML PATH('Header') ,  TYPE  
       )  
                           
     ,(SELECT (  
     SELECT  (                        
     (SELECT (SELECT  (  
     SELECT  (  
      SELECT  @PatientLastName   
      FROM  @results        
      FOR  XML PATH('LastName') ,  TYPE  
     )  
     , ( SELECT  (  
        SELECT  @PatientFirstName   
        FROM  @results        
        FOR  XML PATH('FirstName') ,  TYPE        
            ) )   
     FROM  @results        
     FOR  XML PATH('Name') ,  TYPE  
     ) )  
     , @PatientGender as Gender   
     ,(SELECT  (  
     SELECT  (  
      SELECT  @PatientDOB   
      FROM  @results        
      FOR  XML PATH('Date') ,  TYPE  
     )  
     FROM  @results        
     FOR  XML PATH('DateOfBirth') ,  TYPE  
     ))                      
    FROM @results      
    FOR  XML PATH('Patient') ,  TYPE  
   ))  
   ,   (  
     SELECT  (  
     SELECT  (  
      SELECT  @BenefitsCoordinationEffectivedate  
      FROM  @results        
      FOR  XML PATH('Date') ,  TYPE  
     )       
     FROM  @results        
     FOR  XML PATH('EffectiveDate') ,  TYPE  
     )   
        
     ,(SELECT  (  
     SELECT  (  
      SELECT  @BenefitsCoordinationExpdate   
      FROM  @results        
      FOR  XML PATH('Date') ,  TYPE  
     )  
     FROM  @results        
     FOR  XML PATH('ExpirationDate') ,  TYPE  
     ))    
        ,@patientconsent as Consent        
     FROM @results      
     FOR  XML PATH('BenefitsCoordination') ,  TYPE  
     )  

     FROM  @results        
     FOR  XML PATH('RxHistoryRequest') ,  TYPE  
     )  
       
     FROM @results      
    FOR  XML PATH('Body') ,  TYPE  
    )  
  
   FOR XML PATH('Message'))  
     
   SET @RequestXML = @MessageHeader + @RequestXML   
        
   SET @RequestXML = REPLACE(@RequestXML, '<Message>', '<Message xmlns="http://www.ncpdp.org/schema/SCRIPT" version="010" release="006">');  
     
   SET @RequestXML = REPLACE(@RequestXML, '<ToQualifier>', '<To Qualifier="ZZZ">');  
     
   SET @RequestXML = REPLACE(@RequestXML, '</ToQualifier>', '</To>');  
     
   SET @RequestXML = REPLACE(@RequestXML, '<FromQualifier>', '<From Qualifier="ZZZ">');  
     
   SET @RequestXML = REPLACE(@RequestXML, '</FromQualifier>', '</From>');  
     
     
       
   IF @PatientSSN IS NOT NULL  
   BEGIN  
   SET @RequestXML = REPLACE(@RequestXML, '<SSN>', '<Identification><SSN>');  
   SET @RequestXML = REPLACE(@RequestXML, '</SSN>', '</SSN></Identification>');  
   END  
   ELSE  
   BEGIN  
   SET @RequestXML = REPLACE(@RequestXML, '<SSN>', '');     
   SET @RequestXML = REPLACE(@RequestXML, '<SSN/>', '');  
   END  
            
   --SELECT @RequestXML  
     
   --INSERT XMLData INTO TABLE  
     
    DECLARE @NCPDPConnectionStatus VARCHAR(100)       
          IF ( @RequestXML IS NULL )       
            SET @NCPDPConnectionStatus =       
            'FAILED - Required Request Parameters were not passed'       
          ELSE       
            SET @NCPDPConnectionStatus = NULL   --Made as NULL      
                  
      DECLARE @PMPAuditTrailId INT                   
      INSERT INTO PMPAuditTrails       
                            (CreatedBy       
                             ,CreatedDate       
                             ,ModifiedBy       
                             ,ModifiedDate       
                             ,StaffId       
                             ,ClientId       
                             ,RequestDateTime    
                             ,Requesttype     
                             ,RequestMessageXML       
                             ,PMPConnectionStatus)       
          VALUES     (        'Streamline'       
                             ,Getdate()       
                             ,'Streamline'      
                             ,Getdate()       
                             ,@StaffId       
                             ,@ClientId       
                             ,Getdate()   
                             ,'X'      
                             ,@RequestXML       
                             ,@NCPDPConnectionStatus)       
      
          SET @PMPAuditTrailId = Scope_identity()                                               
  
  END TRY          
           
  BEGIN CATCH          
   DECLARE @Error VARCHAR(8000)           
   SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'    
    + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'    
    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),    
       'ssp_RxNCPDPClientRequestXMLGeneration') + '*****'    
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