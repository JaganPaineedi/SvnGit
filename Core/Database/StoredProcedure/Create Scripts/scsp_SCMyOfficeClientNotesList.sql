 IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[scsp_SCMyOfficeClientNotesList]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[scsp_SCMyOfficeClientNotesList] 
 
go 
 
SET ansi_nulls ON 
 
go 
 
SET quoted_identifier ON 
 
go

 CREATE PROCEDURE [dbo].[scsp_SCMyOfficeClientNotesList]    
/*********************************************************************************/    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Customization support for Client Notes list page depending on the custom filter selection.    
--    
-- Author:  Praveen Potnuru  
-- Date:    10 Jan 2014    
--  
-- 18 May 2016      Veena       What And Why: Adding workGroup EI #340  							
   
/*********************************************************************************/    
    
 @AssignedTo     INT,    
 @StartDate    DATETIME,    
 @NoteType    INT,
 --Added by Veena on 05/18/2016   
 @WorkGroup   INT, 
 @OtherFilter   INT,    
 @StaffId    INT    
     
AS    
BEGIN     
    
 SELECT -1 AS ClientNoteId    
 RETURN    
    
END    