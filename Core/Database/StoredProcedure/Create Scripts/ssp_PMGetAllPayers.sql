/****** Object:  StoredProcedure [dbo].[ssp_PMGetAllPayers]    Script Date: 11/18/2011 16:25:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetAllPayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetAllPayers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_PMGetAllPayers] AS          
          
/*********************************************************************/                          
/* Stored Procedure: dbo.ssp_PMGetAllPayers             */                          
/* Creation Date:  29 June, 2007                                    */                          
/*                                                                   */                          
/* Purpose: retuns data for shared tables filling.             */                         
/*                                                                   */                        
/* Input Parameters:                                    */                        
/*                                                                   */                          
/* Output Parameters:                                */                          
/*                                                                   */                          
/*                                                                   */                          
/* Called By:                                                        */                          
/*                                                                   */                          
/* Calls:                                                            */                          
/*                                                                   */                          
/* Data Modifications:                                               */                          
/* Author: Jaspreet Singh.               
20-04-2012		MSuma           Removed *                            
03-01-2013      Saurav Pande    Add the inner join with GlobalCodes because we need PayerTypeText From Global Codes Done W.r.t Task #418 in Centrawellness-Bugs/Features  
31-01-2018		Chethan N		What : Added new coulmn 'PayerCode'
								Why : Meaningful Use - Stage 3 task #70.	*/                 
/*********************************************************************/                        
BEGIN
	BEGIN TRY
--Payer          

		SELECT   
		 p.PayerId,  
		 p.PayerName,  
		 p.PayerType,
		  GC.CodeName as PayerTypeText,  
		 p.Active,  
		 p.RowIdentifier,  
		 p.CreatedBy,  
		 p.CreatedDate,  
		 p.ModifiedBy,  
		 p.ModifiedDate,  
		 p.RecordDeleted,  
		 p.DeletedDate,  
		 p.DeletedBy,
		 p.PayerCode
		FROM Payers  p 
		 inner join GlobalCodes  GC on p.PayerType=GC.GlobalCodeId
		WHERE ISNULL(p.RecordDeleted,'N')='N'   and ISNULL(gc.RecordDeleted,'N')='N' 
		ORDER BY p.PayerName ASC 
      
  END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_PMGetAllPayers') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + 
			CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                 
				16
				,-- Severity.                 
				1 -- State.                 
				);
	END CATCH
END
GO
