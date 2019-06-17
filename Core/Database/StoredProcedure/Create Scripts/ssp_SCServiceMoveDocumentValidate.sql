IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCServiceMoveDocumentValidate')
	BEGIN
		DROP  Procedure  ssp_SCServiceMoveDocumentValidate
	END

GO

Create procedure [dbo].[ssp_SCServiceMoveDocumentValidate] --1284296,1284297,92                                     
(                                          
 @ServiceIdTo int,                               
 @ServiceIdFrom int,                              
 @StaffId int                                        
)                                  
                              
/*********************************************************************                                          
-- Stored Procedure: dbo.ssp_SCServiceMoveDocumentValidate                                          
--                                          
-- Copyright: 2010 Streamline Healthcare Solutions                                          
--                                          
-- Purpose: Rules For Moving Service Documents.                                          
--                                          
--                                          
-- Updates:                                           
-- Date---------Author--------Purpose-----------------------------------          
-- 25 Feb 2013  SunilKh       Validation for Moving Documents        
--                  
**********************************************************************/                                                           
     
as                              
declare @UserCode varchar(30)                              
declare @DocumentIdTo int                              
declare @DocumentCodeIdTo int                              
declare @ClientIdTo int                              
declare @AuthorIdTo int                              
declare @DocumentIdFrom int                              
declare @DocumentCodeIdFrom int                              
declare @ClientIdFrom int                              
declare @AuthorIdFrom int                              
declare @Return int                              
declare @ErrorMessage varchar(max)    
declare @DocumentStatusTo int   
declare @DocumentStatusFrom int    
declare @ServiceStatusFrom int                        
                              
                              
--Find Staff's UserCode                              
Set @UserCode = (Select UserCode From Staff Where StaffId = @StaffId)                              
                           
create table #Errors                               
(Error varchar(200))                              
             
--Find DocumentId and Client information                              
Select @DocumentIdFrom = d.DocumentId,                              
 @DocumentCodeIdFrom = d.DocumentCodeId,                              
 @ClientIdFrom = d.ClientId,                              
 @ClientIdTo = s.ClientId,                              
 @AuthorIdTo = d.AuthorId,    
 @DocumentStatusFrom=d.CurrentversionStatus,   
 @ServiceStatusFrom=s.status                               
From Documents as d                              
Cross Join Services as s                              
where d.ServiceId = @ServiceIdFrom                              
and s.ServiceId =  d.ServiceId                             
and isnull(d.RecordDeleted, 'N')= 'N'                              
and isnull(s.RecordDeleted, 'N')= 'N'                              
                              
                              
--Find To Document Id and Author                              
Select @DocumentIdTo = d.DocumentId,                              
 @AuthorIdTo = d.AuthorId,                              
 @DocumentCodeIdTo = d.DocumentCodeId,     
 @DocumentStatusTo=d.CurrentversionStatus                           
From Documents as d                      
where d.ServiceId = @ServiceIdTo                              
and isnull(d.RecordDeleted, 'N')= 'N'         
     
  --Only Allow Documents to move in if the document status is not Signed.
If (isnull(@DocumentStatusTo, 0) <> 21  and isnull(@DocumentStatusTo, 0) <> 20)                               
Begin                               
 ------------------------------------------------------------      
     
   
 DECLARE @ERROR1 NVARCHAR(MAX)      
 Set @ERROR1=dbo.Ssf_GetMesageByMessageCode(31,'DOCSIGNED_SSP','The document associated with new service is signed.')      
 insert into #Errors (Error) values (@ERROR1)      
 ------------------------------------------------------------                            
 set @Return = 2                              
End     
    
  --Only Allow Services to move with the status=71 & 75 to be moved.                              
If (isnull(@ServiceStatusFrom, 0) <> 71 and isnull(@ServiceStatusFrom, 0) <> 75)    
Begin                               
 ------------------------------------------------------------      
    
 DECLARE @ERROR2 NVARCHAR(MAX)      
 Set @ERROR2=dbo.Ssf_GetMesageByMessageCode(31,'DOCSIGNED_SSP','The old service should be in a show or complete status and document must be signed.')      
 insert into #Errors (Error) values (@ERROR2)      
 ------------------------------------------------------------                            
 set @Return = 2                              
End      
         
  if(@ClientIdFrom!=@ClientIdTo)            
  BEGIN            
 ------------------------------------------------------------      
     
 DECLARE @ERROR5 NVARCHAR(MAX)      
 Set @ERROR5=dbo.Ssf_GetMesageByMessageCode(31,'CLIENTNOTMATCHED_SSP','Client associated with new service does not match the client associated with old service')      
 insert into #Errors (Error) values (@ERROR5)      
 ------------------------------------------------------------                             
  set @Return = 2              
  END            
                        
                              
--Only Allow Documents with the same DocumentCodeId to be moved.                              
If isnull(@DocumentCodeIdTo, 0) <> isnull(@DocumentCodeIdFrom, 0)                               
Begin                               
 ------------------------------------------------------------      
     
 DECLARE @ERROR3 NVARCHAR(MAX)      
 Set @ERROR3=dbo.Ssf_GetMesageByMessageCode(31,'DOCNOTMATCHED_SSP','Document associated with new service does not match old      
service')      
 insert into #Errors (Error) values (@ERROR3)      
 ------------------------------------------------------------                            
 set @Return = 2                              
End    
    
--Only Allow Documents with the status=signed '22' to be moved.                              
If isnull(@DocumentStatusFrom, 0) <> 22                               
Begin                               
 ------------------------------------------------------------      
     
 DECLARE @ERROR4 NVARCHAR(MAX)      
 Set @ERROR4=dbo.Ssf_GetMesageByMessageCode(31,'DOCNOTSIGNED_SSP','Document must be signed before moving it to a new service')      
 insert into #Errors (Error) values (@ERROR4)      
 ------------------------------------------------------------                            
 set @Return = 2                              
End                                     
                           
create table #validationReturnTable                  
(                                
TableName varchar(200),                                    
ColumnName varchar(200),                                    
ErrorMessage varchar(1000)                                
)                               
                              
-- Validate document move        
IF EXISTS (SELECT  1
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'csp_PMServiceMoveDocumentValidations')
                    AND type IN ( N'P', N'PC' ))   
BEGIN                        
exec csp_PMServiceMoveDocumentValidations @ServiceIdTo ,@ServiceIdFrom ,@StaffId , @DocumentIdTo ,                              
 @DocumentCodeIdTo ,@ClientIdTo , @AuthorIdTo , @DocumentIdFrom , @DocumentCodeIdFrom ,                              
 @ClientIdFrom ,  @AuthorIdFrom                                  
END
                              
if @@error <> 0 goto err_rollback                                  
                               
begin tran                                

if @@error <> 0 goto err_rollback                              
 select * from #Errors                         
commit tran                              
 return 0                              
                              
err_rollback:          
         select * from #Errors                   
rollback tran                              
                              
set @ErrorMessage = ''                              
