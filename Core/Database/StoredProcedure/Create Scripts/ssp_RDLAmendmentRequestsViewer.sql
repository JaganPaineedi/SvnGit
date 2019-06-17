/****** Object:  StoredProcedure [dbo].[ssp_RDLAmendmentRequestsViewer]    Script Date: 06/09/2015 10:07:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLAmendmentRequestsViewer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLAmendmentRequestsViewer]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLAmendmentRequestsViewer]    Script Date: 06/09/2015 10:07:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


   
CREATE PROCEDURE [dbo].[ssp_RDLAmendmentRequestsViewer]        
 (        
  @DocumentCodeId int,
  @ClientId int         
 )        
AS
/******************************************************************************                              
**  File:                               
**  Name: [ssp_RDLAmendmentRequestsViewer]                              
**  Desc: This storeProcedure will return information for RDL                            
**                                            
**  Parameters:                              
**  Input  @DocumentCodeId           
                                
**  Output     ----------       -----------                              
**                          
                            
**  Auth:  Ponnin selvan                        
**  Date:  27 Oct 2014                            
*******************************************************************************                              
**  Change History                              
*******************************************************************************                              
**  Date:				 Author:    Description:                              
**  --------  --------    -------------------------------------------                              
**   29-Oct-2014		Ponnin	   MeaningFul Use Task #65 - Client Amendment Request      
**   3-Nov - 2014		Ponnin	MeaningFul Use Task #65 -Added new Parameter ClientId to display records for the selected client.              
*******************************************************************************/         
BEGIN     
 BEGIN TRY       
   SELECT  top 1   
     C.[ClientId]        
      , C.[FirstName] + ', ' + C.[LastName] As ClientName          
      ,Convert(varchar(10),C.[DOB],101) as DateOfBirth          
      ,(Select OrganizationName from SystemConfigurations) as OrganizationName         
      ,CONVERT(VARCHAR(10),Documents.EffectiveDate,101) as EffectiveDate         
      ,DocumentName = REPLACE(DocumentCodes.DocumentName,'Converted ','')       
   FROM     Documents               
    Inner join DocumentCodes         
     ON DocumentCodes.DocumentCodeid= @DocumentCodeId                     
    INNER JOIN Clients C        
     ON C.ClientId = Documents.ClientId      
   WHERE  C.ClientId = @ClientId    
    AND isnull(Documents.RecordDeleted, 'N') = 'N'         
    AND isnull(C.RecordDeleted, 'N') = 'N'   
        
 END TRY    
  BEGIN CATCH            
  DECLARE @Error varchar(8000)                                                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLAmendmentRequestsViewer')                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                      
  RAISERROR                                                                                         
  (                                                           
   @Error, -- Message text.                                                                                        
   16, -- Severity.                                                                                        
   1 -- State.                                                                                        
   );             
 END CATCH    
END 

GO


