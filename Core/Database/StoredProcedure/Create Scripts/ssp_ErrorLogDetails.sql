

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ErrorLogDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ErrorLogDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ErrorLogDetails]  Script Date: 11/21/2014 18:52:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc ssp_ErrorLogDetails          
@ErrorLogId int          
AS           
/************************************************************************/                                                
/* Stored Procedure: [ssp_ErrorLogDetails]		*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  24 Jan 2018									*/                                                
/*																		*/                                                                                 
/*																		*/                                              
/* Input Parameters: @@ErrorLogId										*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Get data in Errorlog Detail screen					*/                                      
/* Calls:																*/                                                
/* Author:			M Junaid											*/       
/* 04/03/2018		Suneel N		Added new column in ErrorLog table for Created Date w.r.t task #612 Engineering Improvement Initiatives- NBL(I)*/                        
/************************************************************************/     
    
Begin      
Begin Try         
select     
    
ErrorLogId,    
ErrorMessage ,    
VerboseInfo,    
DataSetInfo,    
ErrorType,    
CreatedBy,    
CreatedDate,  
CONVERT(VARCHAR(100), CreatedDate, 100) as CreatedDateText 
from ErrorLog    
    
     
WHERE    ErrorLogId = @ErrorLogId    
--ORDER BY CustomVJContactId DESC      
END TRY      
      
BEGIN CATCH      
  RAISERROR('[ssp_ErrorLogDetails] : An Error Occured',16,1)          
END CATCH      
END