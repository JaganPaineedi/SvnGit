/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformation]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentGetCrisisServiceNoteInformationScore18]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformationScore18] 
GO


/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformationScore18]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
    
CREATE PROCEDURE [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformationScore18]    
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
 -2,'• Scoring: 18-35: Risk: MEDIUM; Suggest Management Plan: May be sent home with agreement by family or friends, that they will provide 24 hour supervision, line-of site. Remove access to means to harm.   
o Next day follow-up assessment by CMHP, private provider or psychiatric provider required.  
o Place person on crisis call list with specific instruction for skills and reminder/check for compliance of safety plan.  
o Crisis Respite should be considered with or without a psych sitter. Psychiatric Admission recommended if individual:   
• Lives alone  
• Has a history of previous suicide attempt; or  
• Is clinically depressed    
'
;  
       
select * from #CrisiServiceNoteInfo       
       
  END     
GO


