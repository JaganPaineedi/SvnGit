/****** Object:  StoredProcedure [dbo].[csp_SCMultiStaffCalendarSelDropDowns]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCMultiStaffCalendarSelDropDowns]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCMultiStaffCalendarSelDropDowns]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCMultiStaffCalendarSelDropDowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_SCMultiStaffCalendarSelDropDowns]       
  @StaffId INT           
AS          
          
          
SELECT          
  0 AS LocationId          
 ,'''' AS LocationCode          
 ,''Y'' AS Active          
UNION           
SELECT          
  LocationId          
 ,LocationCode           
 ,Active          
FROM          
 Locations          
WHERE          
 (RecordDeleted = ''N'' OR RecordDeleted IS NULL)   And Active=''Y''        
           
--AppointmentType          
SELECT          
  GlobalCodeId          
 ,CodeName           
 --,''#80FF80'' AS Color           
 ,Color          
 ,Active            
FROM          
 GlobalCodes          
WHERE          
 Category=''APPOINTMENTTYPE''            
AND          
 (RecordDeleted = ''N'' OR RecordDeleted IS NULL)          
ORDER BY SortOrder ASC, CodeName ASC  -- GlobalCodeId  ----SortOrder ASC, CodeName ASC           
           
              
--ShowTimeAs            
SELECT          
  GlobalCodeId            
 ,CodeName          
 --,''#FF00FF'' AS Color           
 ,Color          
 ,Active          
FROM          
 GlobalCodes          
WHERE          
 Category=''ShowTimeAs''          
AND          
 (RecordDeleted = ''N'' OR RecordDeleted IS NULL)           
ORDER BY GlobalCodeId           
          
--Staff          
SELECT           
  S.StaffId          
  ,CASE          
    WHEN S.Degree IS NULL THEN S.LastName+ '', '' + S.FirstName          
    ELSE S.LastName+ '', '' + S.FirstName + '' '' + GC.CodeName          
    END  AS UName          
 --,LastName + '', '' + FirstName as UName          
 ,S.Active          
FROM           
 Staff S          
Left JOIN          
 GlobalCodes GC            
ON          
 GC.GlobalCodeId=S.Degree          
WHERE           
 S.Active = ''Y''          
AND           
 S.Clinician= ''Y''          
AND          
 ISNULL(S.RecordDeleted,''N'') = ''N''          
ORDER BY Lastname            
          
--MultiStaffViews          
--SELECT 0 AS MultiStaffViewId,          
--'''' as UserStaffId,          
--'''' as ViewName,          
--'''' as AllStaff,           
----'''' as RowIdentifier,           
--'''' as CreatedBy,           
--'''' as CreatedDate,           
--'''' as ModifiedBy,           
--'''' as ModifiedDate,          
--'''' as RecordDeleted,           
--'''' as DeletedDate,           
--'''' as DeletedBy,           
--''D'' AS DeleteButton,          
--''N'' AS RadioButton,          
--'''' as  AllStaff1          
--UNION          
select MultiStaffViewId,UserStaffId, ViewName, AllStaff, --RowIdentifier,           
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy ,''D'' AS DeleteButton          
,''N'' AS RadioButton ,          
AllStaff1 =          
  case AllStaff          
  when ''Y'' Then ''All''          
  When ''N'' then ''Some''          
   end --,RowIdentifier          
from MultiStaffViews Where UserStaffId=@StaffId and (RecordDeleted = ''N''OR RecordDeleted IS NULL)--and createdby in (select usercode from Staff where staffId =@StaffId)          
order by ViewName           
          
--MultiStaffViewStaff          
select * from MultiStaffViewStaff SVS          
INNER JOIN           
 MultiStaffViews SV          
ON           
 SV.MultiStaffViewId = SVS.MultiStaffViewId          
INNER JOIN           
 Staff S          
ON          
 S.StaffId=SVS.StaffId          
WHERE          
 (SV.RecordDeleted = ''N''OR SV.RecordDeleted IS NULL)          
AND          
 (SVS.RecordDeleted = ''N''OR SVS.RecordDeleted IS NULL)          
AND          
 S.Active = ''Y''          
AND          
 S.Clinician=''Y''          
AND          
 (S.RecordDeleted = ''N''OR S.RecordDeleted IS NULL)          
          
--DefaultViewId          
SELECT           
 CASE           
 WHEN DefaultCalenderViewType=''M'' THEN 0          
 ELSE 1          
 END DefaultViewTypeIndex          
 ,CASE          
 WHEN DefaultCalenderViewType=''S'' THEN DefaultCalendarStaffId          
 ELSE DefaultMultiStaffViewId          
 END DefaultId           
 ,CASE          
 WHEN DefaultCalendarIncrement=1 THEN 0          
 WHEN DefaultCalendarIncrement=3 THEN 2          
 ELSE 1 -- when 2 or default          
 END AS DefaultIncrement          
FROM Staff WHERE StaffId=@StaffId
' 
END
GO
