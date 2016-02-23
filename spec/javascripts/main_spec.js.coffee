describe 'MainController', ->
  beforeEach angular.mock.module('Innpress')
  
  MainController = undefined
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
    
    MainController = $controller('MainController', $scope: scope, $modal: modal, $rootScope: scope)

    httpBackend.when('GET', '/api/current_user').respond(200)
    httpBackend.when('GET', '/templates/dashboard').respond(200)
    httpBackend.when('POST', '/api/save_current_path').respond(200)
  )

  afterEach () ->
    expect(mocks.assert).not.toThrow()
  
  it 'openPaymentModal() if its already open', ->
    expect(scope.isPaymentModalOpen).toBe false
    scope.isPaymentModalOpen = true
    scope.openPaymentModal()

  it 'openPaymentModal()', ->
    httpBackend.expect('GET', '/api/current_user').respond(200, { subscription_status: 'canceled' })
    httpBackend.expect('GET', '/api/current_user').respond(200, { subscription_status: 'canceled' })
    expect(scope.isPaymentModalOpen).toBe false
    scope.openPaymentModal()
    mocks.expect '$modal.open'
