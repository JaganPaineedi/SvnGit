IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetAllClientsEnrolledInProgram]') AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[SSP_GetAllClientsEnrolledInProgram] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetAllClientsEnrolledInProgram] 
(
	@ProgramId int  
) 

/********************************************************************************    
-- Stored Procedure: dbo.[SSP_GetAllClientsEnrolledInProgram]  60    
--  
-- Copyright: Streamline Healthcate Solutions 
-- Author : Manjunath K   
-- Created: 28 April 2017
-- Purpose : To pull Clients enrolled in Program          
-- Date			  Author				Purpose 
--
*********************************************************************************/  
AS    
BEGIN    
  BEGIN TRY    
 
   SELECT 
		CP.ClientId,
		CASE       
		WHEN ISNULL(CC.ClientType, 'I') = 'I'      
		THEN ISNULL(CC.LastName, '') + ', ' + ISNULL(CC.FirstName, '')      
		ELSE ISNULL(CC.OrganizationName, '')      
		END AS ClientName    
		FROM [ClientPrograms] CP
		LEFT JOIN Clients CC ON CC.ClientId=CP.ClientId
		WHERE CP.ProgramId=@ProgramId
		AND ISNULL(CP.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(CC.RecordDeleted, 'N') <> 'Y'
		AND CP.Status=4
       
  END TRY    
    
  BEGIN CATCH    
    DECLARE @Error varchar(8000)    
    
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'    
    + CONVERT(varchar(4000), ERROR_MESSAGE())    
    + '*****'    
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),    
    'SSP_GetAllClientsEnrolledInProgram')    
    + '*****' + CONVERT(varchar, ERROR_LINE())    
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())    
    + '*****' + CONVERT(varchar, ERROR_STATE())    
    
    RAISERROR (@Error,    
    -- Message text.                                                         
    16,    
    -- Severity.                                       
    1    
    -- State.                                                                                                                        
    );    
  END CATCH    
END 