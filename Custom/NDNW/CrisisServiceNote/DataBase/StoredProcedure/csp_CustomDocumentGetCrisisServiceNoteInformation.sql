/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformation]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentGetCrisisServiceNoteInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformation] 
GO


/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformation]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
    
CREATE PROCEDURE [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformation]    
 @ClientId           INT     
,@DocumentVersionId INT     
,@ServiceId         INT     
AS     
  
  
/**********************************************************************/     
/* Stored Procedure: csp_CustomDocumentGetCrisisServiceNoteInformation               */     
/* Updates:                         */     
/* 09 Apr 2015 Vichee Humane New Directions - Customization #3 */    
  /*********************************************************************/     
  BEGIN     
      DECLARE @DateOfService DATETIME     
    
      IF @ServiceId IS NOT NULL     
         AND @ServiceId <> 0     
        BEGIN     
            SELECT @DateOfService = DateOfService     
            FROM   Services     
            WHERE  ServiceId = @ServiceId     
        END     
      ELSE     
        BEGIN     
            SET @DateOfService = CONVERT(VARCHAR, Getdate(), 101)     
        END     
    
  Create table #CrisiServiceNoteInfo   
  (  
  CustomInformationId int,
  InformationText varchar (max)
  
  )  
    
  insert into #CrisiServiceNoteInfo
  select
  -1, '• Scoring: 0-17: Risk: LOW; Suggested Management Plan: May be sent home with advice to see community Mental Health Program (CMHP) or private provider for follow up the next day. Place individual on crisis call
 list with skill reminder and specific safety plan in note.'
;  
       
select * from #CrisiServiceNoteInfo       
       
  END     
GO


