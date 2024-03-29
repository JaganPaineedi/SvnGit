/****** Object:  StoredProcedure [dbo].[ssp_SCGetCountQueuedVerbalOrderData]    Script Date: 11/18/2011 16:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCountQueuedVerbalOrderData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCountQueuedVerbalOrderData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCountQueuedVerbalOrderData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[ssp_SCGetCountQueuedVerbalOrderData]               
(                                                                                                                                                                             
 @PrescriberId int                                                          
                                                                                                                                                                               
)                                                                                                                                                                                          
As                           
                      
BEGIN TRY                    
/*********************************************************************/                                                          
/* Stored Procedure: [ssp_SCGetCountQueuedVerbalOrderData]                   */                                                          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                          
/* Creation Date:  28 Oct 2009                                       */                                                          
/*                                                                   */                                                          
/* Purpose: Validate Review Prescriptions                         */                                                         
/*                                                                   */                                                        
/* Input Parameters: @PrescriberId           */                                                        
/*                                                                   */                                                          
/* Return:scalar value for show the prescription      */                                                          
/*                                                                   */                                                          
/* Called By:                                                        */                                                          
/*                                                                   */                                                          
/* Calls:                                                            */                                                          
/*                                                                   */                                                          
/* Data Modifications:                                               */                                                          
/*                                                                   */                                                          
/* Updates:                                                          */                                                          
/*  Date        Author     Purpose       */                                                          
/* 28/10/2009  Priya       Created       */   
/* 13 Nov 2015	Vithobha	added ISNULL(CMS.Voided, ''N'') = ''N'' condition, Valley - Customizations: #65 Queued Orders - Cancel    */  
/* 21 Jan 2016  Malathi shiva           as part of Summit Pointe : Task# 703 - VerbalOrderReadBack column was added into ClientMedicationScripts table which is supposed be added in this sp since we have the table mentioned      */                        
/* 29 Jan 2016  Malathi shiva           as part of Valley - Customizations : Task# 68 - On ajustting a Queued Order it should allow to modify and create the new order and queue the same order. Added Active Check to ClientMedicationInstructions becuase on adjusting an order the order order is set to Active=N and a new order is queued.      */                        
/* 11 Dec 2018            Jyothi             What/Why:Journey-Support Go Live-#1566 - If Client doesnot have access to client,respective client records will not show. */

/*********************************************************************/                           
Declare @VerbalOrdersRequireApproval char,                  
@OrderCount int                     
                    
set @OrderCount= 0                          
                      
                      
select @VerbalOrdersRequireApproval= VerbalOrdersRequireApproval from SystemConfigurations                       
   --print  @VerbalOrdersRequireApproval                
                 
 select                                                         
 count(distinct CMS.ClientMedicationScriptId) as [Count] ,@VerbalOrdersRequireApproval as VerbalOrdersRequireApproval  ,''V'' as OrderType                 
 from ClientMedicationScripts  CMS                    
 inner join Clients C on C.ClientId = CMS.ClientId and   ISNULL(C.RecordDeleted,''N'')<>''Y''                
 inner Join Staff S on S.StaffId = CMS.OrderingPrescriberId and S.StaffId = @PrescriberId  
  join StaffClients sc on sc.StaffId = @PrescriberId and sc.ClientId = CMS.ClientId                                                     
 INNER JOIN ClientMedicationScriptDrugs CMSD on CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId                                                      
 inner join ClientMedicationInstructions CMI on CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
 AND ISNULL(CMI.Active, ''Y'') = ''Y''                                                
 inner Join Staff ST on ST.UserCode = CMS.CreatedBy                                                    
 inner join ClientMedications CM on CM.ClientMedicationId = CMI.ClientMedicationId and isnull(CM.Discontinued,''N'')<>''Y''                                                          
 left outer JOIN  MDMedications on MDMedications.MedicationId = CMI.StrengthId AND ISNULL(CMI.RecordDeleted, ''N'') <> ''Y'' and ISNULL(dbo.MDMedications.RecordDeleted, ''N'') <> ''Y''                                                 
 left outer JOIN  MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  AND ISNULL(dbo.MDDrugs.RecordDeleted, ''N'') <> ''Y''                                                     
 inner join Locations LOC on LOC.LocationId=CMS.LocationId                                                       
 left outer join Pharmacies Ph on Ph.PharmacyId= CMS.PharmacyId                                                  
                                                   
 where CMS.OrderingPrescriberId = @PrescriberId                                                       
 and CMS.CreatedBy <> S.UserCode                           
 and  ISNULL(CMS.VerbalOrderApproved,''N'')=''N'' and  ISNULL(CMS.WaitingPrescriberApproval,''N'')=''N''    
 and @VerbalOrdersRequireApproval=''Y''               
 and ISNULL(CMS.RecordDeleted,''N'')=''N''
 AND ISNULL(CMS.Voided, ''N'') = ''N'' 
 AND ISNULL(CMI.Active, ''Y'') = ''Y''                  
Union                      
 select                                                         
 count(distinct CMS.ClientMedicationScriptId) as [Count],@VerbalOrdersRequireApproval as VerbalOrdersRequireApproval   ,''A'' as OrderType                      
 from ClientMedicationScripts  CMS                                                    
 inner join Clients C on C.ClientId = CMS.ClientId  and ISNULL(C.RecordDeleted,''N'')<>''Y''                                                    
 inner Join Staff S on S.StaffId = CMS.OrderingPrescriberId and S.StaffId = @PrescriberId                                                    
 inner Join Staff ST on ST.UserCode = CMS.CreatedBy   
  join StaffClients sc on sc.StaffId = @PrescriberId and sc.ClientId = CMS.ClientId                        
 INNER JOIN ClientMedicationScriptDrugs CMSD on CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId                                                    
 inner join ClientMedicationInstructions CMI on CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId       
  AND ISNULL(CMI.Active, ''Y'') = ''Y''                                              
 inner join ClientMedications CM on CM.ClientMedicationId = CMI.ClientMedicationId and isnull(CM.Discontinued,''N'')<>''Y''                                               
 left outer JOIN  MDMedications on MDMedications.MedicationId = CMI.StrengthId AND ISNULL(CMI.RecordDeleted, ''N'') <> ''Y'' and ISNULL(dbo.MDMedications.RecordDeleted, ''N'') <> ''Y''                                               
 left outer JOIN  MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  AND ISNULL(dbo.MDDrugs.RecordDeleted, ''N'') <> ''Y''                                                                   
 inner join Locations LOC on LOC.LocationId=CMS.LocationId                                                     
 left outer join Pharmacies Ph on Ph.PharmacyId= CMS.PharmacyId                                                   
                  
 where CMS.OrderingPrescriberId = @PrescriberId and            
CMS.WaitingPrescriberApproval= ''Y'' --and ISNULL(CMS.VerbalOrderApproved,''N'')=''Y''          
 and ISNULL(CMS.RecordDeleted,''N'')=''N''                                                    
 AND ISNULL(CMS.Voided, ''N'') = ''N''                    
  AND ISNULL(CMI.Active, ''Y'') = ''Y''                           
                         
  END TRY                                                        
BEGIN CATCH                                                        
 declare @Error varchar(8000)                                         
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                         
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCGetCountQueuedVerbalOrderData'')                                                         
 + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                          
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                        
                                   
 RAISERROR                                                        
 (                                
  @Error, -- Message text.                      
  16, -- Severity.                     
  1 -- State.                                                        
 );                                                        
                                                        
END CATCH
' 
END
GO
