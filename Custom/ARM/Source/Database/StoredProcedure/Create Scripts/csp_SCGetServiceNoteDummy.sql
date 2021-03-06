/****** Object:  StoredProcedure [dbo].[csp_SCGetServiceNoteDummy]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetServiceNoteDummy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetServiceNoteDummy]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetServiceNoteDummy]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE  [dbo].[csp_SCGetServiceNoteDummy]                 
(                    
           
 @DocumentVersionId as int        
)                    
As          
/******************************************************************************            
**  File: MSDE.cs            
**  Name: csp_SCGetServiceNoteDummy            
**  Desc: This fetches data for Service Note Custom Tables           
**  Copyright: 2006 Streamline SmartCare                                      
**            
**  This template can be customized:            
**                          
**  Return values:            
**             
**  Called by:   DownloadReqServiceData function in MSDE Class in DataServices            
**                          
**  Parameters:            
**  Input       Output            
**     ----------      -----------            
**  DocumentID,Version    Result Set containing values from Service Note Custom Tables          
**            
**  Auth: Balvinder Singh            
**  Date: 24-April-08            
*******************************************************************************            
**  Change History            
*******************************************************************************            
**  Date:    Author:    Description:            
**  --------   --------   -------------------------------------------            
          
*******************************************************************************/
' 
END
GO
