/****** Object:  StoredProcedure [dbo].[ssp_RDLSubReportSelfReportedMedications]    Script Date: 06/21/2016 09:42:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSubReportSelfReportedMedications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSubReportSelfReportedMedications]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLSubReportSelfReportedMedications]    Script Date: 06/21/2016 09:42:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLSubReportSelfReportedMedications] (
	   @DocumentVersionId int
	)
AS
BEGIN 
/********************************************************************************                                                           
--          
-- Copyright: Streamline Healthcare Solutions          
-- "CurrentMedications"        
-- Purpose: Script for CCC-Customizations task#12  (copied from Key Pointe – #604 made it core )      
--          
-- Author:  Ravichandra        
-- Date:    05-21-2018        
-- *****History****          

*********************************************************************************/
  Declare @ClientId int
  Declare @DateOfService DATETIME
  Declare @ServiceId int
  Declare @EffectiveDate DATETIME
  
 SELECT @ClientId = d.ClientId, @ServiceId = d.ServiceId, @EffectiveDate = CONVERT(VARCHAR, EffectiveDate, 101)
		FROM Documents d    
        WHERE d.InProgressDocumentVersionId = @DocumentVersionId
         
 
   SELECT @ServiceId = d.ServiceId
		FROM Documents d    
        WHERE d.InProgressDocumentVersionId = @DocumentVersionId     
        
      SELECT @DateOfService = s.DateOfService
		FROM services s    
		Left Join Documents d On d.ServiceId=s.ServiceId
        WHERE s.ServiceId=@ServiceId   
  
  if(ISNULL(@DateOfService,'') = '')
  BEGIN
	 set @DateOfService = @EffectiveDate
  END
         
 DECLARE @LastScriptIdTable TABLE  
    (  
      ClientmedicationInstructionid INT  
    , ClientMedicationScriptId INT  
    )               
   INSERT INTO @LastScriptIdTable  
     ( ClientmedicationInstructionid  
     , ClientMedicationScriptId                      
                    )  
     SELECT ClientmedicationInstructionid  
        , ClientMedicationScriptId  
     FROM ( SELECT cmsd.ClientmedicationInstructionid  
           , cmsd.ClientMedicationScriptId  
           , cms.OrderDate  
           , ROW_NUMBER() OVER ( PARTITION BY cmsd.ClientmedicationInstructionid ORDER BY cms.OrderDate DESC, cmsd.ClientMedicationScriptId DESC ) AS rownum  
         FROM  clientmedicationscriptdrugs cmsd  
          JOIN clientmedicationscripts cms ON ( cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId )  
         WHERE  ClientMedicationInstructionId IN (  
          SELECT ClientMedicationInstructionId  
          FROM clientmedications a  
            JOIN dbo.ClientMedicationInstructions b ON ( a.ClientMedicationId = b.ClientMedicationId )  
          WHERE a.ClientId = @ClientId  
            AND ISNULL(a.RecordDeleted,  
                 'N') = 'N'  
            AND ISNULL(b.Active, 'Y') = 'Y'  
            AND ISNULL(b.RecordDeleted,  
                 'N') = 'N' )  
          AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'  
          AND ISNULL(cms.RecordDeleted, 'N') = 'N'  
          AND ISNULL(cms.Voided, 'N') = 'N'  
       ) AS a  
     WHERE rownum = 1          
          
  
  
   SET @DateOfService = CONVERT(VARCHAR, @DateOfService, 101)  
   
   
   
   
   
      
     
     SELECT DISTINCT MDM.MedicationName AS MedicationName
     ,ISNULL(CAST(MD.StrengthDescription AS Varchar(max)), '') as   StrengthDescription         
		,CASE 
			WHEN dbo.csf_GetGlobalCodeNameById(ISNULL(CAST(CMI.Schedule AS VARCHAR(50)), '')) = ''
				THEN ''
			ELSE dbo.csf_GetGlobalCodeNameById(ISNULL(CAST(CMI.Schedule AS VARCHAR(50)), ''))
			END AS Direction
			,CASE WHEN CMSD.PharmacyText IS NULL      
                     THEN CAST(CMSD.Pharmacy AS VARCHAR(30))      
                     ELSE CMSD.PharmacyText      
                END AS Quantity 
		,CAST (CMI.Quantity As VARCHAR (50))+ ' '+  ISNULL(CAST(GC.CodeName AS VARCHAR(50)), '') AS Units
		  ,Convert(varchar(10),CMSD.[StartDate],101) as RXStartDate
          ,Convert(varchar(10),CMSD.[EndDate],101) as RXEndDate 
		,ISNULL(CAST(CMSD.Refills AS VARCHAR(50)), '') AS Refills
		,CM.PrescriberName
	FROM ClientMedicationInstructions CMI
	JOIN ClientMedications CM ON (CMI.clientmedicationId = CM.clientMedicationid)  AND CAST(CM.CreatedDate as date) <= CAST(@EffectiveDate as DATE)    
	LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
		AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
		AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
	JOIN MDMedicationNames MDM ON (
			CM.MedicationNameId = MDM.MedicationNameId
			AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
			)
	JOIN MDMedications MD ON (
			MD.MedicationID = CMI.StrengthId
			AND ISNULL(md.RecordDeleted, 'N') <> 'Y'
			)
	JOIN ClientMedicationScriptDrugs CMSD ON (
			CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
			AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y' AND cast(CMSD.CreatedDate as DATE) <= CAST(@EffectiveDate as DATE)
			)
	JOIN ClientMedicationScriptDrugStrengths CMSDS ON (
			CM.clientMedicationid = CMSDS.clientMedicationid
			AND ISNULL(CMSDS.RecordDeleted, 'N') <> 'Y'
			)
	WHERE cm.ClientId = @ClientId
		AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@DateOfService AS DATE)
		AND (
			(
				CAST(CM.MedicationEndDate AS DATE) > CAST(@DateOfService AS DATE)
				OR CM.MedicationEndDate IS NULL
				)
			OR (
				CAST(CM.MedicationEndDate AS DATE) = CAST(@DateOfService AS DATE)
				AND CM.Discontinued IS NULL
				)
			)
		AND ISNULL(CM.RecordDeleted, 'N') = 'N'
		AND ISNULL(CM.Ordered, 'N') = 'N'
		AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(MD.RecordDeleted, 'N') = 'N'
		--ORDER BY M.MedicationName     
END  
  
--Checking For Errors                     
IF (@@error != 0)
BEGIN
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSubReportSelfReportedMedications') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.           
			16
			,-- Severity.           
			1 -- State.                                                             
			);

	RETURN
END
GO

