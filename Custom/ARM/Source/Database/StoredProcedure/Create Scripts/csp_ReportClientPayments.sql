/****** Object:  StoredProcedure [dbo].[csp_ReportClientPayments]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientPayments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientPayments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientPayments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE Procedure [dbo].[csp_ReportClientPayments]
        @StartDate   AS Date
       ,@EndDate     AS Date
       ,@LocationID  AS Int

AS
BEGIN 
         SELECT RESULT.*, F.ORGANIZATIONNAME FROM 
         (
					SELECT C.ClientId
						, C.FirstName
						, C.LastName
						, P.nameifNotClient 
						, GC1.CODENAME		AS PaymentMethod
						, SUM(P.Amount)		AS Total_Amount
						, P.ReferenceNumber
						, GC2.CODENAME		AS PaymentSource 
						, GC3.CODENAME		AS Location 
						, P.DateReceived 
						, GC3.GlobalCodeID	AS LocationID
						, P.CreatedBy
					FROM Payments P 
					LEFT JOIN Clients C ON P.ClientId = C.ClientId
					LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = P.PaymentMethod
					LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = P.PaymentSource
					Inner JOIN GlobalCodes GC3 ON GC3.GlobalCodeId = P.LocationId
					WHERE ISNULL (p.RecordDeleted, ''N'') <> ''Y''
					And (DateReceived >=@StartDate and DateReceived <=@EndDate)
					And GC3.GlobalCodeID=@LocationID
					GROUP BY C.ClientId,C.FirstName,
							 C.LastName,
							 GC1.CODENAME ,
							 P.ReferenceNumber, 
							 GC2.CODENAME ,
							 GC3.CODENAME,
							 P.DateReceived,
							 P.nameifNotClient,
							 P.CreatedBy
					 ,GC3.GlobalCodeID 
				) AS Result 
				cross join SystemConfigurations f
			order by result.DateReceived, result.LastName, Result.FirstName
End ' 
END
GO
