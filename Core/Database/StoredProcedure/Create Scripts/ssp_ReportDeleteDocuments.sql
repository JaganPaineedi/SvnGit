/****** Object:  StoredProcedure [dbo].[ssp_ReportDeleteDocuments]    Script Date: 5/22/2018 11:03:51 AM ******/
if object_id('dbo.ssp_ReportDeleteDocuments') is not null 
DROP PROCEDURE [dbo].[ssp_ReportDeleteDocuments]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ReportDeleteDocuments]    Script Date: 5/22/2018 11:03:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[ssp_ReportDeleteDocuments] ( 
 @DocumentCodeId int,  
 @Client_Id int,  
 @StartDate datetime,   
 @EndDate datetime  
)  
  
AS    
/**********************************************************************  
Report Request:  
 Displays a list of documents that meet the criteria of the  
 parameters, which at that point the user can pick and choose  
 which ones to delete.  
  
Parameters:  
 DocumentCodeId,ClientId,Start Date, End Date  
  
  
Modified By  Modified Date Reason  
----------------------------------------------------------------  
jriley   07/15/2011  created  
avoss   08.16.2011  added document status  
breed           6.4.2013        adding id to document name to distinguish between identical lines  
  
exec ssp_ReportDeleteDocuments 10260, null, '5/1/2013', '5/30/2013'  
exec ssp_ReportDeleteDocuments 353, null, '5/1/2013', '5/30/2013'  
msood/mkhusro	10/21/2016 Changed the @ClientId to @Client_Id - Bradford - Support Go Live Task # 240 
BFagaly 05-07-2018  changed documentname varchar from 50 to 120 because of dataset error using
exec ssp_ReportDeleteDocuments 60103, null, '02/05/2018', '02/06/2018'
**********************************************************************/  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
  
DECLARE @Title varchar(max)  
DECLARE @SubTitle varchar(max)  
DECLARE @Comment varchar(max)  
  
  
SET @Title = 'Delete ' + (SELECT dc.DocumentName  
        FROM DocumentCodes dc  
        WHERE dc.DocumentCodeId = @DocumentCodeId) + ' Report'  
SET @SubTitle = ''   
SET @Comment = ''  
  --
  
CREATE TABLE #Report (  
 ClientId int,  
 ClientName varchar(50),  
 EffectiveDate datetime,  
 Status varchar(30),  
 DocumentId int,  
 DocumentName varchar(120),  
 AuthorName varchar(50)  
)  
  
  
INSERT into #Report (  
 ClientId,  
 ClientName,  
 EffectiveDate,  
 Status,  
 DocumentId,  
 DocumentName,  
 AuthorName  
)  
   
SELECT  c.ClientId ,  
        c.LastName + ', ' + c.FirstName ,  
        d.EffectiveDate ,  
        gc.codeName ,  
        d.DocumentId ,  
        CASE WHEN d.serviceid IS NOT NULL THEN   
            dc.DocumentName+ ' ('+ CAST(d.ServiceId AS VARCHAR) + ')'   
        ELSE   
            dc.DocumentName+ ' ('+ CAST(d.DocumentId AS VARCHAR) + ')'   
        END,  
        s.LastName + ', ' + s.FirstName  
FROM    Documents D  
        LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = d.Status  
        LEFT JOIN Clients c ON c.ClientId = d.ClientId  
        LEFT JOIN Staff s ON s.StaffId = d.AuthorId  
        LEFT JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId  
WHERE   ISNULL(d.RecordDeleted, 'N') = 'N'  
        AND ( @Client_Id IS NULL  
              OR c.ClientId = @Client_Id  
            )  
        AND d.DocumentCodeId = @DocumentCodeId  
		AND DATEDIFF(D,@StartDate, d.EffectiveDate) >= 0
		AND DATEDIFF(D,@EndDate, d.EffectiveDate) <=0
       -- AND d.EffectiveDate >= ISNULL(@StartDate, DATEADD(YY, -1, GETDATE()))  
        --AND d.EffectiveDate <= ISNULL(@EndDate, GETDATE()) 
ORDER BY c.LastName + ', ' + c.FirstName ,  
        d.EffectiveDate  
  
  
  
-------------------------------------  
  
IF exists (select 1 from #Report)  
 BEGIN   
  Select   
  @Title as Title  
  , @SubTitle as SubTitle  
  , @Comment as Comment  
  , *  
  FROM #Report  
  order by ClientName, EffectiveDate  
 END  
ELSE  
 BEGIN  
  Select   
  @Title as Title  
  , @SubTitle as SubTitle  
  , @Comment as Comment  
  , *  
  FROM #Report  
 END  
  
  
DROP TABLE #Report  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  





GO


