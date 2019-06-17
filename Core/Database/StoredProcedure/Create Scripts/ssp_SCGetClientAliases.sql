
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientAliases]    Script Date: 05/15/2013 18:09:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientAliases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientAliases]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientAliases]    Script Date: 05/15/2013 18:09:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SCGetClientAliases]
	@ClientId int
AS
BEGIN
	 BEGIN TRY 
	SELECT [ClientAliasId]    
      ,[ClientId]    
      ,[LastName]    
      ,[FirstName]    
      ,[MiddleName]    
      ,[AliasType]    
      ,[AllowSearch]    
      --,CA.[RowIdentifier]    
      ,CA.[CreatedBy]    
      ,CA.[CreatedDate]    
      ,CA.[ModifiedBy]    
      ,CA.[ModifiedDate]    
      ,CA.[RecordDeleted]    
      ,CA.[DeletedDate]    
      ,CA.[DeletedBy]    
      ,gc.CodeName as AliasTypeText    
      ,case CA.AllowSearch when 'Y' then 'Yes'     
       when 'N' then 'No'                                                                                          
       end AS AllowSearchText        
      ,LastNameSoundex    
      ,FirstNameSoundex                             
  FROM [ClientAliases] CA    
  Join GlobalCodes gc on CA.AliasType = gc.GlobalCodeId    
      
  WHERE (CA.ClientId = @ClientId) AND (CA.RecordDeleted = 'N' OR                                            
         CA.RecordDeleted IS NULL)                                                                   
                                     
  END TRY                                                      
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetClientAliases]')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                   
 RAISERROR                                                                                     
 (                                                       
  @Error, -- Message text.                                                                                    
  16, -- Severity.                                                                                    
  1 -- State.                                                                                    
 );                                                                                 
END CATCH    	
END

GO


