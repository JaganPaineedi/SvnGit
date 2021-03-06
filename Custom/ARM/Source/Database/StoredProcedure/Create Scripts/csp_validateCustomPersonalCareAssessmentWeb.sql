/****** Object:  StoredProcedure [dbo].[csp_validateCustomPersonalCareAssessmentWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPersonalCareAssessmentWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomPersonalCareAssessmentWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPersonalCareAssessmentWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomPersonalCareAssessmentWeb]    
@DocumentVersionId Int    
  
as    
--This is a temporary  Procedure we will modify this as needed                  
/******************************************************************************                                          
**  File: csp_validateCustomPersonalCareAssessmentWeb                                      
**  Name: csp_validateCustomPersonalCareAssessmentWeb                  
**  Desc: For Validation  on Custom Personal Care Assessment            
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  Ankesh Bharti                        
**  Date:  Nov 23 2009                                      
*******************************************************************************                                          
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:                                          
*******************************************************************************/                                        
     
Begin                                                  
        
 Begin try                   
--*TABLE CREATE*--       
CREATE TABLE [#CustomPersonalCareAssessment] (    
DocumentVersionId int null,    
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
INSERT INTO [#CustomPersonalCareAssessment](    
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
select     
a.DocumentVersionId,    
a.DateOfNotice,    
a.PersonalCareHouseKeeping,    
a.PersonalCareEatingOrFeeding,    
a.PersonalCareToileting,    
a.PersonalCareBathing,    
a.PersonalCareDressing,    
a.PersonalCareGrooming,    
a.PersonalCareTransferring,    
a.PersonalCareAmbulation,    
a.PersonalCareMedication,    
a.AveragePersonalCareHoursPerDay,    
a.PersonalCarePerDiemRate,    
a.CLSMealPreperation,    
a.CLSLaundry,    
a.CLSHouseholdMaintenance,    
a.CLSDailyLiving,    
a.CLSShopping,    
a.CLSMoneyManagement,    
a.CLSSocializing,    
a.CLSTransportation,    
a.CLSLeisureChoice,    
a.CLSMedicalAppointments,    
a.CLSMonitoringAndProtection,    
a.CLSMonitoringSelfAdministration,    
a.AverageCLSHoursPerDay,    
a.CLSPerDiemRate    
from CustomPersonalCareAssessment a     
where a.DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''     
    
Insert into #validationReturnTable    
(TableName,    
ColumnName,    
ErrorMessage    
)    
--This validation returns three fields    
--Field1 = TableName    
--Field2 = ColumnName    
--Field3 = ErrorMessage    
    
    
Select ''CustomPersonalCareAssessment'', ''DateOfNotice'', ''Date of Notice must be entered.''    
 FROM #CustomPersonalCareAssessment WHERE isnull(DateOfNotice,'''')=''''   
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareHouseKeeping'', ''Personal Care - HouseKeeping must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareEatingOrFeeding'', ''Personal Care - Eating Or Feeding must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareToileting'', ''Personal Care - Toileting must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareBathing'', ''Personal Care - Bathing must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareDressing'', ''Personal Care - Dressing must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareGrooming'', ''Personal Care - Grooming must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareTransferring'', ''Personal Care - Transferring must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareAmbulation'', ''Personal Care - Ambulation must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCareMedication'', ''Personal Care - Medication must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''AveragePersonalCareHoursPerDay'', ''Personal Care - Average Personal Care Hours Per Day must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''PersonalCarePerDiemRate'', ''Personal Care - Per Diem Rate must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSMealPreperation'', ''CLS - Meal Preperation must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSLaundry'', ''CLS - Laundry must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSHouseholdMaintenance'', ''CLS - Household Maintenance must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSDailyLiving'', ''CLS - Daily Living must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSShopping'', ''CLS - Shopping must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSMoneyManagement'', ''CLS - Money Management must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSSocializing'', ''CLS - Socializing must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSTransportation'', ''CLS - Transportation must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSLeisureChoice'', ''CLS - Leisure Choice must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSMedicalAppointments'', ''CLS - Medical Appointments must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSMonitoringAndProtection'', ''CLS - Monitoring And Protection must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSMonitoringSelfAdministration'', ''CLS - Monitoring Self Administration must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''AverageCLSHoursPerDay'', ''CLS - Average CLS Hours Per Day must be selected''    
--Union    
--Select ''CustomPersonalCareAssessment'', ''CLSPerDiemRate'', ''CLS - Per Diem Rate must be selected''    
    
end try                                                                                    
BEGIN CATCH    
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomPersonalCareAssessmentWeb'')                                                                                 
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
    + ''*****'' + Convert(varchar,ERROR_STATE())                               
 RAISERROR                                                        
 (                                                   
  @Error, -- Message text.                                                                                
  16, -- Severity.                                                                                
  1 -- State.                                                                                
 );                                                                              
END CATCH                            
END
' 
END
GO
