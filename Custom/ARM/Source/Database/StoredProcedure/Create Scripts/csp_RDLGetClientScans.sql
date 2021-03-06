/****** Object:  StoredProcedure [dbo].[csp_RDLGetClientScans]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetClientScans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetClientScans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetClientScans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[csp_RDLGetClientScans]         
 /* Param List */                                    
 @ClientId INT ,  
 @SelectedClientScanIds Varchar(4000)                                  
AS                                    
                                    
/******************************************************************************                                    
**  File:                                     
**  Name: csp_RDLGetClientScans                                   
**  Desc:                                     
**                                    
**  This template can be customized:                                    
**                                                  
**  Return values:                                    
**                                     
**  Called by:                                       
**                                                 
**  Parameters:                                    
**  Input       Output                                    
**  ----------  -----------                                    
**  @ClientId                    
**                    
**  Auth: Jaspreet Singh                                  
**  Date: 03-Jan-2008                                    
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:  Author:    Description:                                    
**  --------  --------    -------------------------------------------                                    
**                                        
*******************************************************************************/                                     
BEGIN TRY                      
 Declare @strSQL NVarchar(4000)  
 set @strSQL=''  
  SELECT  (SELECT OrganizationName FROM SystemConfigurations) AS OrganizationName,       
  C.LastName + '''', '''' + C.FirstName AS ClientName, CS.*       
  FROM ClientScans CS      
  INNER JOIN Clients C ON CS.ClientId=C.ClientId    
  WHERE CS.ClientId='' + cast(@ClientId as varchar) + '' AND ClientScanId in ('' + (@SelectedClientScanIds) + '')  
 AND IsNull(CS.RecordDeleted,''''N'''') <> ''''Y''''           
 ORDER BY ScanDate DESC,ClientScanId''      
 print @strSQL               
exec sp_executeSQL @strSQL                       
  
END TRY                      
BEGIN CATCH                          
 declare @Error varchar(8000)                          
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLGetClientScans'')                           
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                            
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
                            
 RAISERROR                           
 (                          
  @Error, -- Message text.                          
  16, -- Severity.                          
  1 -- State.                          
 );                          
                          
END CATCH
' 
END
GO
