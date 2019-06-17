
/****** Object:  StoredProcedure [dbo].[ssp_SCGetVerboseModeConfiguration]    Script Date: 09/13/2017 16:59:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetVerboseModeConfiguration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetVerboseModeConfiguration]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetVerboseModeConfiguration]    Script Date: 09/13/2017 16:59:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [dbo].[ssp_SCGetVerboseModeConfiguration]    
as  
/*********************************************************************/        
/* Stored Procedure: dbo.ssp_SCGetVerboseModeConfiguration													*/        
/* Copyright: 2007 Streamline Healthcare Solutions,  LLC													*/        
/* Creation Date: 13th Sept 2017																			*/        
/* File: ssp_SCGetVerboseModeConfiguration.sql																*/        
/* Name: ssp_SCGetVerboseModeConfiguration
Purpose: Get SP to retrieve the Verbose Mode configured data
Task:  EI#564 - Implement Verbose Mode Logging in SmartCare Application										*/        
/*																											*/      
/* Input Parameters:																						*/      
/*																											*/        
/* Output Parameters:																						*/       
/*																											*/        
/* Return:  																								*/        
/*																											*/        
/* Called By:																								*/        
/*																											*/        
/* Calls:																									*/        
/*																											*/        
/* Data Modifications:																						*/        
/*																											*/        
/* Updates:																									*/        
/*   Date					Author					Purpose																*/        
/*	 13-09-2017				Rahul					Get SP to retrieve the Verbose Mode configured data																						*/
/************************************************************************************************************/
       
BEGIN      


SELECT VerboseModeConfigurationId
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,RecordDeleted
      ,DeletedDate
      ,DeletedBy
      ,StaffId
      ,ScreenId
      ,ClientId
      ,LogUnsavedChangesXML
      ,DocumentCodeId
      ,StartDateTime
      ,EndDateTime
  FROM dbo.VerboseModeConfigurations

     
IF (@@error!=0)      
    BEGIN      
         RAISERROR  ( 'ssp_SCGetVerboseModeConfiguration : An Error Occured' ,16,1)     
         RETURN(1)      
    END       
      
      
RETURN(0)      
      
END





GO


