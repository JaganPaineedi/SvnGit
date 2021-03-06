/****** Object:  StoredProcedure [dbo].[csp_productivity_summary12_ReportType]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_productivity_summary12_ReportType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_productivity_summary12_ReportType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_productivity_summary12_ReportType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************/
/* Stored Procedure: csp_productivity_summary12_ReportTyp            */
/* Creation Date:    5/30/2012                                      */
/* Copyright:                                                        */
/*                                                                   */
/* Purpose:  Units of Service Report                                 */
/*                                                                   */
/* Input Parameters: @ReportType									 */
/*	               													 */
/*																	 */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:  0=success                                         */
/*                                                                   */
/* Called By:  Crystal productivity_summary							 */
/*                                                                   */
/* Calls: 															 */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*                                    */
/******s***************************************************************/


Create proc [dbo].[csp_productivity_summary12_ReportType]  	
                            @ReportType AS INT	

AS 
BEGIN

        Select  -1 AS StaffID
         ,case when  @ReportType =1 
              Then '' Select A Supervisor'' 
              Else '' Select A Staff'' 
          END AS StaffName
         Union 
	   SELECT StaffID, 
	         LastName +'', '' + Firstname AS StaffName 
	   FROM Staff
	   WHERE ISNULL(Supervisor,''N'')= 
									CASE  WHEN @ReportType=1 
										 THEN ''Y''   --Is Superviosr
										 ELSE ''N''   --Is not a superviosr
								     End

         ORDER BY StaffName
	
END 

	' 
END
GO
