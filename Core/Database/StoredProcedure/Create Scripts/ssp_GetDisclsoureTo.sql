/****** Object:  StoredProcedure [dbo].[ssp_GetDisclsoureTo]    Script Date: 03/18/2016 09:56:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDisclsoureTo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDisclsoureTo]
GO
/****** Object:  StoredProcedure [dbo].[ssp_GetDisclsoureTo]    Script Date: 03/18/2016 09:56:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE Procedure [dbo].[ssp_GetDisclsoureTo]   
@DisclsoureDetailId INT   
AS  
/*************************************************************************/                
/* Stored Procedure: dbo.ssp_GetDisclsoureTo             */                
/* Copyright: DisclosureTo Details					 */                
/* Creation Date:  25/03/2016											 */                
/*                                                                       */                
/* Purpose: retuns the details of NamAddress               */               
/*                                                                       */              
/* Input Parameters: @DisclsoureDetailId                                       */              
/*																		 */                
/* Output Parameters:													 */                
/*                                                                       */                
/* Return:                                                               */                
/*                                                                       */                
/* Called By:                                                            */                
/*                                                                       */                
/* Calls:                                                                */                
/*                                                                       */                
/* Data Modifications:                                                   */                
/*                                                                       */                
/* Updates:                                                              */                
/*  Date            Author				Purpose                  */  
/*	25/03/2016		Lakshmi kanth		Returning Data from disclosureTo Details, for task#613.8 Network 180															*/
/*************************************************************************/    
  
BEGIN  
 BEGIN TRY  
Select   
ERP.DisclosedToDetailId,   
ERP.CreatedBy,   
ERP.CreatedDate,  
ERP.ModifiedBy,   
ERP.ModifiedDate,   
ERP.RecordDeleted,   
ERP.DeletedDate,   
ERP.DeletedBy,   
ERP.DisclsoureType,   
ERP.Name,   
ERP.DisclsoureAddress,   
ERP.City,   
ERP.DisclsoureState,   
ERP.ZipCode,   
ERP.PhoneNumber,   
ERP.Fax,   
ERP.Email,   
ERP.Website,   
ERP.Active,   
ERP.DataEntryComplete,  
--S.StateAbbreviation AS StateName    
ERP.OrganizationName   
,ERP.LastName  
,ERP.FirstName  
,ERP.DisclsoureAddress2  
,ERP.Suffix  
,ERP.ClientId
,ISNULL(ERP.LastName,'') + ISNULL(ERP.FirstName, ERP.Name) as PhysicianName  
FROM DisclosedToDetails   ERP  
LEFT JOIN states S ON S.stateFIPS=  ERP.DisclsoureState    
WHERE (ERP.DisclosedToDetailId = @DisclsoureDetailId OR @DisclsoureDetailId =0) AND ISNULL(ERP.RecordDeleted,'N')='N' ORDER by ERP.NAME ASC  
END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetDisclsoureTo')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  
   1  
  );  
 END CATCH   
 RETURN  
END  

GO


