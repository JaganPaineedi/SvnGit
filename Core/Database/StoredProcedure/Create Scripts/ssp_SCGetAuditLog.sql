IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuditLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAuditLog]
GO

CREATE PROCEDURE  [dbo].[ssp_SCGetAuditLog]               
 (  
 @PrimaryKey INT,  
 @TableName varchar(100)  
 )                                       
As                                                                                                                                                        
/************************************************************************/                                                                
/* Stored Procedure: ssp_SCGetAuditLog        */                                                       
/*        */                                                                
/* Creation Date:  13 september 2012           */                                                                
/*                  */                                                                
/* Purpose: Gets Data for Pcare and CLS task#10 of Allegan      */                                                               
/* Input Parameters: @DocumentVersionId        */                                                              
/* Output Parameters:             */                                                                
/* Purpose: to get AuditLog for Pcare task #10 Allegan        */                                                      
/* Calls:                */                                                                
/*                  */                                                                
/* Author: Atul Pandey             */  
/* 13/5/2015  Jayashree  changed CreatedDate to ModifiedDate w.r.t Allegan 3.5 Implementation task #306 */
/* 18/5/2015  Jayashree  Reverted the changes made on 13/5/2015 w.r.t Allegan 3.5 Implementation task #306 */

/*********************************************************************/                                                                                                                                            
BEGIN TRY                                       
BEGIN  
 DECLARE @DynamicQuery  NVARCHAR(4000)  
 CREATE TABLE #TempAuditLog   
 (  
  UserName VARCHAR(500),  
  ModifiedDate DATETIME  
 )  
  
 IF(@TableName = 'PersonalCareServicesAndCLSs')  
 BEGIN  
  INSERT INTO #TempAuditLog  
  SELECT ISNULL(  ST.LastName,'')+', '+  ISNULL( ST.FirstName,'') AS UserName  
      ,pc.CreatedDate as ModifiedDate  
      FROM PersonalCareServicesAndCLSs pc  
      INNER JOIN Staff ST on ST.UserCode = pc.CreatedBy  
      WHERE pc.PersonalCareServicesAndCLSId = @PrimaryKey  
 END  
 INSERT INTO #TempAuditLog  
 SELECT  
        ISNULL(  ST.LastName,'')+', '+  ISNULL( ST.FirstName,'') AS UserName  
      ,AL.NewValue as ModifiedDate   
 FROM AUDITLOG AL  
 INNER JOIN AuditLogTables ALT ON ALT.AuditLogTableId=AL.AuditLogTableId       
 INNER JOIN STAFF  ST ON AL.StaffId=ST.StaffId   
 WHERE AL.PrimaryKeyValue=@PrimaryKey  
 AND ALT.TableName=@TableName  
 ORDER BY AL.AuditLogId   
   
 SELECT UserName,ModifiedDate FROM #TempAuditLog  
   
 DROP TABLE #TempAuditLog  
   
END                                                                                          
 END TRY                                                                                                   
 BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetAuditLog')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                       
                                                                         
 END CATCH  
    