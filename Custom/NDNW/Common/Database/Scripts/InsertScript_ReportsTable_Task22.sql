If not exists(Select * from reports where Name like 'Insurance Verification Report')
Begin
INSERT INTO dbo.Reports
        ( Name ,
          Description ,
          IsFolder ,
          ParentFolderId ,
          AssociatedWith ,
          ReportServerId ,
          ReportServerPath ,
        
          CreatedBy ,
          CreatedDate ,
          ModifiedBy ,
          ModifiedDate 
       
        )
VALUES  ( 'Insurance Verification Report' , -- Name - varchar(250)
          'Insurance Verification Report' , -- Description - varchar(max)
          'N' , -- IsFolder - type_YOrN
          12 , -- ParentFolderId - int
          5831 , -- AssociatedWith - type_GlobalCode
          2 , -- ReportServerId - int
          '/NDNW/ProdDocuments/InsuranceVerificationReport' , -- ReportServerPath - varchar(500)
          'Streamline' , -- CreatedBy - type_CurrentUser
          GETDATE() , -- CreatedDate - type_CurrentDatetime
          'Streamline', -- ModifiedBy - type_CurrentUser
          GETDATE() -- ModifiedDate - type_CurrentDatetime
       
        )
end