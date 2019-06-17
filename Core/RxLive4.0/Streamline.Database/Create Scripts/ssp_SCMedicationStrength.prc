/****** Object:  StoredProcedure [dbo].[ssp_SCMedicationStrength]    Script Date: 11/26/2008 11:26:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_SCMedicationStrength]     
  @MedicationNameId int =0             
AS                    
/*********************************************************************/                      
/* Stored Procedure: dbo.[ssp_SCMedicationStrength]                */                      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                      
/* Creation Date:    21/Aug/07                                         */                     
/*                                                                   */                      
/* Purpose:  Populate Strength combobox   */                      
/*                                                                   */                    
/* Input Parameters: none       */                    
/*                                                                   */                      
/* Output Parameters:   None                           */                      
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
/*   Date     Author       Purpose                                    */                      
/* 21/Aug/07   Rishu    Created										*/
/* 15th Nov 2008   Chandan Fill Dropdown - Oral show first and then rest */  
/*Task #96 MM -1.6.5 - Strength Drop-Down: Sort Logically            */         
/* 26-Nov-08	TER		where clause should use MDExternalRouteId		*/
/* 26-Nov-08	TER		Added Sorting by numeric value of Strength dosage */
/*********************************************************************/                         
BEGIN          

create table #temp 
( MedicationId int,
Strength varchar(200),
	RouteId int,
RouteAbbreviation varchar(20),
SortOrder1 int default 0,
SortOrder2 decimal(18,6))
--For Inserting Oral RouteAbbreviation First 
Insert into #temp 
(MedicationId, Strength, RouteId, RouteAbbreviation, SortOrder1)
select MD.MedicationId ,StrengthDescription as Strength , MDR.RouteId,RouteAbbreviation, 1
from MDMedications MD
JOIN MDRoutes MDR ON (MD.RouteId = MDR.RouteId AND IsNull(MD.RecordDeleted,'N')<>'Y' and MDR.MDExternalRouteId=24)
JOIN MDRoutedDosageFormMedications MDRD ON (MD.RoutedDosageFormMedicationId=MDRD.RoutedDosageFormMedicationId AND IsNull(MDRD.RecordDeleted,'N')<>'Y')           
JOIN MDDosageForms MDF ON (MDF.DosageFormId=MDRD.DosageFormId AND IsNull(MDF.RecordDeleted,'N')<>'Y')  where MD.MedicationNameId=@MedicationNameId  order by  RouteAbbreviation asc,MD.Strength asc            
         
--For Inserting other than Oral RouteAbbreviation  
Insert into #temp 
(MedicationId, Strength, RouteId, RouteAbbreviation, SortOrder1)
select MD.MedicationId ,StrengthDescription as Strength , MDR.RouteId,RouteAbbreviation, 2
from MDMedications MD          
JOIN MDRoutes MDR ON (MD.RouteId = MDR.RouteId AND IsNull(MD.RecordDeleted,'N')<>'Y' and MDR.MDExternalRouteId<>24)
JOIN MDRoutedDosageFormMedications MDRD ON (MD.RoutedDosageFormMedicationId=MDRD.RoutedDosageFormMedicationId AND IsNull(MDRD.RecordDeleted,'N')<>'Y')           
JOIN MDDosageForms MDF ON (MDF.DosageFormId=MDRD.DosageFormId AND IsNull(MDF.RecordDeleted,'N')<>'Y')  where MD.MedicationNameId=@MedicationNameId  order by  RouteAbbreviation asc,MD.Strength asc          

update #temp set 
	SortOrder2 = case 
		when patindex('%[^0-9.]%',Strength) > 1 then
			case when isnumeric(substring(Strength, 1, patindex('%[^0-9.]%',Strength) - 1)) = 1 
				then cast(substring(Strength, 1, patindex('%[^0-9.]%',Strength) - 1) as decimal(18,6)) else 99 end
		else 99 
	end

select MedicationId, Strength, RouteId, RouteAbbreviation
from #temp
order by SortOrder1, SortOrder2

                  
IF (@@error!=0)                      
BEGIN                      
    RAISERROR  20002 'ssp_SCMedicationStrength : An error  occured'                      
                     
    RETURN(1)               
                       
END                           
                    
END


