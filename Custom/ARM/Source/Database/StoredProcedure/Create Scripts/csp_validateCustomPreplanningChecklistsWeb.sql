/****** Object:  StoredProcedure [dbo].[csp_validateCustomPreplanningChecklistsWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPreplanningChecklistsWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomPreplanningChecklistsWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomPreplanningChecklistsWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomPreplanningChecklistsWeb]  
@DocumentVersionId Int              
as  
/******************************************************************************                                      
**  File: csp_validateCustomPreplanningChecklistsWeb                                  
**  Name: csp_validateCustomPreplanningChecklistsWeb              
**  Desc: For Validation  on Custom Preplanning Checklists document        
**  Return values: Resultset having validation messLegals                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Ankesh Bharti                     
**  Date:  Nov 26 2009                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:           
**  Nov 26 2009  Ankesh Bharti  Creation according to New Data Model 3.0                             
*******************************************************************************/                                    
           --NOT USED--
Begin                                                
      
 Begin try               
--*TABLE CREATE*--    
CREATE TABLE [#CustomPreplanning] (  
DocumentVersionId int null,  
Residential text null,  
--OccupationalCommunityParticpation text null,  
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
INSERT INTO [#CustomPreplanning](  
DocumentVersionId,  
Residential,  
--OccupationalCommunityParticipation,  
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
select   
a.DocumentVersionId,  
a.Residential,  
--a.OccupationalCommunityParticipation,  
a.Safety ,  
a.Legal,  
a.Health,  
a.NaturalSupports,  
a.Other,  
a.Participants,  
a.Facilitator,  
a.Assessments,  
a.TimeLocation,  
a.ISsuesToAvoid,  
a.CommunicationAccomodations,  
a.WishToDiscuss,  
a.SourceOfPrePlanningInformation,  
a.SelfDetermination,  
a.FiscalIntermediary,  
a.PCPInformationPamphletGiven,  
a.PCPInformationDiscussed   
from CustomPreplanningChecklists a  
where a.DocumentVersionId = @DocumentVersionId      
  
Insert into #validationReturnTable  
(TableName,  
ColumnName,  
ErrorMessage  
)  
--This validation returns three fields  
--Field1 = TableName  
--Field2 = ColumnName  
--Field3 = ErrorMessage  
  
  
Select ''CustomPreplanningChecklists'', ''Participants'', ''Pre Plan - Participants must be specified'' FROM #CustomPreplanning WHERE CAST(isnull(Participants,'''') AS VARCHAR) = ''''  
Union  
Select ''CustomPreplanningChecklists'', ''Facilitator'', ''Pre Plan - Facilitator must be indicated'' FROM #CustomPreplanning WHERE CAST(isnull(Facilitator,'''') AS VARCHAR) = ''''   
Union  
Select ''CustomPreplanningChecklists'', ''Assessments'', ''Pre Plan - Assessments must be specified'' FROM #CustomPreplanning WHERE CAST(isnull(Assessments,'''') AS VARCHAR) = ''''  
Union  
Select ''CustomPreplanningChecklists'', ''TimeLocation'', ''Pre Plan - Time/Location must be specified'' FROM #CustomPreplanning WHERE CAST(isnull(TimeLocation,'''') AS VARCHAR) = ''''   
Union  
Select ''CustomPreplanningChecklists'', ''IssuesToAvoid'', ''Pre Plan - Issues to avoid must be specified'' FROM #CustomPreplanning WHERE CAST(isnull(IssuesToAvoid,'''') AS VARCHAR) = ''''   
Union  
Select ''CustomPreplanningChecklists'', ''SourceofPreplanningInformation'', ''Pre Plan - Source of information must be specified'' FROM #CustomPreplanning WHERE CAST(isnull(SourceofPreplanningInformation,'''') AS VARCHAR) = ''''   
Union  
Select ''CustomPreplanningChecklists'', ''CommunicationAccomodations'', ''Pre Plan - Communication accomodations must be specified'' FROM #CustomPreplanning WHERE CAST(isnull(CommunicationAccomodations,'''') AS VARCHAR) = ''''   
Union  
Select ''CustomPreplanningChecklists'', ''WishToDiscuss'', ''Pre Plan - What does the customer wish to discuss must be specified'' FROM #CustomPreplanning WHERE CAST(isnull(WishToDiscuss,'''') AS VARCHAR) = ''''   
Union  
Select ''CustomPreplanningChecklists'', ''DeletedBy'', ''Pre Plan - PCP pamphlet given or discussed must be selected.''   
 FROM #CustomPreplanning  
 where isnull(PCPInformationPamphletGiven, ''N'') = ''N''  
 and isnull(PCPInformationDiscussed, ''N'') = ''N''  
Union  
Select ''CustomPreplanningChecklists'', ''DeletedBy'', ''Pre Plan - Self Determination desired must be selected.''  
 FROM #CustomPreplanning  
 where isnull(SelfDetermination, ''X'') = ''X''  
Union  
Select ''CustomPreplanningChecklists'', ''DeletedBy'', ''Pre Plan - Fiscal Intermediary desired must be selected.''  
 FROM #CustomPreplanning  
 where isnull(FiscalIntermediary, ''X'') = ''X''  
end try                                                                                  
BEGIN CATCH    
DECLARE @Error varchar(8000)                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomPreplanningChecklistsWeb'')                                                                               
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
