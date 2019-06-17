IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSchoolDisTrictContacts]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetSchoolDisTrictContacts]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO    
CREATE PROCEDURE [dbo].[ssp_GetSchoolDisTrictContacts] 
@schoolContactNameSearched Varchar(20)     
AS     
  -- =============================================       
  -- Author:  Pradeep Kumar Yadav       
  -- Create date: 04/04/2018       
  -- Description: To get all School District Contact Name PEP-Customization: #10005.       
  --Modified By   Date          Reason         
  -- =============================================       
  Begin  
  BEGIN try     
    
      ---------SchoolDistricts                   
      SELECT LastName+','+FirstName  As ContactName   
      FROM   SchoolDistrictContacts SDC    
      WHERE  ((SDC.LastName + ' ' + SDC.FirstName) LIKE '%' + @schoolContactNameSearched + '%'  
     OR SDC.LastName LIKE '%' + @schoolContactNameSearched + '%'  
     OR SDC.FirstName LIKE '%' + @schoolContactNameSearched + '%'  
     OR (SDC.LastName + ',' + SDC.FirstName) LIKE '%' + @schoolContactNameSearched + '%'  )
       
      AND Isnull(RecordDeleted, 'N') = 'N'    
  END try     
    
  BEGIN catch     
      DECLARE @Error VARCHAR(8000)     
    
      SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'     
                   + CONVERT(VARCHAR(4000), Error_message())     
                   + '*****'     
                   + Isnull(CONVERT(VARCHAR, Error_procedure()),     
                   'ssp_GetSchoolDisTrictName')     
                   + '*****' + CONVERT(VARCHAR, Error_line())     
                   + '*****' + CONVERT(VARCHAR, Error_severity())     
                   + '*****' + CONVERT(VARCHAR, Error_state())     
    
      RAISERROR ( @Error,-- Message text.                                           
                  16,-- Severity.                                           
                  1 -- State.                                           
      );     
  END catch   
  End