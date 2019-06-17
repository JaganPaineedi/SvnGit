

DECLARE @AssociatedWithGlobalCodeId INT = ( SELECT GlobalCodeId
                                            FROM   dbo.GlobalCodes
                                            WHERE  Category = 'ReportAssociatedWith'
                                                   AND CodeName = 'Client'
                                                   AND Active = 'Y'
                                                   AND ISNULL(RecordDeleted, 'N') <> 'Y'
                                          )


INSERT   INTO dbo.Reports
         (
           Name
         , Description
         , IsFolder
         , ParentFolderId
         , AssociatedWith
         , ReportServerId
         , ReportServerPath
         , RowIdentifier
         , CreatedBy
         , CreatedDate
         , ModifiedBy
         , ModifiedDate
         )
         SELECT   valtable.ReportName-- Name - varchar(250)
                , valtable.Descr-- Description - varchar(max)
                , 'N'-- IsFolder - type_YOrN
                , NULL-- ParentFolderId - int
                , NULL--AssociatedWith - type_GlobalCode
                , rs.ReportServerId-- ReportServerId - int
                , '/' + sc.ReportFolderName + '/' + valtable.RDL-- ReportServerPath - varchar(500)
                , NEWID()-- RowIdentifier - type_GUID
                , 'dknewtson'-- CreatedBy - type_CurrentUser
                , GETDATE()-- CreatedDate - type_CurrentDatetime
                , 'dknewtson'-- ModifiedBy - type_CurrentUser
                , GETDATE()-- ModifiedDate - type_CurrentDatetime
         FROM     dbo.SystemConfigurations AS sc
                  JOIN ( VALUES
                     ( 'Batch Eligibility Change Review', 'Review and update Client Coverage changes from batch 270/271', 'RDLBatchEligibilityChangeReview')
				, ( 'Batch Eligibility Batch List', 'List of Eligibility Batches', 'RDLBatchEligibilityBatchList') ) valtable ( ReportName, Descr, RDL )
                                                                                                        ON NOT EXISTS ( SELECT
                                                                                                        1
                                                                                                        FROM
                                                                                                        dbo.Reports r
                                                                                                        WHERE
                                                                                                        r.ReportServerPath = '/'
                                                                                                        + sc.ReportFolderName
                                                                                                        + '/'
                                                                                                        + valtable.RDL )
                  CROSS JOIN dbo.ReportServers AS rs
         WHERE    NOT EXISTS ( SELECT  1
                               FROM    dbo.Reports r
                               WHERE   r.ReportServerPath = '/' + sc.ReportFolderName + '/' + valtable.RDL )
