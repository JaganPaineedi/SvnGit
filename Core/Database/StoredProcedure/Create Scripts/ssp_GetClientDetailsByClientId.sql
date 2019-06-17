
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientDetailsByClientId]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClientDetailsByClientId]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetClientDetailsByClientId]       
	@ClientId int=0  
AS      
/**************************************************************/                                                                                              
/* Stored Procedure: [ssp_GetClientDetailsByClientId]	58363	*/                                                                                    
/* Creation Date:  09 Dec 2014								*/       
/* Creation By:    Avi Goyal                                */                        
/* Purpose: To Get client details							*/                                                                                             
/* Input Parameters:   @ClientId							*/                                                                                            
/* Data Modifications:										*/                                                                                              
/* Updates:													*/                                                                                              
/* Date			Author			Purpose						*/ 
---------------------------------------------------------------    
/* 09 Dec 2014	Avi Goyal		What :
								Why : Task 614 Walk-Ins-Customer Flow of Network 180 - Customizations  */  
/* Oct 16 2015			  Revathi	 	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
												 why:task #609, Network180 Customization */
/* April 19 2016		Varun - Additional columns - #33 N180 Support Go Live*/
/**************************************************************/
BEGIN
	BEGIN TRY
		SELECT TOP 1 
			RTRIM(C.FirstName) AS FirstName
			,RTRIM(C.LastName) AS LastName
			,ISNULL(CONVERT(VARCHAR,C.DOB,101),'') AS ClientDOB
			 --Added by Revathi  Oct 16 2015	
			,case when  ISNULL(C.ClientType,'I')='I' then RTRIM(ISNULL(C.LastName,'')) + ', ' + RTRIM(ISNULL(C.FirstName,'')) else RTRIM(ISNULL(C.OrganizationName,'')) end AS ClientName
			,C.Active
			,CA.Address
			,CA.City
			,CA.State
			,CA.Zip  
			,CP.PhoneNumber
		FROM Clients C
		LEFT JOIN ClientAddresses CA ON CA.ClientId= C.ClientId AND CA.AddressType=90 AND ISNULL(CA.RecordDeleted,'N')='N'
		LEFT JOIN ClientPhones CP ON CP.ClientId= C.ClientId AND CP.PhoneType=30 AND ISNULL(CP.RecordDeleted,'N')='N'
		WHERE C.ClientId=@ClientId AND ISNULL(C.RecordDeleted,'N')<>'Y' AND C.Active='Y'
	END TRY      
	BEGIN CATCH                                  
		DECLARE @Error VARCHAR(8000)                                                                            
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                         
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetClientDetailsByClientId')                                                                                                             
					+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                              
					+ '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                          
		RAISERROR                                                                                                             
		(                                                                               
			@Error, -- Message text.           
			16, -- Severity.           
			1 -- State.                                                
		);                                                                                                          
	END CATCH       
END    