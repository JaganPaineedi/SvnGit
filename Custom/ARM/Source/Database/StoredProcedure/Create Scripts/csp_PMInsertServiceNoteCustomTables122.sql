/****** Object:  StoredProcedure [dbo].[csp_PMInsertServiceNoteCustomTables122]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMInsertServiceNoteCustomTables122]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMInsertServiceNoteCustomTables122]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMInsertServiceNoteCustomTables122]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_PMInsertServiceNoteCustomTables122]               
(                  
 --@DocumentId as int,                  
 --@Version as int,         
 @DocumentVersionId  int,      
 @ServiceId int,      
 --@CurrentVersion int,           
 @UserCode as varchar(50)      
)                  
As        
/******************************************************************************          
**  File: MSDE.cs          
**  Name: csp_SCGetServiceNoteCustomTables122       
**  Desc: This fetches data for Service Note Custom Tables         
**  Copyright: 2006 Streamline HealthCare                                    
**          
**  This template can be customized:          
**                        
**  Return values:          
**           
**  Called by:         
**                        
**  Parameters:          
**  Input       Output          
**     ----------      -----------          
**   Insert/update Service Note Custom Tables        
**          
**  Auth: Rohit Verma          
**  Date: 26-May-09          
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:    Author:    Description:          
**  --------   --------   -------------------------------------------          
        
*******************************************************************************/             
BEGIN TRY        
      
 if  exists (                          
  select DocumentVersionId from CustomScreenForServices where  DocumentVersionId = @DocumentVersionId )
  --=(select DocumentId from Documents where ServiceId = @ServiceId  and isNull(RecordDeleted, ''N'') <> ''Y'') )    
begin                         
 update CustomScreenForServices set RecordDeleted=''N'',DeletedBy= NULL, DeletedDate=NULL  where DocumentVersionId = @DocumentVersionId                          
    end                         
else                                    
begin                        
                                   
insert into CustomScreenForServices (DocumentVersionId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)                                            
  values (@DocumentVersionId, @UserCode, getdate(), @UserCode, getdate())                                        
                                         
  end               
 if  exists (                          
  select DocumentVersionId from MentalStatus where  DocumentVersionId = @DocumentVersionId )
  --=(select DocumentId from Documents where ServiceId = @ServiceId  and isNull(RecordDeleted, ''N'') <> ''Y'') )    
begin                         
                      
 update MentalStatus set RecordDeleted=''N'',DeletedBy= NULL, DeletedDate=NULL  where DocumentVersionId = @DocumentVersionId                                                                 
end                      
else                      
begin                      
                      
insert into MentalStatus (DocumentVersionId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)                                            
  values (@DocumentVersionId, @UserCode, getdate(), @UserCode, getdate())                                        
           
                                        
end   

--Added By Vikas Vyas in ref. to task #1082
if  exists (                          
  select DocumentVersionId from CustomSubstanceUseAssessments where  DocumentVersionId=@DocumentVersionId
   and isNull(RecordDeleted, ''N'') <> ''Y'')
  Begin
   update CustomSubstanceUseAssessments set RecordDeleted=''N'',DeletedBy= NULL, DeletedDate=NULL  where DocumentVersionId = @DocumentVersionId 
  End
  else
  Begin
  insert into CustomSubstanceUseAssessments(DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)    
   values (@DocumentVersionId, @UserCode, getdate(), @UserCode, getdate())   
  End
  
  --Added By Vikas Vyas in ref. to task #1082
if  exists (select DocumentVersionId from DiagnosesIII where  DocumentVersionId=@DocumentVersionId
   and isNull(RecordDeleted, ''N'') <> ''Y'')
   Begin
    update DiagnosesIII set RecordDeleted=''N'',DeletedBy= NULL, DeletedDate=NULL  where DocumentVersionId = 
    @DocumentVersionId 
   End    
  else
  Begin
  insert into DiagnosesIII (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)    
   values (@DocumentVersionId, @UserCode, getdate(), @UserCode, getdate())   
  End
  
    --Added By Vikas Vyas in ref. to task #1082
if  exists (select DocumentVersionId from DiagnosesIV where  DocumentVersionId=@DocumentVersionId
   and isNull(RecordDeleted, ''N'') <> ''Y'')
   Begin
    update DiagnosesIV set RecordDeleted=''N'',DeletedBy= NULL, DeletedDate=NULL  where DocumentVersionId = 
    @DocumentVersionId 
   End    
  else
  Begin
  insert into DiagnosesIV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)    
   values (@DocumentVersionId, @UserCode, getdate(), @UserCode, getdate())   
  End
  
      --Added By Vikas Vyas in ref. to task #1082
if  exists (select DocumentVersionId from DiagnosesV where  DocumentVersionId=@DocumentVersionId
   and isNull(RecordDeleted, ''N'') <> ''Y'')
   Begin
    update DiagnosesV set RecordDeleted=''N'',DeletedBy= NULL, DeletedDate=NULL  where DocumentVersionId = 
    @DocumentVersionId 
   End    
  else
  Begin
  insert into DiagnosesV (DocumentVersionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)    
   values (@DocumentVersionId, @UserCode, getdate(), @UserCode, getdate())   
  End
  
           
END TRY          
        
BEGIN CATCH          
 declare @Error varchar(8000)          
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_PMInsertServiceNoteCustomTables122'')           
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())            
    + ''*****'' + Convert(varchar,ERROR_STATE())          
            
 RAISERROR           
 (          
  @Error, -- Message text.          
  16,  -- Severity.          
  1  -- State.          
 );          
        
END CATCH
' 
END
GO
