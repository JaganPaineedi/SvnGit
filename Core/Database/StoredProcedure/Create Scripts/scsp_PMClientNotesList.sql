IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[scsp_PMClientNotesList]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[scsp_PMClientNotesList] 
 
go 
 
SET ansi_nulls ON 
 
go 
 
SET quoted_identifier ON 
 
go

CREATE PROCEDURE [dbo].[scsp_PMClientNotesList]  
/*********************************************************************************/  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: Customization support for Client Notes list page depending on the custom filter selection.  
--  
-- Author:  Girish Sanaba  
-- Date:    26 July 2011  
--  
-- *****History****  
-- ** 11-Apr-2012   MSuma  Modified NUll as -1   
-- 18 May 2016      Veena       What And Why: Adding workGroup EI #340  							

/*********************************************************************************/  
  
 @Active     CHAR(1),  
 @StartDate    DATETIME,  
 @NoteType    INT, 
  --Added by Veena on 05/18/2016   
 @WorkGroup   INT, 
 @ClientID    INT,  
 @OtherFilter   INT,  
 @StaffId    INT  
 
   
AS  
BEGIN   
  
 SELECT -1 AS ClientNoteId  
 RETURN  
  
END  