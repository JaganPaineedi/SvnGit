/****** Object:  StoredProcedure [dbo].[csp_InitCustomDiagnosisStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDiagnosisStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDiagnosisStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDiagnosisStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create PROCEDURE  [dbo].[csp_InitCustomDiagnosisStandardInitialization]  
(  
 @ClientId int,  
 @StaffID int,  
 @CustomParameters xml  
)  
As  
 /*********************************************************************/  
 /* Stored Procedure: [csp_InitCustomDiagnosisStandardInitialization]               */  
  
 /* Copyright: 2006 Streamline SmartCare*/  
  
 /* Creation Date:                                     */  
 /*                                                                   */  
 /* Purpose: To Initialize */  
 /*                                                                   */  
 /* Input Parameters:  */  
 /*                                                                   */  
 /* Output Parameters:                                */  
 /*                                                                   */  
 /* Return:   */  
 /*                                                                   */  
 /* Called By:   */  
 /*      */  
 /*                                                                   */  
 /* Calls:                                                            */  
 /*                                                                   */  
 /* Data Modifications:                                               */  
 /*                                                                   */  
 /*   Updates:                                                          */  
 /*   Date              Author              Purpose                                    */  
 /*   Sept22,2009       Mohit Madaan        Made changes as per database  SCWebVenture3.0 */  
 /*   Nov18,2009		Ankesh              Made changes as paer dataModel SCWebVenture3.0  */  
 /*   July19,2010		Anuj				Made changes as per new dataModel */  
 /*   July 21, 2012		Pralyankar			Modified for implementing the Placeholder Concept*/
 /*********************************************************************/  
  
Begin  
  
Begin try  
  
	declare @LatestDocumentVersionID int  
	  
	-- get the previous diagnosis only if it is less than a year old.  
	  
	set @LatestDocumentVersionID =(select top 1 CurrentDocumentVersionId  
	from Documents a  
	where a.ClientId = @ClientID  
	and DATEDIFF(DAY, a.EffectiveDate, GETDATE()) between 0 and 366  
	and a.Status = 22  
	and a.DocumentCodeId=5  
	and isNull(a.RecordDeleted,''N'')<>''Y''  
	order by a.EffectiveDate desc,a.ModifiedDate desc )  
  
	--set @LatestDocumentVersionID = null  
	if @LatestDocumentVersionID is not null  
		begin  
			SELECT ''DiagnosesIAndII'' AS TableName,DIandII.DiagnosisId,DIandII.DocumentVersionId,DIandII.Axis  
			,DIandII.DSMCode,DIandII.DSMNumber,DIandII.DiagnosisType,DIandII.RuleOut,DIandII.Billable  
			,DIandII.Severity,DIandII.DSMVersion,DIandII.DiagnosisOrder,DIandII.Specifier,DIandII.[Source],DIandII.Remission,DIandII.RowIdentifier  
			,DIandII.CreatedBy,DIandII.CreatedDate,DIandII.ModifiedBy, DIandII.ModifiedDate,DIandII.RecordDeleted  
			,DIandII.DeletedDate,DIandII.DeletedBy,DSM.DSMDescription,case DIandII.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText  
			from DiagnosesIAndII as DIandII  
			inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = DIandII.DSMCode and DSM.DSMNumber=DIandII.DSMNumber  and dsm.Axis = DIandII.Axis  
			inner join Documents D on D.CurrentDocumentVersionId=DIandII.DocumentVersionId  
			where DIandII.DocumentVersionId=@LatestDocumentVersionID  
			and  IsNull(DIandII.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''  

	  
			----For DiagnosesIIISpecification  
			select a.TableName, a.DocumentVersionId,  
			DIII.Specification,DIII.CreatedBy,DIII.CreatedDate,DIII.ModifiedBy,DIII.ModifiedDate,DIII.RecordDeleted,DIII.DeletedDate,DIII.DeletedBy  
			from (SELECT ''DiagnosesIII'' AS TableName, @LatestDocumentVersionID as DocumentVersionId) as a  
			LEFT join DiagnosesIII as DIII on DIII.DocumentVersionId = a.DocumentVersionId and IsNull(DIII.RecordDeleted,''N'')=''N''  

			----For DiagnosesIV--  
			SELECT a.TableName, a.DocumentVersionId,  
			DIV.PrimarySupport,DIV.SocialEnvironment,DIV.Educational  
			,DIV.Occupational,DIV.Housing,DIV.Economic,DIV.HealthcareServices,DIV.Legal,DIV.Other,DIV.Specification,DIV.CreatedBy  
			,DIV.CreatedDate,DIV.ModifiedBy,DIV.ModifiedDate,DIV.RecordDeleted,DIV.DeletedDate,DIV.DeletedBy  
			from (SELECT ''DiagnosesIV'' AS TableName, @LatestDocumentVersionID as DocumentVersionId) as a  
			LEFT outer join DiagnosesIV as DIV on DIV.DocumentVersionId=a.DocumentVersionID and IsNull(DIV.RecordDeleted,''N'')=''N''  

			-----For DiagnosesV---  
			SELECT a.TableName, a.DocumentVersionId,  
			DV.AxisV,DV.CreatedBy,DV.CreatedDate,DV.ModifiedBy  
			,DV.ModifiedDate,DV.RecordDeleted,DV.DeletedDate,DV.DeletedBy  
			from (SELECT ''DiagnosesV'' AS TableName, @LatestDocumentVersionID as DocumentVersionId) as a  
			LEFT join DiagnosesV as DV on DV.DocumentVersionId = a.DocumentVersionId and IsNull(DV.RecordDeleted,''N'')=''N''  
	  
			----For DiagnosesIIICodes  
			SELECT ''DiagnosesIIICodes'' AS TableName,DIIICod.DiagnosesIIICodeId,DIIICod.DocumentVersionId,DIIICod.ICDCode,DIIICod.Billable  
			,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy,DICD.ICDDescription  
			from DiagnosesIIICodes as DIIICod  
			inner join DiagnosisICDCodes as DICD on DICD.ICDCode=DIIICod.ICDCode  
			inner join Documents D on D.CurrentDocumentVersionId=DIIICod.DocumentVersionId  
			where DIIICod.DocumentVersionId=@LatestDocumentVersionID  
			and IsNull(DIIICod.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''  

			SELECT  top 1 ''DiagnosesIANDIIMaxOrder'' as TableName,max(DiagnosisOrder) as DiagnosesMaxOrder  
			,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate  
			from  DiagnosesIAndII  
			where DocumentVersionId=@LatestDocumentVersionID  
			and  IsNull(RecordDeleted,''N'')=''N''  
			group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate  
			order by DiagnosesMaxOrder desc  
		end  
	else  
		begin  
  			SELECT TOP 1 Placeholder.TableName --''DiagnosesIII'' AS TableName  
				,DiagnosesIII.DocumentVersionId  
				,DiagnosesIII.Specification  
				,DiagnosesIII.CreatedBy,DiagnosesIII.CreatedDate  
				,DiagnosesIII.ModifiedBy,DiagnosesIII.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy  
			FROM (SELECT ''DiagnosesIII'' AS TableName, isnull(@LatestDocumentVersionID,-1) as DocumentVersionId) AS Placeholder --systemconfigurations s 
				left outer join DiagnosesIII ON DiagnosesIII.DocumentVersionId = Placeholder.DocumentVersionId --s.Databaseversion=-1  

			----For DiagnosesIV--  
			SELECT TOP 1 Placeholder.TableName --''DiagnosesIV'' AS TableName
				,DiagnosesIV.DocumentVersionId,PrimarySupport,SocialEnvironment,Educational  
				,Occupational
				,Housing,Economic,HealthcareServices
				,Legal,Other,Specification,DiagnosesIV.CreatedBy  
				,DiagnosesIV.CreatedDate,DiagnosesIV.ModifiedBy  
				,DiagnosesIV.ModifiedDate,DiagnosesIV.RecordDeleted,DeletedDate,DeletedBy  
			FROM (SELECT ''DiagnosesIV'' AS TableName, isnull(@LatestDocumentVersionID,-1) as DocumentVersionId) AS Placeholder--systemconfigurations s 
				left outer join DiagnosesIV ON DiagnosesIV.DocumentVersionId = Placeholder.DocumentVersionId -- on s.Databaseversion = -1  
			
			-----For DiagnosesV---  
			SELECT TOP 1 Placeholder.TableName --''DiagnosesV'' AS TableName
				,DiagnosesV.DocumentVersionId
				,AxisV  
				,DiagnosesV.CreatedBy
				,DiagnosesV.CreatedDate  
				,DiagnosesV.ModifiedBy  
				,DiagnosesV.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy  
			FROM (SELECT ''DiagnosesV'' AS TableName, isnull(@LatestDocumentVersionID,-1) as DocumentVersionId) AS Placeholder--systemconfigurations s 
				left outer join DiagnosesV ON DiagnosesV.DocumentVersionId = Placeholder.DocumentVersionId --   on s.Databaseversion=-1  
		end  

end try  
  
BEGIN CATCH  
DECLARE @Error varchar(8000)  
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())  
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDiagnosisStandardInitialization'')  
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())  
    + ''*****'' + Convert(varchar,ERROR_STATE())  
 RAISERROR  
 (  
  @Error, -- Message text.  
  16, -- Severity.  
  1 -- State.  
 );  
END CATCH  
END  ' 
END
GO
