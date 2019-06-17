
/****** Object:  StoredProcedure [dbo].[ssp_SCLogVerboseModeInformation]    Script Date: 09/13/2017 17:07:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCLogVerboseModeInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCLogVerboseModeInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCLogVerboseModeInformation]    Script Date: 09/13/2017 17:07:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROC [dbo].[ssp_SCLogVerboseModeInformation](      
@UserCode varchar(30)        
,@StaffId int
,@ScreenId int
,@ClientId int=null
,@ProviderId int=null
,@UnsavedChangesXML xml=null
,@PageDataSetXML xml=null
,@ScreenProperties varchar(max)=null
,@VerboseInfo text=null
,@DataSetInfo text=null
,@DocumentCodeId int=null
)      
as  
/*********************************************************************/        
/* Stored Procedure: dbo.ssp_SCGetVerboseModeConfiguration													*/        
/* Copyright: 2007 Streamline Healthcare Solutions,  LLC													*/        
/* Creation Date: 13th Sept 2017																			*/        
/* File: ssp_SCLogVerboseModeInformation.sql																*/        
/* Name: ssp_SCLogVerboseModeInformation
   Purpose: To log the User Activity in a Verbose Mode														*/        
/* Task:  EI#564 - Implement Verbose Mode Logging in SmartCare Application																											*/      
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
/*   Date				Author					Purpose																*/        
/*	 13-09-2017			Rahul					To log the User Activity in a Verbose Mode																									*/
/************************************************************************************************************/
       
BEGIN      


INSERT INTO [dbo].[VerboseModeLog]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[StaffId]
           ,[ScreenId]
           ,[ClientId]
           ,[ProviderId]
           ,[UnsavedChangesXML]
           ,[PageDataSetXML]
           ,[ScreenProperties]
           ,[VerboseInfo]
           ,[DataSetInfo]
           ,[DocumentCodeId]
           )
     VALUES
     (@UserCode  
        ,Getdate()
        ,@UserCode  
        ,Getdate()       
		,@StaffId
		,@ScreenId
		,@ClientId
		,@ProviderId
		,@UnsavedChangesXML
		,@PageDataSetXML
		,@ScreenProperties
		,@VerboseInfo
		,@DataSetInfo
		,@DocumentCodeId
		)
     
IF (@@error!=0)      
    BEGIN      
         RAISERROR  ( 'ssp_SCLogVerboseModeInformation : An Error Occured' ,16,1)     
         RETURN(1)      
    END       
      
      
RETURN(0)      
      
END


GO


