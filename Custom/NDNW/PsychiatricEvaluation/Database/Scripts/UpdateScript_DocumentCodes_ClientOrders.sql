IF  EXISTS(SELECT 1 FROM DocumentCodes WHERE documentcodeid=1506)
Begin
Update DocumentCodes set Active='Y' where documentcodeid=1506
end