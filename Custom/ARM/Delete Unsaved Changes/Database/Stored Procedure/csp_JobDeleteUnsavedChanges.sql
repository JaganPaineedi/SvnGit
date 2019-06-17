IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_JobDeleteUnsavedChanges')
	BEGIN
		DROP PROCEDURE csp_JobDeleteUnsavedChanges
	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[csp_JobDeleteUnsavedChanges]

AS

--Create key for quick configuration of maximum allowable days an unsaved change can exist
IF NOT EXISTS (
		SELECT 1 
		FROM dbo.SystemConfigurationKeys
		WHERE [Key] = 'LengthOfUnsavedChangesDays')
BEGIN
INSERT INTO dbo.SystemConfigurationKeys
        ( [Key] ,
          Value ,
          Description ,
          AcceptedValues ,
          ShowKeyForViewingAndEditing ,
          Modules ,
          Screens ,
          Comments
        )
VALUES  ( 'LengthOfUnsavedChangesDays' , -- Key - varchar(200)
          '3' , -- Value - varchar(max)
          'This key sets the maximum number of days an unsaved change can exist before nightly deletion' , -- Description - type_Comment2
          '1,2,3,4,5,6,7,8,9,10' , -- AcceptedValues - varchar(max)
          'Y' , -- ShowKeyForViewingAndEditing - type_YOrN
          NULL , -- Modules - varchar(500)
          NULL , -- Screens - varchar(500)
          NULL  -- Comments - type_Comment2
        )
END

--Set @KeyValue equal to absolute value of our configured maximum allowable days unsaved changes can exist
DECLARE @KeyValue INT = (SELECT ABS(CAST(Value AS INT))
						FROM SystemConfigurationKeys
						WHERE [key] = 'LengthOfUnsavedChangesDays')

--delete from unsaved changes if the difference between the created date and the current date is greater than @KeyValue
DELETE
FROM dbo.UnsavedChanges
WHERE DATEDIFF(DAY, CreatedDate, GETDATE()) > @KeyValue

GO
