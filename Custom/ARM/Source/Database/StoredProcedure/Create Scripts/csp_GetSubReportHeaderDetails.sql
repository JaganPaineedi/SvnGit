/****** Object:  StoredProcedure [dbo].[csp_GetSubReportHeaderDetails]    Script Date: 08/22/2013 11:40:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetSubReportHeaderDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetSubReportHeaderDetails] 
GO

/****** Object:  StoredProcedure [dbo].[csp_GetSubReportHeaderDetails]    Script Date: 07/01/2013 18:28:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE csp_GetSubReportHeaderDetails   

 @documentversionid INT  
AS 
-- =============================================  
-- Author:		Shankha Bhowmik 
-- Create date: 08/22/2013
-- Description: Used to display records for the
-- Sub Report RDL SubReportCustomHeader  
-- =============================================  
 
BEGIN  
Begin try
 SELECT   
		A.AgencyName,  
		DC.DocumentName  
		FROM documents D, DocumentCodes DC  
 Cross Join Agency as A
 WHERE D.DocumentCodeId = DC.DocumentCodeId  and 
  D.CurrentDocumentVersionId = @documentversionid  
  AND ISNULL(D.RecordDeleted, 'N') = 'N'
  AND ISNULL(DC.RecordDeleted, 'N') = 'N'
 
             
 End try
 
 BEGIN CATCH
	 declare @Error varchar(8000)                      
	 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                       
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetSubReportHeaderDetails')                       
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                        
		+ '*****' + Convert(varchar,ERROR_STATE())                      
	 RAISERROR                       
	 (                      
	  @Error, -- Message text.                      
	  16,  -- Severity.                      
	  1  -- State.                      
	 ); 
END CATCH
END  