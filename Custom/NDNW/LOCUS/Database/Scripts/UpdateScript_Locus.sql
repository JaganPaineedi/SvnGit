If  EXISTS (select * from screens where ScreenId=30921)
 BEGIN
  update Screens set ScreenName='LOCUS Results' where ScreenId=30921;
            
 END


If  EXISTS (select * from Banners where ScreenId=30921)
 BEGIN
update Banners  set DisplayAs='LOCUS Results',BannerName ='LOCUS Results'  where  ScreenId=30921;
 END
 
 
If  EXISTS (select * from DocumentCodes  where DocumentCodeId=30027)
 BEGIN
update DocumentCodes set DocumentName='LOCUS Results' where DocumentCodeId=30027;

END
