IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentSignSUAdmissions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentSignSUAdmissions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentSignSUAdmissions]  
 @StaffId int,  
 @ClientId int,  
 @DocumentCodeId int  
AS  
BEGIN  
  
 
 DECLARE @Results TABLE(  
  ValidationMessage varchar(max),  
  WarningOrError varchar(1)  
 )  
		
DECLARE @LastSignedASAMDate datetime  

 SET @LastSignedASAMDate = ( SELECT MAX(d.EffectiveDate)  
							FROM Documents d 
							WHERE d.ClientId = @ClientId AND  
								  d.DocumentCodeId = 40034 AND 								 
								  ISNULL(d.RecordDeleted,'N') = 'N' AND
								  d.Status = 22 )  
   
 --IF @LastSignedASAMDate IS NULL OR DATEDIFF(MM,@LastSignedASAMDate,GETDATE()) > 6  
 --BEGIN  
 -- INSERT INTO @Results(  
 --  ValidationMessage,  
 --  WarningOrError  
 -- )  
 -- VALUES(  
 --  'Must complete an ASAM prior to completing the SU Admission document',  
 --  'E'  
 -- )  
 --END  

   
 --SELECT * FROM @Results  
   
END  