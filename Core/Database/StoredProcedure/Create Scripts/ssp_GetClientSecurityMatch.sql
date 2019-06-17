IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientSecurityMatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientSecurityMatch]
GO
--EXEC ssp_GetClientSecurityMatch 'Sierra','Aalfs','02/26/1970'
/********************************************************************************                                                    
-- Stored Procedure: ssp_GetClientSecurityMatch 
-- Copyright: Streamline Healthcate Solutions
-- Purpose: Procedure to return data clients matching the given first name, last name & dob
-- Author:  Avi Goyal
-- Date:    29 Dec 2014  
-- *****History****  
-- Date				Author			Purpose
---------------------------------------------------------------------------------
-- 29 Dec 2014		Avi Goyal		What :Created 
									Why: Task 614 Walk-Ins-Customer Flow of Network 180 - Custmizations
-- 25 May 2016      Shruthi.S       Changed to narrow search as per request.Ref : #66 Network180-Customizations									
*********************************************************************************/  
CREATE PROCEDURE [dbo].[ssp_GetClientSecurityMatch]
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Dob DATETIME
AS 
BEGIN  
	BEGIN TRY 
		
		CREATE TABLE #tempSort
		(
			ClientId INT,
			FirstName VARCHAR(100),
			LastName VARCHAR(100),
			DOB DATETIME,
			SortOrder INT
		)		
		INSERT INTO #tempSort
		
		SELECT  
				C.ClientId,
				C.FirstName,
				C.LastName,
				C.DOB,
				1 AS SortOrder
			--INTO #tempSort1
		FROM Clients C
		WHERE ISNULL(C.RecordDeleted,'N')='N' AND C.Active='Y'
				AND C.FirstName = @FirstName
				AND C.LastName = @LastName
				AND CAST(C.DOB AS DATE) = CAST (@Dob AS DATE)
		
		
	
		
		SELECT  
			ClientId,
			FirstName,
			LastName,
			CONVERT(VARCHAR(10),DOB, 101) AS DOB  
		FROM #tempSort
		ORDER BY SortOrder ASC ,FirstName ASC,LastName ASC ,DOB ASC
		
		
		
		
		
	END TRY 
    BEGIN CATCH                                
		DECLARE @Error VARCHAR(8000)                                                                          
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                       
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetClientSecurityMatch')                                                                                                           
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