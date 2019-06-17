IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetLatestInquiryIdByClientId]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetLatestInquiryIdByClientId]
GO

CREATE PROCEDURE [dbo].[csp_GetLatestInquiryIdByClientId] @ClientId INT
AS
/********************************************************************************    
 * Get The latest inquiry id by client    
 * exec csp_GetLatestInquiryIdByClientId 119       
 * Purpose: Get recent inquiry id   
 * Author: PPOTNURU           
 * Created: 07/21/2014           
 * Task:    Customization Bugs 190   
 *     
  ********************************************************************************/
BEGIN
	SELECT InquiryId
	FROM CustomInquiries ci
	WHERE InquiryStartDateTime = (
			SELECT MAX(InquiryStartDateTime)
			FROM CustomInquiries ci
			WHERE ci.ClientId = @ClientId
				AND ISNULL(RecordDeleted, 'N') = 'N'
			)
END