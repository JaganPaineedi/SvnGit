/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentPsychiatricNote]    Script Date: 07/20/2015  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentPsychiatricNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentPsychiatricNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentPsychiatricNote] 733535   Script Date: 06/30/2014 18:07:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentPsychiatricNote]  
 @DocumentVersionId int    
AS  
   
/**************************************************************  
Created By   : Lakshmi       csp_ValidateCustomDocumentPsychiatricNote     978470
Created Date : 13-11-2015
Description  : Used to Validate Psychiatric Note  
Called From  : Medical Note
/*  Date			  Author				  Description */
/*  13-11-2015	      Lakshmi				  Created    */
/*  JUNE-29-17        Pabitra                 Texas Customizations#58 */
What: Converted both Csp_validatecustompsychiatricnotesubjective And Csp_validatecustompsychiatricnotesubjective to functions.
Why: It was throwing error while signing Batch signature. Error - insert exec statement cannot be nested. A Renewed Mind - Support: #767 
/*	24-09-2018        Lakshmi            What: Added these two validations (Service - Please select at least 1 goal addressed for this														service. Service - Please specify 1 objective addressed for this service)
										 Why:  A Renewed Mind - Support #976
*/
**************************************************************/
 
DECLARE @DocumentType varchar(10)
DECLARE @ClientId int  
DECLARE @EffectiveDate datetime  
DECLARE @StaffId int  
DECLARE @ProgramId int
DECLARE @DocumentCodeId int
DECLARE @TDocumentType CHAR(1);
DECLARE @TreatmentPlanType CHAR(1);
DECLARE @LatestDocumentVersionID INT;
DECLARE @ServiceId INT;

DECLARE @Initial CHAR(1);
SELECT @ClientId = d.ClientId  
FROM Documents d  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  
  
SELECT @StaffId = d.AuthorId,@ServiceId = d.ServiceId  
FROM Documents d  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  

SET @LatestDocumentVersionID = (
			SELECT TOP 1 CurrentDocumentVersionId
			FROM CustomDocumentPsychiatricNoteGenerals CDNA
			INNER JOIN Documents Doc ON CDNA.DocumentVersionId = Doc.CurrentDocumentVersionId
			WHERE Doc.ClientId = @ClientID
				AND Doc.[Status] = 22
				AND ISNULL(CDNA.RecordDeleted, 'N') = 'N'
				AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
				and Doc.DocumentCodeId = 60000
			ORDER BY Doc.EffectiveDate DESC
				,Doc.ModifiedDate DESC
			)
SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)
  set @Initial = case when @LatestDocumentVersionId = -1 then 'Y' else 'N' end 

SET @EffectiveDate = CONVERT(datetime, convert(varchar, getdate(), 101))  
select @ProgramId = s.ProgramId  from [Services] s join Documents d on s.ServiceId = d.ServiceId where d.CurrentDocumentVersionId = @DocumentVersionId

 CREATE TABLE [#validationReturnTable] (        
   TableName varchar(100) null,       
   ColumnName varchar(100) null,       
   ErrorMessage varchar(max) null,
   TabOrder int null,  
   ValidationOrder int null  
   )  
   
   IF OBJECT_ID('tempdb..#tmpPoblemStatus') IS NOT NULL                
	DROP TABLE #tmpPoblemStatus
 
    CREATE TABLE [#tmpPoblemStatus] (        
   RowId Int null,       
   ProblemStatus int null
   )

  
DECLARE @Variables varchar(max)    
SET @Variables = 'DECLARE @DocumentVersionId int  
      SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +    
     ' DECLARE @ClientId int  
      SET @ClientId = ' + convert(varchar(20), @ClientId) +   
     ' DECLARE @EffectiveDate datetime  
      SET @EffectiveDate = ''' + CONVERT(varchar(20), @EffectiveDate, 101) + '''' +  
     ' DECLARE @StaffId int  
       SET @StaffId = ' + CONVERT(varchar(20), @StaffId)  +  
     ' DECLARE @MInitial char(1)  
       SET @MInitial = ''' + @Initial  + ''''  
     
       
If Not Exists (Select 1 From CustomDocumentValidationExceptions where DocumentVersionId = @DocumentVersionId and DocumentValidationid is null)    
Begin    
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 60000, @DocumentType, @Variables



INSERT INTO #validationReturnTable (TableName ,       
   ColumnName,       
   ErrorMessage,
   TabOrder,  
   ValidationOrder)
SELECT TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder FROM Csf_validatecustompsychiatricnotesubjective(@DocumentVersionId,@TDocumentType )
--Added by Lakshmi 03/04/2016
IF(ISNULL(@LatestDocumentVersionID,0)>0)
			BEGIN
			DECLARE @PsychiatricHistory VARCHAR(MAX)
			DECLARE @FamilyHistory VARCHAR(MAX)
			DECLARE @SocialHistory VARCHAR(MAX)
			DECLARE @MedicalHistory VARCHAR(MAX)
			
			SET @PsychiatricHistory=(SELECT PsychiatricHistory 
			FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId)
			
			SET @FamilyHistory=(SELECT FamilyHistory 
			FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId)
			
			SET @SocialHistory=(SELECT SocialHistory 
			FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId)
			
			SET @MedicalHistory=(SELECT MedicalHistory 
			FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId)
			
			--IF(ISNULL(@PsychiatricHistory,'')='')
			--BEGIN
			--INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)  
			--SELECT 'CustomDocumentPsychiatricNoteGenerals','PsychiatricHistory','General - History – Past History is required',1,5
			--END
			
			--IF(ISNULL(@FamilyHistory,'')='')
			--BEGIN
			--INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)  
			--SELECT 'CustomDocumentPsychiatricNoteGenerals','FamilyHistory','General - History – Family History is required',1,7
			--END
			
			--IF(ISNULL(@SocialHistory,'')='')
			--BEGIN
			--INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)  
			--SELECT 'CustomDocumentPsychiatricNoteGenerals','SocialHistory','General - History – Social History is required',1,9 
			--END
			--IF(ISNULL(@MedicalHistory,'')='')
			--BEGIN
			--INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)  
			--SELECT 'CustomDocumentPsychiatricNoteGenerals','SocialHistory','General - History – Medical History is required',1,11
			--END
			END
			
			
	--Added by Lakshmi, 05-08-2016 for Camino Support Go live #70	
	
	--Added by SunilDasari, 14-12-2016 for Camino Support Go live #239	
			INSERT INTO [#tmpPoblemStatus]
			SELECT   ROW_NUMBER() OVER(ORDER BY PsychiatricNoteProblemId ASC) AS RowId,Problemstatus from CustomPsychiatricNoteProblems where DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' 

					 
			--INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder) 
			--SELECT   'CustomPsychiatricNoteProblems','Problemstatus','MDM - MDM - Problem ('+CAST(RowId AS VARCHAR(10)) +') status is required',3,23 from [#tmpPoblemStatus] where ProblemStatus IS NULL

			Drop Table [#tmpPoblemStatus]
					
	--Added by SunilDasari, 14-12-2016 for Camino Support Go live #239	
	
	
	
		
	insert into [#validationReturnTable] (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder) 
	SELECT TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder FROM Csf_commonvalidatecustomdocumentdsm5diagnosis (@DocumentVersionId)
	
	exec dbo.csp_ValidateServiceGoal @ServiceId   --Added by Lakshmi on 24-09-2018
	exec dbo.csp_ValidateServiceObjective @ServiceId ----Added by Lakshmi on 24-09-2018
	
select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder
if @@error <> 0 goto error    
End    
   
if @@error <> 0 goto error    
    
return   
  
error:    
raiserror ( 'csp_ValidateCustomDocumentPsychiatricNote failed.  Please contact your system administrator.' ,16,1) 

GO


