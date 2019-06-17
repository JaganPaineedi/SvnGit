IF EXISTS ( SELECT  *
            FROM    dbo.ClaimFormats
            WHERE   StoredProcedure = 'csp_PMClaims837ProfessionalOfficeAlly' )
    BEGIN 
        UPDATE  ClaimFormats
        SET     FormatName = 'HIPAA 837 Professional Version 5 Office Ally' ,
                FormatDescription = 'HIPAA 837 Professional Version 5 Office Ally' ,
                FormatType = 4683 ,
                Electronic = 'Y' ,
                Active = 'Y' ,
                StoredProcedure = 'csp_PMClaims837ProfessionalOfficeAlly' ,
                BillingLocationCode = '341896193' ,
                ReceiverCode = '330897513' ,
                ReceiverPrimaryId = '330897513' ,
                ProductionOrTest = 'P' ,
                Version = '005010X222A1' ,
                SystemReportId = NULL
        WHERE   StoredProcedure = 'csp_PMClaims837ProfessionalOfficeAlly' 
    END

ELSE
    BEGIN
        INSERT  INTO dbo.ClaimFormats
                ( FormatName ,
                  FormatDescription ,
                  FormatType ,
                  Electronic ,
                  Active ,
                  StoredProcedure ,
                  BillingLocationCode ,
                  ReceiverCode ,
                  ReceiverPrimaryId ,
                  ProductionOrTest ,
                  Version ,
                  SystemReportId
                )
        VALUES  ( 'HIPAA 837 Professional Version 5 Office Ally' , -- FormatName - varchar(100)
                  'HIPAA 837 Professional Version 5 Office Ally' , -- FormatDescription - varchar(500)
                  4683 , -- FormatType - type_GlobalCode
                  'Y' , -- Electronic - type_YOrN
                  'Y' , -- Active - type_Active
                  'csp_PMClaims837ProfessionalOfficeAlly' , -- StoredProcedure - varchar(100)
                  '341896193' , -- BillingLocationCode - varchar(35)
                  '330897513' , -- ReceiverCode - varchar(35)
                  '330897513' , -- ReceiverPrimaryId - varchar(35)
                  'P' , -- ProductionOrTest - char(1)
                  '005010X222A1' , -- Version - varchar(20)
                  NULL  -- SystemReportId - int
                )
    END     