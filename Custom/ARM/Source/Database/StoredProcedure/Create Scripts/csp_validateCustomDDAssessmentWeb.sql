/****** Object:  StoredProcedure [dbo].[csp_validateCustomDDAssessmentWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDDAssessmentWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDDAssessmentWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDDAssessmentWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomDDAssessmentWeb]      
    
@DocumentVersionId Int      
as      
/******************************************************************************                                      
**  File: csp_validateCustomDDAssessmentWeb                                  
**  Name: csp_validateCustomDDAssessmentWeb              
**  Desc: For Validation  on Custom DD assessment document(For Prototype purpose, Need modification)              
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

Return

/*
      
Begin                                                    
          
 Begin try       
--*TABLE CREATE*--               
CREATE TABLE [#CustomDDAssessment] (      
DocumentVersionId int null,      
CommunicationStyle int null,      
SupportNature int null,      
SupportStatus int null,      
LevelVision int null,      
LevelHearing int null,      
LevelOther int null,      
LevelBehavior int null,      
AssistanceMobility char(1) null,      
AssistanceMedication char(1) null,      
AssistancePersonal char(1) null,      
AssistanceHousehold char(1) null,      
AssistanceCommunity char(1) null      
)      
      
--*INSERT LIST*--        
INSERT INTO [#CustomDDAssessment](      
DocumentVersionId,      
CommunicationStyle,      
SupportNature,      
SupportStatus,      
LevelVision,      
LevelHearing,      
LevelOther,      
LevelBehavior,      
AssistanceMobility,      
AssistanceMedication,      
AssistancePersonal,      
AssistanceHousehold,      
AssistanceCommunity      
)      
--*Select LIST*--          
select       
a.DocumentVersionId,      
a.CommunicationStyle,      
a.SupportNature,      
a.SupportStatus,      
a.LevelVision,      
a.LevelHearing,      
a.LevelOther,      
a.LevelBehavior,      
a.AssistanceMobility,      
a.AssistanceMedication,      
a.AssistancePersonal,      
a.AssistanceHousehold,      
a.AssistanceCommunity      
from CustomDDAssessment a       
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
      
      
Select ''CustomDDAssessment'', ''CommunicationStyle'', ''Predominant Communication Style must be specified''   
  
FROM #CustomDDAssessment WHERE isnull(CommunicationStyle,'''')=''''    
Union      
Select ''CustomDDAssessment'', ''SupportNature'', ''Family and/or friends must be specified''      
FROM #CustomDDAssessment WHERE isnull(SupportNature,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''SupportStatus'', ''Status of existing support system must be specified''      
FROM #CustomDDAssessment WHERE isnull(SupportStatus,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''LevelVision'', ''Level of vision assistance must be selected.''      
FROM #CustomDDAssessment WHERE isnull(LevelVision,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''LevelHearing'', ''Level of hearing assistance must be selected.''      
FROM #CustomDDAssessment WHERE isnull(LevelHearing,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''LevelOther'', ''Level of other physical/medical characteristics assistance must be selected.''      
FROM #CustomDDAssessment WHERE isnull(LevelOther,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''LevelBehavior'', ''Level of assistance for accomodating challenging behaviors must be selected.''      
FROM #CustomDDAssessment WHERE isnull(LevelBehavior,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''AssistanceMobility'', ''Mobility assistance needed must be indicated''      
FROM #CustomDDAssessment WHERE isnull(AssistanceMobility,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''AssistanceMedication'', ''Medication administration assistance needed must be indicated''      
FROM #CustomDDAssessment WHERE isnull(AssistanceMedication,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''AssistancePersonal'', ''Personal assistance needed must be indicated''      
FROM #CustomDDAssessment WHERE isnull(AssistancePersonal,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''AssistanceHousehold'', ''Household assistance needed must be indicated''      
FROM #CustomDDAssessment WHERE isnull(AssistanceHousehold,'''')=''''    
  
Union      
Select ''CustomDDAssessment'', ''AssistanceCommunity'', ''Community assistance needed must be indicated''      
FROM #CustomDDAssessment WHERE isnull(AssistanceCommunity,'''')=''''    
    
end try                                                    
                                                                                    
BEGIN CATCH        
      
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomDDAssessmentWeb'')                                                                                   
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
      
*/
' 
END
GO
