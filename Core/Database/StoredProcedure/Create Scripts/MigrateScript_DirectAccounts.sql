--Create Direct Accounts for each staff that has a directaddressemail and password

DECLARE @CurrentUser VARCHAR(30) = 'SWMBH E 833.2';
CREATE TABLE #output (DirectAccountId INT);

INSERT INTO dbo.DirectAccounts (CreatedBy,
                                ModifiedBy,
                                StaffId,
                                DirectFirstName,
                                DirectLastName,
                                DirectEmailAddress,
                                DirectPassword,
                                DirectAlternativeEmail,
                                DirectDescription)
OUTPUT Inserted.DirectAccountId
INTO #output (DirectAccountId)
SELECT @CurrentUser,
       @CurrentUser,
       s.StaffId,
       s.FirstName,
       s.LastName,
       s.DirectEmailAddress,
       s.DirectEmailPassword,
       s.Email,
       NULL
  FROM Staff AS s
 WHERE ISNULL(s.RecordDeleted, 'N')      = 'N'
   AND ISNULL(s.DirectEmailAddress, '')  <> ''
   AND ISNULL(s.DirectEmailPassword, '') <> ''
   AND NOT EXISTS (SELECT 1
                     FROM dbo.DirectAccounts AS a
                    WHERE a.StaffId                    = s.StaffId
                      AND ISNULL(a.RecordDeleted, 'N') = 'N');

INSERT INTO dbo.DirectAccountLog (CreatedBy,
                                  CreatedDate,
                                  ModifiedBy,
                                  ModifiedDate,
                                  RecordDeleted,
                                  DeletedBy,
                                  DeletedDate,
                                  DirectAccountId,
                                  StaffId,
                                  DirectFirstName,
                                  DirectLastName,
                                  DirectEmailAddress,
                                  DirectPassword,
                                  DirectAlternativeEmail,
                                  DirectDescription)
SELECT a.CreatedBy,
       a.CreatedDate,
       a.ModifiedBy,
       a.ModifiedDate,
       a.RecordDeleted,
       a.DeletedBy,
       a.DeletedDate,
       a.DirectAccountId,
       a.StaffId,
       a.DirectFirstName,
       a.DirectLastName,
       a.DirectEmailAddress,
       a.DirectPassword,
       a.DirectAlternativeEmail,
       a.DirectDescription
  FROM dbo.DirectAccounts AS a
  JOIN #output AS b
    ON b.DirectAccountId = a.DirectAccountId;

DROP TABLE #output;

GO


