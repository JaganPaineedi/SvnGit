

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPsychiatricNoteProblems]    Script Date: 07/14/2015 14:41:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportPsychiatricNoteProblems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportPsychiatricNoteProblems]
GO


/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPsychiatricNoteProblems]    Script Date: 07/14/2015 14:41:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_RdlSubReportPsychiatricNoteProblems] @DocumentVersionId INT  
AS  
/*********************************************************************/  
/* Stored Procedure: [csp_RdlSubReportPsychiatricNoteProblems]   */  
/*       Date              Author                  Purpose                   */  
/*      07-14-2014       Vijay Yadav               To Retrieve Data  for RDL   */  
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
    SELECT   
     Row_Number()OVER(Order by CP.PsychiatricNoteProblemId )as Row,  
  CP.SubjectiveText,  
  dbo.csf_GetGlobalCodeNameById(cp.TypeOfProblem) as TypeOfProblem ,   
  GC.CodeName as Severity,  
  GC8.CodeName as Duration, 
  ISNULL(CP.TimeOfDayAllday,'N') as  TimeOfDayAllday,  
  ISNULL(CP.TimeOfDayMorning,'N') as  TimeOfDayMorning,  
  ISNULL(CP.TimeOfDayAfternoon,'N') as TimeOfDayAfternoon,  
  ISNULL(CP.TimeOfDayNight,'N') as TimeOfDayNight,  
  ISNULL(CP.LocationHome,'N') as ContextHome,  
  ISNULL(CP.LocationSchool,'N') as ContextSchool,  
  ISNULL(CP.LocationWork,'N') as ContextWork,  
  ISNULL(CP.LocationEverywhere,'N') as LocationEverywhere,  
  ISNULL(CP.LocationOther,'N') as ContextOther,  
  CP.LocationOtherText as ContextOtherText,  
  CP.ContextText,   
  GC3.CodeName as AssociatedSignsSymptoms,  
  CP.AssociatedSignsSymptomsOtherText,  
  CP.ModifyingFactors,  
  GC4.CodeName as ProblemStatus,  
  Case when (ISNULL(ICD10Code,'') <> '' and  ICD10Code in(SELECT   
  r.CharacterCodeId   
 FROM Recodes r   
 JOIN RecodeCategories rc  ON r.RecodeCategoryId = rc.RecodeCategoryId   
 WHERE rc.CategoryCode IN ('XICD10RECODES'))) then 'Yes' else 'No' end as DiscussLongActingInjectableShow,  
  DiscussLongActingInjectable,  
  ProblemMDMComments  
     FROM 	CustomPsychiatricNoteProblems CP  
     LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=CP.Severity  
     
     LEFT JOIN GlobalCodes GC3 ON GC3.GlobalCodeId=CP.AssociatedSignsSymptoms  
     LEFT JOIN GlobalCodes GC4 ON GC4.GlobalCodeId=CP.ProblemStatus  
     LEFT JOIN GlobalCodes GC8 ON GC8.GlobalCodeId=CP.Duration   
     WHERE  CP.DocumentVersionId=@DocumentVersionId  
     AND ISNULL(CP.RecordDeleted,'N')='N'  
    
   
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RdlSubReportPsychiatricNoteProblems') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END  
  
GO


