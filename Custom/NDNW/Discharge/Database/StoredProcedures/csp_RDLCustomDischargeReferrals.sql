IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDischargeReferrals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDischargeReferrals]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[csp_RDLCustomDischargeReferrals]                                      
(                                                            
 @DocumentVersionId as int                                                            
)                                            
AS          
                                                       
                                                          
/*********************************************************************                        
-- Stored Procedure: dbo.[csp_RDLCustomDischargeReferrals]                                                           
                          
-- Creation Date:    23.02.2014                       
--                         
-- Purpose:  Return Tables for CustomDischargeReferrals and fill the type Dataset                        
--                        
-- Create:                        
--   Date       Author    Purpose                        
--  23.FEB.2015  Anto     To fetch CustomDischargeReferrals               
--        
*********************************************************************/     
BEGIN                                                      
  BEGIN TRY  

	SELECT DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		dbo.csf_GetGlobalCodeNameById([Referral])as ReferralName,
		(select top 1 ProgramName from Programs where ProgramId =  Program AND Active='Y' AND ISNULL(RecordDeleted, 'N') = 'N') as ProgramName 
		from CustomDischargeReferrals  where DocumentVersionId = @DocumentVersionId AND ISNULL (RecordDeleted,'N') = 'N'
		
											  
	END TRY	                                             
   
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomDischargeReferrals')                                                           
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR                                                           
  (                                                          
   @Error, -- Message text.                                                          
   16, -- Severity.                                                          
   1 -- State.                                                          
  )           
 END CATCH                                                
End 

 