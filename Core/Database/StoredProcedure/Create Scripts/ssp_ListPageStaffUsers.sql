/****** Object:  StoredProcedure [ssp_ListPageStaffUsers]    Script Date: 03/07/2012 19:37:42 ******/
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[ssp_ListPageStaffUsers]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [ssp_ListPageStaffUsers] 

go 

/****** Object:  StoredProcedure [ssp_ListPageStaffUsers]    Script Date: 03/07/2012 19:37:42 ******/
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [Ssp_listpagestaffusers] 
  --'hjkzprrtd3ettkuuvbzv2455',4,0,40,'',10455,-1,10456,0                                                 
  @SessionId       VARCHAR(30), 
  @InstanceId      INT, 
  @PageNumber      INT, 
  @PageSize        INT, 
  @SortExpression  VARCHAR(100), 
  @staffNameFilter VARCHAR(100),--added by atul                
  @StatusFilter    INT, 
  @ProgramFilter   INT, 
  @RoleFilter      INT, 
  @OtherFilter     INT, 
  @InsurerId INT,	
  @ProviderId INT
/********************************************************************************                                          
-- Stored Procedure: dbo.ssp_ListPageStaffUsers                                             
-- Copyright: Streamline Healthcate Solutions                                           
-- Purpose: used by Staff Users list page                                           
-- Updates:                                                                                                 
-- Date        Author        Purpose                                           
-- 08.15.2009  Sweety Kamboj    Created.       
-- 07.03.2012  Ponnin Selvan    Redesigned for Performance Tunning.       
-- 12.03.2012  Ponnin Selvan    Removed default @PageNumber     
-- 4.04.2012  Ponnin Selvan    Conditions added for Export  
-- 12.04.2012  MSuma        removed #CustomFilters  
-- 13.04.2012   PSelvan        Added Conditions for NumberOfPages.  
-- 24.04.2012   Atul Pandey      Added new Parameter @staffNameFilter  For filter.                               
--17.10.2012  Sunil khunger    for RecodDeleted Check with StaffRole Table in Reference to  task #146 3.x issue  
--21 jan 2013  Saurav pande        Phone no will come form "PhoneNumber" column done w.r.t task #446 in  Centrawellness-Bugs/Features 
--1st Feb 2013  Sunilkh             Apply a search criteria for usercode w.r.t Primary care bugs/Features (234) --or( S.UserCode like '%'+@staffNameFilter+'%')  
--  June 12 2013  Chuck Blaine  Moved StaffRole.RecordDeleted check logic into same area where RoleFilter is applied
-- 12.13.2013   Manju P      Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes
-- DEC-4-2013   dharvey       Moved StaffRoles record delete check inside the LEFT JOIN to blank results
-- 05/22/2014	PradeepA	 Added NonStaffUser check to filter the Nonstaffuser from the Staff User list page.
-- 28-Feb-2017  Sachin       Added S.lastname + ', ' + S.firstname and S.displayas TO filter displayas wise Task #2348 Core Bugs. 

*********************************************************************************/ 
AS 
  BEGIN 
      BEGIN try 
          DECLARE @Today DATETIME 
          DECLARE @ApplyFilterClicked CHAR(1) 
          DECLARE @Insurers TABLE (
			StaffId INT
			,InsurerId INT
			,InsurerName VARCHAR(100)
			)
		DECLARE @Providers TABLE (
			StaffId INT
			,ProviderId INT
			,ProviderName VARCHAR(100)
			) 

          --                                                               
          -- New retrieve - the request came by clicking on the Apply Filter button                               
          --                                                               
          SET @ApplyFilterClicked = 'Y' 
          --set @PageNumber = 1                                                      
          SET @Today = CONVERT(CHAR(10), Getdate(), 101) 

          INSERT INTO @Insurers (
			StaffId
			,InsurerId
			,InsurerName
			)
		SELECT DISTINCT UI.StaffId
			,UI.InsurerID
			,I.InsurerName
		FROM StaffInsurers UI
		INNER JOIN Staff U ON U.StaffId = UI.StaffId
		INNER JOIN Insurers I ON I.InsurerId = UI.InsurerId
		WHERE isnull(U.RecordDeleted, 'N') = 'N'
		    --AND I.Active='Y'
			AND isnull(UI.RecordDeleted, 'N') = 'N'

		  
		INSERT INTO @Providers (
			StaffId
			,ProviderId
			,ProviderName
			)
		SELECT DISTINCT sp.StaffId
			,SP.ProviderId
			,P.ProviderName
		FROM staffproviders SP
		INNER JOIN Staff S ON S.StaffId = SP.StaffId
		INNER JOIN Providers P ON P.ProviderId = SP.ProviderId
		WHERE isnull(S.RecordDeleted, 'N') = 'N'
		    --AND P.Active='Y'
			AND isnull(SP.RecordDeleted, 'N') = 'N'
          CREATE TABLE #staffuser 
            ( 
               cnt     INT, 
               staffid INT 
            ) 

          INSERT INTO #staffuser 
                      (cnt, 
                       staffid) 
          (SELECT Count(C.clientid), 
                  S.staffid 
           FROM   clients C 
                  INNER JOIN staff S 
                          ON S.staffid = C.primaryclinicianid 
           WHERE  C.active = 'Y' 
                  AND Isnull(C.recorddeleted, 'N') = 'N' 
                  AND Isnull(S.recorddeleted, 'N') = 'N' 
           GROUP  BY S.staffid) 
          --ALTER TABLE #CustomFilters ADD  CONSTRAINT [CustomerFilters_PK] PRIMARY KEY CLUSTERED  
          --           ( 
          --           [StaffId] ASC 
          --           )  
          ; 

          WITH getlistpagestaffusers 
               AS (SELECT DISTINCT S.staffid, 
                                   S.lastname + ', ' + S.firstname AS StaffName, 
                                   Isnull(S.usercode, '')          AS UserName, 
                                   -- ISNULL(S.PhoneNumber, '')+ ' ' + S.OfficePhone1 + ' ' + S.OfficePhone2 AS PhoneNumber,                    
                                   --ISNULL(S.OfficePhone1, '') AS PhoneNumber,                      
                                   Isnull(S.phonenumber, '')       AS 
                                   PhoneNumber, 
                                   Isnull(P.programcode, '')       AS 
                                   PrimaryProgramName, 
                                   Isnull(S.email, '')             AS Email, 
                                   Isnull(S.displayas, '')         AS DisplayAs, 
                                   --S.Active,                     
                                   -- S.PrimaryRoleId,                     
                                   C.cnt                           AS Caseload 
                   FROM   staff S 
                                    LEFT JOIN @Insurers Ins ON S.StaffId = Ins.StaffId
			              LEFT JOIN @Providers Pr ON Pr.StaffId = Ins.StaffId
                          LEFT OUTER JOIN programs P 
                                       ON S.primaryprogramid = P.programid 
                          LEFT JOIN #staffuser C 
                                 ON C.staffid = S.staffid 
                          LEFT OUTER JOIN staffroles SR 
                                       ON SR.staffid = S.staffid AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'
                   WHERE  Isnull(S.recorddeleted, 'N') = 'N' 
						  AND ISNULL(S.NonStaffUser,'N')='N'      
                                  AND (
								@InsurerId = - 1
								OR --- for All                        
								(Ins.InsurerId = @InsurerId)
								)
							AND (
								@ProviderId = - 1
								OR --- for All                        
								(Pr.ProviderId = @ProviderId)
								)
                          AND ( @StatusFilter = 0 
                                 OR --- for All                     
                                ( @StatusFilter = 400 ) 
                                 OR ( @StatusFilter = 401 
                                      AND S.active = 'Y' ) 
                                 OR ( @StatusFilter = 402 
                                      AND S.active = 'N' ) ) 
                          --added by Atul pandey 
                          AND ( ( S.lastname LIKE '%' + @staffNameFilter + '%' ) 
                                 OR ( S.firstname LIKE '%' + @staffNameFilter +  '%' ) 
                                 OR ( S.usercode LIKE '%' + @staffNameFilter + '%' )
                                 OR ( S.lastname + ', ' + S.firstname LIKE '%' + @staffNameFilter + '%'  )  -- Added By Sachin  
                                 OR ( S.displayas LIKE '%' + @staffNameFilter + '%'  )        -- Added By Sachin  
                                  ) 
                          AND ( @RoleFilter = 0 
                                 OR --- for All     
                                ( @RoleFilter > 0 
                                  AND ( SR.roleid = @RoleFilter ) 
                                  --AND Isnull(SR.recorddeleted, 'N') <> 'Y' 
								  ) 
								  ) 
                          -- moved RecordDeleted check from where Staff.RecordDeleted is checked    
                          --( @RoleFilter = 403)or                     
                          --( @RoleFilter = 404 and SR.RoleId=4001) or  --- Access center              
                          --( @RoleFilter = 405 and SR.RoleId=4003) or  -- Clinician              
                          --( @RoleFilter = 406 and SR.RoleId=4002) or  -- Finanace              
                          --( @RoleFilter = 407 and SR.RoleId=4004) or  -- Receptionist                   
                          --( @RoleFilter = 408 and SR.RoleId=4005) or  -- Support                   
                          --( @RoleFilter = 409 and SR.RoleId=4006)     -- Utilization Manager    
                          -- (@RoleFilter=(select GlobalCodeId  from GlobalCodes where Category ='STAFFROLE' and GlobalCodeId= @RoleFilter))  
                          --(SR.RoleId=(select GlobalCodeId  from GlobalCodes where Category ='STAFFROLE' and GlobalCodeId= @RoleFilter)))  
                          AND ( @ProgramFilter = -1 
                                 OR --- for All                  
                                ( P.programid = @ProgramFilter ) )), 
               counts 
               AS (SELECT Count(*) AS totalrows 
                   FROM   getlistpagestaffusers), 
               rankresultset 
               AS (SELECT staffid, 
                          staffname, 
                          username, 
                          phonenumber, 
                          caseload, 
                          primaryprogramname, 
                          email, 
                          displayas, 
                          Count(*) 
                            OVER ( )                           AS TotalCount, 
                          Rank() 
                            OVER ( 
                              ORDER BY CASE WHEN @SortExpression= 'StaffName' 
                            THEN 
                            staffname 
                            END, 
                            CASE 
                            WHEN @SortExpression= 'StaffName desc' THEN 
                            staffname 
                            END 
                            DESC 
                            , 
                            CASE 
                            WHEN 
                            @SortExpression= 'UserName' THEN username END, CASE 
                            WHEN 
                            @SortExpression= 
                            'UserName desc' THEN username END DESC, CASE WHEN 
                            @SortExpression= 
                            'PhoneNumber' THEN phonenumber END, CASE WHEN 
                            @SortExpression= 
                            'PhoneNumber desc' THEN phonenumber END DESC, 
                            --case when @SortExpression= 'CaseLoad' then CaseLoad end,                                                        
                            --case when @SortExpression= 'CaseLoad desc' Then CaseLoad end desc,                                                     
                            CASE WHEN @SortExpression= 'PrimaryProgramName' THEN 
                            primaryprogramname END, 
                            CASE WHEN @SortExpression= 'PrimaryProgramName desc' 
                            THEN 
                            primaryprogramname 
                            END DESC, CASE WHEN @SortExpression= 'Email' THEN 
                            email 
                            END, 
                            CASE 
                            WHEN 
                            @SortExpression= 'Email desc' THEN email END DESC, 
                            CASE 
                            WHEN 
                            @SortExpression= 
                            'DisplayAs' THEN displayas END, CASE WHEN 
                            @SortExpression= 
                            'DisplayAs desc' 
                            THEN displayas END DESC, staffid ) AS RowNumber 
                   FROM   getlistpagestaffusers) 
          SELECT TOP ( CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull( 
          totalrows, 
          0) 
          FROM counts 
          ) ELSE (@PageSize) END) staffid, 
                                  staffname, 
                                  username, 
                                  phonenumber, 
                                  caseload, 
                                  primaryprogramname, 
                                  email, 
                                  displayas, 
                                  totalcount, 
                                  rownumber 
          INTO   #finalresultset 
          FROM   rankresultset 
          WHERE  rownumber > ( ( @PageNumber - 1 ) * @PageSize ) 

          IF (SELECT Isnull(Count(*), 0) 
              FROM   #finalresultset) < 1 
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
                             END                   AS NumberOfPages, 
                             Isnull(totalcount, 0) AS NumberOfRows 
                FROM   #finalresultset 
            END 

          SELECT staffid, 
                 staffname, 
                 username, 
                 phonenumber, 
                 caseload, 
                 primaryprogramname, 
                 email, 
                 displayas 
          FROM   #finalresultset 
          ORDER  BY rownumber 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_ListPageStaffUsers') 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                                        
                      16,-- Severity.                                      
                      1 
          -- State.                                                                                                        
          ); 
      END catch 
  END 

go 