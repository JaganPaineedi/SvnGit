/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformation]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentGetCrisisServiceNoteInformationScore35]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformationScore35]
GO


/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformationScore35]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
    
CREATE PROCEDURE [dbo].[csp_CustomDocumentGetCrisisServiceNoteInformationScore35]    
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
-3,'• Scoring: 36-52: Risk: HIGH; Suggested Management Plan: Psychiatric admission required. Involuntary admission may be required. '
;  
       
select * from #CrisiServiceNoteInfo       
       
  END     
GO


