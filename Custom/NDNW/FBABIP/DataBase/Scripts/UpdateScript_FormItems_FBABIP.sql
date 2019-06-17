  -- Craeted BY      : Varinder
---  Modified Dated  : 4 Dec 2012 
--   Purpose         : FBA/BIP  update scrip for Student   --Task #13 Development Phase 4 (Offshore) 

 if((Exists(select FormItemId from FormItems where FormItemId=4324)))
   begin
     update FormItems set itemLabel='Outstanding client loans' where FormItemId=4324  
   end
   
  if((Exists(select FormItemId from FormItems where FormItemId=4333)))
   begin
     update FormItems set itemLabel='Socializing with other clients' where FormItemId=4333  
   end
   
   if((Exists(select FormItemId from FormItems where FormItemId=4362)))
   begin
     update FormItems set itemLabel='Resolve outstanding client loans' where FormItemId=4362  
   end  
   
    if((Exists(select FormItemId from FormItems where FormItemId=5464)))
   begin
     update FormItems set itemLabel='Who will coordinate the plan with the client’s parent(s)?*' where FormItemId=5464  
   end 
   
   if((Exists(select FormItemId from FormItems where FormItemId=5466)))
   begin
     update FormItems set itemLabel='How will this be coordinated with the client’s parent(s)?*' where FormItemId=5466  
   end
   
  