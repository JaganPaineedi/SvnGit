/****** Object:  StoredProcedure [dbo].[Ssp_listpagenonstaffusers]    Script Date: 05/15/2014 15:51:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ssp_listpagenonstaffusers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Ssp_listpagenonstaffusers]
GO

/****** Object:  StoredProcedure [dbo].[Ssp_listpagenonstaffusers]    Script Date: 05/15/2014 15:51:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROCEDURE [dbo].[Ssp_listpagenonstaffusers]     
  @SessionId       VARCHAR(30),     
  @InstanceId      INT,     
  @PageNumber      INT,     
  @PageSize        INT,     
  @SortExpression  VARCHAR(100),     
  @staffNameFilter VARCHAR(100),                
  @StatusFilter    INT,     
  @ProgramFilter   INT,     
  @RoleFilter      INT,     
  @OtherFilter     INT     
/********************************************************************************                                              
-- Stored Procedure: dbo.Ssp_listpagenonstaffusers                                                 
-- Copyright: Streamline Healthcate Solutions                                               
-- Purpose: used by Staff Users list page                                               
-- Updates:                                                                                                     
-- Date			Author			Purpose                                               
-- May 12 2014	Pradeep.A		Non Staff User Implementation for Patient Portal  
-- 16 Jun 2014	Pradeep A		What : Changed ClientId to TempClientId for releasing PPA. */
-- 16 Oct 2015	Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName. 
--  								why:task #609, Network180 Customization    */
/*********************************************************************************/     
AS     
  BEGIN     
      BEGIN try     
          DECLARE @Today DATETIME     
          DECLARE @ApplyFilterClicked CHAR(1)     
    
          SET @ApplyFilterClicked = 'Y'     
          SET @Today = CONVERT(CHAR(10), Getdate(), 101)     
    
          --CREATE TABLE #staffuser     
          --  (     
          --     cnt     INT,     
          --     staffid INT     
          --  )     
    
          --INSERT INTO #staffuser     
          --            (cnt,     
          --             staffid)     
          --(SELECT Count(C.clientid),     
          --        S.staffid     
          -- FROM   clients C     
          --        INNER JOIN staff S     
          --                ON S.staffid = C.primaryclinicianid     
          -- WHERE  C.active = 'Y'     
          --        AND Isnull(C.recorddeleted, 'N') = 'N'     
          --        AND Isnull(S.recorddeleted, 'N') = 'N'     
          -- GROUP  BY S.staffid)  
    
          ;WITH getlistpagestaffusers     
               AS (SELECT DISTINCT S.staffid,     
                                   S.lastname + ', ' + S.firstname AS StaffName,     
                      Isnull(S.usercode, '')          AS UserName,     
                                   Isnull(S.phonenumber, '')       AS     
                                   PhoneNumber,     
                                   Isnull(P.programcode, '')       AS     
                                   PrimaryProgramName,     
                                   Isnull(S.email, '')             AS Email,     
                                   Isnull(S.displayas, '')         AS DisplayAs,     
                                   --S.ClientId                          AS Caseload,
                                   --Added by Revathi  16 Oct 2015
				CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
					ELSE ISNULL(C.OrganizationName, '')
					END AS ClientName    
                   FROM   staff S     
                          LEFT OUTER JOIN programs P     
                                       ON S.primaryprogramid = P.programid     
                          --LEFT JOIN #staffuser C     
                          --       ON C.staffid = S.staffid   
                          LEFT JOIN Clients C ON C.ClientId =S.TempClientId  
                          LEFT OUTER JOIN staffroles SR     
                                       ON SR.staffid = S.staffid AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'    
                   WHERE  Isnull(S.recorddeleted, 'N') = 'N'  
        AND ISNULL(S. NonStaffUser,'N')='Y'   
        AND ISNULL(S.TempClientId,'') <> ''  
                          AND ( @StatusFilter = 0     
                                 OR --- for All                         
                                ( @StatusFilter = 400 )     
                                 OR ( @StatusFilter = 401     
                                      AND S.active = 'Y' )     
                                 OR ( @StatusFilter = 402     
                                      AND S.active = 'N' ) )     
                          AND ( ( S.lastname LIKE '%' + @staffNameFilter + '%' )     
                                 OR ( S.firstname LIKE '%' + @staffNameFilter +     
                                                       '%' )     
                                 OR ( S.usercode LIKE '%' + @staffNameFilter +     
                                                      '%'     
                                    ))     
                          AND ( @RoleFilter = 0     
                                 OR --- for All         
                                ( @RoleFilter > 0     
                                  AND ( SR.roleid = @RoleFilter)))     
   
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
                          --caseload,   
                          ClientName,  
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
                            'DisplayAs' THEN displayas END,CASE     
                            WHEN     
                            @SortExpression= 'ClientName' THEN ClientName END, CASE     
                            WHEN     
                            @SortExpression=     
                            'ClientName desc' THEN ClientName END DESC,
                             CASE WHEN     
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
                                  --caseload,    
                                  clientname, 
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
                 --caseload, 
                 clientname,    
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
                      'Ssp_listpagenonstaffusers')     
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
GO


