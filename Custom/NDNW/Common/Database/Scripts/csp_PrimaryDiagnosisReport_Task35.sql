If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.csp_PrimaryDiagnosisReport') 
                  And Type In ( N'P', N'PC' )) 
	Drop Procedure dbo.csp_PrimaryDiagnosisReport
Go

Set Ansi_Nulls On
Set Quoted_Identifier On
Go

--/*********************************************************************************             
--**  File: csp_PrimaryDiagnosisReport.sql 
--**  Name: csp_PrimaryDiagnosisReport 
--**  Desc: This report is to track data regarding primary diagnosis.
--**                   
--**  Created By:  Paul Ongwela 
--**  Date:		 July 29, 2015 
--**
--...............................................................................                  
--..  Change History                   
--...............................................................................                  
--..  Date:		Author:				Description:                   
--..  --------	--------			-------------------------------------------    
--..  7/29/2015  Paul Ongwela        Created.
--..
--..
--**********************************************************************************/

Create Procedure dbo.csp_PrimaryDiagnosisReport
	 @ProgramId Int
	,@ServiceArea Int
	,@Gender VarChar(1)
	,@Ethnicity Int
	,@StartAge Int
	,@EndAge Int
	,@StartDate DateTime
	,@EndDate DateTime
	
As

Begin

---- Set NoCount On added to prevent extra result sets from interfering with
---- statements such as SELECT, INSERT, UPDATE, and DELETE... 
--Set NoCount On;

Select dbo.GetAge(c.DOB,GetDate()) As Age
	  ,c.Sex
	  ,dbo.GetGlobalCodeName(cr.RaceId) As Ethnicity
	  ,sa.ServiceAreaName As ServiceArea
	  ,RTrim(LTrim(co.CountyName)) As CountyName
	  ,PrimaryDiagnosis = ddc1.ICD10Code
	  ,SecondaryDiagnosis = ddc2.ICD10Code
	  ,TertiaryDiagnosis = ddc3.ICD10Code

From Documents d
	Join DocumentVersions dv On d.CurrentDocumentVersionId = dv.DocumentVersionId
		And IsNull(dv.RecordDeleted,'N')='N'
	Left Join DocumentDiagnosisCodes ddc1 On dv.DocumentVersionId = ddc1.DocumentVersionId
		And IsNull(ddc1.RecordDeleted,'N')='N'
		And ddc1.DiagnosisOrder = 1
	Left Join DocumentDiagnosisCodes ddc2 On dv.DocumentVersionId = ddc2.DocumentVersionId
		And IsNull(ddc2.RecordDeleted,'N')='N'
		And ddc2.DiagnosisOrder = 2
	Left Join DocumentDiagnosisCodes ddc3 On dv.DocumentVersionId = ddc3.DocumentVersionId
		And IsNull(ddc3.RecordDeleted,'N')='N'
		And ddc3.DiagnosisOrder = 3
	Join Clients c On c.ClientId = d.ClientId
		And IsNull(c.RecordDeleted,'N')='N'
	Join ClientRaces cr On c.ClientId = cr.ClientId
		And IsNull(cr.RecordDeleted,'N')='N'
	Join ClientPrograms cp On c.ClientId = cp.clientId
		And IsNull(cp.RecordDeleted,'N')='N'
		And cp.PrimaryAssignment = 'Y'
	Join Programs p On cp.ProgramId = p.ProgramId
		And IsNull(p.RecordDeleted,'N')='N'
	Join ServiceAreas sa On p.ServiceAreaId = sa.ServiceAreaId
		And IsNull(sa.RecordDeleted,'N')='N'
	Join Counties co On c.CountyOfResidence = co.CountyFIPS
	
Where IsNull(d.RecordDeleted,'N') = 'N'
	And d.DocumentCodeId = 1601
	And d.Status = 22
	And d.EffectiveDate >= @StartDate 
		And d.EffectiveDate <= @EndDate
	And (@StartAge Is Null 
			Or dbo.GetAge(c.DOB,GetDate()) Between @StartAge And @EndAge)
	And (@ProgramId Is Null 
		Or @ProgramId = p.ProgramId)
	And (@ServiceArea Is Null 
		Or @ServiceArea = sa.ServiceAreaId)
	And (@Gender Is Null 
		Or @Gender = c.Sex)
	And (@Ethnicity Is Null 
		Or @Ethnicity = cr.RaceId)

End

Go
