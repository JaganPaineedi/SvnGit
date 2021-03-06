IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportServiceNoteHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportServiceNoteHeader] 
GO

CREATE PROCEDURE [dbo].[csp_RdlSubReportServiceNoteHeader]          
@DocumentVersionId int          
--@DocumentId int,             
--@Version int                    
                  
 AS                   
/*                  
** Object Name:  [csp_RdlSubReportServiceNoteHeader]                  
**                  
**                  
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set                   
**    which matches those parameters.                   
**                  
** Programmers Log:                  
** Date  Programmer  Description                  
**------------------------------------------------------------------------------------------                  
**                
** Oct 08 2007 Ranjeetb             
** 10-21-2009 avoss  modified to correctly calculate duration based on procedurecode     
** 04-30-2012 avoss    Modify for date format.          
** 03-03-2012 Jagdeep  Modify for date format of DateOfService(MM/DD/YYYY).          
** 06-07-2012 Vikas Kashyap  Modify for Added New Columns ProcedureName,LocationName,ModeOfDelivery (W.r.t. Task#1040)       
** 11-07-2012 Jeff Riley  Mapped custom fields to new table CustomServices
-- 10/13/2015 MD Hussain  Added plus 1 to End of service date w.r.t core bugs #1910
*/

DECLARE @GroupName VARCHAR(250)
SELECT TOP 1 @GroupName = G.GroupName
FROM Documents
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId
INNER JOIN Services ON Documents.ServiceId = Services.ServiceId	AND Clients.ClientId = Services.ClientId AND Services.GroupServiceId IS NOT NULL
INNER JOIN GroupServices GS ON Services.GroupServiceId = GS.GroupServiceId
INNER JOIN Groups G ON G.GroupId = GS.GroupId AND G.GroupName IS NOT NULL
INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeid = Services.ProcedureCodeid
INNER JOIN DocumentCodes ON DocumentCodes.DocumentCodeid = Documents.DocumentCodeId
INNER JOIN Staff ON Documents.AuthorId = Staff.StaffId
INNER JOIN DOCUMENTVERSIONS ON DOCUMENTS.DOCUMENTID = DOCUMENTVERSIONS.DOCUMENTID
WHERE DocumentVersions.DocumentVersionId = @DocumentVersionID
              
SELECT  DocumentCodes.DocumentName,Documents.DocumentId,          
  (select OrganizationName from SystemConfigurations ) as OrganizationName,          
  pc.DisplayAs,           
  ISNULL(Clients.FirstName, '') + ' ' + ISNULL(Clients.LastName, '') AS ClientName,           
  Clients.ClientId,          
        GlobalCodes.CodeName AS Status,           
  ISNULL(Staff.FirstName, '') + ' ' + ISNULL(Staff.LastName, '') AS StaffName,           
  Services.EndDateOfService as EndTime,                 
        Convert(varchar(10),Services.DateOfService,101) as DateOfService,           
  Services.DateOfService as StartTime,           
  case gc2.GlobalCodeId           
  when 112--'Days'           
   then case when convert(varchar(7),DATEDIFF(dd, Services.DateOfService, Services.EndDateOfService) ) = 1           
     then convert(varchar(7),DATEDIFF(dd, Services.DateOfService, DATEADD(dd, 1, Services.EndDateOfService)) ) + ' '       
     + case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))='s'           
      then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'')           
      else gc2.CodeName end          
   else convert(varchar(7),DATEDIFF(dd, Services.DateOfService, DATEADD(dd, 1,Services.EndDateOfService)) ) +  ' ' + gc2.Codename end          
  when 111--'Hours'          
   then case when convert(varchar(7),DATEDIFF(hh, Services.DateOfService, Services.EndDateOfService) ) = 1           
     then convert(varchar(7),DATEDIFF(hh, Services.DateOfService, Services.EndDateOfService) ) + ' '          
     + case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))='s'           
      then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'')           
      else gc2.CodeName end          
   else convert(varchar(7),DATEDIFF(hh, Services.DateOfService, Services.EndDateOfService) ) + ' ' +  gc2.Codename end          
  when 113 --'Items'          
   then case when services.Unit = 1           
    then convert(varchar(7),services.Unit) + ' '          
     + case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))='s'           
      then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'')           
      else gc2.CodeName end          
   else convert(varchar(7),services.Unit) +  ' ' + gc2.Codename end          
  when 114 --'mg'          
   then convert(varchar(7),services.Unit) +  ' ' + gc2.Codename          
  when 110 --'Minutes'           
   then case when convert(varchar(7),DATEDIFF(mi, Services.DateOfService, Services.EndDateOfService) ) = 1           
     then convert(varchar(7),DATEDIFF(mi, Services.DateOfService, Services.EndDateOfService) ) + ' '          
     + case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))='s'           
      then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'')           
      else gc2.CodeName end          
   else convert(varchar(7),DATEDIFF(mi, Services.DateOfService, Services.EndDateOfService) ) + ' ' + gc2.Codename end          
  when 116 --'Units'          
   then case when services.Unit = 1           
    then convert(varchar(7),services.Unit) + ' '          
     + case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))='s'           
      then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'')           
      else gc2.CodeName end          
   else convert(varchar(7),services.Unit) +  ' ' + gc2.Codename end          
  end AS Duration,  
  pc.ProcedureCodeName AS ProcedureName,  
  LC.LocationName,  
  --dbo.csf_GetGlobalCodeNameById(cs.ModeOfDelivery) AS ModeOfDelivery,  
 -- cs.MemberParticipated AS MemberPaticipated,  
 -- s2.FirstName + ' ' + s2.LastName AS SecondStaff,  
 --- cs.FamilyMembers AS FamilyMembers,  
 -- cs.InternalCollateral AS InternalCollateral,  
 -- cs.ExternalCollateral AS ExternalCollateral,  
 -- cs.CancelNoShowComment AS CancelNoShowComment,  
  Services.SpecificLocation AS SpecificLocation,  
  ProgramName = p.ProgramName,
  ISNULL(@GroupName,'') AS GroupName
FROM  Documents           
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId           
INNER JOIN Services ON Documents.ServiceId = Services.ServiceId AND Clients.ClientId = Services.ClientId            
Inner join ProcedureCodes pc on pc.ProcedureCodeid=Services.ProcedureCodeid           
Inner join DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId            
INNER JOIN Staff ON Documents.AuthorId = Staff.StaffId           
INNER JOIN DOCUMENTVERSIONS ON DOCUMENTS.DOCUMENTID=DOCUMENTVERSIONS.DOCUMENTID           
INNER JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = Services.Status           
left join globalcodes gc2 on gc2.GlobalCodeId = pc.EnteredAs  
Left Join Locations LC ON LC.LocationId=Services.LocationId    
--Left Join CustomFieldsData CFD On CFD.PrimaryKey1=Services.ServiceId   
LEFT JOIN CustomServices cs ON cs.ServiceId = Services.ServiceId  
--LEFT JOIN Staff s2 ON s2.StaffId = cs.SecondStaffId  
LEFT JOIN Programs p ON p.ProgramId = Services.ProgramId  
Where DocumentVersions.DocumentVersionId = @DocumentVersionID      
--where Documents.DocumentId =@DocumentId           
--and DocumentVersions.Version=@Version                
  
--Documents.CurrentDocumentVersionId=@DocumentVersionId    
  
          
        
