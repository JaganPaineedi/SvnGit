/****** Object:  StoredProcedure [dbo].[SSP_SCGetLinkedProviders]    Script Date: 02/03/2015 01:57:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLinkedProviders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetLinkedProviders]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
 /*********************************************************/                                        
/* Stored Procedure: dbo.SSP_SCGetLinkedProviders        */                                        
/* Creation Date:  03/12/2012                             */                                       
/* Purpose: To check whether the selected provider is associated to any other Placement Family or not */                                     
/* Input Parameters: @FosterReferralId              */                                                                    
/*  Date                  Author                 Purpose  */                                        
/* 12/10/2015             Veena                Created  */                                        
/**********************************************************/                   
CREATE Procedure [dbo].[SSP_SCGetLinkedProviders]                      
 @ProviderId int                      
AS                      
BEGIN                      
BEGIN TRY          
  Select PlacementFamilyId from PlacementFamilies where LinkedProviderId=@ProviderId
  END TRY                                    
 BEGIN CATCH                                  
   RAISERROR  20006  'SSP_SCGetLinkedProviders: An Error Occured'                                         
   Return                                      
 END CATCH        
 END  
GO
