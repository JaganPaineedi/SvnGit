/****** Object:  StoredProcedure [dbo].[csp_validateCustomTransferBrokerWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomTransferBrokerWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomTransferBrokerWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomTransferBrokerWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_validateCustomTransferBrokerWeb]      
@DocumentVersionId Int      
    
as      
/******************************************************************************                                          
**  File: csp_validateCustomTransferBrokerWeb                                      
**  Name: csp_validateCustomTransferBrokerWeb                  
**  Desc: For Validation  on Custom Transfer Broker document            
**  Return values: Resultset having validation messLegals                                          
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
--Load the document data into a temporary table to prevent multiple seeks on the document table      
CREATE TABLE #CustomTransferBroker      
(      
DocumentVersionId int,      
DocumentType char(1),      
DateOfRequest datetime,      
CurrentProgram int,      
ProgramRequested int,      
ServiceRequested int,      
RequestedClinician int,      
VerballyAcceptedDate datetime,      
Rationale text,       
Findings text,      
NoticeDeliveredDate datetime      
)      
--*INSERT LIST*--        
insert into #CustomTransferBroker      
(      
DocumentVersionId,      
DocumentType,      
DateOfRequest,      
CurrentProgram,      
ProgramRequested,      
ServiceRequested,      
RequestedClinician,      
VerballyAcceptedDate,      
Rationale,       
Findings,      
NoticeDeliveredDate      
)      
--*Select LIST*--       
select      
a.DocumentVersionId,      
a.DocumentType,      
a.DateOfRequest,      
a.CurrentProgram,      
a.ProgramRequested,      
a.ServiceRequested,      
a.RequestedClinician,      
a.VerballyAcceptedDate,      
a.Rationale,       
a.Findings,      
a.NoticeDeliveredDate      
from CustomTransferBroker a        
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
      
SELECT ''CustomTransferBroker'' , ''DocumentType'', ''Document Type must be specified.''      
 FROM #CustomTransferBroker WHERE isnull(DocumentType,'''')=''''    
UNION      
SELECT ''CustomTransferBroker'' , ''DateOfRequest'', ''Date Of Request must be specified.''      
 FROM #CustomTransferBroker WHERE isnull(DateOfRequest,'''')=''''   
UNION      
SELECT ''CustomTransferBroker'' , ''CurrentProgram'', ''Current Program must be specified.''      
 FROM #CustomTransferBroker WHERE isnull(CurrentProgram,'''')=''''   
UNION      
SELECT ''CustomTransferBroker'' , ''ProgramRequested'', ''Program Requested must be specified.''      
 FROM #CustomTransferBroker WHERE isnull(ProgramRequested,'''')=''''   
UNION      
SELECT ''CustomTransferBroker'' , ''ServiceRequested'', ''ServiceRequested must be specified.''   
 FROM #CustomTransferBroker WHERE isnull(RequestedClinician,'''')=''''      
UNION      
SELECT ''CustomTransferBroker'' , ''RequestedClinician'', ''Requested Clinician must be specified.''      
 FROM #CustomTransferBroker WHERE isnull(RequestedClinician,'''')=''''   
UNION      
SELECT ''CustomTransferBroker'' , ''VerballyAcceptedDate'', ''Verbally Accepted Date must be specified.''      
 FROM #CustomTransferBroker WHERE isnull(VerballyAcceptedDate,'''')=''''   
UNION      
SELECT ''CustomTransferBroker'' , ''Rationale'', ''Rationale must be specified.''      
 FROM #CustomTransferBroker WHERE cast(isnull(Rationale,'''') as varchar) = ''''  
UNION      
SELECT ''CustomTransferBroker'' , ''Findings'', ''Findings must be specified.''      
FROM #CustomTransferBroker WHERE cast(isnull(Findings,'''') as varchar) = ''''      
UNION      
SELECT ''CustomTransferBroker'' , ''NoticeDeliveredDate'', ''NoticeDeliveredDate must be specified.''      
 FROM #CustomTransferBroker WHERE isnull(NoticeDeliveredDate,'''')=''''   
    
end try                                                    
                                                                                             
BEGIN CATCH        
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomTransferBrokerWeb'')                                                                                   
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
