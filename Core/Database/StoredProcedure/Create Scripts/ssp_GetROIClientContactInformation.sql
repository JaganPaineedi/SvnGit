/****** Object:  StoredProcedure [dbo].[ssp_GetROIClientContactInformation]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetROIClientContactInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetROIClientContactInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetROIClientContactInformation]    Script Date: 12/1/2017 1:23:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetROIClientContactInformation] 
 @ClientContactId Int    
AS    
-- ================================================================    
-- Stored Procedure: ssp_GetROIClientContactInformation    
-- Create Date : Nov 22 2017   
-- Purpose : To Retrive the ClientContact Information Based on ClientContactId    
-- Input Parameter : @ClientContactId    
-- Created By : Ponnin S 
-- ================================================================    
-- History --    
 
-- ================================================================    
BEGIN    
 BEGIN TRY    
     
  Declare @ContactName nvarchar(80)    
  Declare @ContactAddress nvarchar(150)    
  Declare @ContactCity nvarchar(50)    
  Declare @ContactState nvarchar(50)    
  Declare @ContactZip nvarchar(25)    
  Declare @ContactPhone nvarchar(80)   
  Declare @Organization nvarchar(80)    
      
      
     
  SELECT @ContactName = COALESCE(CC.LastName, '') + ', ' + COALESCE(CC.FirstName, '')   
  ,@Organization = ISNULL(CC.Organization,'')   
  FROM ClientContacts AS CC    
  WHERE CC.ClientContactId = @ClientContactId    
   AND ISNULL(CC.RecordDeleted, 'N') = 'N'    
    
  -- First Priority to Get the Home Address    
  IF EXISTS (    
    SELECT 1    
    FROM ClientContactAddresses CCA    
    INNER JOIN ClientContacts CC ON CC.ClientContactId = CCA.ClientContactId    
    WHERE CC.ClientContactId = @ClientContactId    
     AND CCA.AddressType = 90    
     AND ISNULL(CCA.RecordDeleted, 'N') = 'N'    
     AND ISNULL(CC.RecordDeleted, 'N') = 'N'    
    )    
  BEGIN    
   SELECT TOP 1 @ContactAddress =CCA.Address    
    ,@ContactCity = CCA.City    
    ,@ContactState = CCA.STATE    
    ,@ContactZip = CCA.Zip    
   FROM ClientContactAddresses CCA    
   WHERE CCA.ClientContactId = @ClientContactId    
    AND CCA.AddressType = 90    
    AND ISNULL(CCA.RecordDeleted, 'N') = 'N'    
  END    
  ELSE    
  BEGIN    
   IF EXISTS (    
     SELECT 1    
     FROM ClientContactAddresses CCA    
     INNER JOIN ClientContacts CC ON CC.ClientContactId = CCA.ClientContactId    
     WHERE CC.ClientContactId = @ClientContactId    
      AND ISNULL(CCA.RecordDeleted, 'N') = 'N'    
      AND ISNULL(CC.RecordDeleted, 'N') = 'N'    
     )    
   BEGIN    
    SELECT TOP 1 @ContactAddress= CCA.Address    
     ,@ContactCity = CCA.City    
     ,@ContactState = CCA.State    
     ,@ContactZip = CCA.Zip    
    FROM ClientContactAddresses CCA    
    WHERE CCA.ClientContactId = @ClientContactId    
     AND ISNULL(CCA.RecordDeleted, 'N') = 'N'    
   END    
   ELSE     
   BEGIN    
    SELECT @ContactAddress= ''    
     ,@ContactCity = ''     
     ,@ContactState = ''     
     ,@ContactZip =''     
   END    
  END    
      
  -- First Priority to Get the Home Phone    
  IF EXISTS (    
    SELECT 1    
    FROM ClientContactPhones CCP    
    INNER JOIN ClientContacts CC ON CC.ClientContactId = CCP.ClientContactId    
    WHERE CC.ClientContactId = @ClientContactId    
     AND CCP.PhoneType = 90    
     AND ISNULL(CCP.RecordDeleted, 'N') = 'N'    
     AND ISNULL(CC.RecordDeleted, 'N') = 'N'    
    )    
  BEGIN    
   SELECT TOP 1 CCP.ClientContactId    
    ,CCP.PhoneNumber    
   FROM ClientContactPhones CCP    
   WHERE CCP.ClientContactId = @ClientContactId    
    AND CCP.PhoneType = 90    
    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'    
  END    
  ELSE    
  BEGIN    
   IF EXISTS (    
     SELECT 1    
     FROM ClientContactPhones CCP    
     INNER JOIN ClientContacts CC ON CC.ClientContactId = CCP.ClientContactId    
     WHERE CC.ClientContactId = @ClientContactId    
      AND ISNULL(CCP.RecordDeleted, 'N') = 'N'    
      AND ISNULL(CC.RecordDeleted, 'N') = 'N'    
     )    
   BEGIN    
    SELECT TOP 1 @ContactPhone = CCP.PhoneNumber    
    FROM ClientContactPhones CCP    
    WHERE CCP.ClientContactId = @ClientContactId    
     AND ISNULL(CCP.RecordDeleted, 'N') = 'N'    
   END    
   ELSE    
   BEGIN    
    SELECT @ContactPhone = ''    
   END    
  END    
      
  Select @ContactName As Name,    
      @ContactAddress AS Address,    
      @ContactCity AS City,    
      @ContactState As State,    
      @ContactZip As Zip,    
      @ContactPhone As Phone,  
      @Organization AS Organization    
 END TRY    
 BEGIN CATCH     
  DECLARE @Error varchar(8000)                                                   
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetROIClientContactInformation')                                                                                 
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


