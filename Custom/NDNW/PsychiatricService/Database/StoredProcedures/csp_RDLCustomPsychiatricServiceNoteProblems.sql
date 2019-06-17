/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricServiceNoteProblems]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceNoteProblems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteProblems]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricServiceNoteProblems]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteProblems] 
(@DocumentVersionId INT=0)
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
02-Jan-2015    Revathi      What:Get  Psychiatric Service Note Problems list
                             Why:task #823 Woods-Customizations
************************************************/
  AS 
 BEGIN
				
	BEGIN TRY
	   	SELECT 
	   	Row_Number()OVER(Order by CP.PsychiatricServiceNoteProblemId )as Row,
		CP.ProblemText, 
		GC.CodeName as Severity,
		CP.Duration as Duration,
		GC2.CodeName as Intensity,
		CP.IntensityText,
		ISNULL(CP.TimeOfDayMorning,'N') as  TimeOfDayMorning,
		ISNULL(CP.TimeOfDayNoon,'N') as TimeOfDayNoon,
		ISNULL(CP.TimeOfDayAfternoon,'N') as TimeOfDayAfternoon,
		ISNULL(CP.TimeOfDayEvening,'N') as TimeOfDayEvening,
		ISNULL(CP.TimeOfDayNight,'N') as TimeOfDayNight,
		ISNULL(CP.ContextHome,'N') as ContextHome,
		ISNULL(CP.ContextSchool,'N') as ContextSchool,
		ISNULL(CP.ContextWork,'N') as ContextWork,
		ISNULL(CP.ContextCommunity,'N') as ContextCommunity,
		ISNULL(CP.ContextOther,'N') as ContextOther,
		CP.ContextOtherText,
		GC3.CodeName as AssociatedSignsSymptoms,
		CP.AssociatedSignsSymptomsOtherText,
		CP.ModifyingFactors,
		GC4.CodeName as ProblemStatus
	   	FROM CustomPsychiatricServiceNoteProblems CP
	   	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=CP.Severity
	   	LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId=CP.Intensity
	   	LEFT JOIN GlobalCodes GC3 ON GC3.GlobalCodeId=CP.AssociatedSignsSymptoms
	   	LEFT JOIN GlobalCodes GC4 ON GC4.GlobalCodeId=CP.ProblemStatus
	   	WHERE  CP.DocumentVersionId=@DocumentVersionId
	   	AND ISNULL(CP.RecordDeleted,'N')='N'
	   	End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricServiceNoteProblems')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END
	   	
GO


