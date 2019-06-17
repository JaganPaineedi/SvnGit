/****** Object:  StoredProcedure [dbo].[ssp_SCGetHospitalsForADTHospitalization]    Script Date: 05/25/2017 11:33:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetHospitalsForADTHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetHospitalsForADTHospitalization]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetHospitalsForADTHospitalization]    Script Date: 05/25/2017 11:33:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
Create Procedure [dbo].[ssp_SCGetHospitalsForADTHospitalization]  
AS   
  
BEGIN
  BEGIN TRY
  
/*********************************************************************/                                                                                        
 /* Stored Procedure: [ssp_SCGetHospitalsForADTHospitalization]              */                                                                               
 /* Created By: Chethan N					*/
/* Creation Date:  02/09/2017             */                                                                                      
 /* Input Parameters: */                  
  /* Output Parameters:   */            
  /*Returns The Table of Hospitals  */                                                                                        
 /* Called By:                                                       */                                                                              
 /* Data Modifications:                                              */                                                                                        
 /*   Updates:                                                       */                                                                                        
 /*   Date    Author   Purpose                       */             
   
 /********************************************************************/    
 SELECT AHD.HospitalName
 FROM ADTHospitalMaster AHD
 WHERE 
 ISNULL(AHD.RecordDeleted,'N') = 'N'
  
END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)

    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'ssp_SCGetHospitalsForADTHospitalization')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@Error,
    -- Message text.                                            
    16,-- Severity.                                            
    1 -- State.                                            
    );
  END CATCH
END

GO


