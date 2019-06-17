
/****** Object:  StoredProcedure [dbo].[scsp_ReportPrint1099s]    Script Date: 18/12/2017 17:41:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ReportPrint1099s]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ReportPrint1099s]
GO


/****** Object:  StoredProcedure [dbo].[scsp_ReportPrint1099s]    Script Date: 18/12/2017 17:41:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE procedure [dbo].[scsp_ReportPrint1099s]    
@InsurerId      int,  
@CalendarYear datetime,  
@TaxId1 varchar(max) =null,  
@TaxId2 varchar(max)=null 

/********************************************************************************    
-- Stored Procedure:[dbo].[scsp_ReportPrint1099s]   

-- Copyright: 2006 Streamline Healthcate Solutions    
--    
-- Creation Date:    19-Dec-2017                                               
--                                                                         
-- Purpose: Print 1099 report    
--    
-- Updates:                                                           
-- Date        Author      Purpose    
-- 11.17.2006  Sachin      Created to call the custom csp's .          


*********************************************************************************/    
as    

BEGIN

IF OBJECT_ID('csp_ReportPrint1099s') IS NOT NULL 
BEGIN  
    EXEC csp_ReportPrint1099s  @InsurerId, @CalendarYear, @TaxId1,@TaxId2           
END 
	
END