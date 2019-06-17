'use strict';
app.controller('createserviceController', ['$scope', '$q', 'ngAuthSettings', 'authService', 'localDBService', 'dbModel', 'commonService',
    'localPersistenceStrategy', 'localStorageService', '$location', 'persistenceService', 'remotePersistenceStrategy', '$uibModal', 'Notification', '$compile','syncService', function ($scope, $q, ngAuthSettings, authService, localDBService, dbModel, commonService,
        localPersistenceStrategy, localStorageService, $location, persistenceService, remotePersistenceStrategy, $uibModal, Notification, $compile, syncService) {
        if (authService.getprivatekeyrequired() == true) {
            $location.path('/login/UL');
            return;
        }
        var authData = localStorageService.get('authorizationData');
        var parts = $location.absUrl().split('/');
        var ID = '';
        var action = '';
        $scope.CurrentGoals = [];
        $scope.isNonEditable = false;
        $scope.$parent.isNonEditable = false;

        if ($.isNumeric(parts[parts.length - 1])) {
            action = parts[parts.length - 2]
            ID = Number(parts[parts.length - 1]);
        }
        else { action = parts[parts.length - 1]; }

        var self = this;
        self.serviceId = -1;
        self.documentVersionId = -1;
        $scope.appointmentId = ID;

        $scope.loadCFTempalte = function () {
            var cfelement = document.getElementById('customfield');
            if (cfelement) {
                var cfScope = $scope.$new();
                for (var key in $scope.appointment.service.customFields) {
                    if ($scope.appointment.service.customFields && $scope.appointment.service.customFields[key] && typeof ($scope.appointment.service.customFields[key]) == "string") {
                        $scope.appointment.service.customFields[key] = $.parseJSON($scope.appointment.service.customFields[key])[0];
                    } else { $scope.appointment.service.customFields[key] = $scope.appointment.service.customFields[key]; }
                }

                cfScope.cf = $scope.appointment.service.customFields;
                cfScope.serviceId = $scope.appointment.service.serviceId;
                var cfcompileFn = $compile(cfelement);
                cfcompileFn(cfScope);
            }
        }

        $scope.loadNoteTemplate = function () {
            var noteElement = document.getElementById('noteDocument');
            if (noteElement) {
                var noteScope = $scope.$new();

                for (var key in $scope.appointment.service.document.documentVersion.note) {
                    if ($scope.appointment.service.document.documentVersion.note && $scope.appointment.service.document.documentVersion.note[key] && typeof ($scope.appointment.service.document.documentVersion.note[key]) == "string") {
                        $scope.appointment.service.document.documentVersion.note[key] = $.parseJSON($scope.appointment.service.document.documentVersion.note[key])[0];
                    } else { $scope.appointment.service.document.documentVersion.note[key] = $scope.appointment.service.document.documentVersion.note[key]; }
                }
                noteScope.serviceNote = $scope.appointment.service.document.documentVersion.note
                noteScope.documentVersionId = $scope.appointment.service.document.documentVersion.documentVersionId;
                var notecompileFn = $compile(noteElement);
                notecompileFn(noteScope);
            }
        }

        var currentDate = new Date();
        var appointment = {
            appointmentId: -1,
            staffId: '',
            subject: '',
            appointmentType: 4761,
            startTime: '',
            endTime: '',
            showTimeAs: 4342,
            locationId: '',
            serviceId: self.serviceId,
            createdBy: authData.userName,
            createdDate: currentDate,
            modifiedBy: authData.userName,
            modifiedDate: currentDate,
            service: {
                serviceId: self.serviceId,
                clientId: '',
                procedureCodeId: '',
                dateOfService: '',
                //endDateOfService: '',
                dateOfServiceFormatted: '',
                //endDateOfServiceFormatted: '',
                unit: '',
                //unitType: 110,//Minute
                //unitDisplay:'',
                status: 71,
                clinicianId: '',
                programId: '',
                locationId: '',
                clinicianName: '',
                attendingId: '',
                specificLocation: '',
                customFields: {},
                billable: 'Y',
                createdBy: authData.userName,
                createdDate: currentDate,
                modifiedBy: authData.userName,
                modifiedDate: currentDate,
                //dateTimeIn: '',
                //dateTimeOut: '',
                diagnosis: [],
                procedureCodeName: '',
                locationName: '',
                programName:'',
                document: {
                    documentId: -1,
                    createdBy: authData.userName,
                    createdDate: currentDate,
                    modifiedBy: authData.userName,
                    modifiedDate: currentDate,
                    clientId: '',
                    serviceId: self.serviceId,
                    documentCodeId: '',
                    effectiveDate: currentDate,
                    status: 21,
                    authorId: '',
                    currentDocumentVersionId: -1,
                    inProgressDocumentVersionId: -1,
                    currentVersionStatus: 21,
                    appointmentId: -1,
                    signedByAll: 'Y',
                    signedByAuthor: 'Y',
                    documentVersion: {
                        documentVersionId: -1,
                        createdBy: authData.userName,
                        createdDate: currentDate,
                        modifiedBy: authData.userName,
                        modifiedDate: currentDate,
                        documentId: -1,
                        version: 1,
                        authorId: '',
                        effectiveDate: currentDate,
                        note: {},
                        documentServiceNoteGoals: [],
                        documentServiceNoteObjectives: []
                    }
                }
            }
        };
        $scope.diagnosisOrder = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        $scope.baseUrl = ngAuthSettings.virtualDirectoryURL;
        if (ID && action == "service") {
            $scope.title = "Service Detail";
        }
        else {
            $scope.title = "Create Service";
            $scope.customfieldUrl = "app/views/custom/customfield/customservices.html";
            var currentDateTime = new Date();
			
            appointment.service.dateOfService = appointment.service.dateTimeIn = appointment.startTime = moment(currentDateTime).format('MM/DD/YYYY hh:mm A');
            appointment.service.dateOfServiceFormatted = new Date(currentDateTime.getFullYear(), currentDateTime.getMonth(), currentDateTime.getDate(), currentDateTime.getHours(), currentDateTime.getMinutes(), 0);

            if (action == "createservice" && ID) {
                appointment.service.clientId = ID;
                appointment.service.document.clientId = ID;
                $('#ddClients').attr('disabled', 'disabled');
            }
        }



        localDBService.Open(dbModel).then(function () {
            localDBService.GetAll(dbModel.objectStoreName.caseload).then(function (result) {
                $scope.caseloads = result;
            });

            localDBService.GetAll(dbModel.objectStoreName.globalcodes).then(function (result) {
                $scope.serviceStatuses = commonService.GetGlobalCodes('SERVICESTATUS', result);
            });

            localDBService.GetAll(dbModel.objectStoreName.staffprocedurecodes).then(function (staffProcedureCodes) {
                $scope.staffProcedureCodes = staffProcedureCodes;
            });

            localDBService.GetAll(dbModel.objectStoreName.staffprograms).then(function (staffPrograms) {
                $scope.staffPrograms = staffPrograms;
            });

            localDBService.GetAll(dbModel.objectStoreName.stafflocations).then(function (staffLocations) {
                $scope.staffLocations = staffLocations;
            });

            localDBService.GetAll(dbModel.objectStoreName.serviceattending).then(function (serviceAttending) {
                $scope.serviceAttendings = serviceAttending;
            });

            if (ID && action == "service") {
                _getAppointmentDetails(ID, dbModel.objectStoreName.calendarevent);
            }
        });

        if (commonService.GetMobileOperatingSystem() === "unknown") {
            $('input[type=time]').datetimepicker({ showClose: true, format: 'HH:mm' }).on("dp.change", function (a) {//{ format: 'DD/MM/YYYY' } 
                var datesel = a.date._d;
                if (datesel) {
                    //if ((!($scope.appointment.service.dateOfServiceFormatted > datesel || datesel > $scope.appointment.service.dateOfServiceFormatted))){
                    var name = $(this)[0].name;

                    switch (name) {
                        case "start":
                            $scope.appointment.service.dateOfServiceFormatted = new Date(datesel.getFullYear(), datesel.getMonth(), datesel.getDate(), datesel.getHours(), datesel.getMinutes(), 0);// moment(new Date(datesel)).format('yyyy-MM-dd');
                            break;
                    }
                }
            });
        }

        var _decideGoalsFilteredBy = function () {
            if ($scope.caseloads) {
                if ($scope.appointment.service.document.clientId) {
                    var caseLoad = $.grep($scope.caseloads, function (cl) { return cl.clientId == $scope.appointment.service.document.clientId; });
                    if (caseLoad) {
                        parseGoalsAndObjectives(caseLoad[0]);
                    }
                }
            }
            else {
                persistenceService.getById($scope.appointment.service.document.clientId, dbModel.objectStoreName.caseload).then(function (caseload) {
                    parseGoalsAndObjectives(caseload.target.result);
                });
            }
        }

        var _bindClinicians = function (programId) {
            if (programId) {
                localDBService.Open(dbModel).then(function () {
                    localDBService.GetAll(dbModel.objectStoreName.serviceclinicians).then(function (cl) {
                        $scope.clinicians = $.grep(cl, function (sp) { if (sp.programId == programId) { return sp; } });
                        //Clinician Change is allowed only for Scheduled Service
                        if ($scope.appointment.service.status != 70) {
                            localDBService.GetAll(dbModel.objectStoreName.mypreference).then(function (myPreferenceresult) {
                                $scope.appointment.service.clinicianId = $scope.appointment.staffId = $scope.appointment.service.document.authorId = $scope.appointment.service.document.documentVersion.authorId = $scope.staffId = myPreferenceresult[0]['staffId'];
                            });
                        }
                    });
                });
            }
        }

        var _changeProcedureCode = function (newPrId, oldPrId) {
            var $proc = $('#ddProcedureCode option:selected');
            if (newPrId) {
                $scope.appointment.service.procedureCodeId = newPrId;
                if (!ID && newPrId != oldPrId)
                    $scope.appointment.subject = 'Client: ' + $('#ddClients option:selected').text() + '(#' + $('#ddClients').val().replace('number:', '') + ')-' + $proc.text();

                if (action == "createservice")
                    $scope.appointment.subject = 'Client: ' + $('#ddClients option:selected').text() + '(#' + $('#ddClients').val().replace('number:', '') + ')-' + $proc.text();


                if ($scope.staffProcedureCodes) {
                    var procedureCode = $.grep($scope.staffProcedureCodes, function (sp) { return sp.procedureCodeId == newPrId });
                    if (procedureCode) {
                        $scope.appointment.service.document.documentCodeId = procedureCode[0].associatedNoteId;
                        $scope.appointment.service.procedureCodeName = procedureCode[0].procedureCodeName;
                        if (Offline.state == 'up') {
                            $scope.noteTemplateUrl = "app/views/custom/document/document_" + procedureCode[0].associatedNoteId + ".html?_=" + new Date().getTime();
                        }
                        else {
                            $scope.noteTemplateUrl = "app/views/custom/document/document_" + procedureCode[0].associatedNoteId + ".html";
                            $scope.loadNoteTemplate();
                        }
                    }
                }
                else {
                    persistenceService.getById(newPrId, dbModel.objectStoreName.staffprocedurecodes).then(function (spCode) {
                        if (spCode.target.result) {
                            var associatedNoteId = spCode.target.result.associatedNoteId;
                            $scope.appointment.service.document.documentCodeId = associatedNoteId;
                            if (Offline.state == 'up') {
                                $scope.noteTemplateUrl = "app/views/custom/document/document_" + associatedNoteId + ".html?_=" + new Date().getTime();
                            }
                            else {
                                $scope.noteTemplateUrl = "app/views/custom/document/document_" + associatedNoteId + ".html";
                                $scope.loadNoteTemplate();
                            }
                        }
                    });
                }
                _decideGoalsFilteredBy();
            }
        }
        $scope.$watch(function () { return $scope.appointment.service.procedureCodeId; }, function (newPrId, oldPrId) {
            _changeProcedureCode(newPrId, oldPrId);
        });

        $scope.$watch(function () { return $scope.appointment.service.locationId; }, function (newlcId, oldlcId) {
            if (newlcId) {
                $scope.appointment.service.locationId = newlcId;
                $scope.appointment.locationId = newlcId
                if ($scope.staffLocations) {
                    var location = $.grep($scope.staffLocations, function (sp) { return sp.locationId == newlcId });
                    if (location) {
                        $scope.appointment.service.locationName = location[0].locationName;
                    }
                }
            }
        });

        $scope.$watch(function () { return $scope.appointment.service.clientId; }, function (newClientId, oldClientId) {
            if (newClientId) {
                $scope.appointment.service.document.clientId = newClientId;

                if ($scope.caseloads) {
                    var caseLoad = $.grep($scope.caseloads, function (cl) { return cl.clientId == newClientId; });
                    if (caseLoad) {
                        parseGoalsAndObjectives(caseLoad[0]);
                        // Disable the ClientDropdown if the data saved
                        localPersistenceStrategy.exists($scope.appointment.appointmentId, dbModel.objectStoreName.calendarevent, 'appointmentId').then(function (exist) {
                            if (!exist)
                                parseServiceDiagnosis(caseLoad[0]);
                            else
                                $('#ddClients').attr('disabled', 'disabled');
                        });
                    }
                }
                else {
                    persistenceService.getById($scope.appointment.service.document.clientId, dbModel.objectStoreName.caseload).then(function (caseload) {
                        var caseLoad = caseload.target.result;
                        parseGoalsAndObjectives(caseLoad);
                        // Disable the ClientDropdown if the data saved
                        localPersistenceStrategy.exists($scope.appointment.appointmentId, dbModel.objectStoreName.calendarevent, 'appointmentId').then(function (exist) {
                            if (!exist)
                                parseServiceDiagnosis(caseLoad);
                            else
                                $('#ddClients').attr('disabled', 'disabled');
                        });
                    });
                }
            }
        });

        $scope.$watch(function () { return $scope.appointment.service.dateOfServiceFormatted; }, function (newDOS, OldDOS) {
            if (newDOS) {
                var currentDateTime = new Date(newDOS);
                $scope.appointment.service.dateOfService
                    = $scope.appointment.service.dateTimeIn
                    = $scope.appointment.startTime
                    = moment(new Date(currentDateTime.getFullYear(), currentDateTime.getMonth(), currentDateTime.getDate(), currentDateTime.getHours(), currentDateTime.getMinutes(), 0)).format('MM/DD/YYYY hh:mm A');
            }
            else
            {
                $scope.appointment.service.dateOfService
                    = $scope.appointment.service.dateTimeIn
                    = $scope.appointment.startTime = "";
            }
            _decideGoalsFilteredBy();
        });

        //$scope.$watch(function () { return $scope.appointment.service.endDateOfServiceFormatted; }, function (newDOS, OldDOS) {
        //    $scope.appointment.service.endDateOfService = $scope.appointment.service.dateTimeOut = $scope.appointment.endTime = newDOS;
        //    _setUnitValue();
        //});

        $scope.$watch(function () { return $scope.appointment.service.programId; }, function (newPrId, oldPrId) {
            $scope.appointment.service.programId = newPrId;
            _decideGoalsFilteredBy();
            _bindClinicians(newPrId);
        });

        $scope.$watch(function () { return $scope.appointment.service.clinicianId; }, function (newClId, oldClId) {
            $scope.appointment.service.clinicianId = $scope.appointment.staffId = $scope.appointment.service.document.authorId = $scope.appointment.service.document.documentVersion.authorId = $scope.staffId = newClId;
        });

        $scope.isGoalsObjectiveCollapsed = false;
        $scope.isNoteCollapsed = false;
        $scope.isDiagnosisCollapsed = false;
        $scope.isCustomFieldCollapsed = false;
        $scope.isServiceDetailCollapsed = false;

        $scope.save = function (status) {
            Notification.clearAll()

            // Specific Validation.
            if (!$scope.appointment.service.unit) {
                commonService.ShowtostMessage('Duration cannot be empty', 'error', 2000);
                return;
            }

            commonService.ShowProcessing();

            $scope.isNonEditable = true;
            $scope.$parent.isNonEditable = true;
            $(window).scrollTop(0);

            var deferred = $q.defer();
            var cfelement = document.getElementById('customfield');
            var noteElement = document.getElementById('noteDocument');
            var cfScope = angular.element(cfelement).scope();
            var noteScope = angular.element(noteElement).scope();
            if ($scope.$parent.appointment == undefined)
                $scope.$parent.appointment = $scope.appointment;

            if (cfScope && cfScope.cf) {
                for (var key in cfScope.cf) {
                    if (cfScope.cf[key] && $scope.$parent.appointment.service.customFields) {
                        if (typeof (cfScope.cf[key]) != "string")
                            $scope.$parent.appointment.service.customFields[key] = '[' + JSON.stringify(cfScope.cf[key]) + ']';
                        else { $scope.$parent.appointment.service.customFields[key] = cfScope.cf[key]; }
                    }
                    else if (!$scope.$parent.appointment.service.customFields) {
                        $scope.$parent.appointment.service.customFields = {};
                        $scope.$parent.appointment.service.customFields[key] = '[' + JSON.stringify(cfScope.cf[key]) + ']';
                    }
                }
            }

            if (noteScope && noteScope.serviceNote) {
                for (var key in noteScope.serviceNote) {
                    if (noteScope.serviceNote[key] && $scope.$parent.appointment.service.document.documentVersion.note) {
                        if (typeof (noteScope.serviceNote[key]) != "string") {
                            $scope.$parent.appointment.service.document.documentVersion.note[key] = '[' + JSON.stringify(noteScope.serviceNote[key]) + ']';
                        }
                        else { $scope.$parent.appointment.service.document.documentVersion.note[key] = noteScope.serviceNote[key]; }
                    }
                    else if (!$scope.$parent.appointment.service.document.documentVersion.note) {
                        $scope.$parent.appointment.service.document.documentVersion.note = {};
                        $scope.$parent.appointment.service.document.documentVersion.note[key] = '[' + JSON.stringify(noteScope.serviceNote[key]) + ']';
                    }
                }
            }
            //To Reset the Status on Save
            if (status) {
                $scope.$parent.appointment.service.document.status = status;
                $scope.$parent.appointment.service.document.currentVersionStatus = status;
            }
            var appointment = $scope.$parent.appointment;
            var unsavedObj = {
                objectstorename: 'calendarevent',
                localName: 'Service Appointment',
                showDetails: true,
                details: {
                    Subject: appointment.subject,
                    Start: appointment.startTime,
                    End: appointment.endTime,
                    Redirect: '#/service/' + appointment.appointmentId
                },
                id: appointment.appointmentId
            };

            var authData = localStorageService.get('authorizationData');

            localPersistenceStrategy.save(appointment, 'appointmentId', 'calendarevent', authData).then(function (app) {
                localPersistenceStrategy.insert(unsavedObj, 'objectstorename', dbModel.objectStoreName.objectstorenames).then(function (result) {
                    if (!result) {
                        commonService.UpdateLocalChangesCount();
                        if (Offline.state == 'down') {
                            persistenceService.getById(app.appointmentId, dbModel.objectStoreName.calendarevent).then(function (event) {
                                event = event.target.result;
                                if (event) {
                                    setScreenValues(event);
                                    //$scope.loadCFTempalte();
                                    commonService.HideProcessing();
                                    deferred.resolve(event);
                                }
                            });

                            $scope.isNonEditable = false;
                            $scope.$parent.isNonEditable = false;
                        }
                        else {
                            syncService.Syncing = true;
                            remotePersistenceStrategy.saveIndividual(app.appointmentId, dbModel.objectStoreName.calendarevent).then(function (result) {
                                syncService.Syncing = false;
                                var appointment = result.savedResult;
                                $scope.$parent.appointment = $scope.appointment = appointment;
                                setScreenValues(appointment);
                                //$scope.loadCFTempalte();
                                commonService.HideProcessing();
                                deferred.resolve(result);
                            });
                        }
                    }
                });
            });
            return deferred.promise;
        };
        $scope.sign = function () {
            if ($scope.$parent.appointment == undefined)
                $scope.$parent.appointment = $scope.appointment;

            var serviceStatus = $scope.$parent.appointment.service.status;

            if (serviceStatus == 76 || serviceStatus == 70 || serviceStatus == 72 || serviceStatus == 73) {
                commonService.ShowtostMessage("You can not sign the Service with current Status", "error", 2000);
                return;
            }
            openSignatureDialog();
        };

        var openSignatureDialog = function () {
            var uibModalInstance = $uibModal.open({
                backdrop: 'static',
                keyboard: false,
                animation: true,
                templateUrl: 'validatepassword.html',
                controller: 'SignModalInstanceCtrl',
                size: 'sm'
            });

            uibModalInstance.result.then(function () {
                $scope.$parent.appointment.service.document.status = 24;
                $scope.$parent.appointment.service.document.currentVersionStatus = 24;
                $scope.save().then(function (result) {
                    if (result) {
                        if ((result.savedResult && result.savedResult.service.document.status == 24 && !result.serviceValidationMessages) || (result.savedResult && result.savedResult.service.document.status == 22) || (result.service && result.service.document.status == 24)) {
                            $scope.isNonEditable = true;
                            $scope.$parent.isNonEditable = true;
                        }

                        if (result.serviceValidationMessages) {
                            var validations;
                            if (typeof (result.serviceValidationMessages) === "string")
                                validations = $.parseJSON(result.serviceValidationMessages);
                            else
                                validations = result.serviceValidationMessages;
                            showNotification(validations);
                            //if (appointment.service.document.status == 24); {
                            //    $location.path('/service/' + savedResult.appointmentId); return;
                            //}
                        }
                    }
                });
            });
        };

        var _getAppointmentDetails = function (ID, datastore) {
            persistenceService.getById(ID, datastore).then(function (event) {
                if (event.target.result) {
                    setScreenValues(event.target.result);
                }
            });
        };

        var setScreenValues = function (app) {
            var note;
            $scope.appointment = app;

            _changeProcedureCode($scope.appointment.service.procedureCodeId, 0);
            self.serviceId = app.service.serviceId;
            self.documentVersionId = app.service.document.currentDocumentVersionId;


            note = app.service.document.documentVersion.note;
            for (var key in note) {
                if (note[key]) {
                    if (typeof (note[key]) == "string")
                        note = $.parseJSON(note[key])[0];
                    else
                        note = note[key];

                    app.service.document.documentVersion.note[key] = note;
                    self.note = app.service.document.documentVersion.note;
                }
            }
            for (var key in app.service.customFields) {
                if (typeof (app.service.customFields[key]) == "string") {
                    app.service.customFields[key] = $.parseJSON(app.service.customFields[key])[0];
                    self.cf = app.service.customFields;

                }
                else
                    self.cf = app.service.customFields;
            }


            $scope.appointment.service.diagnosis = app.service.diagnosis;
            //var dateofService = new Date(app.service.dateOfService);
            var dateofService = new Date(commonService.ISO8601DateTime(app.service.dateOfService));

            $scope.appointment.service.dateOfServiceFormatted = new Date(dateofService.getFullYear(), dateofService.getMonth(), dateofService.getDate(), dateofService.getHours(), dateofService.getMinutes(), 0);

            $scope.appointment.service.unitDisplay = $scope.appointment.service.unit+' Minutes'
            if (Offline.state == 'up') {
                $scope.customfieldUrl = "app/views/custom/customfield/customservices.html?_=" + new Date().getTime();
            }
            else {
                $scope.customfieldUrl = "app/views/custom/customfield/customservices.html";
                $scope.loadCFTempalte();
            }

            if (($scope.appointment.service.document.status == 24 && !$scope.appointment.service.serviceValidations) || $scope.appointment.service.document.status == 22) {
                $scope.isNonEditable = true;
                $scope.$parent.isNonEditable = true;
            }
            else {
                $scope.isNonEditable = false;
                $scope.$parent.isNonEditable = false;
            }
        }

        var showNotification = function (validations)
        { $scope.notificationHeader = "Service Validation"; $scope.validations = validations; Notification.primary({ message: "Just message", templateUrl: "custom_template.html", scope: $scope }); };

        var parseGoalsAndObjectives = function (caseload) {
            if (caseload && caseload.currentGoals) {
                
                var goals = $.parseJSON(caseload.currentGoals.replace(/'/g, '"').replace("&quot;", "'"));
                var addressedGoals = $scope.appointment.service.document.documentVersion.documentServiceNoteGoals;

                var goalNumbers = [];

                for (var gl = 0; gl < addressedGoals.length; gl++) {
                    if (!$.inArray(addressedGoals[gl].goalNumber, goalNumbers) > -1) {
                        goalNumbers.push(addressedGoals[gl].goalNumber);
                    }
                }

                $scope.CurrentGoals = $.grep(goals, function (g) {
                    if ($scope.appointment.service.document.documentVersion.documentServiceNoteGoals) {

                        if ($.inArray(parseFloat(g.GoalNumber), goalNumbers) > -1)
                        { g.IsChecked = 'Y'; }
                        else { g.IsChecked = 'N'; }
                    }
                    
                    if (g.ProcedureCodeId && $scope.appointment.service.procedureCodeId && $scope.appointment.service.dateOfService && g.EffectiveDate)
                        return g.ProcedureCodeId == $scope.appointment.service.procedureCodeId && new Date(g.EffectiveDate) <= new Date($scope.appointment.service.dateOfService);
                    else if (g.ProgramId && $scope.appointment.service.programId && $scope.appointment.service.dateOfService && g.EffectiveDate)
                        return g.ProgramId == $scope.appointment.service.programId;
                    else if (g.EffectiveDate && $scope.appointment.service.dateOfService)
                        return new Date(g.EffectiveDate) <= new Date($scope.appointment.service.dateOfService);
                    //else return g;                    
                });
            }
            else $scope.CurrentGoals = [];

            if (caseload && caseload.currentObjectives) {
                var objectives = $.parseJSON(caseload.currentObjectives.replace(/'/g, '"').replace("&quot;", "'"));
                var addressedObjectives = $scope.appointment.service.document.documentVersion.documentServiceNoteObjectives;

                var objNumbers = [];
                for (var ol = 0; ol < addressedObjectives.length; ol++) {
                    if (!$.inArray(addressedObjectives[ol].objectiveNumber, objNumbers) > -1) {
                        objNumbers.push(addressedObjectives[ol].objectiveNumber);
                    }
                }
                $scope.CurrentObjectives = $.grep(objectives, function (o) {
                    if ($scope.appointment.service.document.documentVersion.documentServiceNoteObjectives) {
                        if ($.inArray(parseFloat(o.ObjectiveNumber), objNumbers) > -1)
                        { o.IsChecked = 'Y'; }
                        else { o.IsChecked = 'N'; }
                    }
                    return o;
                });
            }
            else $scope.CurrentObjectives = [];
        }

        var parseServiceDiagnosis = function (caseload) {
            if (caseload && caseload.diagnosis) {
                //if (!ID) {
                    var newArray = $.parseJSON(caseload.diagnosis.replace(/'/g, '"'));
                    var serviceDiagnosisId = -1;
                    $scope.appointment.service.diagnosis = $.map(newArray, function (arr) {
                        return {
                            serviceDiagnosisId: serviceDiagnosisId--,
                            createdBy: authData.userName,
                            createdDate: currentDate,
                            modifiedBy: authData.userName,
                            modifiedDate: currentDate,
                            serviceId: -1,
                            dsmCode: '',
                            dsmNumber: '',
                            dsmvCodeId: arr.DSMVCodeId,
                            icD10Code: arr.ICD10Code,
                            icD9Code: arr.ICD9Code,
                            order: arr.DiagnosisOrder,
                            description: arr.Description,
                        };
                    });
                //}
            }
            else $scope.appointment.service.diagnosis = [];
        }

        $scope.addressGoal = function (GoalNumber, GoalText, GoalId, CustomGoalActive, value) {
            //value is getting overwritten here. To get actual value added below code (Need to fix and remove this Code)
            var $goalcbox = $('#cbGoal_' + GoalNumber);
            if ($goalcbox.length > 0)
                value = $goalcbox[0].checked;
            var documentServiceNoteGoals = [] = $scope.appointment.service.document.documentVersion.documentServiceNoteGoals;
            if (documentServiceNoteGoals.length >= 0) {
                var minId = 0;
                var addressedGoal = $.grep(documentServiceNoteGoals, function (sng) { return sng.goalNumber == GoalNumber; });
                if (addressedGoal.length === 0) {
                    var sortGoals = documentServiceNoteGoals.sort(function (a, b) { return a.documentServiceNoteGoalId - b.documentServiceNoteGoalId });

                    if (sortGoals.length > 0)
                        minId = sortGoals[0].documentServiceNoteGoalId
                    if (minId > 0)
                        minId = -1;
                    else
                        minId -= 1;

                    var serviceNoteGoal = {
                        documentServiceNoteGoalId: minId,
                        createdBy: authData.userName,
                        createdDate: currentDate,
                        modifiedBy: authData.userName,
                        modifiedDate: currentDate,
                        documentVersionId: $scope.appointment.service.document.documentVersion.documentVersionId,
                        goalId: GoalId,
                        goalNumber: GoalNumber,
                        goalText: GoalText,
                        customGoalActive: CustomGoalActive,
                    };
                    $scope.appointment.service.document.documentVersion.documentServiceNoteGoals.push(serviceNoteGoal);
                }
                else {
                    $scope.appointment.service.document.documentVersion.documentServiceNoteGoals = $.map(documentServiceNoteGoals, function (goal) {
                        if (goal.goalNumber == addressedGoal[0].goalNumber) {
                            if (value && goal.documentServiceNoteGoalId < 0) {
                                goal.goalNumber = GoalNumber;
                                goal.goalText = GoalText;
                                goal.customGoalActive = CustomGoalActive;
                                goal.goalId = GoalId;
                                return goal;
                            }
                            else if (!value && goal.documentServiceNoteGoalId > 0) {
                                goal.recordDeleted = 'Y';
                                goal.deletedDate = moment().format();
                                goal.deletedBy = authData.userName;
                                return goal;
                            }
                        } else {
                            return goal;
                        }
                    });
                }
            }
        }

        $scope.addressObjective = function (ObjectiveNumber, ObjectiveText, GoalId, CustomObjectiveActive, value) {
            //value is getting overwritten here. To get actual value added below code (Need to fix and remove this Code)
            var $objcbox = $('#cbObjective_' + ObjectiveNumber.replace(/\./g, 'dot'));
            if ($objcbox.length > 0)
                value = $objcbox[0].checked;

            var documentServiceNoteObjectives = [] = $scope.appointment.service.document.documentVersion.documentServiceNoteObjectives;
            if (documentServiceNoteObjectives.length >= 0) {
                var minId = 0;
                var addressedObjective = $.grep(documentServiceNoteObjectives, function (sng) { return sng.objectiveNumber == ObjectiveNumber; });
                if (addressedObjective.length === 0) {
                    var sortObjectives = documentServiceNoteObjectives.sort(function (a, b) { return a.documentServiceNoteObjectiveId - b.documentServiceNoteObjectiveId });

                    if (sortObjectives.length > 0)
                        minId = sortObjectives[0].documentServiceNoteObjectiveId
                    if (minId > 0)
                        minId = -1;
                    else
                        minId -= 1;

                    var serviceNoteObjective = {
                        documentServiceNoteObjectiveId: minId,
                        createdBy: authData.userName,
                        createdDate: currentDate,
                        modifiedBy: authData.userName,
                        modifiedDate: currentDate,
                        documentVersionId: $scope.appointment.service.document.documentVersion.documentVersionId,
                        goalId: GoalId,
                        objectiveNumber: ObjectiveNumber,
                        objectiveText: ObjectiveText,
                        customObjectiveActive: CustomObjectiveActive,
                    };
                    $scope.appointment.service.document.documentVersion.documentServiceNoteObjectives.push(serviceNoteObjective);
                }
                else {
                    $scope.appointment.service.document.documentVersion.documentServiceNoteObjectives = $.map(documentServiceNoteObjectives, function (objective) {
                        if (objective.objectiveNumber == addressedObjective[0].objectiveNumber) {
                            if (value && objective.documentServiceNoteObjectiveId < 0) {
                                objective.objectiveNumber = ObjectiveNumber;
                                objective.goalText = ObjectiveText;
                                objective.customObjectiveActive = CustomObjectiveActive;
                                objective.goalId = GoalId;

                                return objective;
                            }
                            else if (!value && objective.documentServiceNoteObjectiveId > 0) {
                                objective.recordDeleted = 'Y';
                                objective.deletedDate = moment().format();;
                                objective.deletedBy = authData.userName;

                                return objective;
                            }
                        } else {
                            return objective;
                        }
                    });
                }
            }
        }

        $scope.changeDiagnosisOrder = function (diag) {
            var sDiagnosis = $scope.appointment.service.diagnosis;

            $scope.appointment.service.diagnosis = $.map(sDiagnosis, function (arr) {
                if (arr.serviceDiagnosisId == diag.serviceDiagnosisId) {
                    return diag;
                } else {
                    return arr;
                }
            });
        };

        $scope.appointment = appointment;

        if (!ID) {
            // To add more Services when the Staff is offline
            localDBService.GetLowestPrimaryKeyValue(dbModel.objectStoreName.calendarevent, 'appointmentId').then(function (lowerpk) {
                if (lowerpk && lowerpk < 0)
                    $scope.appointment.appointmentId = lowerpk - 1;
            });
        }
    }]);

app.controller('SignModalInstanceCtrl', function ($scope, $uibModalInstance, localStorageService, commonService) {
    $scope.smartkey = '';
    $scope.validateSign = function () {
        var authData = localStorageService.get('authorizationData');
        try {
            if (commonService.Decrypt(authData.encryptedToken, $scope.smartkey)) {
                $uibModalInstance.close($scope.smartkey);
            }
            else { $scope.errorMessage = 'Please enter the valid SmartKey!'; }
        } catch (e) {
            $scope.errorMessage = "Please enter the valid SmartKey!"
        }
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };
});