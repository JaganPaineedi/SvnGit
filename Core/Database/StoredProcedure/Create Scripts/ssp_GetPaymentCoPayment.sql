IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_GetPaymentCoPayment]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetPaymentCoPayment] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_GetPaymentCoPayment]
(@PaymentId	int)
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_GetPaymentCoPayment            */ 
/* Creation Date:    19/May/2014                */ 
/* Purpose:  Get Copayment of Payment                */ 
/*    Exec ssp_GetPaymentCoPayment                                          */
/* Input Parameters:                           */ 
/*  Date			Author			Purpose              */ 
/* 15/July/2014		Ponnin			Created    task #135 ,Automatically Post Payments,Philhaven Development           */ 
/* 24/July/2014		Ponnin			Created    What :Date format changed, Why : task #135 of Philhaven Development            */ 
/* 15/Oct/2015		Revathi		 	what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
	--									why:task #609, Network180 Customization   */
  /*********************************************************************/ 
BEGIN 
begin try

  SELECT pcp.PaymentCopaymentId, pcp.Copayment, S.ServiceId,  pc.ProcedureCodeName,  pc.DisplayAs,  st.LastName + ', ' + st.FirstName as [Clinician], s.ProcedureCodeId ,  s.ClientId,  s.DateOfService,
  substring(convert(varchar(20), s.DateOfService, 9), 13, 5) 
+ ' ' + substring(convert(varchar(30), s.DateOfService, 9), 25, 2) as ServiceTime, pcp.Applied, CONVERT(VARCHAR(12), s.DateOfService, 107) as FormattedDateOfService 
--Added by Revathi 15/Oct/2015
			,CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.FirstName, '') + ' ' + ISNULL(C.LastName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END AS [ClientName]
   from PaymentCopayments pcp
   Join Services s ON s.ServiceId = pcp.ServiceId 
  JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId  
  left join Staff st ON st.StaffId = s.ClinicianId
   left join Clients c ON c.ClientId = s.ClientId 
    where pcp.PaymentId  = @PaymentId  and  ISNULL(s.RecordDeleted,'N')='N' and ISNULL(pc.RecordDeleted,'N')='N' and ISNULL(st.RecordDeleted,'N')='N'
   order by  s.DateOfService asc
 

END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(max) 
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_GetPaymentCoPayment' 
                      ) 
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
      END catch 
  END 

go  



