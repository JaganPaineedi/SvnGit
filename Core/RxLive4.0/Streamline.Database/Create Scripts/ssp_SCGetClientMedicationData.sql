 CREATE PROCEDURE [dbo].[ssp_SCGetClientMedicationData] ( @ClientId INT )
 AS /*********************************************************************/                                                                                                                  
/* Stored Procedure: dbo.[ssp_SCGetClientMedicationData]                */                                                                                                                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                                                  
/* Creation Date:    11/Sep/07                                         */                                                                                                                 
/*                                                                   */                                                                                                                  
/* Purpose:  To retrieve MedicationData   */                                                                                                                  
/*                                                                   */                                                                                                                
/* Input Parameters: none        @ClientId */                                                                                                                
/*                                                                   */                                                                                                                  
/* Output Parameters:   None                           */                                                                                                                  
/*                                                                   */                                                                                                                  
/* Return:  0=success, otherwise an error number                     */                                                                                                                  
/*                                                                   */                                                                                                                  
/* Called By:                                                        */                                                                                                                  
/*                                                                   */                                                                                                                  
/* Calls:                                                            */                                                                                                                  
/*                                                                   */                                                                                                                  
/* Data Modifications:                                               */                                                                                                                  
/*                                                                   */                                                                                                                  
/* Updates:                        */               
/*   Date     Author       Purpose                  */                  
/*  11/Sep/07    Rishu    Created      */                     
/*  27/Feb/07 Sonia Modified toget interactions of Non order medications*/                         
/*  11th April Sonia Modified                          
(Following changes implemented)                            
--CM.OrderStatus,CM.OrderStatusDate,CM.OrderDate removed from Selection list                              
-- Condition removed CM.OrderStatus = 'A'  removed                                    
--In ClientMedicationInstructions Following removed from selection list                            
--mincmi.StartDate, cmi.Days, cmi.Pharmacy, cmi.Sample, cmi.Stock, cmi.Refills,cmi.EndDate, removed                                                                                                  
--Condtion removed  cm.OrderStatus = 'A'                            
--In ClientMedicationInteractions                            
--Condtion removed  cm.OrderStatus = 'A'                            
--Data retrieval from ClientMedicationScriptDrugs added                            
--In ClientMedicationInteractionDetails                            
--Condition removed cm.OrderStatus = 'A'      */                           
/*  26/May/08 Sonia Modified  reference Task #39 MM#1.5.1                      
--Logic of Initialization changed as per New requirement of Task #39 MM 1.5.1*/                      
/*28/May/08 Sonia Modified to replace the NULL DrugCategory with 0*/                      
/*Reference Task #47 MM1.5*/                    
/*Modified by Chandan 19th Nov 2008 for getting MedicationInteraction Name in the Interaction table*/                    
/*Task #82 - MM -1.6.5          */                       
/*Modified by Chandan 15th Dec 2008 for getting StartDate and End Date from Drugs in Instruction table*/                    
/*Task #74 - MM -1.7          */                  
/*  11/April/2009 Loveena Modified  reference Task # MM#1.9                      
--Logic of retreiving these fileds*/                  
/*********************************************************************/                                                                   
    BEGIN                                                                                          
                                 
        SELECT  *
        FROM    ( SELECT DISTINCT
                            CM.ClientMedicationId ,
                            CM.ClientId ,
                            CM.Ordered ,                                         
--CM.OrderDate, removed                                        
                            CM.MedicationNameId ,
                            CM.DrugPurpose ,
                            CM.DSMCode ,
                            CM.DSMNumber ,
                            CM.NewDiagnosis ,
                            CM.PrescriberId ,
                            CM.PrescriberName ,
                            CM.ExternalPrescriberName ,
                            CM.SpecialInstructions ,
                            CM.DAW ,
                            CM.Discontinued ,
                            CM.DiscontinuedReason ,
                            CM.DiscontinueDate ,
                            CM.RowIdentifier ,
                            CM.CreatedBy ,
                            CM.CreatedDate ,
                            CM.ModifiedBy ,
                            CM.ModifiedDate ,
                            CM.RecordDeleted ,
                            CM.DeletedDate ,
                            CM.DeletedBy ,
                            CM.MedicationStartDate ,
                            CM.MedicationEndDate ,                                        
--CM.OrderStatus, CM.OrderStatusDate,                                            
                            RTRIM(LTRIM(ISNULL(DSMCode, '0'))) + '_'
                            + RTRIM(LTRIM(ISNULL(CAST(DSMNumber AS VARCHAR),
                                                 '0'))) AS DxId ,
                            MDN.MedicationName AS MedicationName                                    
--Changes by sonia                    
--*Reference Task #47 MM1.5 as in some cases DEACode is not found for some medications                    
--,MDDrugs.DEACODE as DrugCategory,CM.DEACode,--commented by sonia                    
                            ,
                            ISNULL(MDDrugs.DEACODE, '0') AS DrugCategory ,
                            CM.DEACode ,--added by sonia                              
                            CASE WHEN CM.Ordered = 'Y' THEN 0
                                 ELSE 1
                            END AS CMOrder ,
                            CM.TitrationType , --Added by Chandan       
                            CM.DateTerminated ,
                            CAST(A.ClientMedicationScriptId AS VARCHAR) AS MedicationScriptId ,  -- Added by Ankesh Bharti in ref to task # 2409                                  
                            CM.OffLabel , --Added by Loveena in ref to Task# MM-1.9 to retrieve these fields              
                            CM.DesiredOutcomes ,
                            CM.Comments ,
                            CM.DiscontinuedReasonCode ,
                            CASE WHEN ISNULL(ClientMedicationConsentId, 0) = 0
                                 THEN 0
                                 ELSE 1
                            END AS ClientMedicationConsentId
                  FROM      ClientMedications CM
                            JOIN MDMedicationNames MDN ON CM.MedicationNameId = MDN.MedicationNameId
                            LEFT OUTER JOIN ClientMedicationInstructions ON ClientMedicationInstructions.ClientMedicationId = CM.ClientMedicationId
                                                              AND ISNULL(ClientMedicationInstructions.Active,
                                                              'Y') = 'Y'
                                                              AND ISNULL(ClientMedicationInstructions.RecordDeleted,
                                                              'N') <> 'Y'
                            LEFT OUTER JOIN MDMedications ON MDMedications.MedicationId = ClientMedicationInstructions.StrengthId
                                                             AND ISNULL(dbo.ClientMedicationInstructions.RecordDeleted,
                                                              'N') <> 'Y'
                                                             AND ISNULL(dbo.MDMedications.RecordDeleted,
                                                              'N') <> 'Y'
                            LEFT OUTER JOIN MDDrugs ON dbo.MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId
                                                       AND ISNULL(dbo.MDDrugs.RecordDeleted,
                                                              'N') <> 'Y'                              
--Added by Loveena in ref to To Task#2465 to display CheckBoxIcon on MedicationList if record exists in          
-- ClientMedicationConsents          
                            LEFT OUTER JOIN ( SELECT    ClientMedicationConsentId ,
                                                        MedicationNameId ,
                                                        DC.EffectiveDate ,
                                                        DS.IsClient
                                              FROM      ClientMedicationConsents CMC
                                                        INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = CMC.DocumentVersionId
                                                        INNER JOIN Documents DC ON DC.DocumentId = DV.DocumentId
                                                        INNER JOIN DocumentSignatures DS ON DS.DocumentId = DC.DocumentId
                                            ) B ON B.MedicationNameId = CM.MedicationNameId
                                                   AND B.EffectiveDate BETWEEN ( GETDATE()
                                                              - 1 )
                                                              AND
                                                              DATEADD(year, 1,
                                                              GETDATE())
                            LEFT OUTER JOIN ( SELECT    ClientMedicationInstructionId ,
                                                        MAX(ClientMedicationScriptId) AS ClientMedicationScriptId
                                              FROM      ClientMedicationScriptDrugs
                                              GROUP BY  ClientMedicationInstructionId
                                            ) A ON A.ClientMedicationInstructionId = ClientMedicationInstructions.ClientMedicationInstructionId
                  WHERE     CM.ClientId = @ClientId     
--and A.ClientMedicationScriptId Is not null                                              
--and CM.OrderStatus = 'A' column removed                 
                            AND ISNULL(CM.discontinued, 'N') <> 'Y'
                            AND ISNULL(CM.RecordDeleted, 'N') <> 'Y'
                            AND ISNULL(MDN.RecordDeleted, 'N') <> 'Y'
                ) T
        WHERE   ( Ordered = 'Y'
                  AND MedicationScriptID IS NOT NULL
                )
                OR ( Ordered = 'N' )
        ORDER BY CASE WHEN Ordered = 'Y' THEN 0
                      ELSE 1
                 END                                  
                  
                  
--******** Get Data From ClientMedicationInstructions ******* --                  
                  
        SELECT  cmi.ClientMedicationInstructionId ,
                cmi.ClientMedicationId ,
                cmi.StrengthId ,
                cmi.Quantity ,
                cmi.Unit ,
                cmi.Schedule ,
                cmi.Active , -- Field added by Ankesh Bharti                                          
--mincmi.StartDate, removed                                        
--cmi.Days, cmi.Pharmacy, cmi.Sample, cmi.Stock, cmi.Refills, removed                                            
--cmi.EndDate, removed                                        
                cmi.RowIdentifier ,
                cmi.CreatedBy ,
                cmi.CreatedDate ,
                cmi.ModifiedBy ,
                cmi.ModifiedDate ,
                cmi.RecordDeleted ,
                cmi.DeletedDate ,
                cmi.DeletedBy ,
                ( MD.StrengthDescription + ' ' + CONVERT(VARCHAR, CMI.Quantity)
                  + ' ' + CONVERT(VARCHAR, GC.CodeName) + ' '
                  + CONVERT(VARCHAR, GC1.CodeName) ) AS Instruction ,
                MDM.MedicationName AS MedicationName ,
                '' AS InformationComplete , --'InformationComplete' field added by Ankesh Bharti with ref to Task # 77.                         
--convert(varchar,CMSD.StartDate,101) as StartDate,                    
--convert(varchar,CMSD.EndDate,101) as EndDate ,        
                CMSD.StartDate ,
                CMSD.EndDate ,
                cmi.TitrationStepNumber , --Added by Chandan                    
                CMSD.Days ,
                CMSD.Pharmacy ,
                CMSD.Sample ,
                CMSD.Stock ,
                MD.StrengthDescription AS TitrateSummary ,
                'Y' AS DBdata ,
                CAST(CMSD.ClientMedicationScriptId AS VARCHAR) AS MedicationScriptId
        FROM    ClientMedicationInstructions CMI
                JOIN ClientMedications CM ON ( CMI.clientmedicationId = CM.clientMedicationid )
                LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )
                                            AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
                LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )
                                             AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
                JOIN MDMedicationNames MDM ON ( CM.MedicationNameId = MDM.MedicationNameId )
                JOIN MDMedications MD ON ( MD.MedicationID = CMI.StrengthId )
                JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
                                                         AND ISNULL(CMSD.RecordDeleted,
                                                              'N') <> 'Y'
        WHERE   cm.ClientId = @ClientId                        
--Ref Task #127                    
                AND CMSD.ModifiedDate = ( SELECT    MAX(ModifiedDate)
                                          FROM      ClientMedicationScriptDrugs CMSD1
                                          WHERE     CMSD1.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
                                                    AND ISNULL(CMSD1.RecordDeleted,
                                                              'N') <> 'Y'
                                        )                                     
--removed and cm.OrderStatus = 'A'                  
                AND ISNULL(cmi.Active, 'Y') = 'Y'
                AND ISNULL(cm.discontinued, 'N') <> 'Y'
                AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
                AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
                AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                AND ISNULL(md.RecordDeleted, 'N') <> 'Y'
        ORDER BY MDM.MedicationName ASC                                          
--********************************************************************** --                  
                                        
                                      
--Get Data From ClientMedicationScriptDrugs                                      
        SELECT  CMSD.*
        FROM    ClientMedicationScriptDrugs CMSD
                JOIN ClientMedicationInstructions CMI ON ( CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId )
                                                         AND ISNULL(CMSD.RecordDeleted,
                                                              'N') <> 'Y'
                                                         AND ISNULL(CMI.Active,
                                                              'Y') <> 'N'
                JOIN ClientMedications CM ON ( CMI.clientmedicationId = CM.clientMedicationid )
        WHERE   cm.ClientId = @ClientId                                         
--Logic of Initialization changed as per New requirement of Task #38 MM 1.5.1                      
--Old logic Commented                      
/*--and CMSD.StartDate in                                   
(                                  
Select max(startdate)                                   
from ClientMedicationScriptDrugs  CMSD1                                    
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId                                  
and isnull(CMSD1.RecordDeleted, 'N') <> 'Y' and isnull(CMI.RecordDeleted, 'N') <> 'Y'      
 */                      
--New Logic                      
                AND CMSD.ModifiedDate = ( SELECT    MAX(ModifiedDate)
                                          FROM      ClientMedicationScriptDrugs CMSD1
                                          WHERE     CMSD1.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
                                        )
                AND ISNULL(cm.discontinued, 'N') <> 'Y'
                AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
                AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
        ORDER BY CMSD.ClientMedicationScriptDrugId ,
                CMI.ClientMedicationId DESC                                        
                                      
                                      
                                 
----ClientMedicationInteractions                                      
                                        
--Select distinct cma.ClientMedicationInteractionId, cma.ClientMedicationId1, cma.ClientMedicationId2, cma.InteractionLevel,                                            
--cma.PrescriberAcknowledgementRequired, cma.PrescriberAcknowledged, cma.RowIdentifier, cma.CreatedBy, cma.CreatedDate,                                            
--cma.ModifiedBy, cma.ModifiedDate, cma.RecordDeleted, cma.DeletedDate, cma.DeletedBy                                                                   
--from ClientMedications CM                                                                    
--join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,'N')<>'Y')                                           
--inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,'N')<>'Y')                                                                    
--where cm.ClientId = @ClientId                                            
----and cm.OrderStatus = 'A'                                            
--AND isnull(cm.discontinued,'N') <> 'Y'                                             
--and isnull(cm.RecordDeleted, 'N') <> 'Y'                      
                      
--Added By Chandan on 19th Nov 2008                    
        SELECT DISTINCT
                cma.ClientMedicationInteractionId ,
                cma.ClientMedicationId1 ,
                cma.ClientMedicationId2 ,
                cma.InteractionLevel ,
                cma.PrescriberAcknowledgementRequired ,
                cma.PrescriberAcknowledged ,
                cma.RowIdentifier ,
                cma.CreatedBy ,
                cma.CreatedDate ,
                cma.ModifiedBy ,
                cma.ModifiedDate ,
                cma.RecordDeleted ,
                cma.DeletedDate ,
                cma.DeletedBy ,
                CM1.MedicationNameId ,
                CM2.MedicationNameId ,
                MDN1.MedicationName AS ClientMedicationId1Name ,
                MDN2.MedicationName AS ClientMedicationId2Name
        FROM    ClientMedications CM
                JOIN ClientMedicationInstructions CMI ON ( CM.ClientMedicationId = CMI.ClientMedicationId
                                                           AND ISNULL(CMI.RecordDeleted,
                                                              'N') <> 'Y'
                                                         )
                INNER JOIN ClientMedicationInteractions CMA ON ( ( clientmedicationId1 = CM.ClientMedicationId
                                                              OR clientmedicationid2 = CM.ClientMedicationId
                                                              )
                                                              AND ISNULL(CMA.RecordDeleted,
                                                              'N') <> 'Y'
                                                              )
                INNER JOIN ClientMedications CM1 ON ( cma.ClientMedicationId1 = CM1.ClientMedicationId )
                INNER JOIN ClientMedications CM2 ON ( cma.ClientMedicationId2 = CM2.ClientMedicationId )
                INNER JOIN MDMedicationNames MDN1 ON ( MDN1.MedicationNameId = CM1.MedicationNameId )
                INNER JOIN MDMedicationNames MDN2 ON ( MDN2.MedicationNameId = CM2.MedicationNameId )
        WHERE   cm.ClientId = @ClientId                                            
--and cm.OrderStatus = 'A'                                            
                AND ISNULL(cm.discontinued, 'N') <> 'Y'
                AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'                                         
                                                              
                                                                    
        SELECT DISTINCT
                cmid.ClientMedicationInteractionDetailId ,
                cmid.ClientMedicationInteractionId ,
                cmid.DrugDrugInteractionId ,
                cmid.RowIdentifier ,
                cmid.CreatedBy ,
                cmid.CreatedDate ,
                cmid.ModifiedBy ,
                cmid.ModifiedDate ,
                cmid.RecordDeleted ,
                cmid.DeletedDate ,
                cmid.DeletedBy ,
                MDDI.SeverityLevel AS InteractionLevel ,
                MDDI.InteractionDescription ,
                MDDI.DrugInteractionMonographId
        FROM    ClientMedications CM
                JOIN ClientMedicationInstructions CMI ON ( CM.ClientMedicationId = CMI.ClientMedicationId
                                                           AND ISNULL(CMI.RecordDeleted,
                                                              'N') <> 'Y'
                                                         )
                INNER JOIN ClientMedicationInteractions CMA ON ( ( clientmedicationId1 = CM.ClientMedicationId
                                                              OR clientmedicationid2 = CM.ClientMedicationId
                                                              )
                                                              AND ISNULL(CMA.RecordDeleted,
                                                              'N') <> 'Y'
                                                              )
                INNER JOIN ClientMedicationInteractionDetails CMID ON ( CMID.ClientMedicationInteractionId = CMA.ClientMedicationInteractionId
                                                              AND ISNULL(CMID.RecordDeleted,
                                                              'N') <> 'Y'
                                                              )
                INNER JOIN MDDrugDrugInteractions MDDI ON ( CMID.DrugDrugInteractionId = MDDI.DrugDrugInteractionId
                                                            AND ISNULL(MDDI.RecordDeleted,
                                                              'N') <> 'Y'
                                                          )
        WHERE   cm.ClientId = @ClientId                                  
--and cm.OrderStatus = 'A'                                            
                AND ISNULL(cm.discontinued, 'N') <> 'Y'
                AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
        ORDER BY CMID.ClientMedicationInteractionId                                                                    
                                                                     
        EXEC ssp_SCGetClientDrugAllergyInteraction @ClientId                                                                    
                                                                                                      
        IF ( @@error != 0 ) 
            BEGIN                                                      
                RAISERROR  20002 'ssp_SCGetClientMedicationData : An error  occured'                                                                                                                  
                                                                                                                     
                RETURN(1)                                                                     
                                                                            
            END                                                                                                                       
                                                                                                                
    END                           
                          
                          