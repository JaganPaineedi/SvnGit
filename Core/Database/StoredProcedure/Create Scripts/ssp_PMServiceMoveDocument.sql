IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMServiceMoveDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMServiceMoveDocument]
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[ssp_PMServiceMoveDocument] --1284296,1284297,92                                 
(                                      
 @ServiceIdTo int,                           
 @ServiceIdFrom int,                          
 @StaffId int                                    
)                              
                          
/*********************************************************************                                      
-- Stored Procedure: dbo.ssp_PMServiceMoveDocument                                      
--                                      
-- Copyright: 2010 Streamline Healthcare Solutions                                      
--                                      
-- Purpose: Moves ServiceId from one DocumentId to another.                                      
--                                      
--                                      
-- Updates:                                       
-- Date---------Author--------Purpose-----------------------------------      
-- 7 Sept 2010  Pradeep       Made check if clientidfrom is not equal to clientIdTo then raise error    
--13 Feb 2013 Vikas    What: Added One more paramete For SP "ssp_PMMarkServiceAsError"   
--         Why: Made changes w.r.t Task# ServicesDeleted functionality.   
--04 June 2018	Vithobha	Copied the ssp from 3.5 to 4.0 folder, calling scsp_PMServiceMoveDocumentValidations instead of csp_PMServiceMoveDocumentValidations                           
**********************************************************************/                                                       
as  
BEGIN
	BEGIN TRY                        
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
		                          
		                          
		--Find Staff's UserCode                          
		Set @UserCode = (Select UserCode From Staff Where StaffId = @StaffId)                          
		                          
		                          
		create table #Errors                           
		(Error varchar(200))                          
		                          
		                          
		--Find DocumentId and Client information                          
		Select @DocumentIdFrom = d.DocumentId,                          
		 @DocumentCodeIdFrom = d.DocumentCodeId,                          
		 @ClientIdFrom = d.ClientId,                          
		 @ClientIdTo = s.ClientId,                          
		 @AuthorIdTo = d.AuthorId                          
		From Documents as d                          
		Cross Join Services as s                          
		where d.ServiceId = @ServiceIdFrom                          
		and s.ServiceId = @ServiceIdTo                          
		and isnull(d.RecordDeleted, 'N')= 'N'                          
		and isnull(s.RecordDeleted, 'N')= 'N'                          
		                          
		                          
		--Find To Document Id and Author                          
		Select @DocumentIdTo = d.DocumentId,                          
		 @AuthorIdTo = d.AuthorId,                          
		 @DocumentCodeIdTo = d.DocumentCodeId                          
		From Documents as d                          
		where d.ServiceId = @ServiceIdTo                          
		and isnull(d.RecordDeleted, 'N')= 'N'                          
		  ------Made changes by Pradeep start over here-----        
		  if(@ClientIdFrom!=@ClientIdTo)        
		  BEGIN        
		 ------------------------------------------------------------  
		 --insert into #Errors (Error) values ('Client associated with new service does not match the client associated with old service')  
		  --Modified by: SWAPAN MOHAN   
		  --Modified on: 4 July 2012  
		  --Purpose: For implementing the Customizable Message Codes.   
		  --The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.  
		 DECLARE @ERROR1 NVARCHAR(MAX)  
		 Set @ERROR1=dbo.Ssf_GetMesageByMessageCode(31,'CLIENTNOTMATCHED_SSP','Client associated with new service does not match the client associated with old service')  
		 insert into #Errors (Error) values (@ERROR1)  
		 ------------------------------------------------------------                         
		  set @Return = 2          
		  END        
		  --------Made changes by Pradeep end over here----                        
		                          
		--Only Allow Documents with the same DocumentCodeId to be moved.                          
		If isnull(@DocumentCodeIdTo, 0) <> isnull(@DocumentCodeIdFrom, 0)                           
		Begin                           
		 ------------------------------------------------------------  
		 --insert into #Errors (Error) values ('Document associated with new service does not match old service')   
		  --Modified by: SWAPAN MOHAN   
		  --Modified on: 4 July 2012  
		  --Purpose: For implementing the Customizable Message Codes.   
		  --The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.  
		 DECLARE @ERROR2 NVARCHAR(MAX)  
		 Set @ERROR2=dbo.Ssf_GetMesageByMessageCode(31,'DOCNOTMATCHED_SSP','Document associated with new service does not match old service')  
		 insert into #Errors (Error) values (@ERROR2)  
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
		exec scsp_PMServiceMoveDocumentValidations @ServiceIdTo ,@ServiceIdFrom ,@StaffId , @DocumentIdTo ,                          
		 @DocumentCodeIdTo ,@ClientIdTo , @AuthorIdTo , @DocumentIdFrom , @DocumentCodeIdFrom ,                          
		 @ClientIdFrom ,  @AuthorIdFrom                              
		                          
		                        
		--select * from #validationReturnTable                        
		--IF Exists (Select * From #validationReturnTable)                          
		--Begin                           
		-- select 1  as ValidationStatus                          
		--End                          
		--Else                         
		--Begin                          
		-- Select 0 as ValidationStatus                          
		--End                             
		                          
		if @@error <> 0 goto err_rollback                            
		                         
		begin tran                          
		                          
		--Delete associated document record for @ServiceIdTo                          
		Update Documents                           
		Set RecordDeleted = 'Y',                          
		DeletedBy = @UserCode,                          
		DeletedDate = getdate()                          
		Where DocumentId = @DocumentIdTo                          
		and isnull(RecordDeleted, 'N')= 'N'                          
		                          
		Update DocumentVersions                           
		Set RecordDeleted = 'Y',                          
		DeletedBy = @UserCode,                          
		DeletedDate = getdate()                          
		Where DocumentId = @DocumentIdTo                          
		and isnull(RecordDeleted, 'N')= 'N'                          
		                          
		if @@error <> 0 goto err_rollback                          
		                          
		                          
		exec ssp_PMServiceDeleteNote @DocumentCodeIdTo, @DocumentIdTo, @UserCode                      
		                      
		                      
		                          
		                          
		--Move the @ServiceIdFrom to the @ServiceIdTo document record                          
		Update d                          
		Set d.ServiceId = @ServiceIdTo,                          
		 d.ClientId = @ClientIdTo                          
		From Documents as d                          
		where d.DocumentId = @DocumentIdFrom                          
		and isnull(d.RecordDeleted, 'N')= 'N'                          
		                          
		if @@error <> 0 goto err_rollback                          
		                          
		                          
		--Mark the @ServiceIdFrom record as an error                          
		if not exists (select * from Services where ServiceId = @ServiceIdFrom and status = 76)                          
		begin                          
		 begin try             
		   
		/*Vikas 13 Feb 2013, added New parameter 'N' For  ssp_PMMarkServiceAsError requirement*/               
		 exec dbo.[ssp_PMMarkServiceAsError] @ServiceIdFrom, @UserCode, 0 ,'N'                        
		 end try                          
		                          
		 begin catch                          
		   insert into #Errors (Error) values (ERROR_MESSAGE())                           
		   set @Return = 2                          
		 end catch                          
		                           
		 if (@Return <> 0) or (@@error <> 0) goto err_rollback                          
		end                          
		                          
		                          
		--If successful, insert a tracking record into history table                          
		                          
		if (@Return <> 0) or (@@error <> 0) goto err_rollback                          
		                      
		                   
		Insert into DocumentMoves                          
		(DocumentId,ClientIdFrom,ClientidTo,ServiceIdFrom,ServiceIdTo,DateOfMove,MoverId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                          
		Values                          
		(@DocumentIdTo,@ClientIdFrom,@ClientIdTo,@ServiceIdFrom,@ServiceIdTo,getdate(),@StaffId,@UserCode,getdate(),@UserCode,getdate())                          
		              
		                          
		if @@error <> 0 goto err_rollback                          
		 select * from #Errors                     
		commit tran                          
		 return 0                          
		                          
		err_rollback:      
				 select * from #Errors               
		rollback tran                          
		                          
		set @ErrorMessage = ''  
END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMServiceMoveDocument') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                        
				16
				,-- Severity.                        
				1 -- State.                        
				)
	END CATCH
END			                        

GO


