/****** Object:  StoredProcedure [dbo].[csp_SCDeleteCustomDocuments]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteCustomDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteCustomDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteCustomDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCDeleteCustomDocuments]                                                                     
(                                                                      
 @DocumentVersionId as int,                                                                      
 @DocumentCodeId as int,                                                                    
 @DeletedBy as varchar(100)                                                                    
)                                                                      
AS                                                                      
/*********************************************************************/                                                                        
/* Stored Procedure: dbo.ssp_DeleteDocuments                */                                                                        
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC             */                                                                        
/* Creation Date:    04/28/09                                         */                                                                        
/*                                                                   */                                                                        
/* Purpose:   This procedure is used to Delete the documents for the passed DocumentId and DocumentCodeId */                                                                      
/*                                                                   */                                                                      
/* Input Parameters: @DocumentId,@DocumentCodeId              */                                                                      
/*                                                                   */                                                                        
/* Output Parameters:        */                                                                        
/*                                                                   */                                                                        
/* Return:  0=success, otherwise an error number                     */                                                                        
/*                                                                   */                                                                        
/* Called By:                                                        */                                                                        
/*                                                                   */                                                                        
/* Calls:                                                            */                                                                        
/*                                                                   */                                                                        
/* Data Modifications:                                               */                                                                        
/*                                                                   */                                                                        
/* Updates:                                                          */                                                                        
/*  Date     Author               Purpose                            */                                                                           
/* 04/28/09  Sonia Dhamija  Created (for Custom Documents Deletion Purpose)   */                                                            
/*********************************************************************/                                                                         
                                                                     
                                  
Begin                          
Begin try                                      
            
declare @CustomTables table              
(              
 tabName varchar(1000) not null              
)              
             
declare @execString varchar(2000)              
declare @tabList varchar(8000)              
declare @scanList varchar(8000)              
declare @valueString varchar(8000)              
declare @nextIdx int, @currIdx int              
declare @ServiceNote char(1)        
select @currIdx = 0, @nextIdx = 0, @valueString = ''''              
              
select @tabList=dc.TableList,@ServiceNote =isnull(dc.ServiceNote,''N'')              
from DocumentCodes as dc              
where DocumentCodeId = @DocumentCodeId              
              
if(@ServiceNote=''N'')        
BEGIN              
--Following added to Remove Documents and DocumentVersions from Table list              
 set @tabList = replace(@tabList, ''Documents,DocumentVersions,'', '' '')              
END        
ELSE        
BEGIN        
 set @tabList = replace(@tabList, ''Services,Documents,DocumentVersions,Appointments,ServiceErrors,ServiceGoals,ServiceObjectives,'', '' '')              
 set @tabList = replace(@tabList, ''CustomFieldsData'', '' '')              
      
END            
set @tabList = replace(@tabList, '' '', '''')              
if (@tabList is null) or (len(@tabList) = 0) return              
-- make sure string is comma-terminated              
set @scanList = @tabList + '',''              
              
set @nextIdx = charindex('','', @scanList, @currIdx + 1)              
while @nextIdx > 0              
begin              
 --print @nextIdx              
              
 if @nextIdx = @currIdx + 1 goto next_tab              
--print @currIdx              
 set @valueString = ltrim(rtrim(substring(@scanList, @currIdx + 1, @nextIdx - @currIdx - 1)))              
 insert into @CustomTables(tabName) values(@valueString)              
next_tab:              
 set @currIdx = @nextIdx              
 set @nextIdx = charindex('','', @scanList, @currIdx + 1)              
end              
              
select * from @CustomTables              
              
declare cCustomProcs cursor for              
select ''exec '' + ''csp_SCDeleteDocument'' + tabName              
from @CustomTables              
              
open cCustomProcs              
fetch cCustomProcs into @execString              
              
while @@fetch_status = 0              
begin              
 set @execString = @execString + '' '' + cast(@DocumentVersionId as varchar) + '', '''''' + @DeletedBy + ''''''''              
     
 print @execString             
 exec(@execString)              
              
 fetch cCustomProcs into @execString              
end              
              
close cCustomProcs              
              
deallocate cCustomProcs              
                
end try                                                      
                                                                                               
BEGIN CATCH                                                                                   
DECLARE @Error varchar(8000)                                                       
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteCustomWebDocuments'')                                                                                     
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
