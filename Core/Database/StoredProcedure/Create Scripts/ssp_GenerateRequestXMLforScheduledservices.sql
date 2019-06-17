
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GenerateRequestXMLforScheduledservices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GenerateRequestXMLforScheduledservices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GenerateRequestXMLforScheduledservices] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[ssp_GenerateRequestXMLforScheduledservices]   
/********************************************************************************  
-- Stored Procedure: dbo.ssp_GenerateRequestXMLforScheduledservices    
--  
-- Purpose: Used for generating request XML for the clients whom service is scheduled for the day.
--  
-- Updates:                                                         
-- Date         Author      Purpose  
-- 05.Sep.2018  Anto        Created.        
--  
*********************************************************************************/  
AS  


DECLARE @Scheduledserviceid int
SELECT @Scheduledserviceid = Globalcodeid FROM Globalcodes where Category = 'SERVICESTATUS' and CodeName = 'Scheduled'

DECLARE @Scheduledclients TABLE
(
  Clientid INT,
  Staffid INT
)

INSERT INTO @Scheduledclients 
SELECT Distinct Clientid,Clinicianid from services where status  = @Scheduledserviceid   and ISNULL(Recorddeleted,'N') = 'N'
and CONVERT(char(10), DateofService,126) = CONVERT(char(10), GETDATE(),126)

--SELECT top 1 Clientid,Clinicianid from services where status  = @Scheduledserviceid   and ISNULL(Recorddeleted,'N') = 'N'


DECLARE @Clientid int
DECLARE @Staffid int

DECLARE cur CURSOR LOCAL FOR
    SELECT Clientid, Staffid from @Scheduledclients 
OPEN cur

FETCH NEXT FROM cur INTO @Clientid, @Staffid

WHILE @@FETCH_STATUS = 0 BEGIN

    EXEC ssp_RxNCPDPClientRequestXMLGeneration @Clientid, @Staffid

    FETCH NEXT FROM cur INTO @Clientid, @Staffid
END

CLOSE cur
DEALLOCATE cur


GO