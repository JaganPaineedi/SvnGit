/****** Object:  StoredProcedure [dbo].[ssp_SCGetFormCollections]    Script Date: 11/18/2011 16:25:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFormCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFormCollections]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFormCollections]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================  
-- Author:  Shifali  
-- Create date: 10March,2011  
-- Description: To Fetch FormCollections  
-- =============================================  
CREATE PROCEDURE [dbo].[ssp_SCGetFormCollections]   
AS  
BEGIN  
 SELECT [FormCollectionId]  
      ,[NumberOfForms]       
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[FormCollectionName]
  FROM [FormCollections]  
END  ' 
END
GO
