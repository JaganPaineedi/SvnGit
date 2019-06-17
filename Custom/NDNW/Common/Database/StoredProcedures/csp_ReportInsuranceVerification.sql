IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportInsuranceVerification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportInsuranceVerification] 
GO
create PROCEDURE csp_ReportInsuranceVerification
@StaffId INT,
@ProgramId INT,
@StartDate DATETIME,
@EndDate datetime
as
create TABLE #Results
    (
      ClientName VARCHAR(200) ,
      DOB DATETIME ,
      SSN VARCHAR(200) ,
      ProcedureCodeName VARCHAR(200) ,
      ServiceDate date ,
      ServiceTime Datetime,
      StaffName VARCHAR(200) ,
      PrimaryInsurance VARCHAR(250) ,
      PrimaryInsuredId VARCHAR(50) ,
      SecondaryInsurance VARCHAR(250) ,
      SecondaryInsuranceId VARCHAR(50) ,
      TertiaryInsurace VARCHAR(250) ,
      TertiaryInsuredId VARCHAR(50) ,
      PrimaryClinicianName VARCHAR(200),
      ProgramName VARCHAR(250)
    )

INSERT  INTO #Results
        ( ClientName ,
          DOB ,
          SSN ,
          ProcedureCodeName ,
          ServiceDate ,
          ServiceTime,
          StaffName ,
          PrimaryInsurance ,
          PrimaryInsuredId ,
          SecondaryInsurance ,
          SecondaryInsuranceId ,
          TertiaryInsurace ,
          TertiaryInsuredId ,
          PrimaryClinicianName ,
          ProgramName
        )
   SELECT DISTINCT c.LastName + ', ' + c.FirstName AS ClientName ,
                CAST(c.DOB AS DATE) AS DOB ,
                c.SSN AS SSN ,
                pc.DisplayAS AS ProcedureCodeName ,
                CAST(s.DateOfService AS DATE) AS ServiceDate ,
                s.DateOfService AS ServiceTime,
                st.DisplayAs AS StaffName ,
                cp1.DisplayAs AS PrimaryInsurance ,
                ccp1.InsuredId AS PrimaryInsuredId ,
                cp2.DisplayAs AS SecondaryInsurance ,
                ccp2.InsuredId AS SecondaryInsuranceId ,
                cp3.DisplayAs AS TertiaryInsurace ,
                ccp3.InsuredId AS TertiaryInsuredId ,
                stc.DisplayAs AS PrimaryClinicianName,
                p.ProgramCode AS ProgramName
                
        FROM    dbo.[Services] AS s
                INNER JOIN Staff AS st ON s.ClinicianId = st.StaffId
                                          AND ISNULL(st.RecordDeleted, 'N') = 'N'
                INNER JOIN dbo.ProcedureCodes AS pc ON s.ProcedureCodeId = pc.ProcedureCodeId
                                                       AND ISNULL(pc.RecordDeleted,
                                                              'N') = 'N'
	   --Primary Insurance
                INNER JOIN dbo.ClientCoveragePlans AS ccp1 ON s.ClientId = ccp1.ClientId
                                                              AND ISNULL(ccp1.RecordDeleted,
                                                              'N') = 'N'
                INNER JOIN dbo.ClientCoverageHistory AS cch1 ON ccp1.ClientCoveragePlanId = cch1.ClientCoveragePlanId
                                                              AND cch1.COBOrder = 1
                                                              AND ISNULL(cch1.RecordDeleted,
                                                              'N') = 'N'
                INNER JOIN dbo.CoveragePlans AS cp1 ON ccp1.CoveragePlanId = cp1.CoveragePlanId
                                                       AND ISNULL(cp1.RecordDeleted,
                                                              'N') = 'N'
	   --Secondary Insurance
                LEFT JOIN dbo.ClientCoveragePlans AS ccp2 ON s.ClientId = ccp2.ClientId
                                                             AND ISNULL(ccp2.RecordDeleted,
                                                              'N') = 'N'
                                                             AND EXISTS ( SELECT
                                                              *
                                                              FROM
                                                              dbo.ClientCoverageHistory
                                                              AS cch2
                                                              WHERE
                                                              ccp2.ClientCoveragePlanId = cch2.ClientCoveragePlanId
                                                              AND cch2.COBOrder = 2
                                                              AND ISNULL(cch2.RecordDeleted,
                                                              'N') = 'N' )
                LEFT JOIN dbo.CoveragePlans AS cp2 ON ccp2.CoveragePlanId = cp2.CoveragePlanId
                                                      AND ISNULL(cp2.RecordDeleted,
                                                              'N') = 'N'
	   --Tertiary Insurance
                LEFT JOIN dbo.ClientCoveragePlans AS ccp3 ON s.ClientId = ccp3.ClientId
                                                             AND ISNULL(ccp3.RecordDeleted,
                                                              'N') = 'N'
                                                             AND EXISTS ( SELECT
                                                              *
                                                              FROM
                                                              dbo.ClientCoverageHistory
                                                              AS cch3
                                                              WHERE
                                                              ccp3.ClientCoveragePlanId = cch3.ClientCoveragePlanId
                                                              AND cch3.COBOrder = 3
                                                              AND ISNULL(cch3.RecordDeleted,
                                                              'N') = 'N' )
                LEFT JOIN dbo.CoveragePlans AS cp3 ON ccp3.CoveragePlanId = cp3.CoveragePlanId
                                                      AND ISNULL(cp3.RecordDeleted,
                                                              'N') = 'N'
	   --PrimaryClinicianName
                INNER  JOIN dbo.Clients c ON c.clientId = s.ClientId
                                             AND ISNULL(c.RecordDeleted, 'N') = 'N'
                INNER JOIN dbo.Staff AS stc ON c.PrimaryClinicianId = stc.StaffId
                                               AND ISNULL(stc.RecordDeleted,
                                                          'N') = 'N'
                INNER JOIN dbo.Programs AS p ON s.ProgramId = p.ProgramId
                AND ISNULL(p.RecordDeleted,'N') = 'N'     
                WHERE (s.ClinicianId = @StaffId
				    OR @StaffId = -1
				    )
				   AND (s.ProgramId = @ProgramId
					   OR @ProgramId = -1
					   )
					   
				AND DATEDIFF(DAY,s.DateOfService,@StartDate) <=0
				AND DATEDIFF(DAY,s.DateOfService,@EndDate) >=0
				AND ISNULL(s.RecordDeleted, 'N') = 'N'
				AND s.[Status] <> 76 --error status
				    

SELECT  ClientName ,
        DOB ,
        SSN ,
        ProcedureCodeName ,
        ServiceDate ,
        ServiceTime,
        StaffName ,
        PrimaryInsurance ,
        PrimaryInsuredId ,
        SecondaryInsurance ,
        SecondaryInsuranceId ,
        TertiaryInsurace ,
        TertiaryInsuredId ,
        PrimaryClinicianName,
        ProgramName
FROM    #Results
ORDER BY ServiceDate, ProgramName

GO