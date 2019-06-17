IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_NoteTagSystemScreenOrderNewVitals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_NoteTagSystemScreenOrderNewVitals]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_NoteTagSystemScreenOrderNewVitals] 
@ClientId INT,
@DocumentId INT,
@EffectiveDate DATETIME
AS 
/******************************************************************************
**		File: ssp_NoteTagSystemScreenOrderNewVitals.sql
**		Name: ssp_NoteTagSystemScreenOrderNewVitals
**		Desc: Note Tag System Screen Order New Vitals
**			  Reference Summit Pointe - Enhancements, Task #515
**              
**		Return values: '^' delimited key-value pairs:
**									 OpenMode=Update
**									 HealthDataTemplateId=110
**								     HealthRecordDate=<MM/DD/YYYY ##:## [AM|PM]>
**									 clientId=<####>
**									 clientName=<LastName>, <FirstName> 
** 
**		Called by: 'New Vitals' Link from Client Progress Notes  
**              
**		Parameters:
**		Input							Output
**		ClientId						-----------
**		DocumentId
**		Effecttive Date
**
**		Auth: Jason Steczynski
**		Date: 4/9/2015
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
** 
**    16 Oct 2015	Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName. 
  										why:task #609, Network180 Customization    
*******************************************************************************/
    BEGIN
		BEGIN TRY

			declare @dat datetime = getdate()
			select '^OpenMode=Update^HealthDataTemplateId=110^HealthRecordDate=' +  convert(varchar(10), @dat, 101) + ' ' + ltrim(substring(rtrim(right(convert(varchar(26), @dat, 100),7)),0,6) + ' ' + right(convert(varchar(26),@dat,109),2)) + '^clientId=' + convert(varchar(20), @ClientId) + '^clientName=' +
			 (select CASE --Added by Revathi  16 Oct 2015
						WHEN ISNULL(ClientType, 'I') = 'I'
							THEN ISNULL(lastname, '') + ', ' + ISNULL(firstname, '')
						ELSE ISNULL(OrganizationName, '')
						END from clients where ClientId = @ClientId)
			
		END TRY
	
		BEGIN CATCH
			DECLARE @Error varchar(8000)
			SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE()) 
						+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ClientPrograms') 
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
