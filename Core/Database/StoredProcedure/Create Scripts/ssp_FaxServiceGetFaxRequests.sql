 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_FaxServiceGetFaxRequests]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE ssp_FaxServiceGetFaxRequests
GO


SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE ssp_FaxServiceGetFaxRequests
/*========================================================================================================
-Stored Procedure: ssp_FaxServiceGetFaxRequests
-Creation Date:  01/15/2018
-Created By: Pranay Bodhu
-Purpose:
	Called by Fax-Server to Get the FaxRequests.
-Input Parameters:None
-Output Parameters:None
-Return:
   Returns OutgoingFaxes which are in pending status.
-Called by:
	FaxSerive Client Windows Service
Log:
-Date                           Name                                      Purpose
	
========================================================================================================*/
AS
    BEGIN
        SELECT  fo.OutgoingFaxId ,
               '' as  ImageRecordId ,
                '' AS ImageRecordItemId ,
                '' AS ItemImage ,
                s.FirstName + ',' + s.LastName AS FromAddress ,
                fo.FaxTo AS FaxTo ,
                fo.FaxNumber AS FaxNumber ,
                fo.Subject ,
                fo.CoverLetterNote ,
                'N' AS [Sent] ,
                fo.Attempt ,
                fo.ClientDisclosureId ,
                r.Name AS CoverLetterName ,
                r.ReportServerPath
        FROM    OutgoingFaxes fo 
                JOIN Staff s ON s.StaffId = fo.FromStaffId
                LEFT JOIN Reports r ON r.ReportId = fo.CoverLetterId
        WHERE   fo.Status = 6861
                AND ISNULL(s.FirstName, '') != ''
                AND ISNULL(s.LastName, '') != ''
                AND ISNULL(fo.FaxTo, '') != ''
                AND ISNULL(fo.RecordDeleted, 'N') = 'N'
                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                AND ISNULL(r.RecordDeleted, 'N') = 'N'
        ORDER BY fo.OutgoingFaxId ASC;
    END;


GO

