/****** Object:  StoredProcedure [dbo].[ssp_SCGetSystemReportsForMedication]    Script Date: 03/01/2009 11:38:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.objects where name = 'ssp_SCGetSystemReportsForMedication' and type = 'P')
	drop procedure dbo.ssp_SCGetSystemReportsForMedication
go

CREATE PROCEDURE [dbo].[ssp_SCGetSystemReportsForMedication]                   
AS                            
/*********************************************************************/                              
/* Stored Procedure: dbo.[ssp_SCGetSystemReportsForMedication]                */                              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                              
/* Creation Date:    08/Dec/08                                         */                             
/*                                                                   */                              
/* Purpose:  Populate Reports combobox on main page  */                              
/*                                                                   */                            
/* Input Parameters: none       */                            
/*                                                                   */                              
/* Output Parameters:   None                           */                              
/*                                                                   */                              
/* Return:  Report table, otherwise an error number                     */                              
/*                                                                   */                              
/* Called By:                                                        */                              
/*                                                                   */                              
/* Calls:                                                            */                              
/*                                                                   */                              
/* Data Modifications:                                               */                              
/*                                                                   */                              
/* Updates:                                                          */                              
/*   Date     Author       Purpose                                   */                              
/*                                                                   */  
/*  08/Dec/2008 Rohit Verma   Populate Reports combobox on main page  */                           
/*********************************************************************/                                 
BEGIN                  

	declare @ReportCategoryId int

	select top 1 @ReportCategoryId = gc.GlobalCodeId
	from GlobalCodes as gc
	where gc.Category = 'MEDICATIONREPORTS'
	and isnull(gc.RecordDeleted, 'N') <> 'Y'

	select SystemReportId, ReportName, ReportURL 
    from SystemReports
	where ReportCategory = @ReportCategoryId 
	and Active = 'Y'
    and isnull(RecordDeleted, 'N') <> 'Y' 
	order by ReportName asc
                            
 IF (@@error!=0)                              
BEGIN                              
    RAISERROR  20002 'ssp_SCGetSystemReportsForMedication : An error  occured'                              
                             
    RETURN(1)                              
                               
END                                   
                            
END  