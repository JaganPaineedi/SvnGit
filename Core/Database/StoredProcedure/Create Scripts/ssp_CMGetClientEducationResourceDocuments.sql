
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetClientEducationResourceDocuments]    Script Date: 06/13/2015 16:51:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClientEducationResourceDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetClientEducationResourceDocuments]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetClientEducationResourceDocuments]    Script Date: 06/13/2015 16:51:00 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE  PROCEDURE [dbo].[ssp_CMGetClientEducationResourceDocuments]
(
	@ClientEducationResourceId int
)

AS
BEGIN                                  
BEGIN TRY
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_CMGetClientEducationResourceDocuments  */              
/* Creation Date:  09/05/2011                                       */              
/* Purpose: it will get Client Education Resource Documents as per ClientEducationResourceId*/      

/* Output Parameters:                                               */              
/*                                                                  */              
/* Called By:                                                       */              
/*                                                                  */              
/* Calls:                                                           */              
/*                                                                  */              
/* Date         Author              Purpose                         */              
/* 09/05/2011   Jagdeep Hundal      Created                         */              
/*********************************************************************/            
SELECT 
    CER.DocumentType,
    CER.ResourcePDF,
    CER.ResourceURL,
    CER.ParameterType,
    R.ReportServerPath                      
FROM 
EducationResources CER
LEFT JOIN Reports R ON R.ReportId=CER.ResourceReportId   
WHERE CER.EducationResourceId=@ClientEducationResourceId
  
END TRY

BEGIN CATCH                                  
  DECLARE @Error varchar(8000)                      
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                             
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_CMGetClientEducationResourceDocuments')                                                  
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                            
  + '*****' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                       
END CATCH  
END 




GO

