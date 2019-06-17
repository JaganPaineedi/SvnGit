IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCAutoUnlockallDocuments')
	BEGIN
		DROP  Procedure  ssp_SCAutoUnlockallDocuments
	END
GO      

/****** Object:  StoredProcedure [dbo].[ssp_SCAutoUnlockallDocuments]    Script Date: 5/28/2015 12:38:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO         
               
CREATE proc ssp_SCAutoUnlockallDocuments      -- 803405,92,'vl4yvwylmttx1c55pz2dxn45'      
@documentId int,              
@staffId int,              
@sessionId varchar(100)              
              
/****************************************************************************************/                                    
/* Stored Procedure: dbo.ssp_SCAutoUnlockallDocuments									*/                                    
/* Creation Date:  Dec 09 ,2011															*/                                    
/*																						*/                                    
/* Purpose: To Unlock The Document														*/                              
/*																						*/                                  
/* Input Parameters: @@sessionId, @DocumentId ,@staffId									*/                                  
/*																						*/                                    
/* Output Parameters:																	*/                                    
/*																						*/                                    
/*  Date        Author  Purpose															*/                                    
/* 09 Dec,2011  Karan   Created															*/               
/* 5/28/2015	Wasif	Modified - Philhaven - Customization Issues Tracking			*/
/*						1286 - Unlock documents failing - Quoted Identifier ON 			*/
/*																						*/              
/****************************************************************************************/                 
AS               
BEGIN              
 BEGIN TRY                
           
declare @UnsavedDocuments  table          
(              
UnsavedChangeId int,              
DocumentID int              
)              
declare @tabletotalUnsavedChanges    table           
(              
incrementId int identity (1,1) primary key,              
UnsavedChangeId int,              
ScreenProperties varchar(max)              
)              
              
insert into @tabletotalUnsavedChanges              
select UnsavedChangeId,ScreenProperties from UnsavedChanges where ISNULL(RecordDeleted,'N') = 'N'              
AND StaffId = @staffId            
              
declare @ScreenProperties XML              
declare @totalUnsavedChanges int              
declare @UnsavedChangeId int              
declare @count int              
DECLARE @ListofDocuments VARCHAR(8000)              
              
set @totalUnsavedChanges = (select Count(UnsavedChangeId) from @tabletotalUnsavedChanges )              
set @count = 1              
              
while (@count <= @totalUnsavedChanges)              
              
begin              
              
set @UnsavedChangeId = (select UnsavedChangeId from @tabletotalUnsavedChanges where incrementId = @Count)              
set @ScreenProperties = (select screenproperties from @tabletotalUnsavedChanges where UnsavedChangeId = @UnsavedChangeId)              
              
insert into @UnsavedDocuments(UnsavedChangeId,DocumentID)              
select  @UnsavedChangeId,@ScreenProperties.value('(/ScreenProperties/DocumentId)[1]', 'int');              
              
set @count = @count + 1              
end              
           
              
delete from @UnsavedDocuments where DocumentId is null -- Filtering all the records which are not document Specific            
delete from @UnsavedDocuments where DocumentId = @DocumentId -- Filtering the Document on which user is currently sitting          
-- The Above table NOW has all the Unsaved changes which are for document screens            
          
--select DocumentId           
delete from DocumentLocks where DocumentId not in           
(select DocumentId from @UnsavedDocuments) --AND SessionId = @sessionId -- Documents which are locked but not unsaved.          
AND DocumentId <> @DocumentId   AND  STAFFID = @staffId  
          
           
            
               
                  
END TRY              
 BEGIN CATCH              
  DECLARE @Error varchar(8000)                                                                                                  
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                                                               
  + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCAutoUnlockallDocuments')                                
  + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                          
  + '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                                                                                             
  RAISERROR                    
  (                                                                                        
   @Error, -- Message text.                                                                                                            
   16, -- Severity.                                 
   1 -- State.                                                                        
  );               
 END CATCH              
END