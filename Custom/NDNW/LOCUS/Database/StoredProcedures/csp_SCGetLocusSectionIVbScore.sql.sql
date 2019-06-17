    
/****** Object:  StoredProcedure [dbo].[csp_SCGetLocusSectionIVbScore]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLocusSectionIVbScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLocusSectionIVbScore]
GO

   
create  Procedure [dbo].[csp_SCGetLocusSectionIVbScore]            
                 
As            
/*********************************************************************/                            
/* Stored Procedure: dbo.[csp_SCGetLocusSectionIVbScore]             */                            
/* Creation Date:  12/02/2011                                              */                            
/*                                                                       */                            
/* Purpose: To Get bind the Section IV B Score List with  static values like  */                           
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
  
insert into @table(TextField,ValueField)  values('1 - Highly Supportive Environment',1)  
insert into @table(TextField,ValueField)  values('2 - Supportive Environment',2)  
insert into @table(TextField,ValueField)  values('3 - Limited Support in Environment',3)   
insert into @table(TextField,ValueField)  values('4 - Minimal Support in Environment',4)  
insert into @table(TextField,ValueField)  values('5 - No Support in Environment',5 )  
 
  
  
select TextField,ValueField  from @table  
  
--Checking For Errors            
If (@@error!=0)           
  Begin            
  RAISERROR  20006  '[csp_SCGetLocusSectionIVbScore]: An Error Occured'               
  Return            
 End            
            
            
GO


