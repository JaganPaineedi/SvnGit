'use strict';
app.controller('documentController', ['$scope', 'ngAuthSettings', 'localDBService', 'dbModel',
    'authService', '$location', 'persistenceService', '$sce', '$uibModal', 'commonService', 'localPersistenceStrategy',
    'remotePersistenceStrategy', 'localStorageService','syncService', function ($scope, ngAuthSettings, localDBService, dbModel,
        authService, $location, persistenceService, $sce, $uibModal, commonService, localPersistenceStrategy, remotePersistenceStrategy, localStorageService, syncService) {
        if (authService.getprivatekeyrequired() === true) {
            $location.path('/login/UL');
            return;
        }
        var getDocumentVersionId = function () {
            var parts = $location.absUrl().split('/');
            return Number(parts[parts.length - 1]);
        }
        
        var parts = $location.absUrl().split('/');
        var ID = getDocumentVersionId();

        $scope.title = "Document";
        $scope.documentHtml = '';

       

        $scope.sign = function () {
            var uibModalInstance = $uibModal.open({
                backdrop: 'static',
                keyboard: false,
                animation: true,
                templateUrl: 'validatepassword.html',
                controller: 'SignatureModalInstanceCtrl',
                size: 'sm',
                resolve: {
                    appmodify: function () { return $scope.document; }
                }
            });

            uibModalInstance.result.then(function (signature) {
                $scope.document.signature = signature;

                var document = $scope.document;
                var unsavedObj = {
                    objectstorename: 'documents',
                    localName: 'Documents',
                    showDetails: false,
                    id: document.documentVersionId
                };

                var authData = localStorageService.get('authorizationData');

                localPersistenceStrategy.save(document, 'documentVersionId', 'documents', authData).then(function (doc) {
                    localPersistenceStrategy.insert(unsavedObj, 'objectstorename', dbModel.objectStoreName.objectstorenames).then(function (result) {
                        if (!result) {
                            commonService.UpdateLocalChangesCount();
                            if (Offline.state == 'down') {
                                persistenceService.getById(doc.documentVersionId, dbModel.objectStoreName.documents).then(function (event) {
                                    event = event.target.result;
                                    if (event) {
                                        commonService.HideProcessing();
                                    }
                                });
                            }
                            else {
                                syncService.Syncing = true;
                                remotePersistenceStrategy.saveIndividual(doc.documentVersionId, dbModel.objectStoreName.documents).then(function (result) {
                                    syncService.Syncing = false;
                                    commonService.HideProcessing();
                                });
                            }
                        }
                    });
                });

            });
        }

        persistenceService.getById(ID, dbModel.objectStoreName.documents).then(function (document) {
            $scope.document = document.target.result;
            if (document.target.result.viewHTML)
                $scope.documentHtml = $sce.trustAsHtml(document.target.result.viewHTML);
        }, function (error) {
            $scope.error = error;
        });

       // = $scope.signerName

    }]);
app.controller('SignatureModalInstanceCtrl', function ($scope, $uibModalInstance, localStorageService, commonService, localDBService, dbModel, appmodify) {
    $scope.smartkey = '';



    $scope.documentSignature = { signatureString: '', isClient: appmodify.isClient, relationShipToClient: appmodify.relationToClient, relationShipText: '', signerName: appmodify.signerName, signatureDate: '' };
    $uibModalInstance.rendered.then(function () {
        console.log('test');
        var canvas = document.querySelector("canvas");
        var ctx = canvas.getContext("2d");
        ctx.fillStyle = "white";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
    });
   
    $scope.done = function () {
        var sig = $scope.accept();

        $scope.documentSignature.relationShipText = $('#ddRelationship :selected').text();
        $scope.documentSignature.signatureDate = new Date();
        $scope.documentSignature.signatureString = sig.dataUrl;

        if (sig.isEmpty) {
            $uibModalInstance.dismiss();
        } else {
            $uibModalInstance.close($scope.documentSignature);
        }
    };

    $scope.clear = function () { }

    localDBService.Open(dbModel).then(function () {
        localDBService.GetAll(dbModel.objectStoreName.globalcodes).then(function (result) {
            $scope.relationShips = commonService.GetGlobalCodes('RELATIONSHIP', result);
        });
    });
    
});