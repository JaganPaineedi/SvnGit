/****** Object:  StoredProcedure [dbo].[csp_InitializeVerificationOutOfPocket]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeVerificationOutOfPocket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeVerificationOutOfPocket]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeVerificationOutOfPocket]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

    
CREATE Procedure [dbo].[csp_InitializeVerificationOutOfPocket]    
 @ClientID int,                
 @StaffID int,              
 @CustomParameters xml      
AS    
BEGIN    
 Begin try      
 	declare @ClientIdPrint varchar(100)
    Declare @ClientName varchar(500)    
    Declare @PrimaryInsName varchar(1000) 
    declare @PrimaryInsId varchar(100)   

    Declare @DocumentCodeId int    
    Declare @idoc int    
    Declare @TemplateText varchar(max)    
        
    --Setting value for custom Parameters    
    select  @ClientIdPrint = CAST(@ClientId as varchar), @ClientName= (ISNULL(FirstName, '''') + '' '' + ISNULL(LastName, ''''))
    from Clients where ClientId =@ClientID    
 
	select top 1 @PrimaryInsName = cp.DisplayAs, @PrimaryInsId = ccp.InsuredId
	from dbo.ClientCoveragePlans as ccp
	join dbo.CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId
	join dbo.ClientCoverageHistory as cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
	where ccp.ClientId = @ClientID
	and DATEDIFF(DAY, cch.StartDate, GETDATE()) >= 0
	and ((cch.EndDate is null) or (DATEDIFF(DAY, cch.EndDate, GETDATE()) <= 0))
	and ISNULL(ccp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(cch.RecordDeleted, ''N'') <> ''Y''
	order by cch.COBOrder
 
	if @PrimaryInsName is null set @PrimaryInsName = ''''
	if @PrimaryInsId is null set @PrimaryInsId = ''''
	
    set @DocumentCodeId=0;    
    exec sp_xml_preparedocument @idoc output, @CustomParameters    
        
    select @DocumentCodeId = DocumentCodeId    
	from openxml(@idoc, ''Root/Parameters'',1) with (DocumentCodeId  int  ''@DocumentCodeId'')    
     
 if(@DocumentCodeId!=0)
 begin
	select @TemplateText=TextTemplate from DocumentCodes where DocumentCodeId=@DocumentCodeId     

	select @TemplateText = REPLACE(@TemplateText,''<clientName>'', @ClientName)
	select @TemplateText = REPLACE(@TemplateText,''<ClientId>'', @ClientIdPrint)
	select @TemplateText = REPLACE(@TemplateText,''<PrimaryInsName>'',@PrimaryInsName)
	select @TemplateText = REPLACE(@TemplateText,''<PrimaryInsId>'',@PrimaryInsId)
	

end

Select TOP 1 ''TextDocuments'' AS TableName, -1 as ''DocumentVersionId''                  
,@TemplateText as TextData                        
,'''' as CreatedBy,                                
getdate() as CreatedDate,                                
'''' as ModifiedBy,                                
getdate() as ModifiedDate                                  
from systemconfigurations s left outer join TextDocuments                                                                                  
on s.Databaseversion = -1       
 end try                                                          
                                                                                                   
BEGIN CATCH        
DECLARE @Error varchar(8000)                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitializeVerificationOutOfPocket'')                                                                                         
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + ''*****'' + Convert(varchar,ERROR_STATE())                                      
 RAISERROR                                                                                         
 (       
  @Error, -- Message text.                                                                                        
  16, -- Severity.                                                            
  1 -- State.                                                                                        
 );                                                                                      
END CATCH                                     
END 

' 
END
GO
