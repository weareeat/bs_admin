describe 'AccountPersonalController', ->
  beforeEach angular.mock.module('Innpress')
  
  AccountPersonalController = undefined
  scope = undefined
  httpBackend = undefined
  modal = undefined
  mocks = undefined

  beforeEach inject(($rootScope, $controller, $httpBackend) ->    
    mocks = new window.mocks()
    window.bootbox = mocks.bootbox()    
    scope = $rootScope.$new()
    httpBackend = $httpBackend
    modal = mocks.$modal()
    
    AccountPersonalController = $controller('AccountPersonalController', $scope: scope, $modal: modal)

    httpBackend.when('GET', '/api/current_user').respond(200)
    httpBackend.when('GET', '/templates/dashboard').respond(200)
    httpBackend.when('POST', '/api/save_current_path').respond(200)
  )

  afterEach () ->
    expect(mocks.assert).not.toThrow()

  it 'init', ->     
    httpBackend.expect('GET', '/api/current_user').respond(200)
    httpBackend.expect('GET', '/templates/dashboard').respond(200)
    expect(scope.title).toBeDefined()
    expect(scope.subtitle).toBeDefined()
    expect(scope.Account).toBeDefined()
    expect(scope.model).toBeDefined()    
    expect(httpBackend.flush).not.toThrow()

  it 'resetPassword() with bootbox yes', ->    
    httpBackend.expect('POST', '/api/current_user/reset_password').respond(200)
    scope.resetPassword()
    bootbox.clickYes()
    mocks.expect 'bootbox.confirm'
    mocks.expect 'bootbox.alert'
    expect(httpBackend.flush).not.toThrow()

  it 'resetPassword() with bootbox no', ->     
    scope.resetPassword()
    bootbox.clickNo()
    mocks.expect 'bootbox.confirm'
    expect(httpBackend.flush).not.toThrow()
  
  it 'editEmail() modal close', ->     
    httpBackend.expect('GET', '/api/current_user').respond(200) 
    scope.editEmail()
    mocks.expect '$modal.open'
    mocks.expect '$modal.result.then'
    expect(modal.openData.templateUrl).toBe('/templates/account/personal-modal-edit-email')
    expect(modal.close())
    expect(httpBackend.flush).not.toThrow()
  
  it 'editFields() modal close', -> 
    httpBackend.expect('GET', '/api/current_user').respond(200) 
    scope.editFields()
    mocks.expect '$modal.open'
    mocks.expect '$modal.result.then'
    expect(modal.openData.templateUrl).toBe('/templates/account/personal-modal-edit-fields')
    expect(modal.close())

    expect(httpBackend.flush).not.toThrow()

  it 'editEmail() modal dismiss', ->    
    scope.editEmail()
    mocks.expect '$modal.open'
    mocks.expect '$modal.result.then'
    expect(modal.openData.templateUrl).toBe('/templates/account/personal-modal-edit-email')
    expect(modal.dismiss())
    expect(httpBackend.flush).not.toThrow()
  
  it 'editFields() modal dismiss', ->    
    scope.editFields()
    mocks.expect '$modal.open'
    mocks.expect '$modal.result.then'
    expect(modal.openData.templateUrl).toBe('/templates/account/personal-modal-edit-fields')
    expect(modal.dismiss())
    expect(httpBackend.flush).not.toThrow()

  it 'sendConfirmationEmail() with bootbox yes', ->     
    httpBackend.expect('POST', '/api/current_user/send_email_confirmation_email').respond(200)
    scope.sendConfirmationEmail()
    bootbox.clickYes()
    mocks.expect 'bootbox.confirm'
    expect(httpBackend.flush).not.toThrow()

  it 'sendConfirmationEmail() with bootbox no', ->    
    scope.sendConfirmationEmail()
    bootbox.clickNo()
    mocks.expect 'bootbox.confirm'
    expect(httpBackend.flush).not.toThrow()