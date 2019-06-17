/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricNoteChild]    Script Date: 11/27/2013 16:30:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricNoteChild]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricNoteChild]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricNoteChild]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


               
CREATE PROCEDURE  [dbo].[csp_RDLCustomPsychiatricNoteChild]  
(                                                                                                                                                                                      
  @DocumentVersionId int                                                                                                                                                      
)                                                   
As                                                                                                                                  
                                                                                                                                
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RDLCustomPsychiatricNoteChild]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  14 July,2015                                       */                                                                                                                                                                                                                                                                                                       
                                                                               
/*********************************************************************/                                                                                                                               
                                                                                                                              
BEGIN
	BEGIN TRY
		 SELECT  DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,ProblemsLabors
,ProblemsPregnancy
,PrenatalExposure
,CurrentHealthIssues
,ChildDevlopmental
,SexualityIssues
,CurrentImmunizations
,HealthFunctioningComment
,FunctioningLanguage
,FunctioningVisual
,FunctioningIntellectual
,FunctioningLearning
,AreasOfConcernComment
,FamilyMentalHealth
,FamilyCurrentHousingIssues
,FamilyParticipate
,ChildAbuse
,FamilyDynamicsComment
  FROM CustomDocumentPsychiatricNoteChildAdolescents CD   
  WHERE       
  CD.DocumentVersionId = @DocumentVersionId  
		
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomPsychiatricNoteChild') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


