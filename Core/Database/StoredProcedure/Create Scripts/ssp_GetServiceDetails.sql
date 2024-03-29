IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_GetServiceDetails]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetServiceDetails] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_GetServiceDetails] 
(@ServiceId	int)
AS 
/******************************
***************************************/ 
/* Stored Procedure: dbo.ssp_GetServiceDetails            */ 
/* Creation Date:    19/May/2014                */ 
/* Purpose:  Service details for Client Payment type                */ 
/*    Exec ssp_GetServiceDetails                                          */
/* Input Parameters:                           */ 
/*  Date			Author			Purpose              */ 
/* 15/July/2014		Ponnin			Created    task #135 ,Automatically Post Payments,Philhaven Development           */ 
/* Feb-13-2015		Ponnin			Returning Copayamount for the services by calling 'ssp_GetCopayAmountForServices' Stored procedure. For task #135 of Philhaven Development.  */ 
/* Feb-13-2015		Ponnin			Changes made to show only the completed service in the popup(Amount Applied to Services for Today). For task #135 of Philhaven Development.  */ 
/* Mar-5-2015		Ponnin			Reduced CopayReceived Amount from the TotalCopay of the Client. For task #135 of Philhaven Development.*/
/* Mar-6-2015		Ponnin			Showing all the Services with status 'Show', 'Scheduled' and 'Completed'. For task #135 of Philhaven Development.*/
/* May-14-2015		Ponnin			Return Applied/Unapplied copay amount. For task #135.1 of Philhaven Development.*/
/* May-18-2015		Ponnin			Returning 0.00 for Applied and Unapplied copay amount if the sum is null. For task #135.1 of Philhaven Development.*/
  /*********************************************************************/ 
BEGIN 
begin try
declare @ClientId int;
declare @DateOfService datetime;
DECLARE	@RowCount INT  
DECLARE	@Counter INT
DECLARE @CopayServiceId INT
DECLARE @ClientCopay DECIMAL(18, 2)  
DECLARE @CopayReceived DECIMAL(18, 2)  
DECLARE @CopayUnApplied DECIMAL(18, 2)  

CREATE TABLE #Services
(
	Id INT IDENTITY,
	ServiceId INT,
	[Status] INT,
	ProcedureCodeName VARCHAR (250),
	DisplayAs VARCHAR (250),
	Clinician VARCHAR (60),
	ProcedureCodeId INT,
	ClientId INT,
	DateOfService DATETIME,
	ServiceTime VARCHAR (60),
	IsSelectedService VARCHAR (1),
	Copayamount MONEY,
	CopayApplied MONEY,
	CopayUnapplied MONEY
) 


	
SELECT   @ClientId = s.ClientId, @DateOfService =  CONVERT(VARCHAR(10), s.DateOfService, 101) from Services s
  JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId  
  left join Staff st ON st.StaffId = s.ClinicianId where ServiceId = @ServiceId and ISNULL(s.RecordDeleted,'N')='N' and ISNULL(pc.RecordDeleted,'N')='N' and ISNULL(st.RecordDeleted,'N')='N'
  

INSERT INTO #Services (ServiceId,
	[Status],
	ProcedureCodeName,
	DisplayAs,
	Clinician,
	ProcedureCodeId,
	ClientId,
	DateOfService,
	ServiceTime,
	IsSelectedService,
	Copayamount,
	CopayApplied,
	CopayUnapplied)
	
  Select SData.ServiceId,SData.[Status],SData.ProcedureCodeName,SData.DisplayAs,SData.Clinician,SData.ProcedureCodeId ,SData.ClientId ,SData.DateOfService ,SData.ServiceTime, SData.IsSelectedService, SData.Copayamount ,SData.CopayApplied ,SData.CopayUnapplied
  --ROW_NUMBER()OVER(PARTITION BY SData.IsSelectedService ORDER BY SData.IsSelectedService Desc ) AS RowCountNo
  From (
  SELECT S.ServiceId, S.[Status],  pc.ProcedureCodeName,  pc.DisplayAs,  st.LastName + ', ' + st.FirstName as [Clinician], s.ProcedureCodeId ,  s.ClientId,  s.DateOfService,
  substring(convert(varchar(20), s.DateOfService, 9), 13, 5) 
+ ' ' + substring(convert(varchar(30), s.DateOfService, 9), 25, 2) as ServiceTime,
  CASE 
      WHEN s.serviceid = @ServiceId THEN 'Y'  ELSE 'N'
   END as IsSelectedService
   , '$0.00' as Copayamount
   , '$0.00' as CopayApplied
   , '$0.00' as CopayUnapplied
   from Services s
  JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId  
  left join Staff st ON st.StaffId = s.ClinicianId where s.ClientId = @ClientId and CONVERT(VARCHAR(10), s.DateOfService, 101) = @DateOfService and  ISNULL(s.RecordDeleted,'N')='N' and ISNULL(pc.RecordDeleted,'N')='N' and ISNULL(st.RecordDeleted,'N')='N'
 --  and s.Status in (70,71,75)
  )SData 
  order by SData.IsSelectedService Desc, SData.DateOfService asc
  
  SET @RowCount = @@RowCount
  SET @Counter = 1
  
  WHILE @Counter <= @RowCount 
  BEGIN
  
  SET @CopayServiceId = 0
  SELECT	@CopayServiceId =  ServiceId
					FROM	#Services
					WHERE	Id = @Counter 
					
	CREATE TABLE #ClientCopay ( Copay DECIMAL(18, 2) )
	INSERT  INTO #ClientCopay
	EXEC ssp_GetCopayAmountForServices @CopayServiceId
	SELECT  @ClientCopay = NULLIF(Copay, 0)
    FROM    #ClientCopay  
  
  Select @CopayReceived=sum(Copayment) From PaymentCopayments where serviceId=@CopayServiceId and  ISNULL(RecordDeleted,'N')='N' and Applied = 'Y'
  Select @CopayUnApplied = sum(Copayment) From PaymentCopayments where serviceId=@CopayServiceId and  ISNULL(RecordDeleted,'N')='N' and Applied = 'N'
  
    IF(@CopayReceived is null)  
    BEGIN 
    SET @CopayReceived = 0.00
    END 
    
    IF(@CopayUnApplied is null)  
    BEGIN 
    SET @CopayUnApplied = 0.00
    END 
  
  IF(@ClientCopay is not null)
  BEGIN
  UPDATE #Services SET Copayamount = @ClientCopay  WHERE Id = @Counter
  UPDATE #Services SET CopayApplied = @CopayReceived WHERE Id = @Counter
  UPDATE #Services SET CopayUnapplied = @CopayUnApplied WHERE Id = @Counter
  END
  
  DROP TABLE #ClientCopay
  
  SET @Counter = @Counter + 1 
  END    
  
  SELECT 
	Id,
	ServiceId,
	[Status],
	(SELECT TOP 1 CodeName FROM GlobalCodes where GlobalCodeId = [Status] and Active = 'Y') as StatusCode,
	ProcedureCodeName,
	DisplayAs,
	Clinician,
	ProcedureCodeId,
	ClientId,
	DateOfService,
	ServiceTime,
	IsSelectedService,
	Copayamount,
	CopayApplied,
	CopayUnapplied,
	convert(varchar(30), CopayApplied, 1)  + ' / ' + convert(varchar(30), CopayUnapplied, 1)  as CopayAppliedUnapplied
	FROM #Services 

END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(max) 
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_GetServiceDetails' 
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



