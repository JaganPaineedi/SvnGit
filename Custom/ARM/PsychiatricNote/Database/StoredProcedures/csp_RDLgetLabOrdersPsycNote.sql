/****** Object:  StoredProcedure [dbo].[csp_RDLgetLabOrdersPsycNote]   Script Date: 12/19/2016 15:15:31.027 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLgetLabOrdersPsycNote]') AND type IN (N'P',N'PC'))
	DROP PROCEDURE [dbo].[csp_RDLgetLabOrdersPsycNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLgetLabOrdersPsycNote]    Script Date: 12/19/2016 15:15:31.027******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLgetLabOrdersPsycNote] (
	 @DocumentVersionId INT
	)
AS
BEGIN
	/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "psyc Note" csp_RDLgetLabOrdersPsycNote 4
-- Purpose: Script for Task #701.41 - MHP - Customizations
--  
-- Author: Pabitra
-- Date:   06- Mar -2017
-- *****History****  

SELECT * FROM clientorders

--SELECT * FROM GlobalCodes  where GlobalCodeId=6481
*********************************************************************************/
		DECLARE @ClientId INT

SET @ClientId = (
		SELECT DISTINCT C.ClientId
		FROM Clients C
		INNER JOIN Documents D ON D.ClientId = C.ClientId
		INNER JOIN DocumentVersions DV ON DV.DocumentId = D.DocumentId
		WHERE D.CurrentDocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
		)
	 select 
		CO.ClientOrderId,
		(CONVERT(varchar(20),  CO.OrderStartDateTime,101))as EffectiveDate,
		O.OrderName,
		CO.OrderDescription
	   
from clientorders CO    
         join Orders O on CO.orderid = O.orderid     
         join documentversions ds  on ds.DocumentVersionId = CO.DocumentVersionId 
         join documents d on ds.DocumentVersionId  = d.CurrentDocumentVersionId                                                
   where CO.ClientId = @ClientId
   and O.OrderType = 6481  
   and d.status = 22
   and isnull(O.RecordDeleted,'N') <> 'Y'   
   and isnull(CO.RecordDeleted,'N') <> 'Y'   
    
END

--Checking For Errors             
IF (@@error != 0)
BEGIN
	RAISERROR ('[csp_RDLgetLabOrdersPsycNote] : An Error Occured',16,1)

	RETURN
END
GO


