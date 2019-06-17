/****** Object:  StoredProcedure [dbo].[ssp_EPCSAssignmentValid]   ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_EPCSAssignmentValid]')
					AND type IN ( N'P', N'PC' ) )
	DROP PROCEDURE dbo.ssp_EPCSAssignmentValid
GO

/****** Object:  StoredProcedure [dbo].[ssp_EPCSAssignmentValid]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[ssp_EPCSAssignmentValid]     
@LoggedInStaffId INT, 
@StaffId INT
AS                                      
                                      
/*********************************************************************/                                        
/* Stored Procedure: dbo.ssp_EPCSAssignmentValid					 */                                        
/* Copyright: 2011 Streamline Healthcare Solutions,  LLC             */                                        
/*********************************************************************/                                             
BEGIN                         
BEGIN TRY   

declare @EPCSAssignmentValidCount int = 0
select @EPCSAssignmentValidCount = count(*) from dbo.EPCSAssigment as ea where ea.PrescriberStaffId = @StaffId and ea.Enabled = 'Y' and ea.EPCSAssignorStaffId <> @LoggedInStaffId and isnull(ea.RecordDeleted, 'N') = 'N'

if @EPCSAssignmentValidCount > 0
select 'Y'
else
select 'N'

END TRY              
BEGIN CATCH                        
DECLARE @Error varchar(8000)                                          
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_EPCSAssignmentValid ')                  
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