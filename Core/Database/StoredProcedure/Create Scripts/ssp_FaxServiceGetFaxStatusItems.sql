 IF EXISTS ( SELECT *
             FROM   sys.objects
             WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_FaxServiceGetFaxStatusItems]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_FaxServiceGetFaxStatusItems;
GO

 SET QUOTED_IDENTIFIER ON;
 SET ANSI_NULLS ON;
GO


 CREATE PROCEDURE [ssp_FaxServiceGetFaxStatusItems]
 AS 
 /*========================================================================================================
-Stored Procedure: ssp_FaxServiceGetFaxStatusItems
-Creation Date:  01/15/2018
-Created By: Pranay Bodhu
-Purpose:
	Called by Fax-Server to Get the OutgoingFaxes which are in Queued Status.
-Input Parameters:None
-Output Parameters:None
-Return:
   Returns OutgoingFaxes which are in Queued status.
-Called by:
	FaxSerive Client Windows Service
Log:
-Date                           Name                                      Purpose
	
========================================================================================================*/
    SELECT  FaxExternalIdentifier ,
            MIN(OutgoingFaxId) ,
            'OutgoingFaxes'
    FROM    dbo.OutgoingFaxes
    WHERE   ISNULL(RecordDeleted, 'N') <> 'Y'
            AND Status = 6862
            AND FaxExternalIdentifier IS NOT NULL
    GROUP BY FaxExternalIdentifier;


GO

