/****** Object:  StoredProcedure [dbo].[ssp_UpdateStaffEPCSAssignment]   ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_UpdateStaffEPCSAssignment]')
					AND type IN ( N'P', N'PC' ) )
	DROP PROCEDURE dbo.ssp_UpdateStaffEPCSAssignment
GO

/****** Object:  StoredProcedure [dbo].[ssp_UpdateStaffEPCSAssignment]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[ssp_UpdateStaffEPCSAssignment]     
@Selectedstaff varchar(max),
@EPCSAssignorStaffId INT, 
@CreatedBy VARCHAR(30), 
@Enable CHAR(1)              
AS                                      
                                      
/*********************************************************************/                                        
/* Stored Procedure: dbo.ssp_UpdateStaffEPCSAssignment					 */                                        
/* Copyright: 2011 Streamline Healthcare Solutions,  LLC             */                                        
/* Purpose:  Update the EPCS column as 'Y' for the selected staffs   */                                       
/* Input Parameters: @ClientID                                       */                                      
/* Output Parameters:   None                                         */                                                                               
/* Data Modifications:                                               */                                        
/* Updates:                                                          */                                        
/*  Date            Author          Purpose                          */                                                       
/* 16/Sep/2016      Anto            Create                           */ 
/*********************************************************************/                                             
BEGIN                         
BEGIN TRY   
Declare @selectedStaffId int
-- declare a cursor
DECLARE insert_cursor CURSOR FOR 
SELECT item FROM dbo.fnSplit(@Selectedstaff , ',')
 
-- open cursor and fetch first row into variables
OPEN insert_cursor
FETCH NEXT FROM insert_cursor into @selectedStaffId
 
-- check for a new row
WHILE @@FETCH_STATUS=0
BEGIN
-- do complex operation here

IF EXISTS(SELECT * FROM dbo.EPCSAssigment WHERE [EPCSAssignorStaffId]=@EPCSAssignorStaffId AND [PrescriberStaffId]=@selectedStaffId)
BEGIN
	UPDATE dbo.EPCSAssigment SET [ModifiedBy]=@CreatedBy,[ModifiedDate]=GETDATE(),[RecordDeleted]='Y' 
	WHERE [PrescriberStaffId]=@selectedStaffId
END

	INSERT INTO dbo.EPCSAssigment ( [CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[EPCSAssignorStaffId],[PrescriberStaffId],[Enabled])
	VALUES  (@CreatedBy,GETDATE(),@CreatedBy,GETDATE(),NULL,@EPCSAssignorStaffId,@selectedStaffId,@Enable) 


-- get next available row into variables
FETCH NEXT FROM insert_cursor into @selectedStaffId

END
close insert_cursor
Deallocate insert_cursor
END TRY              
BEGIN CATCH                        
DECLARE @Error varchar(8000)                                          
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_UpdateStaffEPCSAssignment ')                  
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                          
                                        
   RAISERROR                                           
   (                                          
    @Error, -- Message text.                                          
    16, -- Severity.                                          
    1 -- State.                                          
   );                           
End CATCH                                                                 
                    
End    


GO
