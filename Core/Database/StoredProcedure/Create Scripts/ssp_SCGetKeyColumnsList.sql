/****** Object:  StoredProcedure [dbo].[ssp_SCGetKeyColumnsList]    Script Date: 10/14/2016 11:04:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetKeyColumnsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetKeyColumnsList]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetKeyColumnsList]    Script Date: 10/14/2016 11:04:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE PROCEDURE [dbo].[ssp_SCGetKeyColumnsList]    
AS    
 /********************************************************************************                                                                                                                  
-- Stored Procedure: ssp_SCGetTablesList    
--                                                                                                                  
-- Copyright: Streamline Healthcate Solutions                                                                                                                  
--                                                                                                                  
-- Purpose: To get the list of all userdefined tables in the database.    
-- Parameters:    
-- Input   : -                                                                                                                                                                                                                                    
-- Author:  Raghu Mohindru                                                                                                          
-- Creation Date: May 24,2012    
-- Modified By:Rachna Singh to bring the records on specific condition.   
-- Modified By: Vijeta Sinha to put screen filter in the page   
*********************************************************************************/     
BEGIN    
 BEGIN TRY    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
select [KEY],SystemConfigurationKeyId,ShowKeyForViewingAndEditing from SystemConfigurationKeys where [KEY] NOT IN ('EndUserMonitoringFilePath','EndUserMonitoringEnabled')order by [KEY] --AND ShowKeyForViewingAndEditing='y' ---commented by vsinha
    
select DISTINCT ModuleId, ModuleName from Modules where ISNULL(RecordDeleted,'N')='N' order by ModuleName   
 END TRY                                        
 BEGIN CATCH                                                    
 DECLARE @Error varchar(8000)                                                                      
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetKeyColumnsList')                                            
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                                                      
                                                                     
    RAISERROR                                                                       
    (                                                            
  @Error, -- Message text.                                                                      
  16, -- Severity.                                                                      
  1 -- State.                                                                      
    );                                                       
 End CATCH                                                                                                             
                                                 
    
END 

GO


