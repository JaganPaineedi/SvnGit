/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuditLogTables]    Script Date: 11/18/2011 16:25:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuditLogTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAuditLogTables]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuditLogTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE [dbo].[ssp_SCGetAuditLogTables]          
          
AS          
          
/*********************************************************************/                          
/* Stored Procedure: ssp_CMGetAuditLogTables            */                          
/* Copyright: 2005 Provider Claim Management System             */                          
/* Creation Date:  02 June 2009                                */                          
/*                                                                   */                          
/* Purpose: retuns list of Audit tables        */                         
/*                                                                   */                        
/* Input Parameters:                                         */                        
/*                                                                   */                          
/* Output Parameters:                                */                          
/*                                                                   */                          
/* Return: retuns list of Audit tables              */                          
/*                                                                   */                          
/* Called By:                                                        */                          
/*                                                                   */                          
/* Calls:                                                            */                          
/*                                                                   */                          
/* Data Modifications:                                               */                          
/*                                                                   */                          
/* Updates:                                                          */                          
/*  Date               Author                   Purpose              */                          
/* 14/12/2005    Chandan Srivastava       Created              */        
/*29/6/2015 jagan removed userid and rowidentifier from audit log, since those columns are nomore in auditlog table */                  
/*********************************************************************/                        
             
          
          
select AuditLogTableId,TableName from AuditLogTables          
where Isnull(RecordDeleted,''N'')<>''Y'' and Active=''Y''           
          
          
Select AuditLogId,AuditLogTableId,PrimaryKeyValue,StaffId,ColumnName,          
OldValue,NewValue,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,          
RecordDeleted,DeletedDate,DeletedBy from AuditLog          
where 1=2

select AuditLogColumnId,ColumnName,AuditLogColumns.AuditLogTableId,AuditLogLookupId,
ControlIdPrimary,ControlIdSecondary,AuditLogColumns.RowIdentifier,AuditLogColumns.CreatedBy,
AuditLogColumns.CreatedDate,AuditLogColumns.ModifiedBy,AuditLogColumns.ModifiedDate,          
AuditLogColumns.RecordDeleted,AuditLogColumns.DeletedDate,AuditLogColumns.DeletedBy from AuditLogColumns
join AuditLogTables on AuditLogTables.AuditLogTableId = AuditLogColumns.AuditLogTableId
where Isnull(AuditLogColumns.RecordDeleted,''N'')<>''Y''
          
IF (@@error!=0)                      
 BEGIN                      
        RAISERROR  20002  ''ssp_SCGetAuditLogTables: An Error Occured''                      
        RETURN                      
 END
' 
END
GO
