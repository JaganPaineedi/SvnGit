/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomAIMS]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomAIMS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomAIMS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomAIMS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_ValidateCustomAIMS]         
@DocumentVersionId Int, @DocumentCodeId Int         
as         
  
/******************************************************************************                                
**  File: csp_ValidateCustomAIMS                            
**  Name: csp_ValidateCustomAIMS        
**  Desc: For Validation  on Custom AIMS document  
**  Return values: Resultset having validation messages                                
**  Called by:                                 
**  Parameters:            
**  Auth:  Devinder Pal Singh               
**  Date:  Aug 24 2009                            
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:       Author:       Description:                                
**  --------    --------        ----------------------------------------------------                                
**  17/09/2009   Ankesh Bharti   Modify according to data model 3.0 
**  23 Sept 2009  Pradeep        Changed the datatype of ClientInformed from int to char  
*******************************************************************************/                              
 
Return

/* 
        
--*TABLE CREATE*--         
CREATE TABLE #CustomAIMS (          
DocumentVersionId Int,        
TotalScore        int,  
DentalStatusWearDentures char(1),  
DentalStatusCurrentProblems char(1),  
GlobalJudgementAwareness int,  
GlobalJudgementIncapacitation int,  
GlobalJudgementSeverity int,  
FacialOralMovementsMuscles int,  
FacialOralMovementsLips int,  
FacialOralMovementsJaw int,  
FacialOralMovementsTongue int,  
ExtremityMovementsUpper int,  
ExtremityMovementsLower int,  
ExtremityMovementsTrunk int,  
ClientInformed CHAR(1)  
)           
--*INSERT LIST*--         
INSERT INTO #CustomAIMS (          
DocumentVersionId,           
TotalScore,           
DentalStatusWearDentures,           
DentalStatusCurrentProblems,  
GlobalJudgementAwareness ,  
GlobalJudgementIncapacitation ,  
GlobalJudgementSeverity ,  
FacialOralMovementsMuscles ,  
FacialOralMovementsLips ,  
FacialOralMovementsJaw ,  
FacialOralMovementsTongue ,  
ExtremityMovementsUpper ,  
ExtremityMovementsLower ,  
ExtremityMovementsTrunk ,  
ClientInformed    
)           
--*Select LIST*--         
Select DocumentVersionId,           
TotalScore,           
DentalStatusWearDentures,           
DentalStatusCurrentProblems,  
GlobalJudgementAwareness ,  
GlobalJudgementIncapacitation ,  
GlobalJudgementSeverity ,  
FacialOralMovementsMuscles ,  
FacialOralMovementsLips ,  
FacialOralMovementsJaw ,  
FacialOralMovementsTongue ,  
ExtremityMovementsUpper ,  
ExtremityMovementsLower ,  
ExtremityMovementsTrunk ,  
ClientInformed            
FROM CustomAIMS WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''          
         
         
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )          
SELECT ''CustomAIMS'', ''TotalScore'', ''Note - Total Score must be specified'' FROM #CustomAIMS WHERE isnull(TotalScore,'''')=''''          
UNION        
SELECT ''CustomAIMS'', ''DentalStatusCurrentProblems'', ''Note - Dental Status Current Problems must be specified'' FROM #CustomAIMS WHERE isnull(DentalStatusCurrentProblems,'''')=''''        
UNION          
SELECT ''CustomAIMS'', ''DentalStatusWearDentures'', ''Note - Dental Status Wear Dentures must be specified'' FROM #CustomAIMS WHERE isnull(DentalStatusWearDentures,'''')=''''        
UNION  
SELECT ''CustomAIMS'', ''GlobalJudgementAwareness'', ''Note - Dental Status Current Problems must be specified'' FROM #CustomAIMS WHERE isnull(GlobalJudgementAwareness,'''')=''''          
UNION        
SELECT ''CustomAIMS'', ''GlobalJudgementIncapacitation'', ''Note - Status of existing support system must be specified'' FROM #CustomAIMS WHERE isnull(GlobalJudgementIncapacitation,'''')=''''        
UNION          
SELECT ''CustomAIMS'', ''GlobalJudgementSeverity'', ''Note - Family and/or friends must be specified'' FROM #CustomAIMS WHERE isnull(GlobalJudgementSeverity,'''')=''''        
UNION  
SELECT ''CustomAIMS'', ''FacialOralMovementsMuscles'', ''Note - Predominant Communication Style must be specified'' FROM #CustomAIMS WHERE isnull(FacialOralMovementsMuscles,'''')=''''          
UNION        
SELECT ''CustomAIMS'', ''FacialOralMovementsLips'', ''Note - Status of existing support system must be specified'' FROM #CustomAIMS WHERE isnull(FacialOralMovementsLips,'''')=''''        
UNION          
SELECT ''CustomAIMS'', ''FacialOralMovementsJaw'', ''Note - Family and/or friends must be specified'' FROM #CustomAIMS WHERE isnull(FacialOralMovementsJaw,'''')=''''        
UNION  
SELECT ''CustomAIMS'', ''FacialOralMovementsTongue'', ''Note - Predominant Communication Style must be specified'' FROM #CustomAIMS WHERE isnull(FacialOralMovementsTongue,'''')=''''          
UNION        
SELECT ''CustomAIMS'', ''ExtremityMovementsUpper'', ''Note - Status of existing support system must be specified'' FROM #CustomAIMS WHERE isnull(ExtremityMovementsUpper,'''')=''''        
UNION          
SELECT ''CustomAIMS'', ''ExtremityMovementsLower'', ''Note - Family and/or friends must be specified'' FROM #CustomAIMS WHERE isnull(ExtremityMovementsLower,'''')=''''        
UNION  
SELECT ''CustomAIMS'', ''ExtremityMovementsTrunk'', ''Note - Predominant Communication Style must be specified'' FROM #CustomAIMS WHERE isnull(ExtremityMovementsTrunk,'''')=''''          
UNION        
SELECT ''CustomAIMS'', ''ClientInformed'', ''Note - Status of existing support system must be specified'' FROM #CustomAIMS WHERE isnull(ClientInformed,'''')=''''        
  
            
          
  if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_ValidateCustomAIMS failed.  Please contact your system administrator. We apologize for the inconvenience.'' 
  
  
  */
' 
END
GO
