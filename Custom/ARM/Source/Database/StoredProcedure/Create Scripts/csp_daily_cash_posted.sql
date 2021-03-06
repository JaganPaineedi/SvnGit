/****** Object:  StoredProcedure [dbo].[csp_daily_cash_posted]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_daily_cash_posted]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_daily_cash_posted]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_daily_cash_posted]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_daily_cash_posted] 

		 @Start_date   datetime,
		 @End_date	   datetime,
		 @Subtype	   varchar(10)
		 
As 

 Select LEG.PostedDate,
        LEG.Clientid As PatientID , 
        CL.Firstname +'',''+ CL.Lastname As PatientName,
		CL.Ssn               As SSN,
		LEG.CoveragePlanId,
		gc.CodeName          As Instrument,
		Pymt.PaymentMethod  ,
		Pymt.ReferenceNumber As InstrumentReference,
		Pymt.DateReceived,   
		LEG.CreatedBy,       
		Sum(LEG.amount)      As Amount,
		sc.OrganizationName
		
 From Clients CL join Arledger LEG on     CL.clientid     = LEG.clientid
 left join Payments Pymt           on  Pymt.paymentid     = LEG.PaymentId
 join globalcodes     gc           on  Pymt.PaymentMethod = gc.GlobalCodeId
 cross join SystemConfigurations   sc
 where LEG.postedDate >= @Start_date 
 and   LEG.postedDate < dateadd(day, 1, @End_date)
 and   LEG.ledgerType = Case @Subtype
                        when ''All''		   Then LEG.ledgerType
                        when ''Charge''      Then 4201
                        when ''Payment''     Then 4202
                        when ''Adjustment''  Then 4203
                        when ''Transfer''    Then 4204
                        End         
 and   isnull(CL.RecordDeleted   , ''N'') = ''N''
 and   isnull(Pymt.RecordDeleted , ''N'') = ''N''
 and   isnull(LEG.RecordDeleted  , ''N'') = ''N''
 
 
 Group by LEG.PostedDate,
          LEG.Clientid,
		  CL.lastname,
		  CL.firstname,
		  CL.ssn,
		  LEG.CoveragePlanId,
		  LEG.ledgerType,
		  gc.CodeName,
		  Pymt.PaymentMethod ,
		  Pymt.DateReceived,
		  Pymt.ReferenceNumber,
		  LEG.CreatedBy,
		  sc.OrganizationName
			  
 Order by LEG.Clientid,LEG.PostedDate
-----------

' 
END
GO
