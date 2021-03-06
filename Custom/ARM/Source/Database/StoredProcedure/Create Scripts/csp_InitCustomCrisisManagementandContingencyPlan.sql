/****** Object:  StoredProcedure [dbo].[csp_InitCustomCrisisManagementandContingencyPlan]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrisisManagementandContingencyPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomCrisisManagementandContingencyPlan] --2,550,N''
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrisisManagementandContingencyPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomCrisisManagementandContingencyPlan]        
(                            
 @ClientID int,      
 @StaffID int,    
 @CustomParameters xml                            
)                                                    
As                                                      
                                                             
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_InitCustomCrisisManagementandContingencyPlan]   */                                                     
                                                              
 /*       Date              Author                  Purpose                   */                                                                
 /*       28/Feb/2013      Bernardin               To Retrieve Data           */      
 /*********************************************************************/        
Declare @MostRecentCarePlanVersionId int
Declare @MostRecentDiagnosisVersionId int
Declare @MostRecentDiagnosisAssessmentVersionId int
Declare @DIAGNOSISDIAGNOSED int
Declare @MentalHealthDiagnoses varchar(max)
Declare @CurrentDDDiagnoses varchar(max)
Declare @PrimarPhysicianName varchar(250)
Declare @PrimarPhysicianPhone varchar(50)
Declare @PharmacyName varchar(250)
Declare @PharmacyPhone varchar(50) 
Declare @SocialNeeds varchar(max)
Declare @VersionDIAG as bigint
Declare @DocumentIDDIAG as bigint   
                                                                           
Begin                                              
    
Begin try
select  @DIAGNOSISDIAGNOSED = GlobalCodeId from  dbo.GlobalCodes
where   Category = ''XDIAGNOSISSOURCE'' and CodeName = ''Diagnosed'' and ISNULL(RecordDeleted, ''N'') <> ''Y''
-- Get most recent Diagnosis document version id
select top 1 @MostRecentDiagnosisVersionId = d.CurrentDocumentVersionId from  dbo.Documents as d
where   d.ClientId = @ClientID and d.DocumentCodeId = 5 and d.Status = 22 and ISNULL(d.RecordDeleted, ''N'') <> ''Y'' order by d.EffectiveDate desc,d.DocumentId desc
-- Get most recent Diagnoses Assessment document version id
select top 1 @MostRecentDiagnosisAssessmentVersionId = d.CurrentDocumentVersionId from  dbo.Documents as d
where   d.ClientId = @ClientID and d.DocumentCodeId = 1486 and d.Status = 22 and ISNULL(d.RecordDeleted, ''N'') <> ''Y'' order by d.EffectiveDate desc,d.DocumentId desc
-- Get CurrentMentalHealthDiagnoses values

Declare @EffectiveDate Varchar(25)
SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103) 
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument=''Y'' and isNull(a.RecordDeleted,''N'')<>''Y'' and isNull(Dc.RecordDeleted,''N'')<>''Y''                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc 
set @MentalHealthDiagnoses=''Effective Date:''+ @EffectiveDate

-- select @MentalHealthDiagnoses = @MentalHealthDiagnoses + ISNULL(cast(b.CodeName AS varchar),char(9)) + char(9)+ ISNULL(cast(a.ICD9Code as varchar),char(9)) +char(9) + ISNULL(cast(a.ICD10Code as varchar),char(9))+ char(9)+ case ISNULL(cast(ICD10.DSMVCode AS varchar),char(9)) when ''Y'' then ''Yes'' else ''No'' end + char(9) + ISNULL(cast(ICD10.ICDDescription as varchar),'''') + char(13)       
--from DocumentDiagnosisCodes a                              
-- INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
-- INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.ICD10CodeId          
--where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes  where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,''N'')<>''Y'')                           
-- and isNull(a.RecordDeleted,''N'')<>''Y''  and billable =''Y'' order by DiagnosisOrder   


--select @MentalHealthDiagnoses =   @MentalHealthDiagnoses + CAST(dx.DSMCode AS VARCHAR(12)) + case when CAST(dx.Axis AS VARCHAR(12)) =''1'' then '' - Axis I - '' else '' - Axis II - '' end + dsm.DSMDescription + '' - Diagnosed, Per Client Report, Per Records History'' +  CHAR(13)
--        from DiagnosesIandII as dx join diagnosisdsmDescriptions as dsm on dsm.DSMCode = dx.DsmCode and dsm.DSMNumber = dx.DSMNumber
--            where DocumentVersionId = @MostRecentDiagnosisVersionId and dx.DSMCode not like ''317%'' and dx.DSMCode not like ''318%'' and dx.DSMCode not like ''319%'' order by dx.Axis

-- Get CurrentDDDiagnoses values
Set @CurrentDDDiagnoses = '''';
select @CurrentDDDiagnoses = @CurrentDDDiagnoses + CAST(dx.DSMCode AS VARCHAR(12)) + case when CAST(dx.Axis AS VARCHAR(12)) =''1'' then '' - Axis I - '' else '' - Axis II - '' end + dsm.DSMDescription + '' - Diagnosed, Per Client Report, Per Records History'' + + CHAR(13) 
from DiagnosesIandII as dx join diagnosisdsmDescriptions as dsm on dsm.DSMCode = dx.DsmCode and dsm.DSMNumber = dx.DSMNumber
where DocumentVersionId = @MostRecentDiagnosisVersionId and (dx.DSMCode like ''317%'' or dx.DSMCode  like ''318%'' or dx.DSMCode  like ''319%'')
-- Get Primary care physician Name and phone
SELECT    @PrimarPhysicianName = Staff.LastName+'', ''+Staff.FirstName, 
          @PrimarPhysicianPhone = Staff.PhoneNumber
FROM         Clients INNER JOIN ClientContacts ON Clients.ClientId = ClientContacts.ClientId INNER JOIN Staff ON Clients.PrimaryClinicianId = Staff.StaffId
WHERE ClientContacts.Relationship = 1009494
--Get Pharmacy Name and phone
Select @PharmacyName= PharmacyName,@PharmacyPhone = PhoneNumber from Pharmacies Where PharmacyId = (Select top(1) PharmacyId from ClientPharmacies Where ClientId = @ClientID Order By SequenceNumber)
-- Get details about Social needs
SET @SocialNeeds = '''';
SELECT @SocialNeeds = @SocialNeeds + GlobalCodes.CodeName +'': ''+ CustomDocumentHealthHomeCarePlanPESNeeds.PsychosocialSupportNeedPlan + CHAR(13) 
FROM         CustomDocumentHealthHomeCarePlanPESNeeds INNER JOIN
                      GlobalCodes ON CustomDocumentHealthHomeCarePlanPESNeeds.PsychosocialSupportNeedType = GlobalCodes.GlobalCodeId
WHERE CustomDocumentHealthHomeCarePlanPESNeeds.DocumentVersionId = (select top 1 d.CurrentDocumentVersionId from  dbo.Documents as d
where   d.ClientId = @ClientID and d.DocumentCodeId = 1000267 and d.Status = 22 and ISNULL(d.RecordDeleted, ''N'') <> ''Y'' order by d.EffectiveDate desc,d.DocumentId desc)

-- CustomDocumentHealthHomeTransitionPlans                      
Select TOP 1 ''CustomDocumentHealthHomeCrisisPlans'' AS TableName, -1 as ''DocumentVersionId'', 
'''' as CreatedBy,                  
getdate() as CreatedDate,                  
'''' as ModifiedBy,                  
getdate() as ModifiedDate,
@MentalHealthDiagnoses as CurrentMentalHealthDiagnoses,
@CurrentDDDiagnoses as CurrentDDDiagnoses,
@PrimarPhysicianName as PrimaryCarePhysician,
@PrimarPhysicianPhone as PrimaryCarePhysicianPhone,
@PharmacyName as PharmacyName,
@PharmacyPhone as PharmacyPhone,
@SocialNeeds as DescriptionImmediateNeed
from systemconfigurations s left outer join CustomDocumentHealthHomeCrisisPlans                                                                      
on s.Databaseversion = -1

-- CustomDocumentHealthHomeCarePlanDiagnoses
select  PlaceHolder.TableName,
		(CAST(ROW_NUMBER() over (order by icd.ICDDescription) as int) * -1) as CustomDocumentHealthHomeCarePlanDiagnosisId,
		dx3.CreatedBy,
		dx3.CreatedDate,
		dx3.ModifiedBy,
		dx3.ModifiedDate,
		dx3.RecordDeleted,
		dx3.DeletedBy,
		dx3.DeletedDate,
		CAST(-1 as int) as DocumentVersionId,
		(CAST(ROW_NUMBER() over (order by icd.ICDDescription) as int)) as SequenceNumber,
		LEFT(icd.ICDDescription, 200) as ReportedDiagnosis,
		@DIAGNOSISDIAGNOSED as DiagnosisSource,
		''Harbor'' as TreatmentProvider
from    (
		 select ''CustomDocumentHealthHomeCarePlanDiagnoses'' as TableName,
				@MostRecentCarePlanVersionId as DocumentVersionId
		) as PlaceHolder 
cross join dbo.DiagnosesIIICodes as dx3
join    dbo.DiagnosisICDCodes as icd on icd.ICDCode = dx3.ICDCode
where   dx3.DocumentVersionId = @MostRecentDiagnosisVersionId
		and ISNULL(dx3.RecordDeleted, ''N'') <> ''Y''



 select ''CurrentDiagnoses'' as TableName
 ,(CAST(ROW_NUMBER() over (order by ICD10.ICDDescription) as int) * -1) as CurrentDiagnosesId
 ,CodeName , a.ICD9Code,a.ICD10Code
 ,case ISNULL(ICD10.DSMVCode,'''') when ''Y'' then ''Yes'' else ''No'' end as DSMVCode
 
 ,ICD10.ICDDescription 
 ,a.CreatedBy,
		a.CreatedDate,
		a.ModifiedBy,
		a.ModifiedDate,
		a.RecordDeleted,
		a.DeletedBy,
		a.DeletedDate      
from DocumentDiagnosisCodes a                              
 INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
 INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.ICD10CodeId          
where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes 
 where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,''N'')<>''Y'')                      
     
 and isNull(a.RecordDeleted,''N'')<>''Y''  and billable =''Y'' order by DiagnosisOrder
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomCrisisManagementandContingencyPlan'')                                                                             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                              
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
 RAISERROR                                                                             
 (                                               
  @Error, -- Message text.                                                                            
  16, -- Severity.                                                                            
  1 -- State.                                                                            
 );                                                                          
END CATCH                         
END' 
END
GO
