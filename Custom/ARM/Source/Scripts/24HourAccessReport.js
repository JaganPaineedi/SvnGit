function SetScreenSpecificValues(dom, action) {
    try {
        $('#TextBox_CustomDocument24HourAccess_PhoneNumber').attr('datatype', 'PhoneNumber');

    }
    catch (err) {
        LogClientSideException(err, 'Events');
    }
}
//Testing 

//Testing 