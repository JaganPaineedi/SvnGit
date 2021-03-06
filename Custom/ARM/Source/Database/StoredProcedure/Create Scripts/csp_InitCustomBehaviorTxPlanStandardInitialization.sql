/****** Object:  StoredProcedure [dbo].[csp_InitCustomBehaviorTxPlanStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomBehaviorTxPlanStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomBehaviorTxPlanStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomBehaviorTxPlanStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomBehaviorTxPlanStandardInitialization]             
(                                          
 @ClientID int,            
 @StaffID int,          
 @CustomParameters xml                                          
)                                                                  
As                                     
                                                                           
 /*********************************************************************/                                                                              
 /* Stored Procedure: [csp_InitCustomMedsOnlyTxPlanStandardInitialization]               */                                                                     
                                                                     
 /* Copyright: 2006 Streamline SmartCare*/                                                                              
                                                                     
 /* Creation Date:  14/Jan/2008                                    */                                                                              
 /*                                                                   */                                                                              
 /* Purpose: To Initialize */                                                                             
 /*                                                                   */                                                                            
 /* Input Parameters:  */                                                                            
 /*                                                                   */                                                                               
 /* Output Parameters:                                */                                                                              
 /*                                                                   */                                                                              
 /* Return:   */                                                                              
 /*                                                                   */                                                                              
 /* Called By:CustomDocuments Class Of DataService    */                                                                    
 /*      */                                                                    
                                                                     
 /*                                                                   */                                                                              
 /* Calls:                                                            */                                                                              
 /*                                                                   */                                                                              
 /* Data Modifications:                                               */                                                                              
 /*                                                                   */                                                                              
 /*   Updates:                                                          */                                                                              
                                                                     
 /*       Date              Author                  Purpose                                    */                                                                              
 /*       14/Jan/2008        Rishu Chopra          To Retrieve Data      */                
 /*       Sept11,2009        Pradeep                Made changes as per database  SCWebVenture3.0 */        
 /*       Nov18,2009         Ankesh             Made changes as per database  SCWebVenture3.0     
       avoss     correct intialization    
*/ 
/*        2 Sept 2010        Pradeep             Made changes to initialize */       
 /*********************************************************************/                      
                                     
Begin                                                    
          
Begin try                                                         
--Calculate Age of Client      
DECLARE @BirthDate DATETIME            
DECLARE @CurrentDate DATETIME            
DECLARE @Age INT            
SELECT @BirthDate=DOB,@CurrentDate = GETDATE() From Clients where ClientId=@ClientID            
select @Age = dbo.GetAge(isnull(@BirthDate,getdate()),Getdate())    
--SELECT @Age=DATEDIFF(YY, @BirthDate, @CurrentDate) - CASE WHEN (MONTH(@BirthDate)*100 + DAY(@BirthDate)) >(MONTH(@CurrentDate)*100 + DAY(@CurrentDate)) THEN 1  ELSE 0  END                                
    
declare @Diagnosis varchar(max)     
    
    
--Modify for Diagnosis    
--    
--Declare Variables for Loops    
--    
Declare @TempList Varchar(max)    
Declare @TempId   int    
Declare @MaxTempId int    
Declare @MainId Varchar(max)    
    
--    
-- Find Diagnosis    
--    
Set @TempList = NULL    
Set @TempId = NULL    
set @MaxTempId = NULL    
set @MainId = NULL    
    
    
    Set @TempId = 1    
    
    Create table #Temp3    
    (TempId int identity,    
     TempValue varchar(200)    
    )    
--select top 1* from diagnosesIandII    
    Insert into #Temp3    
    (TempValue)    
    select case when h.Axis=1 then ''Axis I: '' when h.Axis=2 then ''Axis II: '' else '''' end +    
 h.dsmcode + case when isnull(h.ruleout, ''N'')= ''Y'' then '' (R/O)'' else '''' end +    
 '' - '' + dd.DSMDescription + char(13)    
    from diagnosesIandII h    
 join diagnosisdsmdescriptions dd on dd.DSMCode = h.DSMCode and dd.DSMNumber = h.DSMNumber and dd.Axis = h.Axis    
 Join documents d on d.currentdocumentversionid = h.documentversionid     
 Where d.ClientId = @ClientId    
 and d.Status = 22    
 and d.DocumentCodeId = 5    
 and not exists (select * from documents d2    
         where d2.clientid = d.clientid    
         and d2.documentcodeid = d.documentcodeid    
         and d2.documentcodeid = 5    
         and d2.Status = 22    
         and d2.effectivedate > d.effectivedate    
         and d2.modifieddate > d.modifieddate    
         and isnull(d2.recorddeleted, ''N'') = ''N''    
         )    
 and isnull(h.recordDeleted, ''N'') = ''N''    
 and isnull(d.recordDeleted, ''N'') = ''N''    
 order by case when diagnosistype = 140 then 0 else diagnosisorder end    
    
    
    
    --Find Diangosis in temp table for while loop    
    Set @MaxTempId = (Select Max(TempId) From #Temp3)    
    
    --Begin Loop to create Allergy List    
    While @TempId <= @MaxTempId    
    Begin    
          Set @TempList = isnull(@TempList, '''') +     
                case when @TempId <> 1 then ''''     
     else '''' end +     
                (select isnull(TempValue, '''')    
                From #Temp3 t    
                Where t.TempId = @TempId)    
          Set @TempId = @TempId + 1    
    End     
    --End Loop    
    
 set @Diagnosis = @TempList    
-- update a    
-- set a.Diagnosis = @TempList    
-- from #PhysicianOverview a    
-- Where a.ClientId = @ClientId    
--    
 set @TempList = NULL    
    
 drop table #temp3    
    
/**/    
    
    
    
declare     
  @Psychologist varchar(100)    
 ,@GoalData varchar(max)    
    
select @GoalData = isnull(p.GoalDetail,'''')       
from documents d    
join CustomBehaviorTxPlan p on p.DocumentVersionId = d.CurrentDocumentVersionId and isnull(p.recorddeleted,''N'')<>''Y''    
where d.Status=22    
and d.ClientId = @ClientId    
and isnull(d.recorddeleted,''N'')<>''Y''    
and not exists (     
 select *     
 from documents d2    
 join CustomBehaviorTxPlan p2 on p2.DocumentVersionId = d2.CurrentDocumentVersionId and isnull(p2.recorddeleted,''N'')<>''Y''    
 where d2.Status=22    
 and d2.ClientId = d.ClientId    
 and isnull(d2.recorddeleted,''N'')<>''Y''    
 and ( ( d2.EffectiveDate > d.EffectiveDate ) or ( d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId ) )    
)    
    
--If past plans exist    
if exists (     
 select *    
 from documents d    
 join CustomBehaviorTxPlan t on t.DocumentVersionId = d.CurrentDocumentVersionId and isnull(t.recorddeleted,''N'')<>''Y''    
 where d.ClientId = @ClientId    
 and d.Status=22    
 and isnull(d.recorddeleted,''N'')<>''Y''    
)    
    
    
BEGIN    
    
 SELECT    
 ''CustomBehaviorTxPlan'' AS TableName    
 ,dv.DocumentVersionId    
 ,t.Type    
 ,@BirthDate as DOB    
-- ,s.LastName+'', ''+s.FirstName as PrimaryClinician    
 --THIS IS INCORRECT AND NEEDS TO BE ABOVE    
 ,convert(varchar(100),s.staffID)  as PrimaryClinician    
 ,s.LastName+'', ''+s.FirstName as PrimaryClinicianName         
 ,@Age as Age    
 ,'''' as Psychologist    
 ,@Diagnosis as Diagnosis    
-- ,t.Diagnosis as Diagnosis    
 ,case when isnull(convert(varchar(max),t.IdentifyingInformation),'''')<>''''     
  then ''Identifying Information: '' + convert(varchar(max),t.IdentifyingInformation)     
  else '''' end    
  + case when isnull(convert(varchar(max),t.BackgroundInformation),'''') <> ''''     
    then char(13)+char(10)+char(13)+char(10)+ ''Background Information: ''+ convert(varchar(max),t.BackgroundInformation)    
    else + '''' end     
  + case when isnull(@GoalData,'''') <> ''''     
    then char(13)+char(10)+char(13)+char(10)+ ''Goals: ''+ @GoalData     
    else '''' end    
  + case when isnull(convert(varchar(max),t.CurrentLevel),'''') <>''''     
    then char(13)+char(10)+char(13)+char(10)+ ''Current Level: ''+ convert(varchar(max),t.CurrentLevel)    
    else '''' end    
  + case when isnull(convert(varchar(max),t.Objective),'''') <>''''     
    then char(13)+char(10)+char(13)+char(10)+ ''Objective: ''+ convert(varchar(max),t.Objective)    
    else '''' end     
    
  as IdentifyingInformation    
 ,t.MedType1 as MedType1 ,t.MedDosage1 as MedDosage1 ,t.MedPurpose1 as MedPurpose1,t.MedPhysician1 as MedPhysician1    
 ,t.MedType2 as MedType2 ,t.MedDosage2 as MedDosage2 ,t.MedPurpose2 as MedPurpose2 ,t.MedPhysician2 as MedPhysician2    
 ,t.MedType3 as MedType3 ,t.MedDosage3 as MedDosage3 ,t.MedPurpose3 as MedPurpose3 ,t.MedPhysician3 as MedPhysician3    
 ,t.MedType4 as MedType4 ,t.MedDosage4 as MedDosage4 ,t.MedPurpose4 as MedPurpose4 ,t.MedPhysician4 as MedPhysician4    
 ,t.MedType5 as MedType5 ,t.MedDosage5 as MedDosage5 ,t.MedPurpose5 as MedPurpose5 ,t.MedPhysician5 as MedPhysician5    
 ,t.MedType6 as MedType6 ,t.MedDosage6 as MedDosage6 ,t.MedPurpose6 as MedPurpose6 ,t.MedPhysician6 as MedPhysician6    
 ,t.MedType7 as MedType7 ,t.MedDosage7 as MedDosage7 ,t.MedPurpose7 as MedPurpose7 ,t.MedPhysician7 as MedPhysician7    
 ,t.MedType8 as MedType8 ,t.MedDosage8 as MedDosage8 ,t.MedPurpose8 as MedPurpose8 ,t.MedPhysician8 as MedPhysician8    
 ,t.MedType9 as MedType9 ,t.MedDosage9 as MedDosage9 ,t.MedPurpose9 as MedPurpose9 ,t.MedPhysician9 as MedPhysician9    
 ,t.BackgroundInformation as BackgroundInformation    
 ,@GoalData as GoalDetail    
 ,t.CurrentLevel as CurrentLevel    
 ,t.Objective as Objective  
 --Written By Pradeep  
 ,t.ChallengingBehaviors as ChallengingBehaviors  
 ,t.RecordingMethod as RecordingMethod  
 ,t.TPPreventative as TPPreventative  
 ,t.TPProactive as TPProactive  
 ,t.TPIntervention as TPIntervention  
        
 from documents d     
 join documentVersions dv on dv.DocumentVersionId = d.CurrentDocumentVersionId and isnull(dv.RecordDeleted,''N'')<>''Y''    
 join CustomBehaviorTxPlan t on t.DocumentVersionId = dv.DocumentVersionId and isnull(t.recorddeleted,''N'')<>''Y''    
 join Clients c on c.ClientId = d.ClientId      
 left join Staff s on s.StaffId = c.PrimaryClinicianId      
 where d.ClientId = @ClientId           
 and d.Status=22    
 and isnull(d.recorddeleted,''N'')<>''Y''    
 and not exists (     
  select *     
  from documents d2    
  join CustomBehaviorTxPlan t2 on t2.DocumentVersionId = d2.CurrentDocumentVersionId and isnull(t2.recorddeleted,''N'')<>''Y''    
  where d2.Status=22    
  and d2.ClientId = d.ClientId    
  and isnull(d2.recorddeleted,''N'')<>''Y''    
  and ( ( d2.EffectiveDate > d.EffectiveDate ) or ( d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId ) )    
 )    
    
END    
    
/*    
if(exists(Select * from CustomBehaviorTxPlan C,Documents D,DocumentVersions DV                                        
    where C.DocumentVersionId=DV.DocumentVersionId and D.DocumentId = DV.DocumentId                  
     and D.ClientId=@ClientID                                                  
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))                                           
BEGIN     
      
  SELECT     TOP (1) ''CustomBehaviorTxPlan'' AS TableName, C.DocumentVersionId, C.Type, @BirthDate AS DOB, @Age AS Age, C.PrimaryClinician,    
  Staff.LastName + '','' + Staff.FirstName AS PrimaryClinicianName,    
  C.Psychologist, C.Diagnosis,       
        C.IdentifyingInformation, C.MedType1, C.MedDosage1, C.MedPurpose1, C.MedPhysician1, C.MedType2, C.MedDosage2, C.MedPurpose2, C.MedPhysician2,       
        C.MedType3, C.MedDosage3, C.MedPurpose3, C.MedPhysician3, C.MedType4, C.MedDosage4, C.MedPurpose4, C.MedPhysician4, C.MedType5, C.MedDosage5,       
        C.MedPurpose5, C.MedPhysician5, C.MedType6, C.MedDosage6, C.MedPurpose6, C.MedPhysician6, C.MedType7, C.MedDosage7, C.MedPurpose7,       
        C.MedPhysician7, C.MedType8, C.MedDosage8, C.MedPurpose8, C.MedPhysician8, C.MedType9, C.MedDosage9, C.MedPurpose9, C.MedPhysician9,       
        C.BackgroundInformation, C.GoalDetail, C.ChallengingBehaviors, C.CurrentLevel, C.Objective, C.RecordingMethod, C.TPPreventative, C.TPProactive, C.TPIntervention,       
        C.CreatedBy, C.CreatedDate, C.ModifiedBy, C.ModifiedDate      
 FROM         CustomBehaviorTxPlan AS C INNER JOIN      
        DocumentVersions AS DV ON C.DocumentVersionId = DV.DocumentVersionId INNER JOIN      
        Documents AS D ON DV.DocumentId = D.DocumentId      
        LEFT OUTER JOIN Staff on Staff.StaffId=C.PrimaryClinician    
 WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')      
 ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC ,  DV.DocumentVersionId DESC                                      
END       
*/    
                                         
else                                            
BEGIN       
                                         
Select TOP 1 ''CustomBehaviorTxPlan'' AS TableName,-1 as ''DocumentVersionId'',                          
--Custom data                      
''T'' as ''Type'',                    
--ISNULL(Convert(varchar(10),Cl.DOB,101),Convert(varchar(10),getdate(),101)) as DOB ,                    
@BirthDate AS DOB,                    
convert(varchar(100),Cl.PrimaryClinicianId) as PrimaryClinician,     
Staff.LastName + '','' + Staff.FirstName AS PrimaryClinicianName,                           
@Age as Age,                    
'''' as Psychologist,        
@Diagnosis as Diagnosis,                
--'''' as Diagnosis,                    
'''' as IdentifyingInformation,                    
'''' as MedType1,                    
'''' as MedDosage1,                    
'''' as MedPurpose1,                    
'''' as MedPhysician1,                    
'''' as MedType2,                    
'''' as MedDosage2,                    
'''' as MedPurpose2,                              
'''' as MedPhysician2,                    
'''' as MedType3,                    
'''' as MedDosage3,                    
'''' as MedPurpose3,                    
'''' as MedPhysician3,                    
'''' as MedType4,                    
'''' as MedDosage4,                    
'''' as MedPurpose4,                    
'''' as MedPhysician4,                    
'''' as MedType5,                    
'''' as MedDosage5,                    
'''' as MedPurpose5,                    
'''' as MedPhysician5,                    
'''' as MedType6,                              
'''' as MedDosage6,                    
'''' as MedPurpose6,                    
'''' as MedPhysician6,                    
'''' as MedType7,          
'''' as MedDosage7,                    
'''' as MedPurpose7,                   
'''' as MedPhysician7,                    
'''' as MedType8,                    
'''' as MedDosage8,                    
'''' as MedPurpose8,                    
'''' as MedPhysician8,                    
'''' as MedType9,                    
'''' as MedDosage9,                    
'''' as MedPurpose9,                       
'''' as MedPhysician9,                    
'''' as BackgroundInformation,                    
'''' as GoalDetail,                    
'''' as CurrentLevel,                    
'''' as Objective,                    
--Custom Data                      
                                   
'''' as CreatedBy,               
getdate() as CreatedDate,                        
'''' as ModifiedBy,                        
getdate() as ModifiedDate                          
from Clients Cl                                  
left outer join Staff ON Cl.PrimaryClinicianId = Staff.StaffId    
where Cl.ClientId=@ClientID    
    
    
    
END                                          
end try                                                    
                                                                                             
BEGIN CATCH        
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomBehaviorTxPlanStandardInitialization'')                                                                                   
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
