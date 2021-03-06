IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderMedications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClientOrderMedications]
GO
/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderMedications]    Script Date: 03/18/2014 12:36:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create procedure [dbo].[ssp_RDLClientOrderMedications]
(@DocumentVersionId int =0,
@OrderType varchar(50) )
as
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 18-mar-2014    Revathi      What:Get Medications ClientOrders 
                             Why:Philhaven Development #26 Inpatient Order Management
 26-Sep-2014	Revathi		 What:Get MayUseOwnSupply and IsStockMedication added 
                             Why:task#206 Philhaven Development    
 19-Feb-2015    Gautam       What:The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
						     and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development  
 26-May-2015	Chethan N	 What:Get 'RationaleOtherText' when Other is selected in Rationale drop down 
                             Why:Philhaven Development Task#252      
 03-Jan-2017	Chethan N	 What: Retrieving Discontinued Reason and Potency Units.
							 Why:  Renaissance - Dev Items task #5                                                   
************************************************/
BEGIN				
	Begin Try 	
	
		CREATE TABLE #DiscontineDocumentVersionId (
	 DocumentVersionId int
	)

	INSERT INTO #DiscontineDocumentVersionId
	 SELECT Co1.DocumentVersionId
	 FROM ClientOrders Co1 JOIN ClientOrders Co2 ON Co1.ClientOrderId = Co2.PreviousClientOrderId
	 WHERE Co2.DocumentVersionId = @DocumentVersionId

	CREATE TABLE #DiscontineOrderCount (
	 OrderType varchar(50),
	 Counts int,
	 OrderDiscontinued char(1),
	 DiscontinuedDateTime datetime
	)
	INSERT INTO #DiscontineOrderCount (OrderType, Counts, OrderDiscontinued, DiscontinuedDateTime)
	 SELECT
	  --Co.OrderType,
	   GC.CodeName as OrderType,
	  ISNULL(COUNT(Co.ClientOrderId), 0),
	  OrderDiscontinued,
	  DiscontinuedDateTime
	 FROM ClientOrders Co
	 INNER JOIN Documents D  ON D.CurrentDocumentVersionId = Co.DocumentVersionId
	 INNER JOIN DocumentVersions Dv ON Dv.DocumentVersionId = Co.DocumentVersionId
	 INNER JOIN Orders O ON O.OrderId=Co.OrderId
	 LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=O.OrderType
	 WHERE ISNULL(Co.RecordDeleted, 'N') <> 'Y'
	 AND Dv.DocumentVersionId IN (SELECT DocumentVersionId FROM #DiscontineDocumentVersionId)
	 AND D.Status = 22
	 AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
	 AND ISNULL(Dv.RecordDeleted, 'N') <> 'Y'
	 GROUP BY --Co.OrderType,
	  GC.CodeName,
	  Co.DiscontinuedDateTime, Co.OrderDiscontinued


	CREATE TABLE #OrderTypeCount (
	 OrderType varchar(50),
	 Counts int,
	 OrderDiscontinued char(1),
	 DiscontinuedDateTime datetime
	)
	INSERT INTO #OrderTypeCount (OrderType, Counts, OrderDiscontinued, DiscontinuedDateTime)
	 (SELECT
	  --Co.OrderType,
	  GC.CodeName as OrderType,
	  ISNULL(COUNT(Co.ClientOrderId), 0),
	  OrderDiscontinued,
	  DiscontinuedDateTime
	 FROM ClientOrders Co
	 INNER JOIN Documents D ON D.CurrentDocumentVersionId = Co.DocumentVersionId
	 INNER JOIN DocumentVersions Dv ON Dv.DocumentVersionId = Co.DocumentVersionId
	 INNER JOIN Orders O ON O.OrderId=Co.OrderId
	 LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=O.OrderType
	 WHERE ISNULL(Co.RecordDeleted, 'N') <> 'Y'
	 AND Dv.DocumentVersionId = @DocumentVersionId
	 AND D.Status = 22
	 AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
	 AND ISNULL(Dv.RecordDeleted, 'N') <> 'Y'
	 GROUP BY --Co.OrderType,
	 GC.CodeName ,Co.DiscontinuedDateTime,Co.OrderDiscontinued)



	SELECT Co.ClientOrderId	
	,ISNULL(MDN.MedicationName+' ','' )+'('+O.OrderName+')' as MedOrderName	
	,UPPER(ISNULL(MDN.MedicationName+' ','' )+ '('+O.OrderName+')' + ' ' +	
	case when ISNULL(convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100),'')='' then 
	'' else ('('+convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100)+')') END
	  +' ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' 
	  +COALESCE(Md.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '')
	  + ISNULL(Md.StrengthUnitOfMeasure, '') + ' ' +  ISNULL(Mr.RouteAbbreviation, '') + ' ' +  ISNULL([dbo].[GetGlobalCodeName](Otf.FrequencyId),'')
	 ) as Ordername	
	,ISNULL(convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100),'')AS Dose
	, Otf.DisplayName AS Frequency
	, ISNULL(Co.MedicationDaySupply, 0) AS Daysupply
	, CONVERT(varchar, Co.OrderStartDateTime, 101) +' '+ RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,Co.OrderStartDateTime,0),7)),7) AS Startdate
	, CASE WHEN RIGHT(CONVERT(varchar, Co.OrderEndDateTime, 100), 8) = ' 12:00AM' THEN CONVERT(varchar, Co.OrderEndDateTime, 101) ELSE CONVERT(varchar, Co.OrderEndDateTime, 101) +' '+ RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,Co.OrderEndDateTime,0),7)),7) END AS Enddate
	, ISNULL(Co.MedicationRefill, 0) AS Medicationrefill
	, Gc1.CodeName AS Priority
	, case when ISNULL(Co.RationaleOtherText,'')='' then Co.RationaleText else Co.RationaleOtherText end as RationaleText
	, Co.CommentsText AS Comments
	, D.Status
	, S.LastName + ', ' + S.FirstName AS Orderedby
	, S1.LastName + ', ' + S1.FirstName AS Assignedto
	, S2.LastName + ', ' + S2.FirstName AS Physician
	, G.CodeName AS Orderstatus
	, G1.CodeName AS Ordermode
	, CASE WHEN ISNULL(CO.MaySelfAdminister, 'N') = 'Y' THEN 'Yes' ELSE 'No' END AS Selfadmin
	, ISNULL((SELECT SUM(ISNULL(Ot.Counts, 0))FROM #OrderTypeCount Ot WHERE Ot.OrderType = 'Medication'	AND Ot.OrderDiscontinued = 'N'	AND ISNULL(Ot.DiscontinuedDateTime, '') = ''), 0) AS Medicationcount
	, ISNULL((SELECT SUM(ISNULL(Ot.Counts, 0))FROM #DiscontineOrderCount Ot	WHERE Ot.OrderType = 'Medication'	AND Ot.OrderDiscontinued = 'Y'	AND ISNULL(Ot.DiscontinuedDateTime, '') <> ''), 0) AS Dicontinuecount
	, ISNULL((SELECT SUM(ISNULL(Ot.Counts, 0))FROM #OrderTypeCount Ot WHERE Ot.OrderType = 'Labs'), 0) AS Labcount
	, ISNULL((SELECT SUM(ISNULL(Ot.Counts, 0))FROM #OrderTypeCount Ot WHERE Ot.OrderType = 'Radiology'), 0) AS Radiologycount
	, ISNULL((SELECT SUM(ISNULL(Ot.Counts, 0))FROM #OrderTypeCount Ot WHERE Ot.OrderType = 'Additional'), 0) AS Additionalcount
	, ISNULL((SELECT SUM(ISNULL(Ot.Counts, 0))FROM #OrderTypeCount Ot WHERE Ot.OrderType = 'Consults'), 0) AS Consultscount
	, ISNULL((SELECT SUM(ISNULL(Ot.Counts, 0))FROM #OrderTypeCount Ot WHERE Ot.OrderType = 'Nursing'), 0) AS Nursingcount
	, CASE WHEN ISNULL(CO.MayUseOwnSupply, 'N') = 'Y' THEN 'Yes' ELSE 'No' END AS MayUseOwnSupply
	, CASE WHEN ISNULL(O.IsStockMedication, 'N') = 'Y' THEN 'Yes' ELSE 'No' END AS IsStockMedication
	, CASE WHEN ISNULL(CO.ConsentIsRequired, 'N') = 'Y' THEN 'Yes' ELSE 'No' END AS ConsentIsRequired
	, CASE WHEN ISNULL(CO.DispenseBrand, 'N') = 'Y' THEN 'Yes' ELSE 'No' END AS DispenseBrand
	,CO.MaxDispense AS MaxDispense
	,G2.CodeName AS DiscontinuedReason
	,SSC.SmartCareRxCode AS PotencyUnit
	FROM ClientOrders Co JOIN orders AS O ON O.OrderId = Co.OrderId	AND (ISNULL(O.RecordDeleted, 'N') = 'N') 
	INNER JOIN Documents D ON D.CurrentDocumentVersionId = Co.DocumentVersionId	AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
	INNER JOIN DocumentVersions Dv ON Dv.DocumentVersionId = Co.DocumentVersionId	AND ISNULL(Dv.RecordDeleted, 'N') <> 'Y' 
	LEFT JOIN OrderRoutes Ors ON Ors.OrderRouteId = Co.MedicationOrderRouteId	AND ISNULL(Ors.RecordDeleted, 'N') <> 'Y'
    LEFT JOIN MDRoutes Mr ON Mr.RouteId = Ors.RouteId AND ISNULL(Mr.RecordDeleted, 'N') <> 'Y'
    LEFT JOIN OrderStrengths Os ON Os.OrderStrengthId = Co.MedicationOrderStrengthId AND ISNULL(Os.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN MDMedications Md ON Md.MedicationId = ISNULL(Os.MedicationId, 0)AND ISNULL(Md.RecordDeleted, 'N') = 'N'
	LEFT JOIN MDMedicationNames MDN ON  MDN.MedicationNameId =Md.MedicationNameId AND ISNULL(MDN.RecordDeleted,'N')='N'
	--LEFT JOIN OrderFrequencies Ofr ON Ofr.OrderFrequencyId = Co.OrderFrequencyId AND ISNULL(Ofr.RecordDeleted, 'N') <> 'Y' 
	LEFT JOIN OrderTemplateFrequencies Otf ON Otf.OrderTemplateFrequencyId = Co.OrderTemplateFrequencyId	AND ISNULL(Otf.RecordDeleted, 'N') <> 'Y'	
	LEFT JOIN MDRoutedDosageFormMedications MDR ON MDR.RoutedDosageFormMedicationId=MD.RoutedDosageFormMedicationId AND ISNULL(MDR.RecordDeleted, 'N') <> 'Y' 
	LEFT JOIN MDDosageForms MDF ON MDF.DosageFormId=MDR.DosageFormId AND ISNULL(MDF.RecordDeleted, 'N') <> 'Y' 
	LEFT JOIN GlobalCodes Gc1 ON Gc1.GlobalCodeId = Co.OrderPriorityId	AND ISNULL(Gc1.RecordDeleted, 'N') <> 'Y' 
	INNER JOIN globalcodes AS G ON G.GlobalCodeId = Co.OrderStatus	AND (ISNULL(G.RecordDeleted, 'N') = 'N') 
	LEFT JOIN globalcodes AS G1 ON G1.GlobalCodeId = Co.OrderMode	AND (ISNULL(G1.RecordDeleted, 'N') = 'N')	
	LEFT JOIN GlobalCodes AS G2 ON G2.GlobalCodeId = Co.DiscontinuedReason	AND (ISNULL(G2.RecordDeleted, 'N') = 'N')
	LEFT JOIN SureScriptsCodes SSC ON SSC.SureScriptsCode = CO.PotencyUnit AND SSC.Category = 'QuantityUnitOfMeasure' AND (ISNULL(SSC.RecordDeleted, 'N') = 'N')
	INNER JOIN staff S ON S.StaffId = Co.OrderedBy	AND S.Active = 'Y'	AND (ISNULL(S.RecordDeleted, 'N') = 'N') 
	LEFT JOIN staff S1 ON S1.StaffId = Co.AssignedTo
	AND S1.Active = 'Y'	AND (ISNULL(S1.RecordDeleted, 'N') = 'N') 
	LEFT JOIN staff S2 ON S2.StaffId = Co.OrderingPhysician
	AND S2.Active = 'Y'	AND (ISNULL(S2.RecordDeleted, 'N') = 'N')WHERE ISNULL(O.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(Co.RecordDeleted, 'N') <> 'Y'
	AND ((@OrderType = 'Medication'	AND
	 --Co.OrderType = 'Medication'
	 O.OrderType=8501
	 	AND ISNULL(Co.OrderDiscontinued, 'N') = 'N'	AND ISNULL(Co.DiscontinuedDateTime, '') = '' AND Dv.DocumentVersionId = @DocumentVersionId)
	OR (@OrderType = 'Discontinued'	AND 
	--Co.OrderType = 'Medication'
	O.OrderType=8501
		AND Co.OrderDiscontinued = 'Y'	AND ISNULL(Co.DiscontinuedDateTime, '') <> '')	AND Dv.DocumentVersionId IN (SELECT	 DocumentVersionId	FROM #DiscontineDocumentVersionId)	)
	AND D.Status = 22
	
End Try

	BEGIN CATCH          
	DECLARE @Error varchar(8000)                                                 
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLClientOrderMedications')                                                                               
	+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
	+ '*****' + Convert(varchar,ERROR_STATE())                                           
	RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
END CATCH          
END			
		