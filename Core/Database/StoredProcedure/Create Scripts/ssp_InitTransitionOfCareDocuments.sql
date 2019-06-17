/****** Object:  StoredProcedure [dbo].[ssp_InitTransitionOfCareDocuments]    Script Date: 06/09/2015 05:25:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitTransitionOfCareDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitTransitionOfCareDocuments]
GO


/****** Object:  StoredProcedure [dbo].[ssp_InitTransitionOfCareDocuments]    Script Date: 06/09/2015 05:25:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[ssp_InitTransitionOfCareDocuments]    
(    
 @ClientID int,    
 @StaffID int,    
 @CustomParameters xml    
)    
AS    
BEGIN
/************************************************************************/                                                                
/* Stored Procedure: ssp_InitTransitionOfCareDocuments					 */                                                                                                                     
/* Creation Date:  23 Apr 2014											 */                                                                                                                           
/* Purpose: Current Medication for Clinical Summary					     */                                                               
/* Input Parameters: 							 */                                                              
/* Output Parameters:													 */                                                                                                                                                                                                                                                
/* Author: Veena S Mani										     */   
/* Updates:																 */    
/* Date				Author				Purpose							 */
/* 14-Aug-17		Alok Kumar			Added ConfidentialityCode with defult initialization to N(i.e. Normal).	Ref#25.1 Meaningful Use - Stage 3

 */
/*************************************************************************/
   


  BEGIN TRY   
SELECT TOP 1 'TransitionOfCareDocuments' AS TableName,    
  -1 AS 'DocumentVersionId',    
  '' as CreatedBy,    
  getdate() as CreatedDate,    
  '' as ModifiedBy,    
  getdate() as ModifiedDate,
  'N' as ConfidentialityCode    --14-Aug-17		Alok Kumar
 END TRY
  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_InitTransitionOfCareDocuments')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.                                                                                                      
    16, -- Severity.                                                                                                      
    1 -- State.                                                                                                      
    );
  END CATCH
END   
GO

