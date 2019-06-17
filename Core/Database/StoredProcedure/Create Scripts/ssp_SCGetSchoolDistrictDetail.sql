

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSchoolDistrictDetail]    Script Date: 06/04/2018 15:59:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSchoolDistrictDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSchoolDistrictDetail]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetSchoolDistrictDetail]    Script Date: 06/04/2018 15:59:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_SCGetSchoolDistrictDetail] @SchoolDistrictId INT  
AS  
/*********************************************************************/  
/* Stored Procedure: dbo.ssp_SCGetSchoolDistrictDetail   137           */  
/* Copyright:Streamline Healthcare Solutions,  LLC             */  
/* Creation Date:    12/Mar/2018                                         */  
/* Created By : Pradeep Kumar Yadav                                                                */  
/* Purpose:  Used in getdata() for School District Detail Page  */  
/*                                                                   */  
/* Input Parameters: @SchoolDistrictId   */  
/*                                                                   */  
/* Output Parameters:   None                */  
/*                                                                   */  
/*********************************************************************/  
BEGIN  
 BEGIN TRY    
  
  SELECT SD.SchoolDistrictId,
SD.CreatedBy,
SD.CreatedDate,
SD.ModifiedBy,
SD.ModifiedDate,
SD.RecordDeleted,
SD.DeletedBy,
SD.DeletedDate,
SD.DistrictName,
SD.DistrictId,
SD.DistrictAddress,
SD.Active,
SD.ClientSchoolDistrict
 From SchoolDistricts As SD
  WHERE SchoolDistrictId = @SchoolDistrictId  
  AND ISNULL(SD.RecordDeleted, 'N') = 'N'  
  
  SELECT SDC.SchoolDistrictContactId,
SDC.CreatedBy,
SDC.CreatedDate,
SDC.ModifiedBy,
SDC.ModifiedDate,
SDC.RecordDeleted,
SDC.DeletedBy,
SDC.DeletedDate,
SDC.SchoolDistrictId,
SDC.Title,
dbo.csf_GetGlobalCodeNameById(Title) as TitleText,
SDC.FirstName,
SDC.LastName,
SDC.PrimaryContact,
SDC.Email,
SDC.Active,
SDC.Phone,  
SDC.LastName+','+SDC.FirstName As Name
  FROM SchoolDistrictContacts SDC  
   Where SDC.SchoolDistrictId=@SchoolDistrictId  
   AND ISNULL(SDC.RecordDeleted, 'N') = 'N'  
 
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetSchoolDistrictDetail]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                          
    16  
    ,-- Severity.                                                                          
    1 -- State.                                                                          
    );  
 END CATCH  
END  
GO


