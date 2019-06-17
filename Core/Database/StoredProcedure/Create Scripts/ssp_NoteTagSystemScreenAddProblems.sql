/****** Object:  StoredProcedure [dbo].[ssp_NoteTagSystemScreenAddProblems]    Script Date: 04/05/2013 16:58:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_NoteTagSystemScreenAddProblems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_NoteTagSystemScreenAddProblems]
GO

/****** Object:  StoredProcedure [dbo].[ssp_NoteTagSystemScreenAddProblems]    Script Date: 04/05/2013 16:58:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************************/                    
-- Copyright: Streamline Healthcate Solutions                    
--                    
-- Purpose: Customization support for Reception list page depending on the custom filter selection.                    
--                    
-- Author:  Vaibhav khare                    
-- Date:    20 May 2011           
-- Jay Wheeler Changed to only pull records with a start date of today for ordered problems.             
--                    
-- *****History****                    
/* 2012-09-21   Vaibhav khare  Created          */       

--03 Sep  2015  vkhare			Modified for ICD10 changes                
/*********************************************************************************/      
    
CREATE PROCEDURE [dbo].[ssp_NoteTagSystemScreenAddProblems]     
/* 2013-03-21    New two parameters added by Deej. As per the discussion with Wasif*/    
 @ClientId INT      
 ,@DocumentId INT    
 ,@EffectiveDate DATETIME    
AS     
    
    BEGIN    
        
        DECLARE @ScreenId INT = 757    
      
        DECLARE @listStr VARCHAR(MAX)    
      
        SET @listStr = '^OpenMode=Popup' + '^popupWindowFeatures=dialogHeight: 500px; dialogWidth: 1030px;dialogTitle:Problems^' --New    
        SELECT  @listStr    
    
    END    
GO


