/****** Object:  UserDefinedFunction [dbo].[GetMedicaidId]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMedicaidId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetMedicaidId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMedicaidId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N' 
 CREATE function [dbo].[GetMedicaidId]  
 ( @ClientId int )  
 returns varchar(25)  
  
BEGIN  
  
 DECLARE @MedicaidId varchar(100)  
 SET @MedicaidId = (Select top 1 ccp.InsuredId                                     
      From ClientCoveragePlans ccp  
      Join CoveragePlans cp on cp.CoveragePlanId=ccp.CoveragePlanId   
       and ISNULL(cp.RecordDeleted,''N'')=''N''  
      Join ClientCoverageHistory cch on ccp.ClientCoveragePlanId=cch.ClientCoveragePlanId   
       and ISNULL(cch.RecordDeleted,''N'')=''N''   
      Where cp.MedicaidPlan = ''Y''  
      and ISNULL(ccp.RecordDeleted,''N'')=''N''  
      and cch.StartDate <= GETDATE()  
      and (cch.EndDate >= GETDATE() or cch.EndDate is null)  
      and ccp.ClientId = @ClientId                                  
      Order by cch.COBOrder    
      )  
   
  
  
Return @MedicaidId  
  
END  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ' 
END
GO
