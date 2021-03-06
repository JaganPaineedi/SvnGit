
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMedicaidHealthHomeServicesNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomMedicaidHealthHomeServicesNote]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO    
Create PROCEDURE  [dbo].[csp_InitCustomMedicaidHealthHomeServicesNote]   
(                            
 @ClientID int,      
 @StaffID int,    
 @CustomParameters xml                            
)                                                    
As                                                      
                                                             
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_InitCustomMedicaidHealthHomeServicesNote]   */                                                     
                                                              
 /*       Date              Author                  Purpose                   */                                                                
 /*       26/Mar/2013      Bernardin               To Retrieve Data           */      
 /*********************************************************************/        
 Declare @MostRecentCarePlanVersionId int
  Declare @MostRecentDiagnosisVersionId int
  Declare @DIAGNOSISDIAGNOSED int
  Declare @MostRecenTransitionPlanVersionId int
  Declare @NextScheduledHHServiceDate datetime
  Declare @Height varchar(50)
  Declare @Weight varchar(50)
  Declare @BMI varchar(50)
  Declare @BloodPressureSystolic varchar(50)
  Declare @BloodPressureDiastolic varchar(50)
  Declare @VersionASS as bigint                                            
  Declare @DocumentIDDIAG as bigint                                                                                              
 Declare @VersionDIAG as bigint   
                                                                           
Begin                                              
    
Begin try

select  @DIAGNOSISDIAGNOSED = GlobalCodeId from  dbo.GlobalCodes
where   Category = 'XDIAGNOSISSOURCE' and CodeName = 'Diagnosed' and ISNULL(RecordDeleted, 'N') <> 'Y'
-- Get most recent Diagnosis document version id
select top 1 @MostRecentDiagnosisVersionId = d.CurrentDocumentVersionId from  dbo.Documents as d
where   d.ClientId = @ClientID and d.DocumentCodeId = 5 and d.Status = 22 and ISNULL(d.RecordDeleted, 'N') <> 'Y' order by d.EffectiveDate desc,d.DocumentId desc
-- Get most recent Diagnosis document version id
select top 1 @MostRecenTransitionPlanVersionId = d.CurrentDocumentVersionId from  dbo.Documents as d
where   d.ClientId = @ClientID and d.DocumentCodeId = 1000268 and d.Status = 22 and ISNULL(d.RecordDeleted, 'N') <> 'Y' order by d.EffectiveDate desc,d.DocumentId desc

Select @NextScheduledHHServiceDate = NextScheduledHHServiceDate from CustomDocumentHealthHomeTransitionPlans Where DocumentVersionId = @MostRecenTransitionPlanVersionId

-- Get Height Weight BMI
SELECT @Height = convert(decimal(18,2), hd.ItemValue1),@Weight = convert(decimal(18,2), hd.ItemValue2),@BMI = convert(decimal(18,4), hd.ItemValue3)
FROM         HealthData AS hd INNER JOIN HealthDataCategories AS HDC ON hd.HealthDataCategoryId = HDC.HealthDataCategoryId 
                      WHERE hd.ClientId = @ClientID and HDC.CategoryName = 'Height Weight BMI'
-- Get Blood Pressure values
SELECT @BloodPressureSystolic = convert(varchar(50), convert(decimal(18,0), hd.ItemValue1)),@BloodPressureDiastolic = convert(varchar(50), convert(decimal(18,0), hd.ItemValue2)) 
FROM         HealthData AS hd INNER JOIN
                      HealthDataCategories AS HDC ON hd.HealthDataCategoryId = HDC.HealthDataCategoryId 
                      WHERE hd.ClientId = @ClientID and HDC.CategoryName = 'Blood Pressure'
                      
                      Declare @EffectiveDate Varchar(25)
SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103) 
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument='Y' and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y'                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc                              
 
 --to fetch the values of DiagnosisI-II  ref #3611                        
declare @CurrentMentalHealthDiagnoses varchar(max)
  
set @CurrentMentalHealthDiagnoses ='Effective Date:'+ @EffectiveDate

--+ CHAR(13) +'Type'+ char(9) + 'ICD 9'  + char(9) + 'ICD 10' + char(9)+ 'DSM5' + char(9) + 'Description' + CHAR(13)        
 
-- select @CurrentMentalHealthDiagnoses = @CurrentMentalHealthDiagnoses + ISNULL(cast(b.CodeName AS varchar),char(9)) + char(9)+ ISNULL(cast(a.ICD9Code as varchar),char(9)) +char(9) + ISNULL(cast(a.ICD10Code as varchar),char(9))+ char(9)+ case ISNULL(cast(ICD10.DSMVCode AS varchar),char(9)) when 'Y' then 'Yes' else 'No' end + char(9) + ISNULL(cast(ICD10.ICDDescription as varchar),'') + char(13)       
--from DocumentDiagnosisCodes a                              
-- INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
-- INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.DSMVCodeId          
--where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes  where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,'N')<>'Y')                           
-- and isNull(a.RecordDeleted,'N')<>'Y'  and billable ='Y' order by DiagnosisOrder    

-- CustomDocumentHealthHomeServiceNotes                      
Select TOP 1 'CustomDocumentHealthHomeServiceNotes' AS TableName, -1 as 'DocumentVersionId', 
'' as CreatedBy,                  
getdate() as CreatedDate,                  
'' as ModifiedBy,                  
getdate() as ModifiedDate,
@NextScheduledHHServiceDate as LastVisitDate,
@Height as HDHt,
@Weight as HDWt,
@BMI as HDBMI,
@BloodPressureSystolic as HDBPSystolic,
@BloodPressureDiastolic as HDBPDiastolic,
@CurrentMentalHealthDiagnoses as CurrentMentalHealthDiagnoses
from systemconfigurations s left outer join CustomDocumentHealthHomeServiceNotes                                                                      
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
		'Harbor' as TreatmentProvider
from    (
		 select 'CustomDocumentHealthHomeCarePlanDiagnoses' as TableName,
				@MostRecentCarePlanVersionId as DocumentVersionId
		) as PlaceHolder 
cross join dbo.DiagnosesIIICodes as dx3
join    dbo.DiagnosisICDCodes as icd on icd.ICDCode = dx3.ICDCode
where   dx3.DocumentVersionId = @MostRecentDiagnosisVersionId
		and ISNULL(dx3.RecordDeleted, 'N') <> 'Y'
		
		
-- select 'CurrentDiagnoses' as TableName
-- ,(CAST(ROW_NUMBER() over (order by ICD10.ICDDescription) as int) * -1) as CurrentDiagnosesId
-- ,CodeName , a.ICD9Code,a.ICD10Code
-- ,case ISNULL(ICD10.DSMVCode,'') when 'Y' then 'Yes' else 'No' end as DSMVCode
 
-- ,ICD10.ICDDescription 
-- ,a.CreatedBy,
--		a.CreatedDate,
--		a.ModifiedBy,
--		a.ModifiedDate,
--		a.RecordDeleted,
--		a.DeletedBy,
--		a.DeletedDate      
--from DocumentDiagnosisCodes a                              
-- INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
-- INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.DSMVCodeId          
--where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes 
-- where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,'N')<>'Y')                      
     
 --and isNull(a.RecordDeleted,'N')<>'Y'  and billable ='Y' order by DiagnosisOrder

end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_InitCustomMedicaidHealthHomeServicesNote')                                                                             
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