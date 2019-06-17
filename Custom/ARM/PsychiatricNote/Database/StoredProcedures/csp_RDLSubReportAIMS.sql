IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportAIMS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportAIMS] --919
GO

CREATE PROCEDURE [dbo].[csp_RDLSubReportAIMS] (
	@DocumentVersionId INT
	)
AS
/******************************************************************************************/  
/* Stored Procedure: [csp_RDLSubReportAIMS] 736500    736521           */  
/*       Date			Author                  Purpose          */
-------------------------------------------------------------------------------------------  
/*       25 Jun 2015	Avi Goyal	            What : RDL SP copied from Psychiatric Diagnostic Evaluation Note 
												Why : Task# 20 Project:Key Point - Customizations */ 
												
/*       21 Oct  2015   Pabitra                 What: Modefied the Csp to show Previous Records 
                 								Why :Camino-Customization #27 */	
/*      06 June  2017  Pabitra                 What: Modefied the Csp to show Previous Records 
                 								Why :Texas-Customizations #58 */				                  								
                 								
/******************************************************************************************/ 
BEGIN
	BEGIN TRY
	
    DECLARE @LatestDocumentVersionID INT
	DECLARE @EffectiveDate Datetime
	DECLARE @PreviousAIMSTotalScore INT
	DECLARE @ClientID INT
	DECLARE @PreviousExtremityMovementsUpper INT
    DECLARE @PreviousMuscleFacialExpression INT
    DECLARE @PreviousLipsPerioralArea INT
    DECLARE @PreviousJaw INT
    DECLARE @PreviousTongue INT
    DECLARE @PreviousExtremityMovementsLower INT
    DECLARE @PreviousNeckShouldersHips INT
    DECLARE @PreviousSeverityAbnormalMovements INT
    DECLARE @PreviousPatientAwarenessAbnormalMovements INT
    DECLARE @PreviousIncapacitationAbnormalMovements INT
    DECLARE @PreviousCurrentProblemsTeeth Varchar(10)
    DECLARE @PreviousDoesPatientWearDentures Varchar(10)
     DECLARE @PreviousAIMSPositveNegative Varchar(10)
	
	SELECT @ClientID = Doc.ClientId  FROM Documents Doc where doc.CurrentDocumentVersionId=@DocumentVersionId
	
Declare @NoAIMSExists INT
SELECT  @NoAIMSExists=Count(DocumentVersionId)

            FROM    CustomDocumentPsychiatricAIMSs CDP ,
                    Documents Doc
            WHERE   CDP.DocumentVersionId = Doc.CurrentDocumentVersionId
                    AND Doc.ClientId = @ClientID
                    AND Doc.Status = 22
                    AND ISNULL(CDP.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                    
                    PRINT @NoAIMSExists

	
	--select * from documents where documentcodeid=28006 and clientid=150
IF(@NoAIMSExists=1)
BEGIN
SET @LatestDocumentVersionID=NULL
END
ELSE
BEGIN
	 SET  @LatestDocumentVersionID = (SELECT MIN(CDP.DocumentVersionId)  From CustomDocumentPsychiatricAIMSs CDP  WHERE CDP.DocumentVersionId in (SELECT TOP 2
                     CDP.DocumentVersionId 
                   -- @EffectiveDate = Doc.EffectiveDate
            FROM    CustomDocumentPsychiatricAIMSs CDP ,
                    Documents Doc
            WHERE   CDP.DocumentVersionId = Doc.CurrentDocumentVersionId
                    AND Doc.ClientId = @ClientID
                    AND Doc.Status = 22
                    AND ISNULL(CDP.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                    AND Doc.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
                    ORDER BY Doc.EffectiveDate DESC ,
                    Doc.ModifiedDate DESC,  CDP.DocumentVersionId  ) )
    END
                    
  SELECT @EffectiveDate = EffectiveDate FROM  Documents WHERE  CurrentDocumentVersionId= @LatestDocumentVersionID             
  IF @LatestDocumentVersionID IS NOT NULL
	BEGIN
		SELECT 
	 @PreviousExtremityMovementsUpper = ExtremityMovementsUpper
	,@PreviousAIMSTotalScore=AIMSTotalScore
	,@PreviousMuscleFacialExpression =MuscleFacialExpression
	,@PreviousLipsPerioralArea = LipsPerioralArea
	,@PreviousJaw = Jaw
	,@PreviousTongue = Tongue
	,@PreviousExtremityMovementsLower = ExtremityMovementsLower
	,@PreviousNeckShouldersHips = NeckShouldersHips
	,@PreviousSeverityAbnormalMovements = SeverityAbnormalMovements
	,@PreviousPatientAwarenessAbnormalMovements = PatientAwarenessAbnormalMovements
	,@PreviousIncapacitationAbnormalMovements = IncapacitationAbnormalMovements
	,@PreviousCurrentProblemsTeeth = CurrentProblemsTeeth
    ,@PreviousDoesPatientWearDentures = DoesPatientWearDentures
    ,@PreviousAIMSPositveNegative =AIMSPositveNegative
    FROM CustomDocumentPsychiatricAIMSs  
    WHERE DocumentVersionId = @LatestDocumentVersionID and ISNULL(RecordDeleted,'N') = 'N' 
 
   	END
   	
   	SELECT 
		 CDPA.DocumentVersionId
		,CDPA.CreatedBy
		,CDPA.CreatedDate
		,CDPA.ModifiedBy
		,CDPA.ModifiedDate
		,CDPA.RecordDeleted
		,CDPA.DeletedBy
		,CDPA.DeletedDate
		,dbo.csf_GetGlobalCodeNameById(MuscleFacialExpression) AS MuscleFacialExpression
		,dbo.csf_GetGlobalCodeNameById(LipsPerioralArea) AS LipsPerioralArea
		,dbo.csf_GetGlobalCodeNameById(Jaw) AS Jaw
		,dbo.csf_GetGlobalCodeNameById(Tongue) AS Tongue
		,dbo.csf_GetGlobalCodeNameById(ExtremityMovementsUpper) AS ExtremityMovementsUpper
		,dbo.csf_GetGlobalCodeNameById(ExtremityMovementsLower) AS ExtremityMovementsLower
		,dbo.csf_GetGlobalCodeNameById(NeckShouldersHips) AS NeckShouldersHips
		,dbo.csf_GetGlobalCodeNameById(SeverityAbnormalMovements) AS SeverityAbnormalMovements
		,dbo.csf_GetGlobalCodeNameById(IncapacitationAbnormalMovements) AS IncapacitationAbnormalMovements
		,dbo.csf_GetGlobalCodeNameById(PatientAwarenessAbnormalMovements) AS PatientAwarenessAbnormalMovements
		,CDPA.CurrentProblemsTeeth
		,CDPA.DoesPatientWearDentures
		,CDPA.AIMSTotalScore
		,dbo.csf_GetGlobalCodeNameById(@PreviousMuscleFacialExpression) as PreviousMuscleFacialExpression
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousLipsPerioralArea) as PreviousLipsPerioralArea
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousJaw) as PreviousJaw
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousTongue) as PreviousTongue
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousExtremityMovementsUpper) as PreviousExtremityMovementsUpper
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousExtremityMovementsLower) as PreviousExtremityMovementsLower
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousNeckShouldersHips) as PreviousNeckShouldersHips
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousSeverityAbnormalMovements) as PreviousSeverityAbnormalMovements
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousIncapacitationAbnormalMovements) as PreviousIncapacitationAbnormalMovements
	    ,dbo.csf_GetGlobalCodeNameById(@PreviousPatientAwarenessAbnormalMovements) as PreviousPatientAwarenessAbnormalMovements
	    ,@PreviousCurrentProblemsTeeth as PreviousCurrentProblemsTeeth
        ,@PreviousDoesPatientWearDentures as PreviousDoesPatientWearDentures
	    ,@PreviousAIMSTotalScore as PreviousAIMSTotalScore 
	    ,CONVERT(VARCHAR(12),@EffectiveDate,101) AS PreviousEffectiveDate	
	    ,AIMSComments
	    ,@PreviousAIMSPositveNegative AS PreviousAIMSPositveNegative
	    ,AIMSPositveNegative
	    ,SetDeafultForMovements					
	FROM CustomDocumentPsychiatricAIMSs CDPA
	WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(CDPA.RecordDeleted,'N') = 'N' 
		
	END TRY
	BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLSubReportAIMS') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	
	END CATCH
END