
/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentGetCurrentLifeEvents]    Script Date: 03/17/2015 16:10:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentGetCurrentLifeEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentGetCurrentLifeEvents]
GO

/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentGetCurrentLifeEvents]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_CustomDocumentGetCurrentLifeEvents] 
@ClientId           INT 
,@DocumentVersionId INT 
,@ServiceId         INT 
AS 
/**********************************************************************/ 
/* Stored Procedure: csp_CustomDocumentGetCurrentLifeEvents               */ 
/* Updates:                         */ 
/* 12 July 2012  Rohit Katoch  getting  only two columns for RDLS #1489, Threshold bugs and features, Previous Phase changes, added (AND P.ProgramType=(select GlobalCodeId from globalcodes where  Code='TEAM' and category='PROGRAMTYPE'))  */ 
/* 07/Jan/2015  Malathi Shiva  Woods Customization: Task#824 - Formatted and moved to common folder for Woods usage */
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

      IF EXISTS (SELECT 1 
                 FROM   ClientLifeEvents cle 
                        LEFT JOIN LifeEvents le 
                               ON le.LifeEventId = cle.LifeEventId 
                                  AND ISNULL(le.RecordDeleted, 'N') = 'N' 
                 WHERE  cle.ClientId = @ClientId 
                        AND le.Active = 'Y' 
                        AND cle.BeginDate <= @DateOfService 
                        AND ( cle.EndDate IS NULL 
                               OR cle.EndDate >= @DateOfService ) 
                        AND ISNULL(cle.RecordDeleted, 'N') = 'N') 
        BEGIN 
            SELECT le.LifeEventId        AS 'CustomInformationId' 
                   ,le.LifeEventName + ': ' 
                    + CONVERT(VARCHAR, cle.BeginDate, 101) 
                    + ' - Current<br />' AS InformationText 
            FROM   ClientLifeEvents cle 
                   LEFT JOIN LifeEvents le 
                          ON le.LifeEventId = cle.LifeEventId 
                             AND ISNULL(le.RecordDeleted, 'N') = 'N' 
            WHERE  cle.ClientId = @ClientId 
                   AND le.Active = 'Y' 
                   AND cle.BeginDate <= @DateOfService 
                   AND ( cle.EndDate IS NULL 
                          OR cle.EndDate >= @DateOfService ) 
                   AND ISNULL(cle.RecordDeleted, 'N') = 'N' 
        END 
      ELSE 
        BEGIN 
            SELECT -1                      AS 'CustomInformationId' 
                   ,'No Life Events found' AS 'InformationText' 
        END 
  END 

GO


