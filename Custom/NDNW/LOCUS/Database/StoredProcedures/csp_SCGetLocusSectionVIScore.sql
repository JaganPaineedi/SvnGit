     
/****** Object:  StoredProcedure [dbo].[csp_SCGetLocusSectionVIScore]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLocusSectionVIScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLocusSectionVIScore]
GO

   
create  Procedure [dbo].[csp_SCGetLocusSectionVIScore]            
                 
As            
/*********************************************************************/                            
/* Stored Procedure: dbo.[csp_SCGetLocusSectionVIScore]             */                            
/* Creation Date:  12/02/2011                                              */                            
/*                                                                       */                            
/* Purpose: To Get bind the Section VI Score List with  static values like  */                           
/*                                                                   */                          
/*                                                                   */                            
/* Output Parameters:                                */                            
/*                                                                   */                            
/*  Date                  Author                 Purpose          */                            
/* 12/02/2011             Rakesh Kumar -II               Created         */                            
/*********************************************************************/                     
            
    Declare @table table  
 (  
  TextField nvarchar(100),  
  ValueField int  
 )  
  
insert into @table(TextField,ValueField)  values('1 - Optimal Engagement',1)  
insert into @table(TextField,ValueField)  values('2 - Positive Engagement',2)  
insert into @table(TextField,ValueField)  values('3 - Limited Engagement',3)   
insert into @table(TextField,ValueField)  values('4 - Minimal Engagement',4)  
insert into @table(TextField,ValueField)  values('5 - Unengaged',5 )  
 
  
  
select TextField,ValueField  from @table  
  
--Checking For Errors            
If (@@error!=0)           
  Begin            
  RAISERROR  20006  '[csp_SCGetLocusSectionVIScore]: An Error Occured'               
  Return            
 End            
            
            
GO


