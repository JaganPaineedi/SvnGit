----Author: Bibhu
----AspenPointe - Support Go Live #49

IF  EXISTS ( SELECT  *
                FROM    dbo.GlobalCodeCategories
                WHERE   Category = 'CONTACTTITLE' ) 
 BEGIN               
 Update GlobalCodeCategories SET AllowAddDelete='Y'  Where category='CONTACTTITLE'
 END







