function GetOffSetTop(obj)
{
    var initialTop = obj.offsetTop;
    obj = obj.parentNode;
    while(obj && obj.tagName != "BODY")
    {
            if(obj.tagName != "TD" && obj.tagName != "FORM")
            {
                initialTop += obj.offsetTop;
            }
            obj = obj.parentNode;
    }
    return initialTop;
}

function GetOffSetLeft(obj)
{
    var initialLeft = obj.offsetLeft;
    obj = obj.parentNode;
    while(obj && obj.tagName != "BODY")
    {
        if(obj.tagName != "TR" && obj.tagName != "FORM")
        {
            initialLeft += obj.offsetLeft;
        }
        obj = obj.parentNode;
    }
    return initialLeft;
}



var divMain;
var Blocker = document.getElementById("Blocker");
function ShowPopUp(divPopUp)
{
    alert(divPopUp);
    Blocker = document.getElementById("Blocker");
    Blocker.style.height = divMain.offsetHeight + 'px';
    Blocker.style.width = divMain.offsetWidth + 'px';
    Blocker.style.top = GetOffSetTop(divMain) + 'px';
    Blocker.style.left =(GetOffSetLeft(divMain) + document.body.offsetLeft + 13) + 'px'; //(GetOffSetLeft(divMain) + 13) + 'px';
    
    if(ua != IE)
    {
        Blocker.style.top = (parseInt(Blocker.style.top)/2 - 85) + 'px';
        Blocker.style.left = (parseInt(Blocker.style.left)/2 - 100) + 'px';
    }
    else
    {
        Blocker.style.left = (parseInt(Blocker.style.left) - 15) + 'px';
    }
    Blocker.style.display = "";
    
    if(arguments[0] != null && arguments[0] != '')
    {      
        if(arguments[1] == null)
        {
            if(window.location.href.toLowerCase().indexOf("group") > -1)
            {
                divPopUp.style.left = ((screen.availWidth - parseInt(divPopUp.style.width))/2 + document.documentElement.scrollLeft) - 30 + 'px';
                divPopUp.style.top = ((screen.availHeight - parseInt(divPopUp.style.height))/2 + document.documentElement.scrollTop - 100) + 'px';
            }
            else
            {
                divPopUp.style.left = ((screen.availWidth - parseInt(divPopUp.style.width))/2 + document.documentElement.scrollLeft) + 'px';
                divPopUp.style.top = ((screen.availHeight - parseInt(divPopUp.style.height))/2 + document.documentElement.scrollTop - 100) + 'px';
            }
            
        }
        
        divPopUp.style.zIndex = 5;
        divPopUp.style.display = "";
    }
}

///Added atul 24nov

function ShowPopUpWithTitle(divPopUp,title)
{
    Blocker = document.getElementById("Blocker");
    Blocker.style.height = divMain.offsetHeight + 'px';
    Blocker.style.width = divMain.offsetWidth + 'px';
    Blocker.style.top = GetOffSetTop(divMain) + 'px';
    Blocker.style.left =(GetOffSetLeft(divMain) + document.body.offsetLeft + 13) + 'px'; //(GetOffSetLeft(divMain) + 13) + 'px';
    document.getElementById("tmpTitle").innerText=title;
    if(ua != IE)
    {
        Blocker.style.top = (parseInt(Blocker.style.top)/2 - 85) + 'px';
        Blocker.style.left = (parseInt(Blocker.style.left)/2 - 100) + 'px';
    }
    else
    {
        Blocker.style.left = (parseInt(Blocker.style.left) - 15) + 'px';
    }
    Blocker.style.display = "";
    
    if(arguments[0] != null && arguments[0] != '')
    {      
        if(arguments[1] == null)
        {
            if(window.location.href.toLowerCase().indexOf("group") > -1)
            {
                divPopUp.style.left = ((screen.availWidth - parseInt(divPopUp.style.width))/2 + document.documentElement.scrollLeft) - 30 + 'px';
                divPopUp.style.top = ((screen.availHeight - parseInt(divPopUp.style.height))/2 + document.documentElement.scrollTop - 100) + 'px';
            }
            else
            {
                divPopUp.style.left = ((screen.availWidth - parseInt(divPopUp.style.width))/2 + document.documentElement.scrollLeft) + 'px';
                divPopUp.style.top = ((screen.availHeight - parseInt(divPopUp.style.height))/2 + document.documentElement.scrollTop - 50) + 'px';
            }
            
        }
        
        divPopUp.style.zIndex = 5;
        divPopUp.style.display = "";
    }
}


/// End Heree

function ShowPopUpWithOutBlocker(divPopUp)
{
    if(arguments[0] != null && arguments[0] != '')
    {      
        if(arguments[1] == null)
        {
            if(window.location.href.toLowerCase().indexOf("group") > -1)
            {
                divPopUp.style.left = ((screen.availWidth - parseInt(divPopUp.style.width))/2 + document.documentElement.scrollLeft) - 30 + 'px';
                divPopUp.style.top = ((screen.availHeight - parseInt(divPopUp.style.height))/2 + document.documentElement.scrollTop - 100) + 'px';
            }
            else
            {
                divPopUp.style.left = ((screen.availWidth - parseInt(divPopUp.style.width))/2 + document.documentElement.scrollLeft) + 'px';
                divPopUp.style.top = ((screen.availHeight - parseInt(divPopUp.style.height))/2 + document.documentElement.scrollTop - 150) + 'px';
            }
            
        }
        
        divPopUp.style.zIndex = 5;
        divPopUp.style.display = "";
    }
}

function ClosePopUpWithOutBlocker(divPopUp)
{
    divPopUp.style.display = "none";
}


function setScroll(grid,rowindex)
{
    try
    {
        var top = (grid.scrollHeight/grid.offsetHeight)+8;
        
        grid.scrollTop=rowindex * top;
    }
    catch(e)
    {
        
    }
}

function ClosePopUp(divPopUp)
{
    Blocker.style.display = "none";
    
    divPopUp.style.display = "none";
}

 // Variables to store x and y co-ordinates of the mouse
var _x;
var _y;

document.onmousemove = function(e)
{
    if(document.all)
    {
        _x = event.x;	
        _y = event.y;	
    }
    else
    {
        _x = e.clientX;	
        _y = e.clientY;	
    }
	
    _x += document.documentElement.scrollLeft;
   
   try
   {
       if(ua != undefined && ua == IE)
       {
           if(posActiveFolder != null)
           {
                _y = GetOffSetTop(posActiveFolder);// - document.documentElement.scrollTop;        
           }
           else
           {
                _y += document.documentElement.scrollTop;
           }
       }
       else
       {
            _y += document.documentElement.scrollTop;
       }  
   }
   catch(err)
   {}
   
   //window.status = _y; 
	
}