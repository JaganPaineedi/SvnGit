IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_SCGetVerbalOrderReviewData]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_SCGetVerbalOrderReviewData]
GO
                        
CREATE PROCEDURE [dbo].[ssp_SCGetVerbalOrderReviewData]
    (
      @StaffId INT ,
      @OrderType CHAR(1)
    )
AS 
/**************************************************************************************************/                                                                                                                                                                                        
-- Stored Procedure: [ssp_SCGetVerbalOrderReviewData]                                                                                                                                                                                                        
-- Copyright: 2005 Streamline Healthcare Solutions,  LLC                                                                                                                                                                                                     
-- Purpose:  To retrieve Verbal Order MedicationData                                                                                                                                                                                             
--
-- Date			Author					Purpose                                                                                                 
-- 12 Nov 2009	Chandan Srivastava		Create                                                     
-- 21 Nov 2009	Loveena					Update(to get LocationId, PharmacyId                                                                                               
-- 27 Dec 2009	Loveena					Changed the conditions related to Retrieving ordere list			                                                   
-- 11 Sep 2015	Wasif Butt				Adding new datamodel column PlanName to the select list		
-- 13 Nov 2015	Vithobha				added ISNULL(CMS.Voided, 'N') = 'N' condition, Valley - Customizations: #65 Queued Orders - Cancel                                                  
-- 14 Dec 2015	Malathi Shiva			added Interactions result set to bind the interactions for Queued Order, Valley - Customizations: #68  
-- 21 Jan 2016  Malathi shiva           as part of Summit Pointe : Task# 703 - VerbalOrderReadBack column was added into ClientMedicationScripts table which is supposed be added in this sp since we have the table mentioned                             
-- 21 Jan 2016  Malathi shiva           as part of Valley - Customizations : Task# 68 - On ajustting a Queued Order it should allow to modify and create the new order and queue the same order. Added Active Check to ClientMedicationInstructions becuase on adjusting an order the order order is set to Active='N' and a new order is queued.   
-- 05 May 2018  Pranay Bodhu            Removed join to MDDrugs and used ssf_SCClientMedicationC2C5Drugs function to get the drug category w.r.t BearRiver Task#434.                
-- 16 Oct 2018 Vinay K S     Added Interaction to Verbal order for the Task #437 Rx: Improvements to Verbal Orders Screen 
-- 11 Dec 2018             Jyothi             What/Why:Journey-Support Go Live-#1566 - If Client doesn't have access to client,respective client records will not show.
/**************************************************************************************************/                                                                                                                                                           
  
                                 
    BEGIN     
     DECLARE @StaffDegree INT ,   @TaxonomyCode INT    
  SELECT  @StaffDegree = s.Degree , @TaxonomyCode = s.TaxonomyCode FROM    Staff AS s  WHERE   s.StaffId = @StaffId                   
                                                                
        DECLARE @VerbalOrdersRequireApproval CHAR(1)                                              
        SELECT  @VerbalOrdersRequireApproval = ISNULL(VerbalOrdersRequireApproval,    
                                                      'N')    
        FROM    SystemConfigurations                                                          
        IF ( @OrderType = 'V'    
             OR @OrderType = 'v'    
           )     
            BEGIN                                                        
                SELECT DISTINCT    
                        CMS.ClientMedicationScriptId ,    
                        CMS.ClientId ,    
                        ScriptEventType ,    
                        ScriptCreationDate ,    
                        OrderDate ,    
                        OrderingMethod ,    
                        PrintDrugInformation ,    
                        OrderingPrescriberId ,    
                        OrderingPrescriberName ,    
                        WaitingPrescriberApproval ,    
                        VerbalOrderApproved ,    
                        SureScriptsRefillRequestId ,    
                        SureScriptsRefillRequestsArchiveId ,    
                        CMS.RowIdentifier ,    
                        CMS.CreatedBy ,    
                        ST.LastName + ',' + ST.FirstName AS CreatedByName ,    
                        CMS.CreatedDate ,    
                        CMS.ModifiedBy ,    
                        CMS.ModifiedDate ,    
                        CMS.RecordDeleted ,    
                        CMS.DeletedDate ,    
                        CMS.DeletedBy ,    
                        C.FirstName ,    
                        C.LastName ,    
                        CONVERT(VARCHAR, C.DOB, 101) AS DOB ,    
                        S.UserCode ,                                                        
  --CM.ClientMedicationId ,                                                      
  --Modified by Loveen ain ref to Task#25                                        
  --LOC.PrescribingLocation ,                    
                        LOC.LocationName ,    
                        Ph.PharmacyName ,                                                  
  --Added by Loveena                                                  
                        CMS.LocationId ,    
                        CMS.PharmacyId ,    
                        CMS.PrescriberReviewDateTime ,    
                        CMS.WaitingPrescriberApproval ,    
                        CMS.VerbalOrderApproved ,    
                        CMS.Voided ,    
                        CMS.VoidedBy ,    
                        CMS.VoidedReason ,    
      CMS.PlanName,    
      VerbalOrderReadBack,                                           
                        --MDDrugs.DEACODE    
                --  ISNULL(MDDrugs.DEACODE,'0') as DrugCategory ,    
      ISNULL([dbo].[ssf_SCClientMedicationC2C5Drugs](MDMedications.MedicationId) ,'0') as DrugCategory                                                         
                  FROM    ClientMedicationScripts CMS    
                        INNER JOIN Clients C ON C.ClientId = CMS.ClientId    
                                                AND ISNULL(C.RecordDeleted,    
                                                           'N') <> 'Y'    
                        INNER JOIN Staff S ON S.StaffId = CMS.OrderingPrescriberId    
                                              AND S.StaffId = @StaffId 
                         INNER join StaffClients sc on sc.StaffId = @StaffId
                                  and sc.ClientId = CMS.ClientId     
                        INNER JOIN ClientMedicationScriptDrugs CMSD ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId    
                        INNER JOIN ClientMedicationInstructions CMI ON CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
                        and  ISNULL(CMI.Active, 'Y') = 'Y'    
                        INNER JOIN Staff ST ON ST.UserCode = CMS.CreatedBy    
                        INNER JOIN ClientMedications CM ON CM.ClientMedicationId = CMI.ClientMedicationId    
                                                           AND ISNULL(CM.Discontinued,    
                                                              'N') <> 'Y'    
                        LEFT OUTER JOIN MDMedications ON MDMedications.MedicationId = CMI.StrengthId    
                                                         AND ISNULL(CMI.RecordDeleted,    
                                                              'N') <> 'Y'    
                                                         AND ISNULL(dbo.MDMedications.RecordDeleted,    
                                                              'N') <> 'Y'    
                        --LEFT OUTER JOIN MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId    
                        --                           AND ISNULL(dbo.MDDrugs.RecordDeleted,    
                        --                                      'N') <> 'Y'    
                        INNER JOIN Locations LOC ON LOC.LocationId = CMS.LocationId    
                        LEFT OUTER JOIN Pharmacies Ph ON Ph.PharmacyId = CMS.PharmacyId    
                WHERE   CMS.OrderingPrescriberId = @StaffId    
                        AND CMS.CreatedBy <> S.UserCode                                 
  --Following changes by Sonia/Devinder Ref Ticket #3 Comments Dated 12/27/2009 3:13:57 AM by Munish                                               
  --and isnull(CMS.WaitingPrescriberApproval,'N')='Y' and ISNULL(CMS.VerbalOrderApproved,'N')<>'Y'                 
  --Commented and modified by Anuj as per new specifications                                                   
  --and  ISNULL(CMS.VerbalOrderApproved,'N')='N' and  ISNULL(CMS.WaitingPrescriberApproval,'N')='Y'                  
  --Ended over here                
                        AND ISNULL(CMS.VerbalOrderApproved, 'N') = 'N'    
                        AND ISNULL(CMS.WaitingPrescriberApproval, 'N') = 'N'    
                        AND @VerbalOrdersRequireApproval = 'Y'    
                        AND ISNULL(CMS.RecordDeleted, 'N') = 'N'    
                        AND ISNULL(CMS.Voided, 'N') = 'N'    
                        AND ISNULL(CMI.Active, 'Y') = 'Y'    
                ORDER BY CMS.ClientMedicationScriptId    
 -- 16 Oct 2018 Vinay K S             
            
          SELECT   DISTINCT    
                        CMS.ClientMedicationScriptId ,    
                        CM.ClientMedicationId,    
                        CMS.ClientId,    
                        CMS.RecordDeleted     
                FROM    ClientMedicationScripts CMS    
                        INNER JOIN Clients C ON C.ClientId = CMS.ClientId    
                                                AND ISNULL(C.RecordDeleted,    
                                                           'N') <> 'Y'    
                        INNER JOIN Staff S ON S.StaffId = CMS.OrderingPrescriberId    
                                              AND S.StaffId = @StaffId    
                        join StaffClients sc on sc.StaffId = @StaffId
                                  and sc.ClientId = CMS.ClientId  
                        INNER JOIN Staff ST ON ST.UserCode = CMS.CreatedBy    
                        INNER JOIN ClientMedicationScriptDrugs CMSD ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId    
                        INNER JOIN ClientMedicationInstructions CMI ON CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
                        and  ISNULL(CMI.Active, 'Y') = 'Y'    
                        INNER JOIN ClientMedications CM ON CM.ClientMedicationId = CMI.ClientMedicationId    
                                                           AND ISNULL(CM.Discontinued,    
                                                              'N') <> 'Y'    
                        LEFT OUTER JOIN MDMedications ON MDMedications.MedicationId = CMI.StrengthId    
                                                         AND ISNULL(CMI.RecordDeleted,    
                                                              'N') <> 'Y'    
                                                         AND ISNULL(dbo.MDMedications.RecordDeleted,    
                                                              'N') <> 'Y'    
                        LEFT OUTER JOIN MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId    
                                                   AND ISNULL(dbo.MDDrugs.RecordDeleted,    
                                                              'N') <> 'Y'    
                        INNER JOIN Locations LOC ON LOC.LocationId = CMS.LocationId    
                        LEFT OUTER JOIN Pharmacies Ph ON Ph.PharmacyId = CMS.PharmacyId                                                       
                WHERE   CMS.OrderingPrescriberId = @StaffId
						AND CMS.CreatedBy <> S.UserCode 
                       AND ISNULL(CMS.WaitingPrescriberApproval,'N') = 'N'    
                        AND ISNULL(CMS.RecordDeleted, 'N') = 'N'    
                        AND ISNULL(CMS.Voided, 'N') = 'N'    
                        AND ISNULL(CMI.Active, 'Y') = 'Y'    
                ORDER BY CMS.ClientMedicationScriptId           
                  
             SELECT distinct  cma.ClientMedicationInteractionId ,      
                            cma.ClientMedicationId1 ,      
                            cma.ClientMedicationId2 ,      
                            CASE WHEN ddo.DrugDrugInteractionOverrideId IS NOT NULL      
                                 THEN LEFT(CAST(ddo.AdjustedSeverityLevel AS VARCHAR),      
                                           1)      
                                 ELSE cma.InteractionLevel      
                            END AS InteractionLevel ,      
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
                            CM2.MedicationNameId AS MedicationNameId2 ,      
                            MDN1.MedicationName AS ClientMedicationId1Name ,      
                            MDN2.MedicationName AS ClientMedicationId2Name      
                             ,null as Color    
                   FROM     ClientMedications CM      
                            JOIN ClientMedicationInstructions CMI ON ( CM.ClientMedicationId = CMI.ClientMedicationId      
                                                              AND ISNULL(CMI.RecordDeleted,      
                                                              'N') <> 'Y'      AND ISNULL(CMI.Active,'Y')='Y'
                                                              )    
                                                              and  ISNULL(CMI.Active, 'Y') = 'Y'      
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
                            LEFT OUTER JOIN DrugDrugInteractionOverrides AS ddo ON ( ( ddo.MedicationNameId1 = MDN1.MedicationNameId      
                                                              AND ddo.MedicationNameId2 = MDN2.MedicationNameId      
                                                              )      
                                                              OR ( ddo.MedicationNameId1 = MDN2.MedicationNameId      
                                                              AND ddo.MedicationNameId2 = MDN1.MedicationNameId      
                                                              )      
                                                              )      
                                                              AND ( ( ddo.Degree IS NULL )      
                                                              OR ( ddo.Degree = ISNULL(@StaffDegree,      
                                                              -1) )      
                                                              )      
                                                              AND ( ( ddo.PrescriberId IS NULL )      
                                                              OR ( ddo.PrescriberId = ISNULL(@StaffId,      
                                                              -1) )      
                                                              )      
                                                              AND ( ( ddo.Specialty IS NULL )      
                                                              OR ( ddo.Specialty = ISNULL(@TaxonomyCode,      
                                                              -1) )      
                                                              )      
                                                              AND ISNULL(ddo.RecordDeleted,      
                                                              'N') <> 'Y'      
                   WHERE    ISNULL(cm.discontinued, 'N') <> 'Y'      
                            AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'      
                            AND ISNULL(CMI.Active, 'Y') = 'Y'    
                            Order by cma.ClientMedicationId1        
--End 16 Oct 2018 Vinay K S                                                                     
            END                                                        
        ELSE     
            BEGIN                                                        
                SELECT   DISTINCT    
                        CMS.ClientMedicationScriptId ,    
                        CMS.ClientId ,    
                        ScriptEventType ,    
                        ScriptCreationDate ,    
                        OrderDate ,    
                        OrderingMethod ,    
                        PrintDrugInformation ,    
                        OrderingPrescriberId ,    
                        OrderingPrescriberName ,    
                        WaitingPrescriberApproval ,    
                        VerbalOrderApproved ,    
                        SureScriptsRefillRequestId ,    
                        SureScriptsRefillRequestsArchiveId ,    
                        CMS.RowIdentifier ,    
                        CMS.CreatedBy ,    
                        ST.LastName + ',' + ST.FirstName AS CreatedByName ,    
                        CMS.CreatedDate ,    
                        CMS.ModifiedBy ,    
                        CMS.ModifiedDate ,    
                        CMS.RecordDeleted ,    
                        CMS.DeletedDate ,    
                        CMS.DeletedBy ,    
                        C.FirstName ,    
                        C.LastName ,    
                        CONVERT(VARCHAR, C.DOB, 101) AS DOB ,    
                        S.UserCode ,                                                        
  --CM.ClientMedicationId ,                                                       
  --Modified by Loveena in ref to Task#25                                        
  --LOC.PrescribingLocation ,                                                      
                        LOC.LocationName ,    
                        Ph.PharmacyName ,                                                  
  -- Added by Loveena                                                  
                        CMS.LocationId ,    
                        CMS.PharmacyId ,    
                        CMS.PrescriberReviewDateTime ,    
                        CMS.WaitingPrescriberApproval ,    
                        CMS.VerbalOrderApproved ,    
                        CMS.Voided ,    
                        CMS.VoidedBy ,    
                        CMS.VoidedReason ,                                     
      CMS.PlanName,    
      VerbalOrderReadBack,                                               
                    ISNULL(MDDrugs.DEACODE,'0') as DrugCategory                                            
                FROM    ClientMedicationScripts CMS    
                 join StaffClients sc on sc.StaffId = @StaffId
                                  and sc.ClientId = CMS.ClientId 
                        INNER JOIN Clients C ON C.ClientId = CMS.ClientId    
                                                AND ISNULL(C.RecordDeleted,    
                                                           'N') <> 'Y'    
                        INNER JOIN Staff S ON S.StaffId = CMS.OrderingPrescriberId    
                                              AND S.StaffId = @StaffId    
                        INNER JOIN Staff ST ON ST.UserCode = CMS.CreatedBy    
                        INNER JOIN ClientMedicationScriptDrugs CMSD ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId    
                        INNER JOIN ClientMedicationInstructions CMI ON CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
                        and  ISNULL(CMI.Active, 'Y') = 'Y'    
                        INNER JOIN ClientMedications CM ON CM.ClientMedicationId = CMI.ClientMedicationId    
                                                           AND ISNULL(CM.Discontinued,    
                                                              'N') <> 'Y'    
                        LEFT OUTER JOIN MDMedications ON MDMedications.MedicationId = CMI.StrengthId    
                                                         AND ISNULL(CMI.RecordDeleted,    
                                                              'N') <> 'Y'    
                                                         AND ISNULL(dbo.MDMedications.RecordDeleted,    
                                                              'N') <> 'Y'    
                        LEFT OUTER JOIN MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId    
                                                   AND ISNULL(dbo.MDDrugs.RecordDeleted,    
                                                              'N') <> 'Y'    
                        INNER JOIN Locations LOC ON LOC.LocationId = CMS.LocationId    
                        LEFT OUTER JOIN Pharmacies Ph ON Ph.PharmacyId = CMS.PharmacyId                                                       
  --Following Changes by Sonia/Devinder for Task #3 SDI FY10-Venture as per ace comment by Munish Sood after Chat with Javed dated 27th Dec 2009                                             
  --where ISNUll(CMS.WaitingPrescriberApproval,'N') = 'Y' and ISNULL(CMS.VerbalOrderApproved,'N')='Y' and ISNULL(CMS.RecordDeleted,'N')<>'Y'                                                        
  --Commented/Changed as per new specification on 12 March,2010                
   --where  CMS.OrderingPrescriberId = @StaffId and CMS.WaitingPrescriberApproval= 'N' --and ISNULL(CMS.VerbalOrderApproved,'N')='Y'                 
                WHERE   CMS.OrderingPrescriberId = @StaffId    
                        AND CMS.WaitingPrescriberApproval = 'Y'    
                        AND ISNULL(CMS.RecordDeleted, 'N') = 'N'    
                        AND ISNULL(CMS.Voided, 'N') = 'N'    
                        AND ISNULL(CMI.Active, 'Y') = 'Y'    
                ORDER BY CMS.ClientMedicationScriptId      
                    
 SELECT   DISTINCT    
                        CMS.ClientMedicationScriptId ,    
                        CM.ClientMedicationId,    
                        CMS.ClientId,    
                        CMS.RecordDeleted     
                FROM    ClientMedicationScripts CMS    
                join StaffClients sc on sc.StaffId = @StaffId
                                  and sc.ClientId = CMS.ClientId
                        INNER JOIN Clients C ON C.ClientId = CMS.ClientId    
                                                AND ISNULL(C.RecordDeleted,    
                                                           'N') <> 'Y'    
                        INNER JOIN Staff S ON S.StaffId = CMS.OrderingPrescriberId    
                                              AND S.StaffId = @StaffId    
                        INNER JOIN Staff ST ON ST.UserCode = CMS.CreatedBy    
                        INNER JOIN ClientMedicationScriptDrugs CMSD ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId    
                        INNER JOIN ClientMedicationInstructions CMI ON CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
                        and  ISNULL(CMI.Active, 'Y') = 'Y'    
                        INNER JOIN ClientMedications CM ON CM.ClientMedicationId = CMI.ClientMedicationId    
                                                           AND ISNULL(CM.Discontinued,    
                                                              'N') <> 'Y'    
                        LEFT OUTER JOIN MDMedications ON MDMedications.MedicationId = CMI.StrengthId    
                                                         AND ISNULL(CMI.RecordDeleted,    
                                                              'N') <> 'Y'    
                                                         AND ISNULL(dbo.MDMedications.RecordDeleted,    
                                                              'N') <> 'Y'    
                        LEFT OUTER JOIN MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId    
                                                   AND ISNULL(dbo.MDDrugs.RecordDeleted,    
                                                              'N') <> 'Y'    
                        INNER JOIN Locations LOC ON LOC.LocationId = CMS.LocationId    
                        LEFT OUTER JOIN Pharmacies Ph ON Ph.PharmacyId = CMS.PharmacyId                                                       
                WHERE   CMS.OrderingPrescriberId = @StaffId    
                        AND CMS.WaitingPrescriberApproval = 'Y'    
                        AND ISNULL(CMS.RecordDeleted, 'N') = 'N'    
                        AND ISNULL(CMS.Voided, 'N') = 'N'    
                        AND ISNULL(CMI.Active, 'Y') = 'Y'    
                ORDER BY CMS.ClientMedicationScriptId      
              
 SELECT distinct  cma.ClientMedicationInteractionId ,      
                            cma.ClientMedicationId1 ,      
                            cma.ClientMedicationId2 ,      
                            CASE WHEN ddo.DrugDrugInteractionOverrideId IS NOT NULL      
                                 THEN LEFT(CAST(ddo.AdjustedSeverityLevel AS VARCHAR),      
                                           1)      
                                 ELSE cma.InteractionLevel      
                            END AS InteractionLevel ,      
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
                            CM2.MedicationNameId AS MedicationNameId2 ,      
                            MDN1.MedicationName AS ClientMedicationId1Name ,      
                            MDN2.MedicationName AS ClientMedicationId2Name      
                             ,null as Color    
                   FROM     ClientMedications CM      
                            JOIN ClientMedicationInstructions CMI ON ( CM.ClientMedicationId = CMI.ClientMedicationId      
                                                              AND ISNULL(CMI.RecordDeleted,      
                                                              'N') <> 'Y'      
          )    
                                                              and  ISNULL(CMI.Active, 'Y') = 'Y'      
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
                            LEFT OUTER JOIN DrugDrugInteractionOverrides AS ddo ON ( ( ddo.MedicationNameId1 = MDN1.MedicationNameId      
                                                              AND ddo.MedicationNameId2 = MDN2.MedicationNameId      
                                                              )      
                                                              OR ( ddo.MedicationNameId1 = MDN2.MedicationNameId      
                                                              AND ddo.MedicationNameId2 = MDN1.MedicationNameId      
                                                              )      
                                                              )      
                                                              AND ( ( ddo.Degree IS NULL )      
                                                              OR ( ddo.Degree = ISNULL(@StaffDegree,      
                                                              -1) )      
                                                              )      
                                                              AND ( ( ddo.PrescriberId IS NULL )      
                                                              OR ( ddo.PrescriberId = ISNULL(@StaffId,      
                                                              -1) )      
                                                              )      
                                                              AND ( ( ddo.Specialty IS NULL )      
                                                              OR ( ddo.Specialty = ISNULL(@TaxonomyCode,      
                                                              -1) )      
                                                              )      
                                                              AND ISNULL(ddo.RecordDeleted,      
                                                              'N') <> 'Y'      
                   WHERE    ISNULL(cm.discontinued, 'N') <> 'Y'      
                            AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'      
                            AND ISNULL(CMI.Active, 'Y') = 'Y'    
                            Order by cma.ClientMedicationId1     
                                                    
            END                                                        
                                                                      
        IF ( @@error != 0 )     
            BEGIN                                                                                                  
                                                                                                  
                  RAISERROR('ssp_SCGetVerbalOrderReviewData : An error  occured', 16, 1);    
                       
                RETURN(1)                                                         
                                                                                                                                        
            END                                                                                                                                            
                                                                                                                  
    END 
GO
