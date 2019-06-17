/****** Object:  StoredProcedure [dbo].[csp_PostUpdatePsychaitricNote]    Script Date: 07/07/2015 16:26:11 ******/
IF EXISTS (
		SELECT * 
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdatePsychaitricNote]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_PostUpdatePsychaitricNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_PostUpdatePsychaitricNote]    Script Date: 26/07/2015 16:26:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_PostUpdatePsychaitricNote] (
	 @ScreenKeyId int,                            
	 @StaffId int,                            
     @CurrentUser varchar(30),                            
	 @CustomParameters xml--Status
	)
AS

BEGIN

DECLARE @ClientId INT
DECLARE @PrimaryClinicianID INT
DECLARE @CurrentDocumentVersionId INT


SET @CurrentDocumentVersionId = (SELECT CurrentDocumentVersionId FROM DOCUMENTS WHERE DOCUMENTID=@ScreenKeyId AND ISNULL(RecordDeleted, 'N') = 'N' AND Status=22)
SET @ClientId = (SELECT CLIENTID FROM DOCUMENTS WHERE DOCUMENTID=@ScreenKeyId AND ISNULL(RecordDeleted, 'N') = 'N' AND Status=22)
SET @PrimaryClinicianID= (SELECT PrimaryClinicianId FROM CLIENTS WHERE ClientId=@ClientId AND ISNULL(RecordDeleted, 'N') = 'N')

 INSERT INTO [Messages] (  
   [FromStaffId]  
   ,[ToStaffId]  
   ,[ClientId]  
   ,[Unread]  
   ,[DateReceived]  
   ,[Subject]  
   ,[Message]  
   ,[DocumentId]  
   ,[Priority]  
   ,[ReferenceType]  
   ,[ReferenceId]  
   ,[Reference]  
   ,[ReferenceLink]  
   )  
   SELECT @StaffId  
   ,@PrimaryClinicianID  
   ,@ClientId  
   ,'Y'  
   ,GETDATE()  
   ,'Plan of Care From Psychiatrist'  
   ,PlanComment     
   ,@ScreenKeyId  
   ,60  
      ,5854  
      ,@ScreenKeyId  
      ,(SELECT TOP 1 (DocumentName) FROM DocumentCodes WHERE DocumentCodeId = 60000)  
      ,@ScreenKeyId  
       FROM CustomDocumentPsychiatricNoteMDMs 
       where DocumentVersionId=@CurrentDocumentVersionId
       and isnull(NurseMonitorPillBox,'N')='Y' AND ISNULL(RecordDeleted, 'N') = 'N'
END