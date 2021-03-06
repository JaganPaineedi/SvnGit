/****** Object:  StoredProcedure [dbo].[csp_jobAlertClinicianClientNeedsICPReview]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobAlertClinicianClientNeedsICPReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_jobAlertClinicianClientNeedsICPReview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobAlertClinicianClientNeedsICPReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_jobAlertClinicianClientNeedsICPReview]
	@AgeBeforeAlert int = 80
AS
/*********************************************************************/                    
/* Stored Procedure: dbo.[csp_jobAlertClinicianClientNeedsICPReview] */                    
/* Copyright: 2013 Streamline Healthcare Solutions,  LLC             */                    
/* Creation Date:    03/14/2013                                      */                    
/*                                                                   */                    
/* Purpose: Generate Alerts for any ICP Document older than			 */
/*						a certain number of days					 */                    
/*                                                                   */                  
/* Input Parameters: @AgeBeforeAlert - The number of days			 */
/*									   from Documents.EffectiveDate	 */                            
/*                                     After which an Alert will be  */
/*									   Generated                     */                    
/* Called By: Nightly Job                                            */                    
/*                                                                   */                    
/* Calls: None                                                       */                    
/*                                                                   */                    
/* Data Modifications: Addition to Alerts Table                      */                    
/*                                                                   */                    
/* Updates:                                                          */                    
/*   Date       Author              Purpose                          */                    
/*	 03/14/2013 David Knewtson      Creation                         */                    
/*********************************************************************/    

BEGIN TRY
DECLARE @WatchDocId int = 1000406 -- Integrated Care Plan
--DECLARE @AgeBeforeAlert int = 80 -- days
DECLARE @AlertTypeGlobalCode int = 81 -- ''Document''


Insert into dbo.Alerts
		(
			ToStaffId,
			ClientId,
			AlertType,
			Unread,
			Subject,
			Message,
			FollowUp,
			DocumentId,
			DateReceived,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate
		)
SELECT            
			c.PrimaryClinicianId,				 --ToStaffId
            c.ClientId,							 --ClientId
            @AlertTypeGlobalCode,				 --AlertType
			''Y'',								 --Unread
			''ICP Alert'',						 --Subject
			''The Integrated Care Plan for ''
				+ c.FirstName + '' '' + c.LastName --Message
				+ '' is due for Review.'' 
				+ Char(13) + Char(10) + Char(13) + Char(10) 
				+ ''Click the Reference Link to open the most recent ICP.'',
			''N'',								 --FollowUp
			d.DocumentId,						 --DocumentId
			GETDATE(),							 --DateRecieved
			''AlertICP'',						     --CreatedBy
			GetDate(),							 --CreatedDate
			''AlertICP'',							 --ModifiedBy
            GetDate()							 --ModifiedDate
	FROM Documents d
	JOIN Clients c on d.ClientId = c.ClientId
		AND ISNULL(c.RecordDeleted,''N'') = ''N''
		AND c.Active = ''Y''
	JOIN Staff s on s.StaffId = c.PrimaryClinicianId
		AND ISNULL(s.RecordDeleted,''N'') = ''N''
	WHERE
		d.DocumentCodeId = @WatchDocId	-- The Document must be the kind of document we''re watching
		AND d.Status = 22				-- The Document must be signed
		AND ISNULL(d.RecordDeleted,''N'') = ''N''
		AND NOT EXISTS (SELECT 1 FROM Alerts a where d.DocumentId = a.DocumentId)
		AND NOT EXISTS (SELECT 1 FROM Documents d2  
							WHERE 
								d2.ClientId = c.ClientId
								AND d2.DocumentCodeId = d.DocumentCodeId
								AND d2.Status = 22
								AND ISNULL(d2.RecordDeleted,''N'') = ''N''
								AND (d2.EffectiveDate > d.EffectiveDate 
									OR (d2.EffectiveDate = d.EffectiveDate AND d2.DocumentId > d.DocumentId) )
						)-- Must be the latest signed document of this type for the client
		AND DATEDIFF(day,d.EffectiveDate,GETDATE()) >= @AgeBeforeAlert  -- And the Effective date was more than 80 days ago.

END TRY
BEGIN CATCH

exec ssp_SQLErrorHandler

END CATCH

' 
END
GO
