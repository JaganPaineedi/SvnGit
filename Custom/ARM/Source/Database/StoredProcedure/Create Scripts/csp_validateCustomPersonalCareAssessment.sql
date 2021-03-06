/****** Object:  StoredProcedure [dbo].[csp_validateCustomPersonalCareAssessment]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPersonalCareAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomPersonalCareAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPersonalCareAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomPersonalCareAssessment]             
@DocumentVersionId Int       
as             
            
/******************************************************************************                                    
**  File: csp_validateCustomPersonalCareAssessment                                
**  Name: csp_validateCustomPersonalCareAssessment            
**  Desc: For Validation  on Custom Personal Care Assessment      
**  Return values: Resultset having validation messages                                    
**  Called by:                                     
**  Parameters:                
**  Auth:  Devinder Pal Singh                   
**  Date:  Aug 24 2009                                
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:       Author:       Description:                                    
**  17/09/2009   Ankesh Bharti  Modify according to Data Model 3.0      
**  --------    --------        ----------------------------------------------------                                    
*******************************************************************************/                                  


Return



/*

  
DECLARE @DocumentCodeId INT
SET @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)
          
--*TABLE CREATE*--             
CREATE TABLE #CustomPersonalCareAssessment (              
DocumentVersionId Int,            
DateOfNotice datetime null,
PersonalCareHouseKeeping char(3) null,
PersonalCareEatingOrFeeding char(3) null,
PersonalCareToileting char(3) null,
PersonalCareBathing char(3) null,
PersonalCareDressing char(3) null,
PersonalCareGrooming char(3) null,
PersonalCareTransferring char(3) null,
PersonalCareAmbulation char(3) null,
PersonalCareMedication char(3) null,
AveragePersonalCareHoursPerDay int null,
PersonalCarePerDiemRate money null,
CLSMealPreperation  char(3) null,
CLSLaundry char(3) null,
CLSHouseholdMaintenance char(3) null,
CLSDailyLiving char(3) null,
CLSShopping char(3) null,
CLSMoneyManagement char(3) null,
CLSSocializing char(3) null,
CLSTransportation char(3) null,
CLSLeisureChoice char(3) null,
CLSMedicalAppointments char(3) null,
CLSMonitoringAndProtection char(3) null,
CLSMonitoringSelfAdministration char(3) null,
AverageCLSHoursPerDay datetime null,
CLSPerDiemRate money null             
)               
--*INSERT LIST*--             
INSERT INTO #CustomPersonalCareAssessment (              
DocumentVersionId,               
DateOfNotice,
PersonalCareHouseKeeping,
PersonalCareEatingOrFeeding,
PersonalCareToileting,
PersonalCareBathing,
PersonalCareDressing,
PersonalCareGrooming,
PersonalCareTransferring,
PersonalCareAmbulation,
PersonalCareMedication,
AveragePersonalCareHoursPerDay,
PersonalCarePerDiemRate,
CLSMealPreperation,
CLSLaundry,
CLSHouseholdMaintenance,
CLSDailyLiving,
CLSShopping,
CLSMoneyManagement,
CLSSocializing,
CLSTransportation,
CLSLeisureChoice,
CLSMedicalAppointments,
CLSMonitoringAndProtection,
CLSMonitoringSelfAdministration,
AverageCLSHoursPerDay,
CLSPerDiemRate             
)               
--*Select LIST*--             
Select DocumentVersionId,               
DateOfNotice,
PersonalCareHouseKeeping,
PersonalCareEatingOrFeeding,
PersonalCareToileting,
PersonalCareBathing,
PersonalCareDressing,
PersonalCareGrooming,
PersonalCareTransferring,
PersonalCareAmbulation,
PersonalCareMedication,
AveragePersonalCareHoursPerDay,
PersonalCarePerDiemRate,
CLSMealPreperation,
CLSLaundry,
CLSHouseholdMaintenance,
CLSDailyLiving,
CLSShopping,
CLSMoneyManagement,
CLSSocializing,
CLSTransportation,
CLSLeisureChoice,
CLSMedicalAppointments,
CLSMonitoringAndProtection,
CLSMonitoringSelfAdministration,
AverageCLSHoursPerDay,
CLSPerDiemRate                
FROM CustomPersonalCareAssessment WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''              
             
   

--
-- DECLARE VARIABLES
--
declare @Variables varchar(max)
declare @DocumentType varchar(20)

--
-- DECLARE TABLE SELECT VARIABLES
--
set @Variables = ''Declare @DocumentVersionId int
					Set @DocumentVersionId = '' + convert(varchar(20), @DocumentVersionId)

set @DocumentType = NULL

--
-- Exec csp_validateDocumentsTableSelect to determine validation list
--
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables


/*          
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )              
SELECT ''CustomPersonalCareAssessment'', ''DateOfNotice'', ''Note - Date Of Notice must be specified'' FROM #CustomPersonalCareAssessment WHERE isnull(DateOfNotice,'''')=''''              
UNION            
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareEatingOrFeeding'', ''Note - Personal Care Eating Or Feeding must be specified'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareEatingOrFeeding,'''')=''''            
UNION              
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareHouseKeeping'', ''Note - Personal Care House Keeping must be specified'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareHouseKeeping,'''')=''''            
UNION
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareToileting'', ''Personal Care - Toileting must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareToileting,'''')=''''            
UNION
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareBathing'', ''Personal Care - Bathing must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareBathing,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareDressing'', ''Personal Care - Dressing must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareDressing,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareGrooming'', ''Personal Care - Grooming must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareGrooming,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareTransferring'', ''Personal Care - Transferring must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareTransferring,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareAmbulation'', ''Personal Care - Ambulation must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareAmbulation,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''PersonalCareMedication'', ''Personal Care - Medication must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(PersonalCareMedication,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''AveragePersonalCareHoursPerDay'', ''Personal Care - Average Personal Care Hours Per Day must be selected'' FROM #CustomPersonalCareAssessment WHERE AveragePersonalCareHoursPerDay IS NULL
UNION
SELECT ''CustomPersonalCareAssessment'', ''PersonalCarePerDiemRate'', ''Personal Care - Per Diem Rate must be selected'' FROM #CustomPersonalCareAssessment WHERE PersonalCarePerDiemRate IS NULL
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSMealPreperation'', ''CLS - Meal Preperation must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSMealPreperation,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSLaundry'', ''CLS - Laundry must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSLaundry,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSHouseholdMaintenance'', ''CLS - Household Maintenance must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSHouseholdMaintenance,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSDailyLiving'', ''CLS - Daily Living must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSDailyLiving,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSShopping'', ''CLS - Shopping must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSShopping,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSMoneyManagement'', ''CLS - Money Management must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSMoneyManagement,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSSocializing'', ''CLS - Socializing must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSSocializing,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSTransportation'', ''CLS - Transportation must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSTransportation,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSLeisureChoice'', ''CLS - Leisure Choice must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSLeisureChoice,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSMedicalAppointments'', ''CLS - Medical Appointments must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSMedicalAppointments,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSMonitoringAndProtection'', ''CLS - Monitoring And Protection must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSMonitoringAndProtection,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSMonitoringSelfAdministration'', ''CLS - Monitoring Self Administration must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(CLSMonitoringSelfAdministration,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''AverageCLSHoursPerDay'', ''CLS - Average CLS Hours Per Day must be selected'' FROM #CustomPersonalCareAssessment WHERE isnull(AverageCLSHoursPerDay,'''')=''''
UNION
SELECT ''CustomPersonalCareAssessment'', ''CLSPerDiemRate'', ''CLS - Per Diem Rate must be selected'' FROM #CustomPersonalCareAssessment WHERE CLSPerDiemRate IS NULL
 

*/


  if @@error <> 0 goto error  

	return  

error: raiserror 50000 ''csp_validateCustomMSTAssessments failed.  Please contact your system administrator. We apologize for the inconvenience.'' 

*/
' 
END
GO
