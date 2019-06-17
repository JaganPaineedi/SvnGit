/****** Object:  StoredProcedure [dbo].[scsp_ListPageSCAssociteDocumentList]    Script Date: 25/09/2017 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageSCAssociteDocumentList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPageSCAssociteDocumentList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageSCAssociteDocumentList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[scsp_ListPageSCAssociteDocumentList]           
@StatusFilter int,  
--@DueDaysFilter int,  
@OtherFilter int  
/********************************************************************************  
-- Stored Procedure: dbo.scsp_ListPageSCAssociteDocumentList  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: used by Client Documents list page to apply custom filters  
-- Called by: ssp_SCAssociateDocumentsListPage  
-- Task:#838 Threshold Enhancements
-- Updates:                                                         
-- Date        Author      Purpose  
-- 25/09/2017  Sunil.D     Created.        
--  
*********************************************************************************/  
as  
  
-- Join to the #ResultSet table populated in the parent stored procedure  
-- Retrieve only DocumentCodeId in the final Select statement  
  
select null as DocumentCodeId
' 
END
GO
