/****** Object:  StoredProcedure [dbo].[ssp_SCGetRecommendedServices]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetRecommendedServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetRecommendedServices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetRecommendedServices]******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ssp_SCGetRecommendedServices] As  
/******************************************************************************                  
**  File:                   
**  Name: ssp_SCGetSharedTablesForApplication                  
**  Desc:  Streamline.DataServices.HRMAssessments.cs                 
**                  
**  This Stored procedure will execute the query for recommended services  
**                                
**  Return values:                  
**                   
**  Called by: GetCustomHRMLevelOfCareOptions()                     
**                                
**  Parameters:                  
**  Input    Output                  
**     ----------       -----------                  
            
                
**  Auth:  Rakesh Singh                 
**  Date:   08/05/2008                
*******************************************************************************                  
**  Change History                  
*******************************************************************************                  
**  Date:  Author:    Description:                  
**  --------  --------    -------------------------------------------                  
**            
        
  
*******************************************************************************/     
Begin  
 Begin Try  
  Select   
   HRMLevelOfCareOptionId,  
   ServiceChoiceLabel,  
   SortOrder,  
   Active,  
   Rowidentifier,  
   Createdby,  
   CreateDate,  
   ModifiedBy,  
   ModifedDate,  
   RecordDeleted,  
   DeletedDate,  
   DeletedBy  
  From CustomHRMLevelOfCareOptions where Active='Y' and Isnull(RecordDeleted,'N')='N'  
 End Try  
 Begin Catch  
  declare @Error varchar(8000)                
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                 
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetRecommendedServices')                 
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                  
  + '*****' + Convert(varchar,ERROR_STATE())  
    
 End Catch  
End  
GO


