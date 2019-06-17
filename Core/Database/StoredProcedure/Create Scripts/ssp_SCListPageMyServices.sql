
/****** Object:  StoredProcedure [dbo].[ssp_SCListPageMyServices]    Script Date: 04/18/2013 16:17:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageMyServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageMyServices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageMyServices]    Script Date: 04/18/2013 16:17:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[ssp_SCListPageMyServices]
@SessionId varchar(30),
@InstanceId int,
@PageNumber int,
@PageSize int,
@SortExpression varchar(100),
@varStaffId int,
@DOSFrom datetime = null,
@DOSTo datetime = null,
@ClientFilter int,  -- 0 (All Clients) - default, 1 (only clients where staffId is primaryClinicianId), 2 (only clients where staffId is not primaryClinicianId)
@StatusFilter int,
@ProcedureFilter int,
@DateFilter int,
@ProgramFilter int,
@ServiceFilter int ,
@OtherFilter int ,
@LoggedInStaffId int,
@AddOnCodes char(1)='N' 
/********************************************************************************
-- Stored Procedure: dbo.ssp_SCListPageMyServices
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: used by MyServices list page
--
-- Updates:
-- Date        Author            Purpose
-- 01.21.2010  Sweety Kamboj     Created.
-- Modified By Damanpreet Kaur 07.17.2010 as per Filters Problem modify the Services Filter
-- Modified By Mahesh S         Set null as NumberOfTimesCancelled in place of '' as NumberOfTimesCancelled as '' take 0 as default                         -- 23 May 12   Sudhir Singh       get the services having signed document for status filter value

187
--14Aug2012  Shifali   show status of service signed if service.status = show and document.status = sign (Task# 1799, project Thresholds Buges/Feature)
--29Aug2012  Vikas     Added Filter condition documentstatus<>22 In Status Filter 186 w.r.t. Task#1866 (Threshold phase III Buges)
--31Aug2012	 Shifali	Modified - When Filter = "signed" (187), then show services where status = 71 and not is signed (Discussion with SHS - task# 1866 (Thresholds Bugs/Features)
--28Dec2012	 Maninder	   Added Groups.RecordDeleted and GroupServices.RecordDeleted check
--18Jan2013	 Maninder	   Added Logic for opening of service list page from dashboard documents widget
--28Feb2013	 Rahul Aneja   Added GroupId and GroupServiceId ref task#2808 in Thresholds Bugs and Features ,why:when sorting the list page Data GroupId and GroupServiceId is not returning
-- 2013.12.02 - T.Remisoski - Removed @ServiceFilter from IF condition and set @CustomFiltersApplied when the scsp is executed
-- 28Jan2014 Gautam     Removed the ListPagePMMoveServiceDocuments and implemented temporary table Why :  task#1364 - Corebugs 
--14Dec2015  Akwinass   What: Since attendance services are not connected with documents, ISNULL condition Implemented for the column 'CurrentVersionStatus' of Documents table.
						Why: Service that are on the attendance list page are not showing on the my services list page. (Task #152 in Valley - Support Go Live)
--17-DEC-2015  Basudev Sahu Modified For Task #609 Network180 Customization to  Get Organisation  As ClientName	
--22.Mar.2016  Gautam      Changed code to see those services that are in a Program that is associated to the Staff Account using sys key ShowAllClientsServices
								Why : Engineering Improvement Initiatives- NBL(I) > Tasks#297 
--12-Dec-2016  	Gautam		Modified code to display Units ,Keystone - Customizations #43 	
--02/10/2017    jcarlson    Keystone Customizations 69 - increased procedurecodename length to 155 to handle procedure code display as increasing to 75										
--21.Feb.2017   Alok Kumar	Added a new filter 'Add On Codes' and a new column to the List page. 
								Why : Harbor - Support	Task #1003. 
--06-July-2017	Gautam		Modified code for Performance issue.,Thresholds - Support, Task#991
--24-NOV-2017   Akwinass    Added "Attachments" column (Task #589 in Engineering Improvement Initiatives- NBL(I))								
--17-Jan-2019    Vkumar     What: Removed the case statement check for Displayas column and showing full character of Displayas column as per the task requiement of ViaQuest-SGL#31
*********************************************************************************/
as
  BEGIN               
    BEGIN try 
    
CREATE TABLE #ResultSet(       
	ClientId  int,    
	ClientName  varchar(100),    
	AuthorizationsRequested char(3),    
	DateOfService datetime,    
	ServiceId  int,    
	[DocumentId] int,    
	[ProcedureCodeName] varchar(155),    
	--ProgramName varchar(100),    
	ProgramName varchar(100),    
	[Status]    varchar(50),    
	GroupName  varchar(100),    
	Comment    ntext,    
	NumberOfTimesCancelled int,    
	ErrorMessage varchar(max),    
	GroupId int,    
	GroupServiceId int,    
	ScreenId int,    
	ResourceNameDisplayAs varchar(100),
	Units DECIMAL(18,2),
	AddOnCodes VARCHAR(Max),
	ProcedureCodeId Int,
	Attachments INT    
)  
     

    CREATE TABLE #customfilters               
      (               
         ServiceId INT NOT NULL               
      )   
	DECLARE @ApplyFilterClicked CHAR(1)               
	DECLARE @CustomFilterApplied CHAR(1)
	DECLARE @Today datetime 
	 
	SET @ApplyFilterClicked= 'Y'               
    SET @CustomFilterApplied= 'N' 
    SET @Today = convert(char(10), getdate(), 101)
        
 -- 22.Mar.2016     Gautam   
   DECLARE @ShowAllClientsServices CHAR(1)   
   Create Table #StaffPrograms
   (ProgramId int) 
   
	SELECT @ShowAllClientsServices= dbo.ssf_GetSystemConfigurationKeyValue('ShowAllClientsServices')
	IF ISNULL(@ShowAllClientsServices,'Y')='N' 
		BEGIN
			IF exists ( select 1 from   ViewStaffPermissions  where  StaffId = @LoggedInStaffId  and PermissionTemplateType = 5705  
							  and PermissionItemId = 5744 ) --5744 (Clinician in Program Which Shares Clients) 5741(All clients)
				and not exists ( select 1 from   ViewStaffPermissions  where  StaffId = @LoggedInStaffId  and PermissionTemplateType = 5705  
							  and PermissionItemId = 5741)								  
			BEGIN                          
				Insert into #StaffPrograms
				Select ProgramId From StaffPrograms Where StaffId=@LoggedInStaffId  AND ISNULL(RecordDeleted, 'N') <> 'Y'
			END
			ELSE
			BEGIN
				SET @ShowAllClientsServices='Y'
			END
		END    
	ELSE
		BEGIN
			SET @ShowAllClientsServices='Y'
		END
	-- End -- 22.Mar.2016     Gautam  
			        
-- 2013.12.02 - T.Remisoski - Removed @ServiceFilter from IF condition
IF (@ClientFilter>10000 or @StatusFilter>10000 or @ProcedureFilter>10000 or @DateFilter>10000 or @ProgramFilter>10000 or @OtherFilter>10000)
BEGIN

	EXEC scsp_SCListPageMyServices @varStaffId, @DOSFrom, @DOSTo, @ClientFilter, @StatusFilter, @ProcedureFilter, @DateFilter, @ProgramFilter, @ServiceFilter, @OtherFilter, @LoggedInStaffId

	-- 2013.12.02 - T.Remisoski - Always set @CustomFiltersApplied to 'Y' if the scsp is executed.
	SET @CustomFilterApplied = 'Y'
END

IF @CustomFilterApplied='N'
Begin
	with ListMyServices
		AS
		(
		select
		C.ClientID ,
		CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '')+', '+ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END AS ClientName,
		--convert(varchar(50),rtrim(C.Lastname)) +', '+ convert(varchar(50),rtrim(C.Firstname)) as ClientName ,
		--case
		--when S.AuthorizationsRequested like 'N' then 'NO'
		--when S.AuthorizationsRequested like 'Y' then 'Yes'
		--when S.AuthorizationsRequested is Null then ''
		--end
		--as AuthorizationsRequested,
		case when isnull(S.AuthorizationsNeeded, 0) = 0 then ' '
		when isnull(S.AuthorizationsNeeded, 0)=isnull(S.AuthorizationsApproved, 0) then 'Yes'
		when isnull(S.AuthorizationsNeeded, 0)<> isnull(S.AuthorizationsApproved, 0) and isnull(S.AuthorizationsRequested, 0) >0 then 'Req'
		when isnull(S.AuthorizationsNeeded, 0)<> isnull(S.AuthorizationsApproved, 0)and isnull(S.AuthorizationsRequested, 0) =0 then 'No'
		end
		as AuthorizationsRequested,
		S.DateOfService as DateOfService,
		S.ServiceId,
		convert(int,D.DocumentId) as [DocumentId],
		Rtrim(PC.DisplayAs)
		 +
		Case When PC.AllowDecimals='Y' then ' '+CAST(isnull(S.Unit,'') AS VARCHAR(10))+' '+SUBSTRING(isnull(GC1.CodeName,''),0,4)
		 else ' '+Cast(CAST(isnull(S.Unit,'') AS Decimal) as Varchar(10)) +' '+SUBSTRING(isnull(GC1.CodeName,''),0,4)
		end as ProcedureCodeName,
		isnull(P.ProgramName,'') as ProgramName,
		/*isnull(GC.CodeName,'') + rtrim(isnull( ' ('+rtrim(Glo.CodeName)+ ')','')) as [Status],*/
		/*CASE WHEN S.GroupServiceId IS NULL
		 THEN */
		 CASE WHEN D.CurrentVersionStatus = 22 AND S.Status = 71 THEN GCD.CodeName ELSE GC.CodeName END  -- If d.Status=Signed and S.Status=Show
		 /*ELSE dbo.SCGetGroupServiceStatusName(S.GroupServiceId)
		END*/
		 AS Status,
		IsNull(Groups.GroupName,'') as 'GroupName',
		isnull(S.Comment,'') as Comment, null as NumberOfTimesCancelled, --Old syntax is '' as NumberOfTimesCancelled  so it will take 0 as default
		dbo.getServiceErrors(s.ServiceId) as 'ErrorMessage',
		GroupServices.GroupId,
		GroupServices.GroupServiceId,
		Scr.ScreenId,
		'' as ResourceNameDisplayAs,
		S.ProcedureCodeId
		from Services S
		join Clients C on S.ClientId=C.ClientId
		 join StaffClients sc on sc.StaffId = @LoggedInStaffId and sc.ClientId = c.ClientId
		join ProcedureCodes PC on S.ProcedureCodeId=PC.ProcedureCodeId
		join Programs P on P.ProgramId=S.ProgramId
		left join Documents D on D.ServiceId = S.ServiceId  and isNull(D.RecordDeleted,'N')<>'Y'
		left outer join GroupServices on S.GroupServiceId=GroupServices.GroupServiceId
		left outer join Groups ON GroupServices.GroupId=Groups.GroupId
		left join DocumentCodes DC on D.DocumentCodeID = Dc.DocumentCodeID and DC.DocumentCodeID  in (select DocumentCodeId from  DocumentCodes where ServiceNote = 'Y')
		left join Screens Scr on Dc.DocumentCodeID=Scr.DocumentCodeId	
		left join GlobalCodes GC on (GC.GlobalCodeId=S.Status and GC.Category ='SERVICESTATUS')
		left join GlobalCodes GLo on (GLo.GlobalCodeID = S.CancelReason and GLo.Category ='CancelReason')
		left join GlobalCodes GC1 on (GC1.GlobalCodeId = S.UnitType and GC1.Category Like 'UNITTYPE')
		LEFT JOIN GlobalCodes GCD ON GCD.GlobalCodeId = D.CurrentVersionStatus
		where S.ClinicianId = @varStaffId
		 -- 22.Mar.2016     Gautam  
	    and ( @ShowAllClientsServices='Y' Or ( @ShowAllClientsServices='N' and 
							EXISTS ( SELECT *
                                             FROM   #StaffPrograms SP
                                             WHERE  SP.ProgramId = S.ProgramId )))
        -- end
        
        --13.Feb.2017     Alok Kumar 
	    AND ( @AddOnCodes='N' Or ( @AddOnCodes='Y' and				
								EXISTS ( SELECT 1 FROM   ServiceAddOnCodes ACS
                                                 WHERE  ACS.ServiceId = S.ServiceId AND ISNULL(ACS.RecordDeleted, 'N') = 'N' )))			--15.Mar.2017     Alok Kumar
        -- end
        
		and isNull(S.RecordDeleted,'N')<>'Y'
		and isNull(C.RecordDeleted,'N')<>'Y'
		and isnull(Groups.RecordDeleted,'N')<>'Y'       -- Added by Maninder: don't show deleted groups services
		and isnull(GroupServices.RecordDeleted,'N')<>'Y' -- Added by Maninder: don't show deleted groups services
		and (S.ProgramId=@ProgramFilter or (isnull(@ProgramFilter, -1) = -1) )-- -1 For All Programs
		and (S.ProcedureCodeId=@ProcedureFilter or (isnull(@ProcedureFilter, 0) = 0))-- 0 For All ProcedureCode
		and (@DOSFrom is null or S.DateOfService >= @DOSFrom)
		and (@DOSTo is null or S.DateOfService < dateadd(dd, 1, @DOSTo))

		--Services Filter
		--Modified by Damanpreet Kaur
		and((@ServiceFilter = -1 and
		exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId  and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,'N')='N' and s.status not in (75, 72, 73, 76))
		)
		or  @ServiceFilter = 0
		--or (@ServiceFilter = 216 and exists (select ServiceId from ServiceErrors SE where S.ServiceId = SE.ServiceId and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,'N')='N' and s.status not in (75, 72, 73, 76)
		--)
		--)
		or  exists (select * from ServiceErrors SE where S.ServiceId = SE.ServiceId and SE.ErrorType = @ServiceFilter and s.ClinicianId=@varStaffId and isnull(s.RecordDeleted,'N')='N' and s.status not in (75, 72, 73, 76))
		)
		
		-------------StatusFilter
		and (
		 @StatusFilter = 0 or -- All Statuses
		 @StatusFilter = 184 or -- All Statuses
		(@StatusFilter = 185 and S.Status = 70) or -- Sheduled
		--14Dec2015 -- Akwinass -- ISNULL condition Implemented. 
		(@StatusFilter = 186 and S.Status in(70,71) AND ISNULL(D.CurrentVersionStatus,0) <> 22) or -- show and sheduled
		(@StatusFilter = 188 and S.Status in(72,73)) or -- Cancel or not show
		(@StatusFilter = 189 and S.Status = 75) or -- Complete
		 (@StatusFilter = 187 and S.Status in (71) and D.CurrentVersionStatus = 22)  -- signed document --added by sudhir singh
			)
		 ------------ClientFilter
		  and(
		   @ClientFilter=0 or ---All Client
		   @ClientFilter=98 or ---All Client
		  (@ClientFilter =99 and C.PrimaryClinicianId=@varStaffId ) or -- primary clients
		  (@ClientFilter=100 and C.PrimaryClinicianId <> @varStaffId )-- no primary
		  )
		)
		insert into #ResultSet(    
				ClientId,    
				ClientName,    
				AuthorizationsRequested,    
				DateOfService,    
				ServiceId,    
				[DocumentId],    
				[ProcedureCodeName],    
				ProgramName,    
				[Status],    
				GroupName,    
				Comment,-- as Comment    
				NumberOfTimesCancelled,    
				ErrorMessage,    
				GroupId,    
				GroupServiceId,    
				ScreenId,    
				ResourceNameDisplayAs,
				Units,
				AddOnCodes,		--13.Feb.2017     Alok Kumar
				ProcedureCodeId
			 )       
		Select L.ClientId,L.ClientName,L.AuthorizationsRequested,L.DateOfService,L.ServiceId,L.DocumentId,L.ProcedureCodeName,
				L.ProgramName,L.[Status], L.GroupName,L.Comment,L.NumberOfTimesCancelled,L.ErrorMessage,L.GroupId,    
				L.GroupServiceId,L.ScreenId, L.ResourceNameDisplayAs, ch2.Units, 
				NULL AS AddOnCodes,		--13.Feb.2017     Alok Kumar 
				L.ProcedureCodeId 
		From ListMyServices L LEFT JOIN ---12-Dec-2016  	Gautam 
				  (Select ServiceId,ChargeId,Units from 
                 (Select Ch.ServiceId,Ch.ChargeId,Ch.Units, row_number() over(partition by Ch.ServiceId order by Ch.ChargeId Asc) as RNK  
				  From Charges Ch Join ListMyServices d ON Ch.ServiceId = d.ServiceId 
							and Ch.Priority <= 1 
				  Where isnull(Ch.RecordDeleted, 'N') = 'N'  )Ch1 
				  where RNK=1 ) ch2  on L.ServiceId = Ch2.ServiceId      

End


			--13.Feb.2017     Alok Kumar	
			--06-July-2017	Gautam	
			UPDATE  C 
			SET C.AddOnCodes = isnull(REPLACE(REPLACE(STUFF((
								SELECT DISTINCT ', ' +  PC.ProcedureCodeName FROM ProcedureCodes PC
								Join ServiceAddOnCodes SOC on PC.ProcedureCodeId= SOC.AddOnProcedureCodeId
								where SOC.ServiceId = C.ServiceId AND ISNULL(SOC.RecordDeleted, 'N') ='N'
								FOR XML PATH('')
								), 1, 1, ''), '&lt;', '<'), '&gt;', '>'), '')
			FROM    #ResultSet C join ServiceAddOnCodes SOC1 
							   on SOC1.ServiceId = C.ServiceId AND ISNULL(SOC1.RecordDeleted, 'N') = 'N'
			
			UPDATE C
			SET C.Attachments = (SELECT COUNT(ImageRecordId) FROM ImageRecords IR WHERE IR.ServiceId = C.ServiceId AND ISNULL(IR.RecordDeleted, 'N') = 'N')
			FROM #ResultSet C
			JOIN ProcedureCodes PC ON C.ProcedureCodeId = PC.ProcedureCodeId
				AND ISNULL(PC.AllowAttachmentsToService, 'N') = 'Y'
			--( SELECT DISTINCT ISNULL(STUFF((SELECT ', ' + 
			--				ISNULL((SELECT TOP 1 ProcedureCodeName FROM ProcedureCodes WHERE ProcedureCodeId= SOC.AddOnProcedureCodeId
			--							AND ISNULL(RecordDeleted, 'N') <> 'Y' AND ISNULL(Active, 'N') = 'Y'), '')	
			--				   FROM ServiceAddOnCodes SOC 
			--				   WHERE SOC.ServiceId = C.ServiceId AND ISNULL(SOC.RecordDeleted, 'N') <> 'Y'
			--				   FOR XML PATH(''),type ).value('.', 'nvarchar(max)'), 1, 2, ' '), ''))
			--FROM    #ResultSet C join ServiceAddOnCodes SOC1 
			--				   on SOC1.ServiceId = C.ServiceId AND ISNULL(SOC1.RecordDeleted, 'N') = 'N'
			--End Alok Kumar
			
			
		;With counts               
             AS (SELECT Count(*) AS TotalRows               
                 FROM   #ResultSet),
                   RankResultSet               
             AS (SELECT
				ClientId,
				ClientName,
				AuthorizationsRequested,
				DateOfService,
				ServiceId,
				[DocumentId],
				[ProcedureCodeName],
				ProgramName,
				[Status],
				GroupName,
				Comment,-- as Comment
				NumberOfTimesCancelled,
				ErrorMessage ,
				GroupId,     -- added by Rahul Aneja ref task#2808 in Threshold Bugs and Features
				GroupServiceId,     -- added by Rahul Aneja ref task#2808 in Threshold Bugs and Features
				ScreenId,
				'' as ResourceNameDisplayAs, 
				Units,
				AddOnCodes,				--13.Feb.2017     Alok Kumar
				Attachments,
               Count(*)               
                          OVER ( ) AS               
                        TotalCount,               
                        Rank() over(order by case when @SortExpression= 'ClientId' then ClientId end,
                                                case when @SortExpression= 'ClientId desc' then ClientId end desc,
                                                case when @SortExpression= 'AuthorizationsRequested' then AuthorizationsRequested end,
                                                case when @SortExpression= 'AuthorizationsRequested desc' then AuthorizationsRequested end desc,
												case when @SortExpression= 'ClientName' then ClientName end,
												case when @SortExpression= 'ClientName desc' then ClientName end desc,
                                                case when @SortExpression= 'DateOfService' then DateOfService end,
                                                case when @SortExpression= 'DateOfService desc' Then DateOfService end desc,
                                                case when @SortExpression= 'ProcedureCodeName' then [ProcedureCodeName] end,
                                                case when @SortExpression= 'ProcedureCodeName desc' then [ProcedureCodeName] end desc,
                                                case when @SortExpression= 'ProgramName' then ProgramName end,
                                                case when @SortExpression= 'ProgramName desc' then ProgramName end desc,
                                                case when @SortExpression= 'Status' then Status end,
                                                case when @SortExpression= 'Status desc' then Status end desc,
                                                case when @SortExpression= 'GroupName' then GroupName end,
                                                case when @SortExpression= 'GroupName desc' then GroupName end desc,
                                                case when @SortExpression= 'Comment' then cast(Comment as varchar(500)) end,
                                                case when @SortExpression= 'Comment desc' then cast(Comment as varchar(500)) end desc,
                                                case when @SortExpression= 'NumberOfTimesCancelled' then NumberOfTimesCancelled end,
                                                case when @SortExpression= 'NumberOfTimesCancelled desc' then NumberOfTimesCancelled end desc,
                                                case when @SortExpression= 'ErrorMessage' then ErrorMessage end,
                                       case when @SortExpression= 'ErrorMessage desc' then ErrorMessage end desc,
                                       case when @SortExpression= 'ResourceNameDisplayAs' then ResourceNameDisplayAs end,
                                                case when @SortExpression= 'ResourceNameDisplayAs desc' then ResourceNameDisplayAs end desc ,--) as  RowNumber ,          
												case when @SortExpression= 'Units' then Units end, 
												case when @SortExpression= 'Units desc' then Units end desc ,--ServiceId ) as  RowNumber     
												case when @SortExpression= 'AddOnCodes' then AddOnCodes end,										--13.Feb.2017     Alok Kumar
												case when @SortExpression= 'AddOnCodes desc' then AddOnCodes end desc, 
												case when @SortExpression= 'Attachments' then Attachments end,
												case when @SortExpression= 'Attachments desc' then Attachments end desc ,ServiceId ) as  RowNumber 
                 FROM   #ResultSet   
             )


SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows,               
        0)               
        FROM Counts)               
        ELSE (@PageSize) END)
		ClientId,
		ClientName,
		AuthorizationsRequested,
		DateOfService,
		RankResultSet.ServiceId,
		[DocumentId],
		[ProcedureCodeName],
		ProgramName,
		[Status],
		GroupName,
		Comment,-- as Comment
		NumberOfTimesCancelled,
		ErrorMessage,
		GroupId,
		GroupServiceId,		
		ScreenId,   
		totalcount,             
		rownumber,
		ISnull(ResourceWithService.DisplayAs,'') as ResourceNameDisplayAs,
		Units,
		AddOnCodes,           --13.Feb.2017     Alok Kumar 
		Attachments  
        INTO   #FinalResultSet               
        from RankResultSet  Left Outer Join (Select AppointmentResourceList.ServiceId,AppointmentResourceList.DisplayAs From
         ( Select AM.AppointmentMasterId,AM.ServiceId,RES.DisplayAs,
           ROW_NUMBER()OVER(PARTITION BY AM.AppointmentMasterId  ORDER BY RES.DisplayAs ASC ) AS RowCountNo
           From RankResultSet RS Inner Join AppointmentMaster AM ON RS.ServiceId=AM.ServiceId
              Inner Join AppointmentMasterResources AMR On  AMR.AppointmentMasterId=AM.AppointmentMasterId
              Inner Join Resources RES on RES.ResourceId=AMR.ResourceId
              Where isNull(AM.RecordDeleted,'N')<>'Y'
              And isNull(AMR.RecordDeleted,'N')<>'Y'
              And isNull(RES.RecordDeleted,'N')<>'Y'
              ) AppointmentResourceList  Where AppointmentResourceList.RowCountNo=1
         ) ResourceWithService on RankResultSet.ServiceId=ResourceWithService.ServiceId                  
        WHERE  rownumber > ( ( @PageNumber - 1 ) * @PageSize )
        
         IF (SELECT Isnull(Count(*), 0)               
            FROM   #FinalResultSet) < 1               
          BEGIN               
              SELECT 0 AS PageNumber,               
                     0 AS NumberOfPages,               
                     0 NumberOfRows               
          END               
        ELSE               
          BEGIN               
              SELECT TOP 1 @PageNumber           AS PageNumber,               
                           CASE ( totalcount % @PageSize )               
                             WHEN 0 THEN Isnull(( totalcount / @PageSize ), 0)               
                             ELSE Isnull(( totalcount / @PageSize ), 0) + 1               
                           END           AS NumberOfPages,               
                           Isnull(totalcount, 0) AS NumberOfRows               
        FROM   #FinalResultSet               
          END               

		select
			ClientId,
			ClientName,
			AuthorizationsRequested,
			DateOfService,
			ServiceId,
			[DocumentId],
			[ProcedureCodeName],
			ProgramName,
			[Status],
			GroupName,
			Comment,-- as Comment
			NumberOfTimesCancelled,
			ErrorMessage,
			GroupId,
			GroupServiceId,
			ScreenId,
			ResourceNameDisplayAs,
			Units,
			AddOnCodes,					--13.Feb.2017     Alok Kumar
			Attachments
			FROM   #FinalResultSet               
            ORDER  BY rownumber     
	 END try            
              
    BEGIN catch               
        DECLARE @Error VARCHAR(8000)               
              
        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****'               
                    + CONVERT(VARCHAR(4000), Error_message())               
                    + '*****'               
                    + Isnull(CONVERT(VARCHAR, Error_procedure()),               
                    'ssp_SCListPageMyServices' )               
                    + '*****' + CONVERT(VARCHAR, Error_line())               
                    + '*****' + CONVERT(VARCHAR, Error_severity())               
                    + '*****' + CONVERT(VARCHAR, Error_state())               
              
        RAISERROR ( @Error,-- Message text.                                           
                    16,-- Severity.                                           
                    1 -- State.                                           
        );               
    END catch          		         
End