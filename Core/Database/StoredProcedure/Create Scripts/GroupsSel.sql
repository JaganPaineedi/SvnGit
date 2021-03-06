/****** Object:  StoredProcedure [dbo].[GroupsSel]    Script Date: 11/18/2011 16:25:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GroupsSel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GroupsSel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GroupsSel]        
@GroupId INT        
AS        
/******************************************************************************        
**  File: dbo.GroupsSel.prc        
**  Name: Stored_Procedure_Name        
**  Desc:         
**        
**  This template can be customized:        
**                      
**  Return values:        
**         
**  Called by:           
**                      
**  Parameters:        
**  Input       Output        
**     ----------       -----------        
**        
**  Auth:         
**  Date:         
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:  Modified:    Description:        
**  --------  --------    -------------------------------------------        
**  03/01/2017    vsinha	  What:  Length of "Display As" to handle procedure code display as increasing to 75     
							  Why :  Keystone Customizations 69  
*******************************************************************************/     
BEGIN
BEGIN TRY   
if @GroupId =-1        
 begin        
  SELECT    * --dbo.Groups.GroupCode, dbo.Programs.ProgramCode, dbo.Locations.LocationCode, dbo.ProcedureCodes.ProcedureCode--, dbo.Staff.LastName + ' , ' + dbo.staff.FirstName as Name        
  FROM         dbo.Groups INNER JOIN        
  dbo.Programs ON dbo.Groups.ProgramId = dbo.Programs.ProgramId INNER JOIN        
  dbo.Locations ON dbo.Groups.LocationId = dbo.Locations.LocationId INNER JOIN        
  dbo.ProcedureCodes ON dbo.Groups.ProcedureCodeId = dbo.ProcedureCodes.ProcedureCodeId        
 end        
else        
 begin        
  select * from groups where groupid=@GroupId and  (ISNULL(RecordDeleted, 'N') ='N' )         
 end        
        
--GlobalCodes for group types combo        
select  0 as GlobalCodeId,        
  'GroupType' as CateGory,        
  ' ' as CodeName        
union        
SELECT     GlobalCodeId,CateGory,CodeName        
FROM         GlobalCodes        
WHERE     (Category = 'GroupType'  --or Category = 'STAFFROLES'        
) and        
Active='Y' and        
 (ISNULL(RecordDeleted, 'N') ='N' )         
  
--Locations        
SELECT        
 0 AS LocationId        
 ,'' AS LocationCode        
 ,'' AS LocationName        
UNION        
select LocationId,LocationCode,LocationName from locations        
where Active='Y'        
and  (ISNULL(RecordDeleted, 'N') ='N' )        
order by LocationCode ASC        
        
--Programs        
  
SELECT        
 0 AS ProgramId        
 ,'' AS ProgramCode        
 ,'' AS ProgramName        
 ,0 as ProgramType        
UNION        
select P.ProgramId, P.ProgramCode, P.ProgramName, P.ProgramType        
 from programs P where P.Active='Y' And  (ISNULL(P.RecordDeleted, 'N') ='N' )        
 order by ProgramCode ASC         
       
--Procedure Codes        
SELECT        
 0 AS ProcedureCodeId        
 ,'' AS DisplayAs        
 ,0 AS EnteredAs        
 ,'' as CodeName        
UNION        
select P.ProcedureCodeId,P.DisplayAs, P.EnteredAs, G.CodeName from procedureCodes p        
inner join globalcodes G on P.EnteredAs=G.GlobalCodeId         
 where P.Active='Y' And  (ISNULL(P.RecordDeleted, 'N') ='N' )         
 order by DisplayAs ASC        
        
--SELECT     dbo.Clients.ClientId, dbo.Clients.LastName, dbo.Clients.FirstName, dbo.GroupClients.GroupId        
--if @GroupId>0        
--begin         
SELECT     'D' As DeleteButton, dbo.Clients.ClientId, dbo.Clients.LastName+' , '+ dbo.Clients.FirstName as [Name], dbo.GroupClients.*        
FROM         dbo.GroupClients INNER JOIN        
dbo.Clients ON dbo.GroupClients.ClientId = dbo.Clients.ClientId        
where dbo.GroupClients.groupid=@GroupId        
--end        
--else        
--begin        
--SELECT     'D' As DeleteButton, dbo.Clients.ClientId, dbo.Clients.LastName+','+ dbo.Clients.FirstName as [Name], dbo.GroupClients.*        
--FROM         dbo.GroupClients INNER JOIN        
--                      dbo.Clients ON dbo.GroupClients.ClientId = dbo.Clients.ClientId        
--end        
                              
                              
        
--SELECT     dbo.Staff.StaffId, dbo.Staff.LastName, dbo.Staff.FirstName, dbo.GroupStaff.GroupId        
--FROM         dbo.GroupStaff INNER JOIN        
--                      dbo.Staff ON dbo.GroupStaff.StaffId = dbo.Staff.StaffId        
                              
   --For Selected Staff                           
     if @GroupId>=0        
     begin        
SELECT         
    'D' AS DeleteButton        
,CASE         
WHEN S.DEGREE is NULL then S.LastName + ' , ' + S.FirstName        
else S.LastName + ' , ' + S.FirstName + '  ' + GC.CodeName         
end        
As [Name]        
--   ,S.LastName +' , ' + S.FirstName As [Name]        
   ,SP.GroupStaffId         
   ,sp.GroupId        
      ,S.StaffId        
      ,SP.RowIdentifier      ,SP.CreatedBy        
      ,SP.CreatedDate        
      ,SP.ModifiedBy        
      ,SP.ModifiedDate        
      ,SP.RecordDeleted        
      ,SP.DeletedDate        
      ,SP.DeletedBy        
FROM GroupStaff SP INNER JOIN Staff S ON S.StaffId = SP.staffid           
left outer join GlobalCodes GC on S.Degree=GC.globalcodeid        
WHERE        
        
  sp.groupid=@GroupId  and        
         
  (S.RecordDeleted = 'N' OR S.RecordDeleted IS NULL)          
AND        
  (SP.RecordDeleted = 'N' OR SP.RecordDeleted IS NULL)        
and S.Clinician='Y'        
        
end        
else            --If it is for list page or if it is a new record, used for staff filter        
begin        
SELECT 'D' AS DeleteButton        
,CASE         
WHEN S.DEGREE is NULL then S.LastName + ' , ' + S.FirstName        
else S.LastName + ' , ' + S.FirstName + '  ' + GC.CodeName         
end        
As [Name]        
--   ,S.LastName +' , ' + S.FirstName As [Name]        
   ,SP.GroupStaffId ,sp.GroupId,S.StaffId,SP.RowIdentifier        
    ,SP.CreatedBy  ,SP.CreatedDate  ,SP.ModifiedBy  ,SP.ModifiedDate ,SP.RecordDeleted        
     ,SP.DeletedDate    ,SP.DeletedBy        
     FROM  GroupStaff SP INNER JOIN Staff S ON S.StaffId = SP.staffid        
left outer join Globalcodes GC on S.Degree=GC.Globalcodeid        
WHERE        
   (S.RecordDeleted = 'N' OR S.RecordDeleted IS NULL)          
AND  (SP.RecordDeleted = 'N' OR SP.RecordDeleted IS NULL)        
end        
          
  --Available Staff        
          
SELECT         
    'D' AS DeleteButton        
,CASE         
WHEN S.DEGREE is NULL then S.LastName + ' , ' + S.FirstName        
else S.LastName + ' , ' + S.FirstName + '  ' + GC.CodeName         
end        
As [Name]        
--   ,LastName+ ' , ' + FirstName AS [Name]         
   ,'0' AS GroupStaffId        
      ,@GroupId AS GroupId        
      ,S.StaffId            
      ,S.RowIdentifier        
      ,S.CreatedBy        
      ,S.CreatedDate        
      ,S.ModifiedBy        
      ,S.ModifiedDate        
      ,'N' AS RecordDeleted        
      ,S.DeletedDate        
      ,S.DeletedBy        
FROM         
 Staff S        
left outer join globalcodes GC on S.Degree=GC.Globalcodeid        
WHERE        
StaffId NOT IN        
(        
   select s.staffid from staff s inner join GroupStaff G        
     on s.staffid=g.staffid where        
(S.RecordDeleted = 'N' OR S.RecordDeleted IS NULL)          
AND (G.RecordDeleted = 'N' OR G.RecordDeleted IS NULL)        
AND S.Active = 'Y'and G.GroupId=@GroupId        
)        
        
AND         
 (S.RecordDeleted = 'N' OR S.RecordDeleted IS NULL)          
AND        
 S.Active = 'Y'           
and S.Clinician='Y'        
order by [Name] Asc        
         
--Start Group List for displaying in group list page datagrid        
         
 Declare @GroupIds int,        
@GroupCode varchar(50),            
@Active Varchar(10),        
@programid int,        
 @ProgramCode varchar(50),            
@locationid int,        
 @LocationCode varchar(50),            
@procedurecodeid int,        
 @DisplayAs varchar(75),     --03/01/2017    vsinha       
@Staffid int,        
 @StaffName varchar(500),          
 --@DateOfService datetime,        
--@EndDateOfService datetime,        
--@Status int,          
  @tempGroupId int,        
 @Counter int            
    
Declare Staff cursor for            
        
select Groups.GroupId,Groups.groupCode, Groups.Active,        
programs.programid,Programs.ProgramCode,        
locations.locationid,Locations.LocationCode,        
 procedurecodes.procedurecodeid, ProcedureCodes.DisplayAs ,        
Staff.staffid,        
CASE        
WHEN Staff.DEGREE is NULL then Staff.LastName + ' , ' + Staff.FirstName        
else Staff.LastName + ' , ' + Staff.FirstName + '  ' + GC.CodeName         
end        
as StaffName         
--Staff.LastName + ' , ' + Staff.FirstName StaffName          
--,groupservices.DateOfService,groupservices.EndDateOfService,groupservices.Status        
        
from groups        
left outer join groupstaff on groupstaff.groupid=groups.groupid        
left outer join programs on Groups.ProgramId = Programs.ProgramId            
left outer join locations on groups.LocationId = Locations.LocationId            
left outer join procedurecodes on Groups.ProcedureCodeId = ProcedureCodes.ProcedureCodeId            
left outer join staff on GroupStaff.StaffId =Staff.StaffId          
left outer join globalcodes GC on Staff.Degree=GC.Globalcodeid        
--left outer join groupservices on groupstaff.groupid=groupservices.groupid        
where (Groups.RecordDeleted = 'N' OR Groups.RecordDeleted IS NULL)         
--and Groups.Active='Y'        
order by groups.groupid        
        
open Staff           
         
Fetch Staff into @GroupIds,        
@GroupCode, @Active,@programid, @ProgramCode, @locationid, @LocationCode, @procedurecodeid ,        
@DisplayAs, @Staffid , @StaffName        
--,          
--@DateOfService ,        
--@EndDateOfService,        
--@Status         
         
set @Counter=0                
create table #temp1            
(            
GroupIds int,        
 GroupCode varchar(50),           
Active varchar(10),        
programid int,        
 ProgramCode varchar(50),            
locationid int,        
 LocationCode varchar(50),            
procedurecodeid int,        
 DisplayAs varchar(75),    --03/01/2017    vsinha       
Staffid int,        
 Staff1  varchar(500),            
 Staff2 varchar(500),            
 Staff3 varchar(500),            
 Staff4 varchar(500)--,        
 --DateOfService datetime,        
--EndDateOfService datetime,        
--Status int         
)            
          
WHILE @@Fetch_Status = 0  or  @Counter < 4            
Begin          
  print @StaffName          
 set @Counter=@Counter + 1                
        
 if @Counter=1            
 BEGIN            
  insert into #temp1(GroupIds,GroupCode,Active,programid,ProgramCode,locationid,LocationCode,procedurecodeid,DisplayAs,Staffid,Staff1,Staff2,Staff3,Staff4--,DateOfService ,        
--EndDateOfService ,Status        
)             
  values(@GroupIds,@GroupCode,@Active,@programid,@ProgramCode,@locationid,@LocationCode,@procedurecodeid,@DisplayAs,@Staffid,@StaffName,'','',''--,@DateOfService ,@EndDateOfService ,@Status        
  )            
 END            
            
 ELSE if @Counter=2            
 BEGIN            
  update #temp1 set Staff2=@StaffName   where GroupIds=@GroupIds         
 END            
 Else if @Counter=3            
 BEGIN            
  update #temp1 set Staff3=@StaffName    where GroupIds=@GroupIds        
 END            
 Else if @Counter=4            
 Begin            
  update #temp1 set Staff4=@StaffName    where GroupIds=@GroupIds        
 End            
  set  @tempGroupId = @GroupIds        
Fetch Staff into @GroupIds,        
@GroupCode, @Active, @programid, @ProgramCode, @locationid,        
@LocationCode, @procedurecodeid , @DisplayAs, @Staffid ,        
@StaffName--,           
--@DateOfService ,        
--@EndDateOfService,        
--@Status         
      if @tempGroupId!=@GroupIds        
  BEGIN        
         
 set @Counter=0        
 print 'in the counter set'        
  END           
End            
close Staff                
DEALLOCATE Staff                
            
Select * from #temp1            
drop table #temp1            
            
--return             
        
--End Group List for displaying in group list page datagrid        
        
        
--Get all staff information        
        
select S.StaffId,         
 S.LastName + ' , ' + S.FirstName As [Name]  from         
staff S left outer join globalcodes GC on S.Degree=GC.globalcodeid        
 where (S.RecordDeleted = 'N' OR S.RecordDeleted IS NULL)          
AND        
 S.Active = 'Y'         
 order by [Name] ASC
END TRY
BEGIN CATCH
   DECLARE @Error varchar(8000)                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'GroupsSel')                                        
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                              
         + '*****' + Convert(varchar,ERROR_STATE())                                            
        RAISERROR                                             
   (                                            
     @Error, -- Message text.                                
     16, -- Severity.                                            
     1 -- State.                                            
    );
END CATCH
END
GO