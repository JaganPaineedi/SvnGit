/****** Object:  StoredProcedure [dbo].[ssp_GetAuthor]    Script Date: 09/24/2017 13:12:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAuthor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAuthor]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetAuthor]    Script Date: 09/24/2017 13:12:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetAuthor] @ClientId INT = NULL    
 ,@Type VARCHAR(10) = NULL    
 ,@DocumentVersionId INT = NULL    
 ,@FromDate DATETIME = NULL    
 ,@ToDate DATETIME = NULL
AS    
-- =============================================            
-- Author:  Vijay            
-- Create date: July 24, 2017            
-- Description: Retrieves Author details
-- Task:   MUS3 - Task#25.4 Transition of Care - CCDA Generation           
/*            
 Author   Modified Date   Reason           
*/    
-- =============================================            
BEGIN    
 BEGIN TRY    
    
  	  SELECT DISTINCT c.ClientId    
		  ,sf.FirstName    
		  ,sf.LastName    
		  ,A.AgencyName       
		  ,A.Address        
		  ,A.City        
		  ,A.State       
		  ,A.ZipCode    
		  ,CASE WHEN ISNULL(A.MainPhone,'') <> ''        
		 THEN '('+SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 1, 3) +')'       
		  + ' '       
          + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 4, 3)        
          + '-'       
          + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 7, 4)
		  ELSE ''      
		  END AS [Phone]    
		  ,A.CreatedDate AS [Date]         
	  FROM Clients c    
	   LEFT JOIN Staff sf ON sf.StaffId = c.PrimaryClinicianId AND  sf.Prescriber = 'Y'    
	   CROSS JOIN  Agency A               
	   WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
	   AND c.Active = 'Y'     
	   AND ISNULL(c.RecordDeleted,'N')='N'    
	     
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetAuthor') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' +     
   CONVERT(VARCHAR, ERROR_STATE())    
    
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


