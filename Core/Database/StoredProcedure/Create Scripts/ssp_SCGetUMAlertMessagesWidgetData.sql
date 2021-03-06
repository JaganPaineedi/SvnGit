/****** Object:  StoredProcedure [dbo].[ssp_SCGetUMAlertMessagesWidgetData]    Script Date: 11/18/2011 16:25:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetUMAlertMessagesWidgetData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetUMAlertMessagesWidgetData]
GO

CREATE PROCEDURE [dbo].[ssp_SCGetUMAlertMessagesWidgetData] (
	@StaffId INT
	,@LoggedInStaffId INT
	,@RefreshData CHAR(1) = NULL
	)
AS 
/*********************************************************************
** Stored Procedure: ssp_SCGetUMAlertMessagesWidgetData              
** Copyright: 2005 Streamline Healthcare Solutions,  LLC             
** Creation Date:   12/1/2006                                        
**                                                                   
** Purpose:  It is used to return the messages or Alerts list which  
**           we show on the UM Tab dashboard for the loged user      
**                                                                   
** Input Parameters: @StaffId                                     
**                                                                   
** Output Parameters:   None                                         
**                                                                   
** Return:  0=success, otherwise an error number                     
**                                                                   
** Updates:                                                          
** Date			Author		  Purpose                                    
** 01/10/2010   Vikas Vyas	  Created                                    
** 30/10/2012   Rakesh-II	  altered as widget was not loading #25 in Newaygo Implementation Tasks  
** 11/4/2014	NJain		  Added Order by Received
** 20/11/2014	Akwinas		  Instead of '<> NULL' included 'IS NOT NULL' (Task #33.1 in WMU - Enhancements.)
** 02/15/2018	jcarlson	  Andrews Center SGL 13 - insert data into temp table then return data with sorting the recevied field before it is converted to string
** 03/07/2018   jcarlson	  Andrews Center SGL 13 - Added DESC and Convert varchar date to DATE in ORDER BY so the data is sorted correctly
** 08/20/2018   Rajeshwari S  Remove the code to display null values when StaffId and LoggedInStaffId is not same.	Journey-Support Go Live #240
**********************************************************************/
          
SELECT (
		CASE 
			WHEN c.FirstName IS NOT NULL --20/11/2014	Akwinas
				THEN RTRIM(ISNULL(c.LastName, '')) + ', ' + RTRIM(ISNULL(c.FirstName, ''))
			ELSE RTRIM(c.LastName)
			END
		) AS FromLastName
	,RTRIM(ISNULL(c.FirstName, '')) AS FromFirstName
	,CAST(a.dateReceived AS DATE) AS Received
	,(
		CASE 
			WHEN b.FirstName IS NOT NULL --20/11/2014	Akwinas
				THEN RTRIM(ISNULL(b.LastName, '')) + ', ' + RTRIM(ISNULL(b.FirstName, ''))
			ELSE RTRIM(ISNULL(b.LastName, ''))
			END
		) AS ClientLastName
	,RTRIM(ISNULL(b.FirstName, '')) AS CLientFirstName
	,ISNULL(a.Subject, '') AS Subject
	,SUBSTRING(REPLACE(REPLACE(CAST(ISNULL(a.Message, '') AS VARCHAR(8000)), CHAR(10), ''), CHAR(13), ''), 1, 60) AS Message
	,a.MessageId
	,'Message' AS MessageType
INTO #Results
FROM Messages a
LEFT JOIN Clients b ON b.Clientid = a.Clientid
	AND ISNULL(b.RecordDeleted, 'N') <> 'Y'
LEFT JOIN StaffClients sc ON sc.StaffId = @LoggedInStaffId
	AND sc.ClientId = b.ClientId
LEFT JOIN Staff c ON a.FromStaffId = c.StaffId
	AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
WHERE a.unread = 'Y'
	AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
	AND a.ToStaffId = @StaffId

UNION ALL

SELECT 'System' AS FromLastName
	,'' AS FromFirstName
	,CAST(a.dateReceived AS DATE ) AS Received
	,RTRIM(ISNULL(b.LastName, '')) + ', ' + RTRIM(ISNULL(b.FirstName, '')) AS ClientLastName
	,RTRIM(ISNULL(b.FirstName, '')) AS ClientFirstName
	,ISNULL(a.Subject, '')
	,SUBSTRING(REPLACE(REPLACE(ISNULL(a.Message, ''), CHAR(10), ''), CHAR(13), ''), 1, 60) AS Message
	,a.AlertId AS MessageId
	,'Alert' AS MessageType
FROM Alerts a
LEFT JOIN Clients b ON a.ClientId = b.ClientId
	AND ISNULL(b.RecordDeleted, 'N') <> 'Y'
LEFT JOIN StaffClients sc ON sc.StaffId = @LoggedInStaffId
	AND sc.ClientId = b.ClientId
WHERE a.ToStaffId = @StaffId
	AND a.Unread = 'Y'
	AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
ORDER BY Received DESC

SELECT FromLastName, FromFirstName, CONVERT(VARCHAR(18),Received,101) AS Received, ClientLastName, CLientFirstName, [Subject], [Message], MessageId, MessageType
FROM #Results 
ORDER BY CONVERT(DATE,Received) DESC 

RETURN (0)
