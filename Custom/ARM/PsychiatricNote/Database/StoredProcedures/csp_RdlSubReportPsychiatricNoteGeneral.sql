

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPsychiatricNoteGeneral]    Script Date: 07/13/2015 18:19:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportPsychiatricNoteGeneral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportPsychiatricNoteGeneral] --1174
GO



/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPsychiatricNoteGeneral]    Script Date: 07/13/2015 18:19:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RdlSubReportPsychiatricNoteGeneral] @DocumentVersionId INT  
AS  
/*********************************************************************/  
/* Stored Procedure: [csp_RdlSubReportPsychiatricNoteGeneral] 734093   */  
/*       Date              Author                  Purpose                   */  
/*      13-07-2014         Lakshmi Kanth           To Retrieve Data  for RDL   */ 
/*      06 June  2017  Pabitra                 What: Modefied the Csp to show Previous Records 
                 								Why :Texas-Customizations #58 */	
 /*      06/07/2017          Pabitra             TxAce Customizations #22 */
  /*     07/25/2017          Pabitra             TxAce Customizations #107*/		                 						
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
   
 DECLARE @OrganizationName VARCHAR(250)  
 DECLARE @Allergies varchar(max)
 DECLARE @ClientId INT  


SELECT TOP 1 @OrganizationName = OrganizationName FROM SystemConfigurations  

DECLARE @Output VARCHAR(max)
SET @ClientId= (Select ClientId from Documents where CurrentDocumentVersionId=@DocumentVersionId)

CREATE TABLE #tmpTable
(
    OutputValue VARCHAR(max)
)

INSERT INTO #tmpTable (OutputValue)
EXEC csp_SCGetAllergies @ClientId 

SELECT
    @Allergies = OutputValue
FROM 
    #tmpTable

DROP TABLE #tmpTable
   
 SELECT  DocumentVersionId
,AdultChildAdolescent
,PersonPresent
,ChiefComplaint
,SideEffects
,SideEffectsComments
,PlanLastVisit
,PsychiatricHistory
,PsychiatricHistoryComments
,FamilyHistory
,FamilyHistoryComments
,SocialHistory
,SocialHistoryComments
,ReviewPsychiatric
,ReviewMusculoskeletal
,ReviewConstitutional
,ReviewEarNoseMouthThroat
,ReviewGenitourinary
,ReviewGastrointestinal
,ReviewIntegumentary
,ReviewEndocrine
,ReviewNeurological
,ReviewImmune
,ReviewEyes
,ReviewRespiratory
,ReviewCardio
,ReviewHemLymph
,ReviewOthersNegative
,ReviewComments
,SubstanceUse
,Pregnant
,LastMenstrualPeriod
,PresentingProblem
,@Allergies AS AllergiesText
,AllergiesSmoke
,AllergiesSmokePerday
,AllergiesTobacouse
,AllergiesCaffeineConsumption
,MedicalHistory
,MedicalHistoryComments  
,SUAlcohol
,SUAmphetamines
,SUBenzos
,SUCocaine
,SUMarijuana
,SUOpiates
,SUOthers
,SUHallucinogen
,SUInhalant 
,SUAlcoholDiagnosis
,SUAmphetaminesDiagnosis
,SUBenzosDiagnosis
,SUCocaineDiagnosis
,SUMarijuanaDiagnosis
,SUOpiatesDiagnosis
,SUOthersDiagnosis
,SUHallucinogenDiagnosis
,SUInhalantDiagnosis 
  FROM CustomDocumentPsychiatricNoteGenerals CD     
  WHERE         
  CD.DocumentVersionId = @DocumentVersionId    
    
   
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RdlSubReportPsychiatricNoteGeneral') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
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


