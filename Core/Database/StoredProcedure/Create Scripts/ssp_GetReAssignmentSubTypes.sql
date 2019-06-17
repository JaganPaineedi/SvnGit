/****** Object:  StoredProcedure [dbo].[ssp_GetReAssignmentSubTypes]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetReAssignmentSubTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetReAssignmentSubTypes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetReAssignmentSubTypes]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                                
**  File: ssp_GetReAssignmentSubTypes                                            
**  Name: ssp_GetReAssignmentSubTypes                        
**  Desc: To Get ReAssignment SubTypes                                           
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  April 20 2017
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
10 Aug 2017 Kavya -- 1. Differentiate ORDERS with ORDERASSIGNED and ORDERSAUTHOR, 2. Hard coded Rx AssignmentSubTypeText #Thresholds - Support: #825.1
--*******************************************************************************/                                   
CREATE PROCEDURE  [dbo].[ssp_GetReAssignmentSubTypes]                                                                   
(                                                                                                                                                           
  @AssignmentTypeId int,
  @AssignmentSubTypeText varchar (200) = null                                                                     
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY   
   
   DECLARE @AssignmentTypeCode varchar (100) 
   
  Select Top 1 @AssignmentTypeCode =  Code from GlobalCodes Where globalcodeid = @AssignmentTypeId AND Category = 'ASSIGNMENTTYPES'
  
  IF(@AssignmentTypeCode = 'FLAG')
  BEGIN
  select FlagTypeId as ItemId, FlagType as ItemName from FlagTypes Where Active = 'Y' 
  AND (isnull(FlagType, '') = '' or FlagType like '%'+ @AssignmentSubTypeText + '%') AND isnull(RecordDeleted, 'N') = 'N'
  END
  ELSE  IF(@AssignmentTypeCode = 'PROGRAM')
  BEGIN
	select ProgramId as ItemId, ProgramName as ItemName  from Programs Where Active = 'Y' 
	 AND (isnull(ProgramName, '') = '' or ProgramName like '%'+ @AssignmentSubTypeText + '%') AND isnull(RecordDeleted, 'N') = 'N'
  END
    ELSE  IF(@AssignmentTypeCode = 'DOCUMENTS' OR @AssignmentTypeCode = 'DOCUMENTSINPROGRESS' OR @AssignmentTypeCode = 'DOCUMENTSTODO' OR @AssignmentTypeCode = 'DOCUMENTSTOSIGN' OR @AssignmentTypeCode = 'DOCUMENTSTOCOSIGN' OR @AssignmentTypeCode = 'DOCUMENTSTOACKNOWLEDGE' OR @AssignmentTypeCode = 'DOCUMENTSTOBEREVIEWED')
  BEGIN
	
	select DC.DocumentCodeId as ItemId, DC.DocumentName as ItemName  from DocumentCodes DC
	 Where  DC.Active = 'Y' AND DC.ServiceNote <> 'Y' 
	  AND (isnull(DC.DocumentName, '') = '' or DC.DocumentName like '%'+ @AssignmentSubTypeText + '%') AND isnull(DC.RecordDeleted, 'N') = 'N'
	 AND DC.DocumentCodeId  NOT in (SELECT ISNULL(ET.AssociatedDocumentCodeId, -1) from EventTypes ET where isnull(ET.RecordDeleted, 'N') = 'N')
	
  END
   ELSE  IF(@AssignmentTypeCode = 'EVENTS')
  BEGIN
	
	select DC.DocumentCodeId as ItemId, DC.DocumentName as ItemName  from DocumentCodes DC
	 Where  DC.Active = 'Y' 
	  AND (isnull(DC.DocumentName, '') = '' or DC.DocumentName like '%'+ @AssignmentSubTypeText + '%') AND isnull(DC.RecordDeleted, 'N') = 'N'
	 AND DC.DocumentCodeId  in (SELECT ISNULL(ET.AssociatedDocumentCodeId, -1) from EventTypes ET where isnull(ET.RecordDeleted, 'N') = 'N')
	
  END
   ELSE  IF(@AssignmentTypeCode = 'ORDERSASSIGNED' OR @AssignmentTypeCode = 'ORDERSAUTHOR')--Differentiated ORDERS with ORDERASSIGNED and ORDERSAUTHOR #Thresholds - Support: #825.1-Kavya
  BEGIN
	
	select GlobalCodeId as ItemId, CodeName as ItemName from globalcodes where category = 'ORDERTYPE' AND Active = 'Y' 
	AND (isnull(CodeName, '') = '' or CodeName like '%'+ @AssignmentSubTypeText + '%') AND isnull(RecordDeleted, 'N') = 'N'
	
  END
   ELSE  IF(@AssignmentTypeCode = 'Rx')
  BEGIN
  
   -- RX (To get verbal order approval)
--Hard coded Rx AssignmentSubTypeText  #Thresholds - Support: #825.1--Kavya
Declare @VerbalOrdersRequireApproval char                                      
select @VerbalOrdersRequireApproval= VerbalOrdersRequireApproval from SystemConfigurations  

 
if(@AssignmentSubTypeText like '%ver%')
begin 
select 1 as ItemId, 'Verbal Order' as  ItemName
end

if(@AssignmentSubTypeText like '%que%')
begin 
select 2 as ItemId, 'Queued Order' as  ItemName
end


 -- Select MMN.MedicationNameId as ItemId, MMN.MedicationName as ItemName           
 --from ClientMedicationScripts  CMS                      
 --inner join Clients C on C.ClientId = CMS.ClientId and   ISNULL(C.RecordDeleted,'N')<>'Y'                  
 --inner Join Staff S on S.StaffId = CMS.OrderingPrescriberId                                                    
 --INNER JOIN ClientMedicationScriptDrugs CMSD on CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId                                                        
 --inner join ClientMedicationInstructions CMI on CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId      
 --AND ISNULL(CMI.Active, 'Y') = 'Y'                                                  
 --inner Join Staff ST on ST.UserCode = CMS.CreatedBy                                                      
 --inner join ClientMedications CM on CM.ClientMedicationId = CMI.ClientMedicationId and isnull(CM.Discontinued,'N')<>'Y'                                                            
 --left outer JOIN  MDMedications on MDMedications.MedicationId = CMI.StrengthId AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y' and ISNULL(dbo.MDMedications.RecordDeleted, 'N') <> 'Y'                                                   
 --left outer JOIN  MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  AND ISNULL(dbo.MDDrugs.RecordDeleted, 'N') <> 'Y'                                                       
 --inner join Locations LOC on LOC.LocationId=CMS.LocationId                                                         
 --left outer join Pharmacies Ph on Ph.PharmacyId= CMS.PharmacyId   
 --inner join MDMedicationNames MMN on MMN.MedicationNameId = MDMedications.MedicationNameId AND ISNULL(MMN.RecordDeleted, 'N') <> 'Y'                                        
                                                     
 --where ISNULL(CMS.VerbalOrderApproved,'N')='N' and  ISNULL(CMS.WaitingPrescriberApproval,'N')='N'    
 --AND (isnull(MMN.MedicationName, '') = '' or MMN.MedicationName like '%'+ @AssignmentSubTypeText + '%')  
 --and @VerbalOrdersRequireApproval='Y'                 
 --and ISNULL(CMS.RecordDeleted,'N')='N'  
 --AND ISNULL(CMS.Voided, 'N') = 'N'   
 --AND ISNULL(CMI.Active, 'Y') = 'Y'  
 ----AND (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'RX')
  
 -- UNION         
 --   -- To get Rx (Queued Orders)         
 -- Select MMN.MedicationNameId as ItemId, MMN.MedicationName as ItemName                     
 --from ClientMedicationScripts  CMS                                                      
 --inner join Clients C on C.ClientId = CMS.ClientId  and ISNULL(C.RecordDeleted,'N')<>'Y'                                                      
 --inner Join Staff S on S.StaffId = CMS.OrderingPrescriberId                                                    
 --inner Join Staff ST on ST.UserCode = CMS.CreatedBy                            
 --INNER JOIN ClientMedicationScriptDrugs CMSD on CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId                                                      
 --inner join ClientMedicationInstructions CMI on CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId         
 -- AND ISNULL(CMI.Active, 'Y') = 'Y'                                                
 --inner join ClientMedications CM on CM.ClientMedicationId = CMI.ClientMedicationId and isnull(CM.Discontinued,'N')<>'Y'                                                 
 --left outer JOIN  MDMedications on MDMedications.MedicationId = CMI.StrengthId AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y' and ISNULL(dbo.MDMedications.RecordDeleted, 'N') <> 'Y'                                                 
 --left outer JOIN  MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  AND ISNULL(dbo.MDDrugs.RecordDeleted, 'N') <> 'Y'                                                                     
 --inner join Locations LOC on LOC.LocationId=CMS.LocationId                                                       
 --left outer join Pharmacies Ph on Ph.PharmacyId= CMS.PharmacyId  
 --inner join MDMedicationNames MMN on MMN.MedicationNameId = MDMedications.MedicationNameId AND ISNULL(MMN.RecordDeleted, 'N') <> 'Y'                                                     
                    
 --where CMS.WaitingPrescriberApproval= 'Y' --and ISNULL(CMS.VerbalOrderApproved,'N')='Y'      
 -- AND (isnull(MMN.MedicationName, '') = '' or MMN.MedicationName like '%'+ @AssignmentSubTypeText + '%')        
 --and ISNULL(CMS.RecordDeleted,'N')='N'                                                      
 --AND ISNULL(CMS.Voided, 'N') = 'N'                      
 -- AND ISNULL(CMI.Active, 'Y') = 'Y'   
	--/****** Starts :  Select statement need to write for RX- Verbal and Queued orders ***************/
	----select -1 as ItemId, '' as ItemName where 1 = 0	
	--/****** Ends :  Select statement need to write for RX- Verbal and Queued orders ***************/
END
   ELSE 
  BEGIN
	
	select -1 as ItemId, '' as ItemName where 1 = 0
	
  END
	
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_GetReAssignmentSubTypes]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO


