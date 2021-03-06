/****** Object:  StoredProcedure [dbo].[csp_RdlTransferBrokerRequestedServices]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlTransferBrokerRequestedServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlTransferBrokerRequestedServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlTransferBrokerRequestedServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlTransferBrokerRequestedServices] 
(     
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010       
)     
AS       
      
Begin       
      
/*       
      
** Object Name: [csp_RdlTransferBrokerRequestedServices]       
      
**       
      
**       
      
** Notes: Accepts two parameters (DocumentId & Version) and returns a record set       
      
** which matches those parameters.       
      
**       
      
** Programmers Log:       
      
** Date Programmer Description       
      
**------------------------------------------------------------------------------------------       
      
** Get Data From CustomRequestedServices,ProcedureCodes       
      
** Nov 19 2007 Vikas Vyas      
** 01-23-2008 avoss --to enable sub report dataset to display results 
      
*/       
      
DECLARE @Requested nvarchar(10)       
      
DECLARE @CustomRequestedServices CURSOR       
      
DeClare @CodeName nvarchar(4000)      
      
SET @CustomRequestedServices  = CURSOR FAST_FORWARD       
      
FOR       
      
Select Requested from CustomRequestedServices  
--where ISNull(RecordDeleted,''N'')=''N'' and Documentid=@DocumentId and Version=@Version      
where ISNull(RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId       --Modified by Anuj Dated 03-May-2010 

OPEN @CustomRequestedServices       
      
FETCH NEXT FROM @CustomRequestedServices       
      
INTO @Requested      
      
WHILE @@FETCH_STATUS = 0       
       
BEGIN       
      
Select @CodeName = isnull(@CodeName,'''') + '','' + '' '' +  DisplayAs  
from ProcedureCodes where ProcedureCodeid=@Requested      
      
FETCH NEXT FROM @CustomRequestedServices       
      
INTO @Requested      
      
END       
      
CLOSE @CustomRequestedServices       
      
DEALLOCATE @CustomRequestedServices       
      
Select @CodeName = Substring(@CodeName,2,Len(rtrim(@CodeName)))    
    
Select @CodeName  as RequestedServices
      
      
      
--Checking For Errors       
      
If (@@error!=0)       
      
Begin       
      
RAISERROR 20006 ''csp_RdlTransferBrokerRequestedServices: An Error Occured''       
      
Return       
      
end

end
' 
END
GO
