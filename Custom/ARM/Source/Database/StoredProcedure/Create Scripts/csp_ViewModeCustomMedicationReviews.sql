/****** Object:  StoredProcedure [dbo].[csp_ViewModeCustomMedicationReviews]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeCustomMedicationReviews]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ViewModeCustomMedicationReviews]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeCustomMedicationReviews]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ViewModeCustomMedicationReviews]  
@DocumentVersionId INT
--@DocumentId int,   
--@Version int  
 AS   
/*  
** Object Name:  [csp_ViewModeCustomMedicationReview]  
**  
**  
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set   
**    which matches those parameters.   
**  
** Programmers Log:  
** Date  Programmer  Description  
**------------------------------------------------------------------------------------------  
** Oct 08 2007 Ranjeetb    
** 09/14/2010	dharvey		Modified to accept @DocumentVersionId parameter
*/  
  
  
SELECT [ClientId],d.[DocumentID]
      ,[Subjective]
      ,[Objective]
      ,[Assessment]
      ,[PlanDetail]
      ,[Aims]
      ,[SideEffects]
      ,[Changes]
      ,[Efficacy]
      ,[MedicationConsentGiven]
      ,[UnderstoodEducation]
      ,[GivenToCareProvide]
      ,[NextSession]
      
  FROM Documents d
left join CustomMedicationReviews mr on mr.DocumentVersionId=d.CurrentDocumentVersionId and isnull(mr.RecordDeleted, ''N'')= ''N''
where d.CurrentDocumentVersionId=@DocumentVersionId 
and isnull(d.RecordDeleted, ''N'')= ''N''

--
--Previous DocumentId/Version based syntax
/*
SELECT [ClientId],d.[DocumentID]
      ,[Version]
      ,[Subjective]
      ,[Objective]
      ,[Assessment]
      ,[PlanDetail]
      ,[Aims]
      ,[SideEffects]
      ,[Changes]
      ,[Efficacy]
      ,[MedicationConsentGiven]
      ,[UnderstoodEducation]
      ,[GivenToCareProvide]
      ,[NextSession]
      
  FROM Documents d
left join CustomMedicationReviews mr on mr.documentid = d.documentid and mr.version = @version and isnull(mr.RecordDeleted, ''N'')= ''N''
where d.[DocumentID]=@DocumentId 
and isnull(d.recorddeleted, ''N'')= ''N''
*/
' 
END
GO
