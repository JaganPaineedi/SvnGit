if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_PMServiceDeleteNote]')
                    and type in ( N'P', N'PC' ) )
    drop procedure [dbo].[ssp_PMServiceDeleteNote]; 

go 
set quoted_identifier on;
set ansi_nulls on;
go
create procedure [dbo].[ssp_PMServiceDeleteNote]
    @DocumentCodeId int
  , @DocumentVersionId int
  ,                                     
   --@DocumentId int,                                                        
    @AuthorName varchar(50)
as /******************************************************************************                                    
**  File: dbo.ssp_PMServiceDeleteNote.prc                                    
**  Name: dbo.ssp_PMServiceDeleteNote                                    
**  Desc:                                     
**                                    
** For updating the record in child table.                                  
**                                                  
**  Return values:                                    
**                                     
**  Called by:     ssp_PMServiceNote                                  
**                                                  
**  Parameters:                                    
**  Input       Output                                    
**     ----------       -----------                                    
**                                    
**  Auth: KamaljitSingh                                  
**  Date: 27/10/2007                                    
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:  Author:    Description:                                    
**  --------  --------    -------------------------------------------                                    
**  26/May/2009   Rohit Verma Shifted the delete logic to custom stores procedures
	23/Jan/2017	  Wasif Butt	added call to scsp for custom logic and removed custom references
*******************************************************************************/                                      
    begin 
        begin try 

            if exists ( select  *
                        from    sys.objects
                        where   object_id = object_id(N'[dbo].[scsp_PMServiceDeleteNote]')
                                and type in ( N'P', N'PC' ) )
                begin
                    exec scsp_PMServiceDeleteNote @DocumentCodeId,
                        @DocumentVersionId, @AuthorName;
                end;                                
        end try 

        begin catch 
            declare @Error varchar(8000); 

            set @Error = convert(varchar, error_number()) + '*****'
                + convert(varchar(4000), error_message()) + '*****'
                + isnull(convert(varchar, error_procedure()),
                         'ssp_PMServiceDeleteNote') + '*****'
                + convert(varchar, error_line()) + '*****'
                + convert(varchar, error_severity()) + '*****'
                + convert(varchar, error_state()); 

            raiserror ( @Error, 
                      -- Message text.                                                                                                   
                      16, 
                      -- Severity.                                                                                                   
                      1 
          -- State.                                                                                                   
          ); 
        end catch; 
    end; 

go