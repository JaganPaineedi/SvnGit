IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCPostSignatureUpdateROI]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCPostSignatureUpdateROI] 

GO 


CREATE PROCEDURE [dbo].[ssp_SCPostSignatureUpdateROI] (@ScreenKeyId      INT, 
                                                       @StaffId          INT, 
                                                       @CurrentUser      VARCHAR (30), 
                                                       @CustomParameters XML) 
AS 
/************************************************************************************/ 
/* Stored Procedure: dbo.[ssp_SCPostSignatureUpdateROI]        */ 
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */ 
/* Creation Date:   23/Nov/2017            */ 
/* Purpose:To create No. of documents of 'Release of Information' document as created in CustomDocumentReleaseOfInformations   */
/*                     */ 
/* Input Parameters:  @ScreenKeyId int,@StaffId,@CurrentUse,@CustomParameters       */ 
/*                     */ 
/* Output Parameters:   None              */ 
/*                     */ 
/* Return:  0=success, otherwise an error number         */ 
/*                     */ 
/* Called By:                  */ 
/*                     */ 
/* Calls:                   */ 
/*                     */ 
/* Data Modifications:                */ 
/*                     */ 
/* Updates:                   */ 
/*  Date           Author             Purpose            */ 
/* 23/Nov/2017   Alok Kumar          Created. Ref: Task#2013 Spring River - Customizations  */ 
/* 07/Feb/2018         Ponnin        Inserting ROI log to with start and end dates of the Expiration section. For Ref: Task#2013 Spring River - Customizations */ 

  /************************************************************************************/ 
  BEGIN 
      BEGIN try 
          DECLARE @CurrentDocumentVersionId INT, 
                  @CurrentVersionstatus     INT, 
                  @clientid                 INT, 
                  @ClientSignatureId        INT, 
                  @SignatureType            VARCHAR(1), 
                  @documentcodeid           INT, 
                  @authorid                 INT 
                  
		declare @ClientInformationReleases table (NewClientInformationReleaseId int not null)     

          SELECT @CurrentDocumentVersionId = currentdocumentversionid, 
                 @CurrentVersionstatus = currentversionstatus, 
                 @clientid = clientid, 
                 @documentcodeid = documentcodeid, 
                 @authorid = authorid 
          FROM   documents 
          WHERE  documentid = @ScreenKeyId 
                 AND Isnull(recorddeleted, 'N') = 'N' 

          /*Add by sanjayb 5/feb/2013 #2*/ 
          SELECT @ClientSignatureId = 
          @CustomParameters.value('Root[1]/Parameters[1]/@SignerId', 'bigint') 

          SELECT @SignatureType = 
  @CustomParameters.value('Root[1]/Parameters[1]/@SignerType', 'varchar(1)') 

  /*End#2*/ 
  --Check Signed Document status i.e 22(signed) and Checking that Document ClientId is equal to SignatureId        
  IF( Isnull(@CurrentVersionstatus, -1) = 22  AND Isnull(@ClientSignatureId, -1) = @clientid ) 
    BEGIN 
        -------Creating Client Release of Information Log entry here                       
        INSERT INTO clientinformationreleases 
                    ([clientid], 
                     [releasetoid], 
                     [releasetoname], 
                     [startdate], 
                     [enddate], 
                     [comment], 
                     [documentattached], 
                     [locked], 
                     [lockedby], 
                     [lockeddate], 
                     [createdby], 
                     [createddate]) 
        output  inserted.clientinformationreleaseid  INTO @ClientInformationReleases 
        SELECT D.clientid, 
               CASE 
                 WHEN ( CDRI.ReleaseType = 'C' ) THEN 
                 CDRI.ReleaseToFromContactId 
                 ELSE NULL 
               END, 
               CDRI.releasename, 
               CDRI.ExpirationStartDate,
               --CONVERT(VARCHAR(10), D.effectivedate, 101), 
               CDRI.ExpirationEndDate AS EndDate, 
               Isnull(CDRI.releaseaddress + ' | ', '') 
               + Isnull(CDRI.releasephonenumber + ' ', '') 
               + 'Program: ' + Isnull(P.programname, NULL), 
               'Release of Information', 
               'Y', 
               @CurrentUser, 
               Getdate(), 
               @CurrentUser, 
               Getdate() 
        FROM   DocumentReleaseOfInformations CDRI 
               JOIN DocumentVersions DV ON CDRI.DocumentVersionId = DV.DocumentVersionId 
               JOIN Documents D ON DV.DocumentId = D.DocumentId 
               LEFT JOIN ClientContacts CC  ON CDRI.ReleaseToFromContactId = CC.ClientContactId 
               LEFT JOIN programs P ON CDRI.programid = P.programid 
        WHERE  CDRI.documentversionid = @CurrentDocumentVersionId 

     
        
        INSERT INTO ClientInformationReleaseDocuments 
                    (ClientInformationReleaseId, 
                     DocumentId) 
        SELECT newclientinformationreleaseid, 
               @ScreenKeyId 
        FROM   @ClientInformationReleases 
    END 
    
  END try 

BEGIN CATCH                                            
DECLARE @Error varchar(8000)                                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCPostSignatureUpdateROI')                                                                                                                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                        
 RAISERROR                                                                                                                       
 (                                                                                         
  @Error, -- Message text.                                                                                                                      
  16, -- Severity.                                                                                                                      
  1 -- State.                                                                                                                      
 );                                                                                                                    
END CATCH  

  END 