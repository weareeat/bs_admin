describe 'AccountEditEmailModalController', ->
  beforeEach angular.mock.module('Innpress')
  
  AccountEditEmailModalController = undefined
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
    
    AccountEditEmailModalController = $controller('AccountEditEmailModalController', $scope: scope, $modalInstance: modalInstance, action: '')    

    httpBackend.when('GET', '/api/current_user').respond(200)
    httpBackend.when('GET', '/templates/dashboard').respond(200)
    httpBackend.when('POST', '/api/save_current_path').respond(200)
  )
  
  afterEach () ->
    expect(mocks.assert).not.toThrow()

  it 'init', ->     
    expect(scope.model).toBeDefined()
    expect(httpBackend.flush).not.toThrow()

  it 'save', ->    
    spyOn scope, 'handleServerSideErrors'
    httpBackend.when('POST', '/api/current_user/update_email').respond(200)
    scope.save()
    expect(httpBackend.flush).not.toThrow()
    mocks.expect '$modalInstance.close'
    expect(scope.handleServerSideErrors).not.toHaveBeenCalled() 

  it 'save with error response', ->    
    spyOn scope, 'handleServerSideErrors'
    httpBackend.when('POST', '/api/current_user/update_email').respond(500)
    scope.save()
    expect(httpBackend.flush).not.toThrow()    
    expect(scope.handleServerSideErrors).toHaveBeenCalled() 