

/****** Object:  StoredProcedure [dbo].[ssp_GetSchoolDisTrictName]    Script Date: 06/04/2018 15:46:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSchoolDisTrictName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSchoolDisTrictName]
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetSchoolDisTrictName]    Script Date: 06/04/2018 15:46:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
Create PROCEDURE [dbo].[ssp_GetSchoolDisTrictName]  
@schoolNameSearched Varchar(20)
AS   
  -- =============================================     
  -- Author:  Pradeep Kumar Yadav     
  -- Create date: 04/04/2018     
  -- Description: To get all School District Name PEP-Customization: #10005.     
  --Modified By   Date          Reason       
  -- =============================================     
  Begin
  BEGIN try   
      ---------SchoolDistricts                 
      SELECT    DistrictName   
      FROM   SchoolDistricts   
      WHERE DistrictName Like '%'+ @schoolNameSearched +'%' AND  Isnull(RecordDeleted, 'N') = 'N'  and DistrictName is not null 
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
GO


