IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_GetChangeOrderMedicationList ]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_GetChangeOrderMedicationList;
GO



SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
Create PROC ssp_GetChangeOrderMedicationList ( @SureScriptChangeRequestId INT )  


/*********************************************************************/        
---Copyright: 2011 Streamline Healthcare Solutions, LLC

---Creation Date: 09/22/2017

--Author : Pranay

---Purpose:To get the change request

---Input Parameters: @SureScriptChangeRequestId

---Return:Change List Medication List

---Called by:Application
---Log:
--	Date                     Author                             Purpose
--10/23/2017              PranayB                         Added Potenct w.r.t MU Changes
/*********************************************************************/   

AS

BEGIN 
 select                     '<ChangeOrderResponse>
   <PrescribedDrugInformation>
    <DrugName>'+ISNULL(scr.DrugDescription,'')+'</DrugName>
	<Quantity>'+ISNULL(CONVERT(VARCHAR(30),scr.QuantityValue),'')+'</Quantity>
	<Refills>'+ISNULL(CONVERT(VARCHAR(30),scr.NumberOfRefills),'')+'</Refills>
	<DaysSupply>'+ISNULL(CONVERT(VARCHAR(30),scr.NumberOfDaysSupply),'')+ '</DaysSupply>
	<Potency>'+ISNULL(map2.SmartCareRxCode,'Unspecified')+ '</Potency>
	<DAW>'+(CASE WHEN scr.Substitutions='1' THEN 'Yes' ELSE 'No' END) +'</DAW>	
	<Directions>'+ISNULL(scr.Directions,'')+'</Directions>
	<Note>'+ISNULL(scr.Note,'')+'</Note>
    </PrescribedDrugInformation>
   <ChangeDrugInformation>
    <DrugName>'+ISNULL(scmr.RequestedDrugDescription,'')+'</DrugName>
	<Quantity>'+ISNULL(CONVERT(VARCHAR(30),scmr.RequestedQuantityValue),'')+'</Quantity>
	<Refills>'+ISNULL(CONVERT(VARCHAR(30),scmr.RequestedNumberOfRefills),'')+'</Refills>
	<DaysSupply>'+ISNULL(CONVERT(VARCHAR(30),scmr.RequestedNumberOfDaysSupply),'')+'</DaysSupply>
	<Potency>'+ISNULL(map3.SmartCareRxCode,'Unspecified')+ '</Potency>
	<DAW>'+(CASE WHEN scmr.RequestedSubstitutions='1' THEN 'Yes' ELSE 'No' End)+'</DAW>
	<Directions>'+ISNULL(scmr.RequestedDirections,'')+'</Directions>
	<Note>'+ISNULL(scmr.RequestedNote,'')+'</Note>
  </ChangeDrugInformation>
</ChangeOrderResponse>' as ChangeOrderMedicationListXML FROM dbo.SureScriptsChangeRequests scr
JOIN dbo.SureScriptsChangeMedicationRequests scmr ON scmr.SureScriptChangeRequestedId=scr.SureScriptsChangeRequestId
LEFT JOIN SureScriptsCodes AS map2 ON(map2.Category = 'QuantityUnitOfMeasure' AND map2.SureScriptsCode=scr.PotencyUnitCode)
LEFT JOIN SureScriptsCodes AS map3 ON(map3.Category = 'QuantityUnitOfMeasure' AND map3.SureScriptsCode=scmr.RequestedPotencyUnitCode)
 WHERE SureScriptsChangeRequestId=@SureScriptChangeRequestId
END 




GO

