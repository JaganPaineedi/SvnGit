/****** Object:  StoredProcedure [dbo].[ssp_CMGetProvidersListForClientAuthorizations]    Script Date: 11/16/2011 11:52:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetProvidersListForClientAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetProvidersListForClientAuthorizations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

create procedure dbo.ssp_CMGetProvidersListForClientAuthorizations
  @LoggedInStaff int,
  @ClientId int
	/***************************************************************************************************/
	/* Stored Procedure: ssp_CMGetProvidersListForClientAuthorizations	 550,115478                              */
	/* Copyright: 2005 Provider Claim Management System					                               */
	/*                                                                                                 */
	/* Purpose: Fetch Provider IDs,Names to bind provider drop down on cm clientAuthorization list Page*/
	/*                                                                  */
	/* Created Info :Kalamazoo need to bind only those providers with provider drop down on CM          */ 
	/* ClientAuthorization list page  which are associated with authorization of clients                */                                                                                   
	/* Author: PradeepT                                                                                  */
	/* Why: As per Task KCMHSAS - Support-#960.16                                                       */
	/* Return: returns DataSet											                                */
	/*Called From: Only from CM ClientAuthorization List Page                                           */
	/*                                                                                                  */
	/* Data Modifications:												                                */
	/*																	                                */
	/* Updates:															                                */
	/****************************************************************************************************/
	/*	Date			Author			Purpose							                                */
	/*  28 Dec 2017     PradeepT        Created as per task KCMHSAS - Support-#960.16                   */
	/****************************************************************************************************/
as

declare @AllProvider varchar(1)
	
 

select top 1
        @AllProvider = isnull(AllProviders, 'N')
from    Staff
where   StaffId = @LoggedInStaff
	
select  p.ProviderId,
        case p.ProviderType
          when 'I' then isnull(p.ProviderName, '') + ', ' + isnull(p.FirstName, '')
          when 'F' then isnull(p.ProviderName, '')
        end as ProviderName
from    Providers p
where EXISTS(SELECT 1 FROM ProviderAuthorizations PA 
             WHERE ISNULL(PA.RecordDeleted,'N')='N' AND PA.ProviderId=p.ProviderId AND PA.ClientId=@ClientId)   
        and (@AllProvider = 'Y'
             or exists ( select *
                         from   StaffProviders sp
                         where  sp.StaffId = @LoggedInStaff
                                and sp.ProviderId = p.ProviderId
                                and isnull(sp.RecordDeleted, 'N') = 'N' ))
        and p.Active = 'Y'
        and isnull(p.RenderingProvider, 'N') = 'N'
        and isnull(p.RecordDeleted, 'N') = 'N'
order by p.ProviderName 
	       
go


