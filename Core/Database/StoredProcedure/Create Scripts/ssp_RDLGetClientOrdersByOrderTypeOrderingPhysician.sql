 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLGetClientOrdersByOrderTypeOrderingPhysician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLGetClientOrdersByOrderTypeOrderingPhysician]
GO
/****** Object:  StoredProcedure [dbo].[ssp_RDLGetClientOrdersByOrderTypeOrderingPhysician]    Script Date: 03/18/2014 12:20:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLGetClientOrdersByOrderTypeOrderingPhysician] (
	@DocumentVersionId INT = 0
	,@OrderType VARCHAR(50)
	)
/*****************************************************************************    
  Date:   Author:       Description:                                
      
  -------------------------------------------------------------------------                
 18-mar-2014    Revathi      What:Get ClientOrders by OrderType     
                             Why:Philhaven Development #26 Inpatient Order Management    
 19-Feb-2015    Gautam       What : The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table    
           and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development     
 18-Fab-2016 Ajay      What: Added CASE to return RationaleText if it is in Rationale other Text.    
           Why: RDL is showing blank if other text is entered.Barry - Support: #287     
 10 Feb 2017 Chethan N  What : Added new column 'ClinicalLocation' to ClientOrders table.    
        Why : Key Point - Support Go Live task #365  
 27 Nov 2018 Ravichandra  What : added REPLACE function t remove space in phone and fax numbers to display correct phone format .      
        Why : AHN-Build Cycle Tasks #6              
 14 Jan	2019:	Msood	What: Added the condition to display the Phone Number and Fax Number from Loctions table if it is formatted else format the Phone and Fax Number
					Why: CCC - Support Go Live Task #61		  			           				 
****************************************************************************/
AS
BEGIN
	BEGIN TRY
		SELECT S2.LastName + ', ' + S2.FirstName + ' ' + dbo.ssf_GetGlobalCodeNameById(S2.Degree) AS Physician
			,S2.StaffId
			,LC.LocationId
			,ISNULL(LC.AddressDisplay, '') + ' ' + CHAR(13) + CHAR(10) 
			  + CASE 
				WHEN ISNULL(LC.PhoneNumber, '') <> ''
					-- msood 10/29/2018
					AND SUBSTRING(LC.PhoneNumber, 1, 1) = '('
					THEN LC.PhoneNumber
				WHEN ISNULL(LC.PhoneNumber, '') <> ''
					AND SUBSTRING(LC.PhoneNumber, 1, 1) <> '('
					THEN 'Phone: (' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(LC.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' '
					 + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(LC.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) 
					 + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(LC.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
					  + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(LC.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 11, 75)
					  
				ELSE ''
				END + CASE 
				WHEN ISNULL(LC.FaxNumber, '') <> ''
					-- msood 10/29/2018
					AND SUBSTRING(LC.FaxNumber, 1, 1) = '('
					THEN LC.FaxNumber
				WHEN ISNULL(LC.FaxNumber, '') <> ''
					AND SUBSTRING(LC.FaxNumber, 1, 1) <> '('
					THEN '  Fax: (' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(LC.FaxNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(LC.FaxNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(LC.FaxNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4) + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(LC.FaxNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 11, 75)
				ELSE ''
				END AS AddressDisplay
		FROM ClientOrders Co
		JOIN orders AS O ON O.OrderId = Co.OrderId
			AND (ISNULL(O.RecordDeleted, 'N') = 'N')
		INNER JOIN Documents D ON D.CurrentDocumentVersionId = Co.DocumentVersionId
		INNER JOIN DocumentVersions Dv ON Dv.DocumentVersionId = Co.DocumentVersionId
		--LEFT JOIN OrderFrequencies Ofr ON Ofr.OrderFrequencyId = Co.OrderFrequencyId AND ISNULL(Ofr.RecordDeleted, 'N') <> 'Y'     
		LEFT JOIN staff S2 ON S2.StaffId = Co.OrderingPhysician
			AND S2.Active = 'Y'
			AND (ISNULL(S2.RecordDeleted, 'N') = 'N')
		LEFT JOIN GlobalCOdes OTC ON OTC.GlobalCOdeId = O.OrderType
		LEFT JOIN Laboratories L ON L.LaboratoryId = CO.LaboratoryId
			AND (ISNULL(L.RecordDeleted, 'N') = 'N')
		LEFT JOIN GlobalCodes GCCL ON GCCL.GlobalCodeId = CO.ClinicalLocation
			AND (ISNULL(GCCL.RecordDeleted, 'N') = 'N')
		LEFT JOIN Locations LC ON LC.LocationId = CO.LocationId
		WHERE ISNULL(O.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(Co.RecordDeleted, 'N') <> 'Y'
			AND Dv.DocumentVersionId = @DocumentVersionId
			AND OTC.CodeName = @OrderType
			--AND Co.OrderType = @OrderType    
			AND D.STATUS = 22
			AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(Dv.RecordDeleted, 'N') <> 'Y'
		GROUP BY StaffId
			,S2.LastName + ', ' + S2.FirstName
			,LC.LocationId
			,LC.AddressDisplay
			,LC.PhoneNumber
			,LC.FaxNumber
			,S2.Degree
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLGetClientOrdersByOrderTypeOrderingPhysician') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END
