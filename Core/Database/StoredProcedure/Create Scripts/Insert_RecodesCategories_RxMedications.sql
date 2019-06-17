
/******************************************************************************         
** Name: Rx Medication Screen      
--       
-- Purpose: Script to create Recodes Category 'MEDICATIONVISITPROCEDURES' which is used in scsp_MMGetLastNextMedicationVisits in Medication - Patient Summary screen to pull in Medication Visit details. 
--        
-- Author:  Malathi Shiva       
-- Date:    30 May 2017        
--        
-- *****Histroy****        
**********************************************************************************/ 
  
IF NOT EXISTS(SELECT *
              FROM   RecodeCategories 
              WHERE  CategoryCode = 'MEDICATIONVISITPROCEDURES') 
  BEGIN 
      INSERT INTO RecodeCategories 
                  (CategoryCode,CategoryName,[Description],MappingEntity,RecodeType) 
      VALUES      ('MEDICATIONVISITPROCEDURES','MEDICATIONVISITPROCEDURES','Used in Medication - Pateient Summary to displat Medication Visits','ProcedureCodeId',8401) 
     
  END 
GO 

