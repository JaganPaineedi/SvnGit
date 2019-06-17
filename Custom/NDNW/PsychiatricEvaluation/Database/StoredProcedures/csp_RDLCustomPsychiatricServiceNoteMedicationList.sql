/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricServiceNoteMedicationList]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceNoteMedicationList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteMedicationList]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPsychiatricServiceNoteMedicationList]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteMedicationList] --5,'D'  
(@DocumentVersionId INT=0,  
@Type char(1)       )  
/*************************************************  
  Date:   Author:       Description:                              
    
  -------------------------------------------------------------------------              
 18-Dec-2014    Revathi      What:  
                             Why:task #823 Woods-Customizations  
************************************************/  
  AS   
 BEGIN  
      
 BEGIN TRY  
  DECLARE @ClientId INT   
  DECLARE @DateOfService DATETIME  
   SELECT @ClientId = D.ClientId,  
     @DateOfService=S.DateOfService    
   FROM Documents D    
     INNER JOIN Services S ON D.ServiceId=S.ServiceId    
   WHERE D.InProgressDocumentVersionId=@DocumentVersionId AND    
   IsNull(D.RecordDeleted,'N')='N'    
   AND IsNull(S.RecordDeleted,'N')='N'  
     
   CREATE TABLE #Medication(  
   MedicationName varchar(max),  
   PrescriberName varchar(max),  
   Sources varchar(max),  
   LastOrdered varchar(100),  
   MedicationStartDate  varchar(100),   
   MedicationEndDate varchar(100),  
   Script varchar(10),  
   Instructions varchar(max)     
   )  
     
      
    
 CREATE TABLE #LastScriptIdTable   
    (  
      ClientMedicationInstructionId INT  
    , ClientMedicationScriptId INT  
    )               
   INSERT INTO #LastScriptIdTable  
     ( ClientMedicationInstructionId  
     , ClientMedicationScriptId                      
                    )  
     SELECT ClientMedicationInstructionId  
        , ClientMedicationScriptId  
     FROM ( SELECT cmsd.ClientMedicationInstructionId  
           , cmsd.ClientMedicationScriptId  
           , cms.OrderDate  
           , ROW_NUMBER() OVER ( PARTITION BY cmsd.ClientMedicationInstructionId ORDER BY cms.OrderDate DESC, cmsd.ClientMedicationScriptId DESC ) AS rownum  
         FROM  ClientMedicationScriptDrugs cmsd  
          JOIN ClientMedicationScripts cms ON ( cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId )  
         WHERE  ClientMedicationInstructionId IN (  
          SELECT ClientMedicationInstructionId  
          FROM ClientMedications a  
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
   IF ( @Type = 'C' )   
    BEGIN  
    INSERT INTO #Medication     
                  SELECT   
DISTINCT					MDM.MedicationName AS MedicationName
						  , CM.PrescriberName
						  , ISNULL(dbo.csf_GetGlobalCodeNameById(CM.RXSource),
								   '') AS SOURCE
						  , ISNULL(CONVERT(VARCHAR(10), cms.OrderDate, 101),
								   '') AS LastOrdered
						  , ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 101),
								   '') AS MedicationStartDate
						  , ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS MedicationEndDate
						  , 'Yes' AS Script
						  , dbo.csf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) AS Instructions
					FROM	ClientMedicationInstructions CMI
							JOIN ClientMedications CM ON ( CMI.clientmedicationId = CM.clientMedicationid
														   AND ISNULL(cm.discontinued,
															  'N') <> 'Y'
														   AND ISNULL(cm.RecordDeleted,
															  'N') <> 'Y'
														 )
							LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )
														AND ISNULL(gc.RecordDeleted,
															  'N') <> 'Y'
							LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )
														 AND ISNULL(gc1.RecordDeleted,
															  'N') <> 'Y'
							JOIN MDMedicationNames MDM ON ( CM.MedicationNameId = MDM.MedicationNameId
															AND ISNULL(mdm.RecordDeleted,
															  'N') <> 'Y'
														  )
							JOIN MDMedications MD ON ( MD.MedicationID = CMI.StrengthId
													   AND ISNULL(md.RecordDeleted,
															  'N') <> 'Y'
													 )
							JOIN ClientMedicationScriptDrugs CMSD ON ( CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
															  AND ISNULL(CMSD.RecordDeleted,
															  'N') <> 'Y'
															  )
							LEFT JOIN #LastScriptIdTable LSId ON ( cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
															  AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
															  )
							JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
					WHERE	cm.ClientId = @ClientId
							AND ISNULL(cmi.Active, 'Y') = 'Y'
							AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
							AND ( CMSD.ClientMedicationScriptId IS NULL
								  OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
								)
					ORDER BY MDM.MedicationName 
  END     
   IF ( @Type = 'D' )   
    BEGIN  
     ;  
     WITH DelMeds  
         AS ( SELECT M.MedicationName  
            , CM.PrescriberName  
            , CM.RXSource  
            ,   '' AS LastOrdered   
            , ISNULL(CONVERT(VARCHAR(10), CM.MedicationStartDate, 101),  
               '') AS MedicationStartDate  
            , ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101),  
               '') AS MedicationEndDate                 
            , 'Yes' AS Script  
            , CM.ClientMedicationId  
            , cm.DiscontinueDate  
            , cmi.ClientMedicationInstructionId  
           FROM  MDMedicationNames M  
           INNER JOIN ClientMedications CM ON ( CM.MedicationNameId = m.MedicationNameId )  
           JOIN ClientMedicationInstructions CMI ON ( CMI.clientmedicationId = CM.clientMedicationid )  
           JOIN ClientMedicationScriptDrugs CMSD ON ( CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId )  
           LEFT JOIN #LastScriptIdTable LSId ON ( cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId )  
           WHERE CM.ClientId = @ClientID  
           AND CM.Ordered = 'Y'  
           AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
           AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'  
           AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y'  
           AND ISNULL(M.RecordDeleted, 'N') = 'N'  
           AND ( CMSD.ClientMedicationScriptId IS NULL  
              OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId  
            )  
         )  
       INSERT INTO #Medication    
      SELECT DISTINCT  
        MedicationName  
        ,PrescriberName  
         , ISNULL(dbo.csf_GetGlobalCodeExternalCode1ById(rxsource),  
            '') AS SOURCE  
         ,LastOrdered       
         , MedicationStartDate  
         , MedicationEndDate  
         , Script  
         , dbo.csf_GetMedicationInstruction(ClientMedicationInstructionId) AS Instructions  
      FROM DelMeds  
      WHERE CAST( DiscontinueDate AS DATE) =CAST( @DateOfService AS DATE)    
      ORDER BY MedicationName      
      
    END   
     IF ( @Type = 'S' )   
    BEGIN  
     INSERT INTO #Medication    
     SELECT     
      DISTINCT M.MedicationName  
        , CM.PrescriberName  
        , ISNULL(dbo.csf_GetGlobalCodeNameById(CM.RXSource),  
           '') AS Source  
        ,    '' AS LastOrdered        
        , ISNULL(CONVERT(VARCHAR(10), CM.MedicationStartDate, 101),  
           '') AS MedicationStartDate  
        , ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS MedicationEndDate  
        , 'No' AS Script  
        , dbo.csf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) AS Instructions  
     FROM MDMedicationNames M  
       INNER JOIN ClientMedications CM ON CM.MedicationNameId = m.MedicationNameId  
       LEFT JOIN ClientMedicationInstructions CMI ON CMI.clientmedicationId = CM.clientMedicationid  
       LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )  
              AND ISNULL(gc.RecordDeleted,  
                 'N') <> 'Y'  
       LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )  
               AND ISNULL(gc1.RecordDeleted,  
                 'N') <> 'Y'  
       LEFT JOIN MDMedications MD ON ( MD.MedicationID = CMI.StrengthId )  
       LEFT JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId  
     WHERE CM.ClientId = @ClientId   
  
       AND CAST( CM.MedicationStartDate AS DATE) <= CAST( @DateOfService AS DATE)  
       AND ( ( CAST(CM.MedicationEndDate AS DATE) > CAST( @DateOfService AS DATE)  
         OR CM.MedicationEndDate IS NULL  
          )  
          OR ( CAST( CM.MedicationEndDate AS DATE) = CAST( @DateOfService AS DATE)  
            AND CM.Discontinued IS NULL  
          )  
        )  
       AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
       AND ISNULL(CM.Ordered, 'N') = 'N'  
       AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'  
       AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y'  
       AND ISNULL(M.RecordDeleted, 'N') = 'N'  
     ORDER BY M.MedicationName   
      
    END     
      
    SELECT   
     MedicationName,  
    PrescriberName,  
    Sources,  
    LastOrdered,  
    MedicationStartDate ,   
    MedicationEndDate ,  
    Script,  
    Instructions   
     FROM  
     #Medication      
         
 End TRY  
   
  BEGIN CATCH            
   DECLARE @Error varchar(8000)                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                          
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricServiceNoteMedicationList')                                                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                  
   + '*****' + Convert(varchar,ERROR_STATE())                                             
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );               
 END CATCH            
END
GO


