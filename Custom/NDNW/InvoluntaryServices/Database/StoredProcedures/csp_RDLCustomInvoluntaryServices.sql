IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_RDLCustomInvoluntaryServices]' 
                  ) 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_RDLCustomInvoluntaryServices] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[csp_RDLCustomInvoluntaryServices] ( 
@DocumentVersionId INT) 
AS 
/*************************************************************************************/ 
/* Stored Procedure: [csp_RDLCustomInvoluntaryServices]                      */ 
/* Creation Date:  06 May 2015                                                         */ 
/* Purpose: Gets Data from CustomDocumentGambling                 */ 
/* Input Parameters: @DocumentVersionId                                         */ 
/* Purpose: Use For Rdl Report                                                 */ 
/* Author:  Malathi Shiva                                                                 */ 
  /*************************************************************************************/ 
  BEGIN 
      BEGIN TRY 
          DECLARE @ClientId INT 
          DECLARE @ClientName VARCHAR(250) 
          DECLARE @ClinicianName VARCHAR(250) 
          DECLARE @OrganizationName VARCHAR(250) 
          DECLARE @DocumentName VARCHAR(250) 
          DECLARE @EffectiveDate DATETIME 

          SELECT @ClientId = D.ClientId 
                 ,@ClientName = C.LastName + ', ' + C.FirstName 
                 ,@ClinicianName = S.LastName + ', ' + S.FirstName 
                 ,@EffectiveDate = D.EffectiveDate 
                 ,@OrganizationName = SC.OrganizationName 
                 ,@DocumentName = DC.DocumentName 
          FROM   Documents D 
                 JOIN Clients C WITH (NOLOCK) 
                   ON C.ClientId = D.ClientId 
                 LEFT JOIN Staff S WITH (NOLOCK) 
                        ON S.StaffId = D.AuthorId 
                 CROSS JOIN SystemConfigurations SC WITH (NOLOCK) 
                 LEFT JOIN DocumentCodes DC WITH (NOLOCK) 
                        ON DC.DocumentCodeId = D.DocumentCodeId 
          WHERE  InProgressDocumentVersionId = @DocumentVersionId 

          SELECT @OrganizationName                                            AS 
                 OrganizationName 
                 ,@DocumentName                                               AS 
                  DocumentName 
                 ,@ClientId                                                   AS 
                  ClientId 
                 ,@ClientName                                                 AS 
                  ClientName 
                 ,@ClinicianName                                              AS 
                  ClinicianName 
                 ,@EffectiveDate                                              AS 
                  EffectiveDate 
                 ,SIDNumber 
                 ,DBO.csf_GetGlobalCodeNameById(ServiceStatus)                AS 
                  ServiceStatus 
                 ,DBO.csf_GetGlobalCodeNameById(TypeOfPetition)               AS 
                  TypeOfPetition 
                 ,CONVERT(VARCHAR(10), DateOfPetition, 101)                   AS 
                  DateOfPetition 
                 ,DBO.csf_GetGlobalCodeNameById(HearingRecommended)           AS 
                  HearingRecommended 
                  ,DBO.csf_GetGlobalCodeNameById(ReasonForHearing)          AS 
                  ReasonForHearing 
                 ,DBO.csf_GetGlobalCodeNameById(BasisForInvoluntaryServices)  AS 
                  BasisForInvoluntaryServices 
                 ,DBO.csf_GetGlobalCodeNameById(DispositionByJudge)           AS 
                  DispositionByJudge 
                 ,DBO.csf_GetGlobalCodeNameById(InvoluntaryServicesCommitted) AS 
                  InvoluntaryServicesCommitted 
                 ,DBO.csf_GetGlobalCodeNameById(ServiceSettingAssignedTo)     AS 
                  ServiceSettingAssignedTo 
                 ,CONVERT(VARCHAR(10), DateOfCommitment, 101)                 AS 
                  DateOfCommitment 
                 ,CONVERT(VARCHAR(10), LengthOfCommitment, 101)               AS 
                  LengthOfCommitment 
                 ,CONVERT(VARCHAR(10), PeriodOfIntensiveTreatment, 101)       AS 
                  PeriodOfIntensiveTreatment 
          FROM   CustomDocumentInvoluntaryServices 
          WHERE  DocumentVersionId = @DocumentVersionId 
                 AND isnull(RecordDeleted, 'N') = 'N' 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                       + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                       + '*****' 
                       + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                       'csp_RDLCustomInvoluntaryServices') 
                       + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,-- Message text.     
                      16,-- Severity.     
                      1 -- State.     
          ); 
      END CATCH 
  END 