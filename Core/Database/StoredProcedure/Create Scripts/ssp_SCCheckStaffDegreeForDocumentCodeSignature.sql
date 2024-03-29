/****** Object:  StoredProcedure [dbo].[ssp_SCCheckStaffDegreeForDocumentCodeSignature]    Script Date: 02/05/2012 15:27:17 ******/
set ANSI_NULLS on
GO
set QUOTED_IDENTIFIER on
GO

if object_id('ssp_SCCheckStaffDegreeForDocumentCodeSignature', 'P') is not null
	drop procedure dbo.ssp_SCCheckStaffDegreeForDocumentCodeSignature
go

 /********************************************************************************                                      
-- Stored Procedure: ssp_SCCheckStaffDegreeForDocumentCodeSignature                                        
--                                      
-- Copyright: Streamline Healthcate Solutions                                      
--                                      
-- Purpose: To Check whether a document author has required license to sign the document or not                      
-- Invoked By : <Its invoked by Document.cs class>                 
--                                      
-- Updates:                                                                                             
-- Date         Author      Purpose                                      
-- 04 Aug,2011  Shifali      Created.                      
-- 10Nov,2011	Shifali		Modified in order to remove Duplicacy in Records for Reviewer Dropdown and added Orderby    
-- 13 Dec 2013  Manju P      Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes
-- 07 JUL 2014  PPOTNURU     Added record deleted checks
-- 10 FEB 2016  Akwinass     Included @MultipleDocumentID for GroupServices (Task #124 in MFS - Customization Issue Tracking)
*********************************************************************************/
create procedure [dbo].[ssp_SCCheckStaffDegreeForDocumentCodeSignature] (
     @DocumentId int,     
     @DocumentCodeId int,
     @AuthorFlag char(1),
     @MultipleDocumentID varchar(max) = NULL
    )
as 
begin  
    begin try     
     
        declare @AuthorId int  
        declare @EffectiveDate date  
        
        IF ISNULL(@DocumentId, 0) > 0
		BEGIN
			select  @AuthorId = AuthorId,
					@EffectiveDate = EffectiveDate
			from    Documents
			where   DocumentId = @DocumentId
        END
        ELSE if(ISNULL(@MultipleDocumentID,'') <> '' and @DocumentId = 0)
        begin
			SELECT TOP 1 @AuthorId = AuthorId
				,@EffectiveDate = CAST(EffectiveDate AS DATE)
			FROM Documents D
			WHERE EXISTS (SELECT 1 FROM dbo.fnSplit(ISNULL(@MultipleDocumentID,''), ',') WHERE ISNULL(item, '') <> '' AND item = D.DocumentId)
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
        end 
        
        if (@AuthorFlag = 'Y') 
            begin
                select  *
                from    StaffLicenseDegrees SLD
                left join DocumentCodeLicensedSignatures DCLS on SLD.LicenseTypeDegree = DCLS.Degree AND ISNULL(DCLS.RecordDeleted,'N')='N'
                where   StaffId = ISNULL(@AuthorId, -1) AND ISNULL(SLD.RecordDeleted,'N')='N'
                        and DCLS.DocumentCodeId = @DocumentCodeId
                        and (
                             SLD.StartDate is null
                             or @EffectiveDate >= SLD.StartDate
                            )
                        and (
                             SLD.EndDate is null
                             or @EffectiveDate < DATEADD(DD, 1, SLD.EndDate)
                            )
            end
        else 
            begin
                select  *
                from    StaffLicenseDegrees SLD
                left join DocumentCodeLicensedSignatures DCLS on SLD.LicenseTypeDegree = DCLS.Degree AND ISNULL(DCLS.RecordDeleted,'N')='N'
                where   DCLS.DocumentCodeId = @DocumentCodeId  AND ISNULL(SLD.RecordDeleted,'N')='N'
                        and (
                             SLD.StartDate is null
                             or @EffectiveDate >= SLD.StartDate
                            )
                        and (
                             SLD.EndDate is null
                             or @EffectiveDate < DATEADD(DD, 1, SLD.EndDate)
                            )
            end  
         
     
        select distinct
                0 as StaffLicenseDegreeId,
                CAST(null as varchar(30)) as CreatedBy,
                CAST(null as datetime) as CreatedDate,
                CAST(null as varchar(30)) as ModifiedBy,
                CAST(null as datetime) as ModifiedDate,
                CAST(null as char(1)) as RecordDeleted,
                CAST(null as datetime) as DeletedDate,
                CAST(null as varchar(30)) as DeletedBy,
                S.[StaffId],
                case when ss.SupervisorId is not null then '* ' else '' end + S.DisplayAs as StaffName,  --S.LastName + ', ' + S.FirstName as StaffName,  
                CAST(null as int) as LicenseTypeDegree,
                CAST(null as varchar(25)) as LicenseNumber,
                CAST(null as datetime) as StartDate,
                CAST(null as datetime) as EndDate,
                CAST(null as char(1)) as Billing
        from dbo.Staff as s
		LEFT join dbo.StaffSupervisors as ss on ss.SupervisorId = s.StaffId and ss.StaffId = @AuthorId and ISNULL(ss.RecordDeleted, 'N') <> 'Y'
        where s.StaffId <> @AuthorId
        and s.Active = 'Y'
        and exists (
			select *
			from StaffLicenseDegrees SLD
			join DocumentCodeLicensedSignatures DCLS on SLD.LicenseTypeDegree = DCLS.Degree AND ISNULL(DCLS.RecordDeleted,'N')='N'
			where sld.StaffId = s.StaffId
			and DCLS.DocumentCodeId = @DocumentCodeId  AND ISNULL(SLD.RecordDeleted,'N')='N'
                and (
                     SLD.StartDate is null
                     or @EffectiveDate >= SLD.StartDate
                    )
                and (
                     SLD.EndDate is null
                     or @EffectiveDate < DATEADD(DD, 1, SLD.EndDate)
                    )
		)
        order by StaffName
   
         
    end try  
    begin catch  
        declare @Error varchar(8000)                                                                                                                                  
        set @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
            + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
                     'ssp_SCCheckStaffDegreeForDocumentCodeSignature') + '*****'
            + CONVERT(varchar, ERROR_LINE()) + '*****'
            + CONVERT(varchar, ERROR_SEVERITY()) + '*****'
            + CONVERT(varchar, ERROR_STATE())                                                                                                                 
        raiserror                                                                          
   (                                                                            
    @Error, -- Message text.                                                                                                
    16, -- Severity.                     
    1 -- State.                                                            
   ) ;   
    end catch  
end  

go
