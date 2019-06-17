
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCListPageClientImmunizations]    Script Date: 06/13/2015 17:24:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListPageClientImmunizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCListPageClientImmunizations]
GO


GO

/****** Object:  StoredProcedure [dbo].[scsp_SCListPageClientImmunizations]    Script Date: 06/13/2015 17:24:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[scsp_SCListPageClientImmunizations]  
(  
 @ClientId int,      
@StaffId int,                
@LoggedInUserId int,
@RowSelectionList varchar(max), 
@OtherFilter int 
)  
 
/********************************************************************************    
-- Stored Procedure: dbo.scsp_SCListPageClientImmunizations      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 20-may-2014	 Revathi		What:Used in Client Immunizations List Page.          
--								Why:task #20 MeaningFul Use
*********************************************************************************/   
AS
BEGIN  
SELECT  null as ClientImmunizationId  
END

GO

