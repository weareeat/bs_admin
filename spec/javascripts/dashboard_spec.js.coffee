describe 'DashboardController', ->
  beforeEach angular.mock.module('Innpress')
  
  DashboardController = undefined
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
    
    DashboardController = $controller('DashboardController', $scope: scope, $modal: modal)

    httpBackend.when('GET', '/api/current_user').respond(200)
    httpBackend.when('GET', '/templates/dashboard').respond(200)
    httpBackend.when('POST', '/api/save_current_path').respond(200)
  )

  afterEach () ->
    expect(mocks.assert).not.toThrow()

  it 'init', ->         
    httpBackend.expect('GET', '/api/videos?take=3').respond(200, [{}, {}, {}])
    httpBackend.expect('GET', '/api/videos/today').respond(200, {})
    expect(httpBackend.flush).not.toThrow()
    expect(scope.today).toBeDefined()
    expect(scope.videos.length).toBe 3 
