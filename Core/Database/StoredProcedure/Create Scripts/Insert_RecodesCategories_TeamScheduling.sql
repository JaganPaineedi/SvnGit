
/******************************************************************************         
** Name: Team Scheduling Screen      
--       
-- Purpose: Script to create Recodes Category 'TeamScheduling7Days' 
-- Adding Saturday and Sunday in Team Scheduling screen.  - Texas Customizations #124
--        
-- Author:  Anto       
-- Date:    24 Oct 2017        
--        
-- *****Histroy**** 
  *Name*      *Date*                   *Purpose*  
  Anto        29/Nov/2018        Modified the script by updating the MappingEntity to ProgramId instead of ProcedureCodeId, as this was updated incorrectly in the initial script - Core Bugs #2686
**********************************************************************************/ 
  
IF NOT EXISTS(SELECT *
              FROM   RecodeCategories 
              WHERE  CategoryCode = 'TEAMSCHEDULING7DAYS') 
  BEGIN 
      INSERT INTO RecodeCategories 
                  (CategoryCode,CategoryName,[Description],MappingEntity,RecodeType) 
      VALUES      ('TEAMSCHEDULING7DAYS','TEAMSCHEDULING7DAYS','Used in Team Scheduling screen to display Saturday and Sunday','ProgramId',8401) 
     
  END 
  ELSE
   BEGIN 
      UPDATE RecodeCategories                  
      SET MappingEntity = 'ProgramId' WHERE  CategoryCode = 'TEAMSCHEDULING7DAYS'
     
  END 
GO 
