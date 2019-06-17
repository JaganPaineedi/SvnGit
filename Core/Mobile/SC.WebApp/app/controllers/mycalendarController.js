'use strict';
app.controller('myCalendarController', ['$scope', 'ngAuthSettings', 'briefcaseService', 'localDBService', 'dbModel', 'authService', '$location',
    'commonService', '$compile', '$uibModal', 'localPersistenceStrategy', 'localStorageService', 'persistenceService', 'remotePersistenceStrategy', 'syncService',
    function ($scope, ngAuthSettings, briefcaseService, localDBService, dbModel, authService, $location, commonService, $compile, $uibModal, localPersistenceStrategy,
        localStorageService, persistenceService, remotePersistenceStrategy, syncService) {
        if (authService.getprivatekeyrequired() === true) {
            $location.path('/login/UL');
            return;
        }

        var showToolbars = ['btnSave'];
        commonService.ManageToolbarItem(showToolbars, true);

        $scope.title = "My Calendar";
        $scope.staffId = localDBService.GetCurrentUserID();
        $scope.baseUrl = ngAuthSettings.virtualDirectoryURL;
        $scope.addNewEvent = function () {
            _openDialog();
        }


        localDBService.Open(dbModel).then(function () {
            localDBService.GetAll(dbModel.objectStoreName.stafflocations).then(function (staffLocations) {
                $scope.staffLocations = staffLocations;
            });
            localDBService.GetAll(dbModel.objectStoreName.globalcodes).then(function (result) {
                $scope.appointmentTypes = commonService.GetGlobalCodes('APPOINTMENTTYPE', result);
                $scope.showTimeAs = commonService.GetGlobalCodes('SHOWTIMEAS', result);
            });
        });

        localDBService.Open(dbModel).then(function () {
            localDBService.GetAll(dbModel.objectStoreName.mypreference).then(function (myPreferenceresult) {
                $scope.username = myPreferenceresult[0]['staffName'];
            },
            function (error) {
                $scope.error = error;
            });
        });

        var _getEvents = function () {
            $scope.$watch(function () { return briefcaseService.UpdatedOn }, function (newdate, olddate) {
                if (briefcaseService.UpdatedOn) {
                    _renderEvents();
                }
            });
            $scope.$watch(function () { return remotePersistenceStrategy.actioncompleted }, function (newValue, oldValue) {
                if (remotePersistenceStrategy.actioncompleted) {
                    remotePersistenceStrategy.actioncompleted = false;
                    _renderEvents();
                }
            });
            _renderEvents();
        }

        var _clearEvents = function () {
            $('#calendar').fullCalendar('removeEvents', function (event) {
                return true;
            });
        }

        var _renderEvents = function () {
            localDBService.Open(dbModel).then(function () {
                localDBService.GetAll(dbModel.objectStoreName.calendarevent).then(function (result) {
                    var appointment = $.map(result, function (appointment, index) {
                        if (appointment.staffId == authService.GetCurrentStaffId()) {
                            return {
                                "appointmentId": appointment.appointmentId,
                                "title": appointment.subject,
                                "start": appointment.startTime,
                                "end": appointment.endTime,
                                "backgroundColor": appointment.readonly ? "#454b4e" : (appointment.serviceId || appointment.groupServiceId) ? "ff000000" : "#ff3300",
                                "borderColor": appointment.serviceId ? "#333333" : "#333333",
                                "tip": appointment.subject,
                                "serviceId": appointment.serviceId,
                                "isReadonly": appointment.readonly
                            };
                        }
                    });
                    var arr = $('#calendar').fullCalendar('clientEvents');
                    if (arr.length > 0 && _clearEvents()) {
                        $('#calendar').fullCalendar('addEventSource', appointment);
                    }
                    else
                        $('#calendar').fullCalendar('addEventSource', appointment);
                });
            });
        }

        var _calendarHeight = function () {
            if (commonService.GetMobileOperatingSystem() === "unknown")
                return $(window).height() - 200;
            else
                return $(window).height() - 100;
        }

        var _createAddAppointmentButton = function (where, text, id) {
            var my_button = '<img id="' + id + '" src="./images/Add_Appointment.png" class="addAppointment fc-state-default fc-corner-left fc-corner-right" title="Add Appointment"  data-toggle="modal" data-target="#myModal" ng-click="addNewEvent()"></img>';

            var temp = $compile(my_button)($scope);
            $("div.fc-" + where).append(temp);
        }

        var _createAddServiceAppointmentButton = function (where, text, id) {
            var my_button = '<a href="#/createservice"><img id="' + id + '" src="./images/Add_ServiceAppointment.png" class="addAppointment fc-state-default fc-corner-left fc-corner-right" title="Add Service Appointment"></img></a>';

            var temp = $compile(my_button)($scope);
            $("div.fc-" + where).append(temp);
        }

        var _createCalendarButton = function (where, text, id) {
            var my_button = '<button id="calendarbtn" class="fc-button fc-state-default fc-corner-left fc-corner-right"><span class="fa-calendar fa"></span></button><input type="hidden" id="datetimepicker" />';
            var temp = $compile(my_button)($scope);
            $("div.fc-" + where).append(temp);
        }

        var _openDialog = function (appointment) {
            var _Locations = $scope.staffLocations;
            var _AppointmentTypes = $scope.appointmentTypes;
            var _ShowTimeAs = $scope.showTimeAs;
            var _currentUserId = $scope.staffId;
            var _currentUserName = $scope.username;

            var modalInstance = $uibModal.open({
                backdrop: 'static',
                keyboard: false,
                animation: true,
                templateUrl: 'myModalContent.html',
                controller: 'ModalInstanceCtrl',
                size: 'lg',
                resolve: {
                    appmodify: function () { return appointment; },
                    locations: function () { return _Locations },
                    appointmentTypes: function () { return _AppointmentTypes },
                    showTimeAs: function () { return _ShowTimeAs },
                    currentUserId: function () { return _currentUserId },
                    currentUserName: function () { return _currentUserName },
                    commonService: function () { return commonService }
                }
            });

            modalInstance.result.then(function (selectedItem) {
                var authData = localStorageService.get('authorizationData');
                localPersistenceStrategy.save(selectedItem, 'appointmentId', 'calendarevent', authData).then(function (app) {
                    var unsavedObj = {
                        objectstorename: 'calendarevent',
                        localName: 'Appointment',
                        showDetails: true,
                        details: {
                            Subject: app.subject,
                            Start: app.startTime,
                            End: app.endTime
                        },
                        id: app.appointmentId
                    };

                    localPersistenceStrategy.insert(unsavedObj, 'objectstorename', dbModel.objectStoreName.objectstorenames).then(function (result) {
                        if (!result) {
                            commonService.UpdateLocalChangesCount();
                            if (Offline.state === 'up') {
                                syncService.Syncing = true;
                                remotePersistenceStrategy.saveIndividual(app.appointmentId, 'calendarevent').then(function (result) {
                                    syncService.Syncing = false;
                                    _renderEvents();
                                });
                            } else { _renderEvents(); }
                        }
                    });
                });
            }, function (reason) {
                if (reason.indexOf('delete') > -1) {
                    var arr = reason.split(',');
                    var appointmentId = parseInt(arr[1]);
                    localDBService.Open(dbModel).then(function () {
                        if (parseInt(arr[1]) < 0) {
                            localDBService.Delete(dbModel.objectStoreName.calendarevent, parseInt(arr[1])).then(function (key) {
                                _renderEvents();
                                localPersistenceStrategy.delete(key, 'objectstorenames').then(function (res) {
                                    commonService.UpdateLocalChangesCount();
                                });
                            });
                        }
                        else if (appointmentId > 0) {
                            localDBService.UpdateDeleted(dbModel.objectStoreName.calendarevent, undefined, parseInt(arr[1])).then(function (app) {
                                localPersistenceStrategy.insert({ objectstorename: 'calendarevent', localName: 'Appointment (' + app.subject + ')- Deleted', id: app.appointmentId }, 'objectstorename', dbModel.objectStoreName.objectstorenames).then(function (result) {
                                    if (!result) {
                                        commonService.UpdateLocalChangesCount();
                                        if (Offline.state === 'up') {
                                            syncService.Syncing = true;
                                            remotePersistenceStrategy.saveIndividual(app.appointmentId, 'calendarevent').then(function (result) {
                                                syncService.Syncing = false;
                                                _renderEvents();
                                            });
                                        } else { _renderEvents(); }
                                    }

                                });
                            });
                        }
                    });
                }
            });
        }

        var _renderCalendar = function () {
            $('#calendar').fullCalendar({
                height: _calendarHeight(),
                header: {
                    left: 'prev,next',
                    center: 'title',
                    right: 'agendaDay,agendaWeek,month'
                },
                defaultView: 'agendaDay',
                scrollTime: moment().subtract(1, 'hour').format('HH:mm:ss'),
                buttonText: {
                    month: 'M',
                    week: 'W',
                    day: 'D'
                },
                events: _getEvents(),
                editable: false,
                droppable: true,
                eventClick: function (calEvent, jsEvent, view) {
                    if (calEvent.serviceId) {
                        $location.path('/service/' + calEvent.appointmentId);
                        $scope.$apply();
                    }
                    //window.location.href = window.location.origin + window.location.pathname + '#/service/' + calEvent.appointmentId;
                    else if (calEvent.appointmentId)
                        persistenceService.getById(calEvent.appointmentId, dbModel.objectStoreName.calendarevent).then(function (appointment) {
                            _openDialog(appointment.target.result);
                        },
                       function (error) {
                           $scope.error = error;
                       });
                },
                eventRender: function (event, element) {
                    element.attr('title', event.tip);
                },
                viewRender: function (e) {
                    if (window.innerWidth > window.innerHeight) {
                        $('#calendar').fullCalendar('option', 'height', $(window).height());
                    }
                    else { $('#calendar').fullCalendar('option', 'height', _calendarHeight()) }
                } //View Change event
            });
        }

        _renderCalendar();
        _createAddAppointmentButton("right", "", "my_button");
        _createAddServiceAppointmentButton("right", "", "my_button");
        _createCalendarButton("left", "Calendar", "my_button");
        var $btn = $('#calendarbtn');
        var $datetimepicker = $('#datetimepicker');

        $datetimepicker.datetimepicker({
            widgetParent: $btn, showClose: true, format: 'MM/DD/YYYY', showTodayButton: true
        });

        $btn.click(function (e) {
            $datetimepicker.data('DateTimePicker').viewMode('days');
            $datetimepicker.data('DateTimePicker').toggle();
        });

        $datetimepicker.on("dp.change", function (e) {
            $('#calendar').fullCalendar('gotoDate', e.date);
            $('.bootstrap-datetimepicker-widget table td span').css({ 'float': 'left', 'width': '65px' });
            $('a[data-action="close"] span,a[data-action="today"] span').css("float", "none");
            $datetimepicker.data('DateTimePicker').hide();
        });

        $datetimepicker.on("dp.update", function (e) {
            $('.bootstrap-datetimepicker-widget table td span').css({ 'float': 'left', 'width': '65px' });
            $('a[data-action="close"] span,a[data-action="today"] span').css("float", "none");

        });

        $datetimepicker.on("dp.show", function (e) {
            $('.bootstrap-datetimepicker-widget table td span').css({ 'float': 'left', 'width': '65px' });
            $('a[data-action="close"] span,a[data-action="today"] span').css("float", "none");

        });
    }]);

app.controller('ModalInstanceCtrl', function ($scope, $uibModalInstance, appmodify, locations, appointmentTypes, showTimeAs, currentUserId, currentUserName, commonService) {
    $scope.locations = locations;
    $scope.appointmentTypes = appointmentTypes;
    $scope.showTimeAs = showTimeAs;
    $scope.cannotdelete = true;

    var startTime = new Date();
    var endTime = new Date();

    if (startTime.getMinutes() > 0) {
        startTime.setHours(startTime.getHours() + 1,0,0,0);

        endTime.setHours(startTime.getHours() + 1, 0, 0, 0);
    }

    var appointment = {
        subject: '',
        locationId: "",
        specificLocation: '',
        startTime: new Date(startTime.getFullYear(), startTime.getMonth(), startTime.getDate(), startTime.getHours(), startTime.getMinutes(), 0),//
        endTime: new Date(endTime.getFullYear(), endTime.getMonth(), endTime.getDate(), endTime.getHours(), endTime.getMinutes(), 0),//,
        startFormatted: new Date(startTime.getFullYear(), startTime.getMonth(), startTime.getDate(), startTime.getHours(), startTime.getMinutes(), 0),
        endFormatted: new Date(endTime.getFullYear(), endTime.getMonth(), endTime.getDate(), endTime.getHours(), endTime.getMinutes(), 0),
        appointmentType: '',
        showTimeAs: '',
        staffId: currentUserId,
        staffName: currentUserName,
        description: '',
        appointmentTypeColor: "ff00c0c0",
        backgroundColor: "#ff3300",
        borderColor: "#333333"
    };

    if (appmodify) {
        appointment = appmodify;

        //var startTime = new Date(commonService.ISO8601DateTime(appmodify.startTime));
        //var endTime = new Date(commonService.ISO8601DateTime(appmodify.endTime));
        var startTime = new Date(appmodify.startTime);
        var endTime = new Date(appmodify.endTime);

        appointment.startFormatted = new Date(startTime.getFullYear(), startTime.getMonth(), startTime.getDate(), startTime.getHours(), startTime.getMinutes(), 0);
        appointment.endFormatted = new Date(endTime.getFullYear(), endTime.getMonth(), endTime.getDate(), endTime.getHours(), endTime.getMinutes(), 0);

        //appointment.startFormatted = moment(new Date(appmodify.startTime)).format('MM/DD/YYYY hh:mm A');
        //appointment.endFormatted = moment(new Date(appmodify.endTime)).format('MM/DD/YYYY hh:mm A');
        appointment.staffName = currentUserName;
        $scope.cannotdelete = false;
    }

    $scope.appointment = appointment;

    $scope.ok = function () {
        $uibModalInstance.close($scope.appointment);
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.delete = function () { $uibModalInstance.dismiss('delete,' + appointment.appointmentId); };

    $scope.$watch(function () { return appointment.appointmentType }, function (newvalue, oldvalue) {
        if (newvalue) {
            $scope.appointment.appointmentType = newvalue;
        }
    });

    $scope.$watch(function () { return appointment.startFormatted }, function (newvalue, oldvalue) {
        if (newvalue && newvalue.getHours() === 0 && newvalue.getMinutes() === 0 && newvalue.getMilliseconds() === 0) {
            var d = new Date();
            newvalue.setHours(d.getHours());
            newvalue.setMinutes(d.getMinutes());
            $scope.appointment.startTime = moment(new Date(newvalue.getFullYear(), newvalue.getMonth(), newvalue.getDate(), newvalue.getHours(), newvalue.getMinutes(), 0)).format('MM/DD/YYYY hh:mm A');
        }
        else if (newvalue) $scope.appointment.startTime = moment(new Date(newvalue.getFullYear(), newvalue.getMonth(), newvalue.getDate(), newvalue.getHours(), newvalue.getMinutes(), 0)).format('MM/DD/YYYY hh:mm A');
        else $scope.appointment.startTime = newvalue;
    });

    $scope.$watch(function () { return appointment.endFormatted }, function (newvalue, oldvalue) {
        if (newvalue && newvalue.getHours() === 0 && newvalue.getMinutes() === 0 && newvalue.getMilliseconds() === 0) {
            var d = new Date();
            newvalue.setHours(d.getHours());
            newvalue.setMinutes(d.getMinutes());
            $scope.appointment.endTime = moment(new Date(newvalue.getFullYear(), newvalue.getMonth(), newvalue.getDate(), newvalue.getHours(), newvalue.getMinutes(), 0)).format('MM/DD/YYYY hh:mm A');
        }
        else if (newvalue) $scope.appointment.endTime = moment(new Date(newvalue.getFullYear(), newvalue.getMonth(), newvalue.getDate(), newvalue.getHours(), newvalue.getMinutes(), 0)).format('MM/DD/YYYY hh:mm A');
        else $scope.appointment.endTime = newvalue;
    });
    
    if (commonService.GetMobileOperatingSystem() === "unknown") {
        $uibModalInstance.rendered.then(function () {
            $('input[type=time]').datetimepicker({ showClose: true, format: 'HH:mm' }).on("dp.change", function (a) {//{ format: 'DD/MM/YYYY' } 
                var datesel = a.date._d;
                if (datesel) {
                    var name = $(this)[0].name;
                    switch (name) {
                        case "start":
                            appointment.startTime = datesel;
                            appointment.startFormatted = new Date(datesel.getFullYear(), datesel.getMonth(), datesel.getDate(), datesel.getHours(), datesel.getMinutes(), 0);// moment(new Date(datesel)).format('yyyy-MM-dd');
                            break;
                        case "end":
                            appointment.endTime = datesel;
                            appointment.endFormatted = new Date(datesel.getFullYear(), datesel.getMonth(), datesel.getDate(), datesel.getHours(), datesel.getMinutes(), 0);// moment(new Date(datesel)).format('yyyy-MM-dd');
                            break;
                    }

                    $scope.appointment = appointment;
                }
            });
            $('input[autofocus]').focus().select();
        });
    }
});