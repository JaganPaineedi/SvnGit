/****** Object:  StoredProcedure [dbo].[csp_validateCustomPreplanningChecklists]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPreplanningChecklists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomPreplanningChecklists]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPreplanningChecklists]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomPreplanningChecklists]           
@DocumentVersionId Int--, @DocumentCodeId Int           
as           
    
/******************************************************************************                                  
**  File: csp_ValidateCustomPreplanningChecklists                              
**  Name: csp_ValidateCustomPreplanningChecklists          
**  Desc: For Validation  on Custom Meds Only Treatment Plan document    
**  Return values: Resultset having validation messLegals                                  
**  Called by:                                   
**  Parameters:              
**  Auth:  Devinder Pal Singh                 
**  Date:  Aug 24 2009                              
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:       Author:       Description:                                  
**  17/09/2009  Ankesh Bharti  Modify according to Data Model 3.0    
**  --------    --------        ----------------------------------------------------                                  
*******************************************************************************/                                

Return


/*


          
--*TABLE CREATE*--           
CREATE TABLE #CustomPreplanningChecklists (            
DocumentVersionId Int,          
Residential text null,
Safety text null,
Legal text null,
Health text null,
NaturalSupports text null,
Other text null,
Participants text null,
Facilitator text null,
Assessments text null,
TimeLocation text null,
ISsuesToAvoid text null,
CommunicationAccomodations text null,
WishToDiscuss text null,
SourceOfPrePlanningInformation text null,
SelfDetermination char(2) null,
FiscalIntermediary char(2) null,
PCPInformationPamphletGiven char(2) null,
PCPInformationDiscussed char(2) null    
)             
--*INSERT LIST*--           
INSERT INTO #CustomPreplanningChecklists (            
DocumentVersionId,             
Residential,
Safety ,
Legal,
Health,
NaturalSupports,
Other,
Participants,
Facilitator,
Assessments,
TimeLocation,
ISsuesToAvoid,
CommunicationAccomodations,
WishToDiscuss,
SourceOfPrePlanningInformation,
SelfDetermination,
FiscalIntermediary,
PCPInformationPamphletGiven,
PCPInformationDiscussed
)             
--*Select LIST*--           
Select DocumentVersionId,             
Residential,
Safety ,
Legal,
Health,
NaturalSupports,
Other,
Participants,
Facilitator,
Assessments,
TimeLocation,
ISsuesToAvoid,
CommunicationAccomodations,
WishToDiscuss,
SourceOfPrePlanningInformation,
SelfDetermination,
FiscalIntermediary,
PCPInformationPamphletGiven,
PCPInformationDiscussed              
FROM CustomPreplanningChecklists WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''            
           
           
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )            
SELECT ''CustomPreplanningChecklists'', ''Residential'', ''Residential must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(Residential,'''') AS VARCHAR) = ''''            
UNION          
SELECT ''CustomPreplanningChecklists'', ''Legal'', ''Legal must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(Legal,'''') AS VARCHAR) = ''''          
UNION            
SELECT ''CustomPreplanningChecklists'', ''Safety'', ''Safety must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(Safety,'''') AS VARCHAR) = ''''          
UNION            
SELECT ''CustomPreplanningChecklists'', ''Health'', ''Health must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(Health,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''NaturalSupports'', ''NaturalSupports must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(NaturalSupports,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''Other'', ''Other must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(Other,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''Participants'', ''Participants must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(Participants,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''Facilitator'', ''Facilitator must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(Facilitator,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''Assessments'', ''Assessments must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(Assessments,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''TimeLocation'', ''TimeLocation must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(TimeLocation,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''ISsuesToAvoid'', ''ISsuesToAvoid must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(ISsuesToAvoid,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''CommunicationAccomodations'', ''CommunicationAccomodations must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(CommunicationAccomodations,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''WishToDiscuss'', ''WishToDiscuss must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(WishToDiscuss,'''') AS VARCHAR) = ''''                        
UNION            
SELECT ''CustomPreplanningChecklists'', ''SourceOfPrePlanningInformation'', ''SourceOfPrePlanningInformation must be specified'' 
FROM #CustomPreplanningChecklists WHERE CAST(isnull(SourceOfPrePlanningInformation,'''') AS VARCHAR) = ''''                        
--UNION            
--SELECT ''CustomPreplanningChecklists'', ''SelfDetermination'', ''must be specified'' 
FROM #CustomPreplanningChecklists WHERE isnull(SelfDetermination,'''') = ''''                        
--UNION            
--SELECT ''CustomPreplanningChecklists'', ''FiscalIntermediary'', ''FiscalIntermediary must be specified'' 
FROM #CustomPreplanningChecklists WHERE isnull(FiscalIntermediary,'''') = ''''                        
--UNION            
--SELECT ''CustomPreplanningChecklists'', ''PCPInformationPamphletGiven'', ''PCPInformationPamphletGiven must be specified'' 
FROM #CustomPreplanningChecklists WHERE isnull(PCPInformationPamphletGiven,'''') = ''''                        
--UNION            
--SELECT ''CustomPreplanningChecklists'', ''PCPInformationDiscussed'', ''PCPInformationDiscussed must be specified'' 
FROM #CustomPreplanningChecklists WHERE isnull(PCPInformationDiscussed,'''') = ''''                        
Union  
Select ''CustomPreplanningChecklists'', ''DeletedBy'', ''Pre Plan - Self Determination desired must be selected.''  
 FROM #CustomPreplanningChecklists  
 where isnull(SelfDetermination, ''X'') = ''X''  
Union  
Select ''CustomPreplanningChecklists'', ''DeletedBy'', ''Pre Plan - Fiscal Intermediary desired must be selected.''  
 FROM #CustomPreplanningChecklists  
 where isnull(FiscalIntermediary, ''X'') = ''X''  
Union 
Select ''CustomPreplanningChecklists'', ''DeletedBy'', ''Pre Plan - PCP pamphlet given or discussed must be selected.''   
 FROM #CustomPreplanningChecklists  
 where isnull(PCPInformationPamphletGiven, ''N'') = ''N''  
 and isnull(PCPInformationDiscussed, ''N'') = ''N''  

            
if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_ValidateCustomPreplanningChecklists failed.  Please contact your system administrator. We apologize for the inconvenience.'' 


*/
' 
END
GO
