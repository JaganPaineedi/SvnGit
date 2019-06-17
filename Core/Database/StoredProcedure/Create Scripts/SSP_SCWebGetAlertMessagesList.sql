

/****** Object:  StoredProcedure [dbo].[SSP_SCWebGetAlertMessagesList]    Script Date: 02/19/2016 11:43:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCWebGetAlertMessagesList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCWebGetAlertMessagesList]
GO



/****** Object:  StoredProcedure [dbo].[SSP_SCWebGetAlertMessagesList]    Script Date: 02/19/2016 11:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCWebGetAlertMessagesList] (
	@StaffId INT
	,@LoggedInStaffId INT
	,@RefreshData CHAR(1) = NULL
	)
AS
/*********************************************************************/
/* Stored Procedure: ssp_GetAlertMessagesList       */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    8/1/05                                          */
/*                                                                   */
/* Purpose:  It is used to return the messages  or Alerts list which we show on the dashboard for the loged user          */
/*                                                                   */
/* Input Parameters: @StaffId           */
/*                                                                   */
/* Output Parameters:   None              */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*  Date     Author       Purpose                                    */
/* 8/1/05   Vikas     Created           */
/*01 march 2008 Pramod returning lastname frist name as single field */
/*March 7, 2012 Kneale Alpers updated the client not to return null value */
/*April 22,2012 Vikas Kashyap (Subject Column Set isNull Condition)*/
/*Nove 07, 2012 Sunil kh  Add Isnull check for  Subject, client, Message fields only */
/*  21 Oct 2015    Revathi    what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /     
/            why:task #609, Network180 Customization  */
/*-- 19.02.2016	Pradeep Kumar Yadav		What: Added Condition to Check ClientID when selecting ClientName.
								Why : It was returning only ',' if ClientId is 0. SWMBH - Support #867.
*/
/*August 02, 2018 Neha  What:Retrieving AlertType,ServiceId,ClienId and DocumentId. 
						Why: Clicking on the hyperlink that is on the subject of the Alert, should navigate to the Service Note screen (If alerttype is 'Services') instead of Alert Details.
						As per Engineering Improvement Initiatives- NBL(I) - 699
 */
/* 08/24/2076   Chethan N   What : Retrieving ClientOrderId based on the Reference Type -- 'LabResults', 'BatchLabResults'
							Why : Engineering Improvement Initiatives- NBL(I) task #551*/
/* 30/11/2018   Lakshmi     What: Temp table @AlertMessages, the coloumn AlertType length declared with 20 character but while insering										data to the temptable the length what we specfied for the coloumn AlertType is insuffiecent and it was									causing the issue(String or binary data would be truncated.)
							Why:  Barry - Support #613*/
/*06/02/2019    Prem        What :Added IsNull check for AlertType while getting the result set.
                            why:Kalamazoo Build Cycle Tasks#62   */								
												
/* ********************************************************************/
BEGIN
	BEGIN TRY
		--get the data from messages                      
		IF (@StaffId <> @LoggedInStaffId)
		BEGIN
			SET FMTONLY ON

			SELECT NULL AS 'FromName'
				,NULL AS 'Received'
				,NULL AS 'Subject'
				,NULL AS 'Client'
				,NULL AS 'Message'
				,NULL AS 'MessageId'
				,NULL AS 'AlertType'  
				,NULL AS 'ServiceId'  
				,NULL AS 'DocumentId'  
				,NULL AS 'ClientId' 
				,NULL AS 'ClientOrderId'

			SET FMTONLY OFF

			RETURN (0)
		END

		DECLARE @AlertMessages TABLE (
			FromName VARCHAR(300)
			,Received VARCHAR(12)
			,[Subject] VARCHAR(max)
			,Client VARCHAR(300)
			,[Message] VARCHAR(max)
			,MessageId INT
			,DateSort DATETIME
			,AlertType VARCHAR(100)  
			,ServiceId INT  
	        ,DocumentId INT  
		    ,ClientId INT 
		    ,ClientOrderId INT
			)

		INSERT INTO @AlertMessages
		--select                    
		----Change By Pramod Prakash On 01 March 2008                   
		-- -- rtrim(c.LastName) as FromLastName,rtrim(c.FirstName) as FromFirstName ,                  
		----now returning last name and fisrt as single field                  
		--rtrim(c.LastName)+', ' +  rtrim(c.FirstName)as FromName ,                  
		-- convert(varchar,a.dateReceived,101) as Received ,                       
		--a.Subject,rtrim(b.LastName)+', ' +  rtrim(b.FirstName)  as Client ,a.Message,a.MessageId         
		--,a.dateReceived as Datesort        
		--from Messages a                      
		--Left outer join Clients b on b.Clientid= a.Clientid  and IsNull(b.RecordDeleted,'N')<>'Y'                    
		--Left outer join Staff c  on a.FromStaffId=c.StaffId  and IsNull(c.RecordDeleted,'N')<>'Y'          
		--where  a.unread='Y' and isNull(a.RecordDeleted,'N')<>'Y'  and a.ToStaffId= @StaffId                       
		----where a.MessageId in (select Top 2 MessageId from Messages Order by messageid desc)  )        
		--Modified by priya      
		SELECT CASE 
				WHEN a.FromStaffId IS NOT NULL
					THEN rtrim(isnull(c.LastName, '')) + ', ' + rtrim(isnull(c.FirstName, ''))
				ELSE FromSystemStaffName
				END AS FromName
			,convert(VARCHAR, a.dateReceived, 101) AS Received
			,isnull(a.Subject, '') AS Subject
			,
			--Added by Revathi 21 Oct 2015  
			CASE 
				WHEN a.ClientId <> 0
					THEN CASE 
							WHEN ISNULL(b.ClientType, 'I') = 'I'
								THEN isnull(rtrim(ISNULL(b.LastName, '')) + ', ' + rtrim(ISNULL(b.FirstName, '')), '')
							ELSE ISNULL(b.OrganizationName, '')
							END
				ELSE ''
				END AS Client
			,isnull(a.Message, '') AS [Message]
			,isnull(a.MessageId, 0) AS MessageId
			,a.dateReceived AS Datesort
		    ,dbo.ssf_GetGlobalCodeCODEById(a.ReferenceType) AS AlertType  
		    ,-1 AS ServiceId  
		    ,-1 AS documentid  
		    ,ISNULL(CO.ClientId, -1) AS ClientId
		    ,ISNULL(CO.ClientOrderId, -1) AS ClientOrderId
		FROM Messages a
		LEFT JOIN Clients b ON b.Clientid = a.Clientid
			AND IsNull(b.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff c ON a.FromStaffId = c.StaffId
			AND IsNull(c.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff d ON a.FromSystemStaffId = d.StaffId
			AND IsNull(c.RecordDeleted, 'N') <> 'Y' 
		LEFT JOIN ClientOrders CO ON CO.ClientOrderId = a.ReferenceId AND dbo.ssf_GetGlobalCodeCODEById(a.ReferenceType) IN ('LabResults', 'BatchLabResults')
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
		WHERE a.unread = 'Y'
			AND isNull(a.RecordDeleted, 'N') <> 'Y'
			AND a.ToStaffId = @StaffId
			AND a.DateReceived < = GETDATE()
		
		UNION ALL
		
		-- get the Data from Alerts                      
		SELECT
			--Change By Pramod on 1 march 2008 now first name and last name                   
			--now returning last name and fisrt as single field                  
			-- 'System' as FromLastName,'' as FromFirstName ,                  
			'System' AS FromName
			,convert(VARCHAR, a.dateReceived, 101) AS Received
			,isnull(a.Subject, '') AS Subject
			,CASE 
				WHEN a.ClientId <> 0
					THEN CASE 
							WHEN ISNULL(b.ClientType, 'I') = 'I'
								THEN isnull(rtrim(ISNULL(b.LastName, '')) + ', ' + rtrim(ISNULL(b.FirstName, '')), '')
							ELSE ISNULL(b.OrganizationName, '')
							END
				ELSE ''
				END AS Client
			--,isnull(rtrim(b.LastName) + ', ' + rtrim(b.FirstName), '') AS Client  
			,isnull(a.Message, '') AS [Message]
			,isnull(a.AlertId, 0) AS MessageId
			,a.dateReceived AS Datesort 
		    ,dbo.ssf_GetGlobalCodeCODEById(a.AlertType) AS AlertType   
		    ,ISNULL(S.ServiceId, -1) AS ServiceId  
		    ,ISNULL(a.DocumentId, -1) AS DocumentId  
		    ,ISNULL(a.ClientId, -1) AS ClientId 
		    ,-1 AS ClientOrderId
		FROM alerts a
		 LEFT JOIN Documents d ON d.DocumentId = a.DocumentId   
            AND isnull(d.RecordDeleted, 'N') = 'N'  
		 LEFT JOIN Services S ON S.ServiceId = d.ServiceId  
			 AND IsNull(S.RecordDeleted, 'N') = 'N'  
			 AND S.STATUS IN (  
			  70  
			 ,71  
			 ,72  
			 ,73  
			 )  
		LEFT JOIN Clients b ON a.ClientId = b.ClientId
			AND IsNull(b.RecordDeleted, 'N') <> 'Y'
		WHERE a.ToStaffId = @StaffId
			AND a.unread = 'Y'
			AND isNull(a.RecordDeleted, 'N') <> 'Y'
			AND a.DateReceived <= GETDATE()
		ORDER BY dateSort DESC

		--DJH Added top 1000 filter to prevent error on Dashboard widget        
		SELECT TOP 1000 FromName
			,Received
			,Subject
			,ISNULL(Client, '') AS Client
			,Message
			,MessageId
		    ,ISNULL(AlertType,'') As AlertType --Isnull Condition Added by Prem
		    ,ServiceId  
		    ,DocumentId  
		    ,ClientId 
		    ,ClientOrderId
		FROM @AlertMessages
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCWebGetAlertMessagesList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                   
				16
				,-- Severity.                                                                
				1 -- State.                                                             
				);

		RETURN (1)
	END CATCH

	RETURN (0)
END

GO


