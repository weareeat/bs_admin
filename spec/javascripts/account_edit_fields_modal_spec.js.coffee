describe 'AccountEditFieldsModalController', ->
  beforeEach angular.mock.module('Innpress')
  
  AccountEditFieldsModalController = undefined
  scope = undefined
  httpBackend = undefined
  modalInstance = undefined
  mocks = undefined

  beforeEach inject(($rootScope, $controller, $httpBackend) ->    
    mocks = new window.mocks()
    window.bootbox = mocks.bootbox()    
    scope = $rootScope.$new()
    httpBackend = $httpBackend
    modalInstance = mocks.$modalInstance()
    
    AccountEditFieldsModalController = $controller('AccountEditFieldsModalController', $scope: scope, $modalInstance: modalInstance, action: '')    

    httpBackend.when('GET', '/api/current_user').respond(200)
    httpBackend.when('GET', '/templates/dashboard').respond(200)
    httpBackend.when('POST', '/api/save_current_path').respond(200)
  )

  afterEach () ->    
    expect(mocks.assert).not.toThrow()
  
  it 'init', ->     
    expect(scope.model).toBeDefined()
    expect(scope.usStates).toBeDefined()
    expect(scope.model.state).toBeDefined()
    expect(httpBackend.flush).not.toThrow()

  it 'save', ->    
    spyOn scope, 'handleServerSideErrors'
    httpBackend.when('PUT', '/api/current_user').respond(200)
    scope.save()
    expect(httpBackend.flush).not.toThrow()
    mocks.expect '$modalInstance.close'
    expect(scope.handleServerSideErrors).not.toHaveBeenCalled() 

  it 'save with error response', ->    
    spyOn scope, 'handleServerSideErrors'
    httpBackend.when('PUT', '/api/current_user').respond(500)
    scope.save()
    expect(httpBackend.flush).not.toThrow()    
    expect(scope.handleServerSideErrors).toHaveBeenCalled() 