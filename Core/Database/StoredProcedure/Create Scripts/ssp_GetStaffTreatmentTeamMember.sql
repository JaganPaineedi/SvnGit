IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffTreatmentTeamMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetStaffTreatmentTeamMember]
GO
/****** Object:  StoredProcedure [dbo].[ssp_GetStaffTreatmentTeamMember]    Script Date: 07-12-2016 15:58:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[ssp_GetStaffTreatmentTeamMember] 
@StaffId int
As
/*************************************************************************************************
  -- 17 May 2017  Bibhu            Removed Duplicated CellPhone  
                                   Task #239 AspenPointe-Environment Issue              
  *************************************************************************************************/  
Begin	
 BEGIN TRY
DECLARE @phoneText varchar(500)
DECLARE @addressText varchar(max)
DECLARE @TreatmentRole INT

SET @TreatmentRole=(SELECT TreatmentTeamRole FROM StaffPreferences WHERE ISNULL(RecordDeleted,'N')='N' AND StaffId=@StaffId)

Create table #StaffInfo
(
	PhoneNumber varchar(100)
	,OfficePhone1 varchar(100)
	,OfficePhone2 varchar(100)
	,CellPhone varchar(100)
	,HomePhone varchar(100)
	,PagerNumber varchar(100)
	,FaxNumber varchar(100)
)

INSERT INTO #StaffInfo
SELECT 
	CASE 
		WHEN PhoneNumber is NULL
			OR PhoneNumber = ''
			THEN ''
		ELSE 'Phone Number: ' + PhoneNumber  + '<br/><br/>'
		END AS PhoneNumber
	,CASE 
		WHEN OfficePhone1 is NULL
			OR OfficePhone1 = ''
			THEN ''
		ELSE 'Phone Number: ' + OfficePhone1  + '<br/><br/>'
		END AS OfficePhone1
	,CASE 
		WHEN OfficePhone2 is NULL
			OR OfficePhone2 = ''
			THEN ''
		ELSE 'Office Phone 2: ' + OfficePhone2  + '<br/><br/>'
		END AS OfficePhone2
	,CASE 
		WHEN CellPhone is NULL
			OR CellPhone = ''
			THEN ''
		ELSE 'Cell Phone: ' + CellPhone  + '<br/><br/>'
		END AS CellPhone
	,CASE 
		WHEN HomePhone is NULL
			OR HomePhone = ''
			THEN ''
		ELSE 'Home Phone: ' + HomePhone  + '<br/><br/>'
		END AS HomePhone
	,CASE 
		WHEN PagerNumber is NULL
			OR PagerNumber = ''
			THEN ''
		ELSE 'Pager Number: ' + PagerNumber  + '<br/><br/>'
		END AS PagerNumber
	,CASE 
		WHEN FaxNumber is NULL
			OR FaxNumber = ''
			THEN ''
		ELSE 'Fax Number: ' + FaxNumber  + '<br/><br/>'
		END AS FaxNumber
FROM Staff
WHERE StaffId = @StaffId

SET @phoneText= (SELECT STUFF( (SELECT  PhoneNumber
       + OfficePhone1
       + OfficePhone2
       + CellPhone
      
                             FROM #StaffInfo
                             FOR XML PATH('')), 
                            1, 0, ''))
set @addressText=(select AddressDisplay from Staff where StaffId=@StaffId)

DROP Table #StaffInfo
select ISNULL(@phoneText,'') AS StaffPhone,ISNULL(@addressText,'') AS StaffAddress,@TreatmentRole AS StaffTreatmentRole

END TRY
BEGIN CATCH       
        DECLARE @Error VARCHAR(8000)       
      
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'       
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())       
                    + '*****'       
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),       
                    'ssp_GetStaffTreatmentTeamMember')       
                    + '*****' + CONVERT(VARCHAR, ERROR_LINE())       
                    + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())       
                    + '*****' + CONVERT(VARCHAR, ERROR_STATE())       
      
        RAISERROR ( @Error,       
                    -- Message text.                                                                                                  
                    16,       
                    -- Severity.                                                                                                  
                    1       
                   -- State.                                                                                                  
                    );       
     END CATCH       
END   



GO


