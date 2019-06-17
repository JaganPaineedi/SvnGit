IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMMarkServiceNoteAsNoShowCancel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMMarkServiceNoteAsNoShowCancel]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   procedure [dbo].[ssp_PMMarkServiceNoteAsNoShowCancel]              
(    
            
 @ServiceId INT,                    
 @UserCode VARCHAR(30),                    
 @RetStatus INT                     
)                    
/***************************************************************************************************************************                    
-- Stored Procedure: dbo.ssp_PMMarkServiceNoteAsNoShowCancel                    
--                    
-- Copyright: 2006 Streamline Healthcare Solutions                    
--                    
-- Purpose: Mark service as error                    
--                    
-- Updates:                     
--  Date         Author           Purpose    
-- 28Nov2012	Rahul Aneja       Update related table (DOcuments,DocumentVersions,DocumentSignatures) when change status of service as NoShow/Cancel 72/73
-- 30Nov2012    Rakesh Garg       Modified W.rf to task 2258 in Threshold Bugs/Features on ace comments ANKITS - Assigned - 11/29/2012 6:03:05 AM as  DisableNOshownotes & Disablecancelnotes functionaliy not working   
-- DEC-5-2014   dharvey           Removed logic to deleted Documents when a NoShow or Cancel note has not yet been initialized  
	Maintained logic to delete Document for Error status 
-- 01Aug2016    Shruthi.S         Added table name condition to avoid error on cancelling a service.Ref : #
-- 12/16/2016   MD Hussain K      Merged missing changes done by dharvey on DEC-5-2014 and added try catch block w.r.t task #769 Pines-Support
-- 08/10/2017   Vijeta Sinha      Added ssp_PMServiceAuthorizations to update the authorization table if service get canceled w.r.t task #659 CEI - Support Go Live 
-- 06/12/2018   Pabitra           Added the condition to check for the DocumentVersionId Column exists in table before fetching the DocumentVersionId from the table Why:Texas Go Live Build Issues#274  
                                  Added ANSI_NULLS and  QUOTED_IDENTIFIER and increased @tNames variable length to 100.
******************************************************************************************************************************/                                     
AS           
BEgin   
BEGIN TRY            
Declare 
  @DisableNoShowNotes CHAR(5) ,
  @DisableCancelNotes CHAR(5) , 
  @SignedDocument   INT,                    
  @ServiceCancelStatus   INT,                    
  @ServiceNoShowStatus  INT,                    
  @ServiceErrorStatus  INT,                    
  @ServiceCompleteStatus  INT ,                   
  @AssociatedNoteId INT
      
 SELECT                    
 @SignedDocument   = 22,                    
 @ServiceNoShowStatus  = 72 , 
 @ServiceCancelStatus  = 73 ,                
 @ServiceErrorStatus  = 76,                    
 @ServiceCompleteStatus  = 75 ,                    
 @RetStatus   = 0                    
     
 SELECT 
 @DisableCancelNotes=DisableCancelNotes,
 @DisableNoShowNotes=DisableNoShowNotes
 FROM SystemConfigurations  
    
 SELECT 
 @AssociatedNoteId=PC.AssociatedNoteId
 FROM ProcedureCodes PC  
 INNER JOIN Services S   
 ON S.ProcedureCodeid=PC.ProcedureCodeid
 WHERE  S.serviceid  =@ServiceId 
 AND  IsNull(S.RecordDeleted,'N')='N'
 AND  IsNull(PC.RecordDeleted,'N')='N'     
	   

 DECLARE @Tablelist VARCHAR(max),
 @CurrentDocumentVersionId INT, 
 @HasCustomTableRows VARCHAR(10)='False'
 
 SELECT @Tablelist=DC.TableList , 
 @CurrentDocumentVersionId= D.CurrentDocumentVersionId  
 FROM DocumentCodes DC   
 INNER JOIN Documents D   ON DC.DocumentCodeId=D.DocumentCodeId
 WHERE  D.serviceid  =@ServiceId 
 AND  IsNull(D.RecordDeleted,'N')='N'
 AND  IsNull(DC.RecordDeleted,'N')='N' 
 
Declare @HasCustomTableRowsCount TABLE(recordExists VARCHAR(10))
DECLARE @TableNames Table(id INT IDENTITY,tablenames VARCHAR(100)) 
INSERT INTO @TableNames(tablenames)
SELECT item FROM   dbo.fnSplit(@Tablelist,',')  as s where s.item <>'CustomServiceGoalsObjectives'

DECLARE @count INT=1
DECLARE @tablecount INT=(SELECT COUNT(*) FROM @TableNames)
WHILE @count <= @tablecount
Begin
	DECLARE @tNames varchar(100)=(select tablenames from @TableNames where id=@count and tablenames <> 'ExternalReferralProviders')
	DECLARE @sql NVARCHAR(800)
	  
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_TYPE='BASE TABLE' AND  TABLE_NAME=@tNames)  
BEGIN
	IF COL_LENGTH(@tNames,'DocumentVersionId') IS NOT NULL  --06/12/2018  Pabitra 
	  BEGIN  
	SET @sql = '
			IF (0<(SELECT count(*) FROM ' + QUOTENAME(@tNames) + ' where DocumentVersionId='+cast(@CurrentDocumentVersionId as varchar)+')) 
				select ''True''
		    ELSE
		        select ''False''
	           '
	            
	Delete from @HasCustomTableRowsCount
	INSERT INTO @HasCustomTableRowsCount EXECUTE(@sql)
	 IF( 'True'=(select recordExists FROM @HasCustomTableRowsCount))
	   Begin
		SELECT @HasCustomTableRows=recordExists FROM @HasCustomTableRowsCount
		BREAK
	  END
END
END
 SET @count=@count+1

End

Create Table #TempDocuments                    
	(                    
	DocumentId INT,                    
	Status  INT ,
	CurrentDocumentVersionId INT,
	CurrentVersionStatus INT,
	InProgressDocumentVersionId INT                     
	)                    
INSERT INTO #TempDocuments                    
	SELECT a.DocumentId,
	a.Status,CurrentDocumentVersionId,
	CurrentVersionStatus,
	InProgressDocumentVersionId 
	FROM Documents a                    
	WHERE a.ServiceId = @ServiceId                    
	AND IsNULL(a.RecordDeleted,'N')='N'                 
                   
Declare @serviceStatus INT
 SET   @serviceStatus = (SELECT STATUS FROM Services WHERE ServiceId = @ServiceId )                   
IF Exists ( SELECT 1 FROM #TempDocuments WHERE STATUS = @SignedDocument )            
BEGIN            
		IF Exists(SELECT 1 FROM Services WHERE ServiceId = @ServiceId and (Status = @ServiceNoShowStatus or STATUS =@ServiceCancelStatus))            
		Begin           
		             
		           IF(@serviceStatus=@ServiceNoShowStatus)
		           	 Update Services SET STATUS=@ServiceNoShowStatus,ModifiedBy=@UserCode,ModifiedDate=getdate()                    
                     WHERE serviceId=@ServiceId                     
				    Else IF(@serviceStatus=@ServiceCancelStatus)
				      Update Services SET STATUS=@ServiceCancelStatus,ModifiedBy=@UserCode,ModifiedDate=getdate()                    
                      WHERE serviceId=@ServiceId 
                 --Below IF Condition Modify by Rakesh Garg w.rf to task 2258 in Threshold Bugs/Features     
				 --IF (@DisableCancelNotes ='Y' or @DisableNoShowNotes ='Y')     
				 IF ((@DisableCancelNotes ='Y' and @serviceStatus=@ServiceCancelStatus)  or (@DisableNoShowNotes ='Y' and @serviceStatus=@ServiceNoShowStatus ))
				 Begin   
				     Update DV                
					 Set RecordDeleted = 'Y',                    
					 DeletedDate = getdate(),                    
					 DeletedBy = @UserCode                    
					 From DocumentVersions DV                    
					 join #TempDocuments b on DV.DocumentId = b.DocumentId  
					 WHERE DV.DocumentVersionId > b.CurrentDocumentVersionId
					 
					 Update DS                
					 Set RecordDeleted = 'Y',                    
					 DeletedDate = getdate(),                    
					 DeletedBy = @UserCode                    
					 From DocumentSignatures DS
					 join #TempDocuments b on DS.DocumentId = b.DocumentId  
					 WHERE DS.SignatureDate IS NULL
					 
					 Update D                
					 Set D.InProgressDocumentVersionId = D.CurrentDocumentVersionId
					 ,D.CurrentVersionStatus = D.Status                 
					 From Documents D
					 join #TempDocuments b on D.DocumentId = b.DocumentId 
				END
				 --Below IF Condition Modify by Rakesh Garg w.rf to task 2258 in Threshold Bugs/Features
				--ELSE IF((ISNull(@DisableCancelNotes ,'N')='N' or IsNull(@DisableNoShowNotes,'N') ='N') and @HasCustomTableRows='False')
				--ELSE IF(((ISNull(@DisableCancelNotes ,'N')='N'  and @serviceStatus=@ServiceCancelStatus)  or (IsNull(@DisableNoShowNotes,'N') ='N'  and @serviceStatus=@ServiceNoShowStatus)) and @HasCustomTableRows='False')
				ELSE IF ( @serviceStatus = @ServiceErrorStatus 
                     AND @HasCustomTableRows = 'False' ) 
				Begin
				     Update DV                
					 Set RecordDeleted = 'Y',                    
					 DeletedDate = getdate(),                    
					 DeletedBy = @UserCode                    
					 From DocumentVersions DV                    
					 join #TempDocuments b on DV.DocumentId = b.DocumentId  
					 WHERE DV.DocumentVersionId > b.CurrentDocumentVersionId
					 
					 Update DS                
					 Set RecordDeleted = 'Y',                    
					 DeletedDate = getdate(),                    
					 DeletedBy = @UserCode                    
					 From DocumentSignatures DS
					 join #TempDocuments b on DS.DocumentId = b.DocumentId  
					 WHERE DS.SignatureDate IS NULL
					 
					 Update D                
					 Set D.InProgressDocumentVersionId = D.CurrentDocumentVersionId
					 ,D.CurrentVersionStatus = D.Status                 
					 From Documents D
					 join #TempDocuments b on D.DocumentId = b.DocumentId 
				END
					        
		End   
		          
End                    
            
Else IF Exists (Select 1 from #TempDocuments where status <> @SignedDocument)                    
Begin 
  -- Below IF condition added by Rakesh w.rf to task 2258 Ace comments "ANKITS - Assigned - 11/29/2012 6:03:05 AM" as  DisableNOshownotes & Disablecancelnotes functionaliy not working                  
	IF ((@DisableCancelNotes ='Y' and @serviceStatus = @ServiceCancelStatus)  or (@DisableNoShowNotes ='Y' and @serviceStatus = @ServiceNoShowStatus) or  (@serviceStatus = @ServiceErrorStatus and @HasCustomTableRows = 'False')) 
     Begin  
			 Update a                    
			 Set RecordDeleted = 'Y',                    
			 DeletedDate = getdate(),                    
			 DeletedBy = @UserCode                    
			 From Documents a                    
			 join #TempDocuments b on a.DocumentId = b.DocumentId                    
			                    
			Update C                
			 Set RecordDeleted = 'Y',                    
			 DeletedDate = getdate(),                    
			 DeletedBy = @UserCode                    
			 From DocumentVersions C                    
			 join #TempDocuments b on C.DocumentId = b.DocumentId                    
			                    
			   
			Update DS                  
			 Set RecordDeleted = 'Y',                      
			 DeletedDate = getdate(),                      
			 DeletedBy = @UserCode                  
			 From DocumentSignatures DS                      
			 join #TempDocuments b on DS.DocumentId = b.DocumentId               
      END 
      ELSE 
            BEGIN 
                IF EXISTS (SELECT * 
                           FROM   sys.objects 
                           WHERE  object_id = 
                   Object_id(N'[dbo].[scsp_PMMarkServiceNoteAsNoShowCancel]') 
                   AND type IN ( N'P', N'PC' )) 
                  BEGIN 
                      EXEC Scsp_pmmarkservicenoteasnoshowcancel 
                        @ServiceId, 
                        @UserCode 
                  END 
            END                
                    
 END  
  ------------- Added by vsinha----------- 
exec ssp_PMServiceAuthorizations   
      @CurrentUser = @UserCode,  
      @ServiceId = @ServiceId,  
      @ServiceDeleted = 'N' 
      
--------------------------------------- 
   END TRY
  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_PMMarkServiceNoteAsNoShowCancel')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.  
    16,  -- Severity.  
    1  -- State.  
    );
  END CATCH                     
             
END  


GO


