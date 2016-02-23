window.ng_bs_admin = {  
  entities: [{
    name: 'blog_post',
    relationships: [
      { type: 'has_many', with: 'photos', view_type: 'images' }
    ],
    fields: [
      { type: 'permalink', name: 'permalink',   required: true                             },
      { type: 'string',    name: 'title',       required: true                             },
      { type: 'string',    name: 'summary'                                                 },
      { type: 'image',     name: 'cover_image', required: true                             },
      { type: 'wysi',      name: 'content'                                                 },
      { type: 'select',    name: 'kind',        options: ['blog', 'portfolio', 'tutorial'] },
      { type: 'string',    name: 'video_link'                                              }
    ],
    index_fields: ['title', 'kind', 'summary', 'cover_image', 'permalink']
  }]
}

window.location.hash = null if window.location.hash == '#_=_'
loc = window.location.href
index = loc.indexOf('#')
window.location = loc.substring(0, index) if index > 0

window.hasValue = (value) ->  
  (typeof value != "undefined") and value != null and value != ""

@app = angular.module('BsAdmin', [  
  'ui.bootstrap'
  'ngResource'
  'file-model'
  'ui.router'
  'ui.router.stateHelper'  
  # 'xeditable'
  # 'ngStaticInclude'
  'ngSanitize'
  'file-model'
  'ngTouch'
  'bootstrapLightbox'
  # 'angularPayments'
  'checklist-model'
])

# @app.service 'C', () -> 
#   r = window.constants
#   r.getProjectType = (id) ->
#     _.findWhere(r.PROJECT_TYPES, { id: id })
#   r

# @app.config (LightboxProvider, $locationProvider) ->  
#   LightboxProvider.templateUrl = '/templates/lightbox'  
#   $locationProvider.html5Mode(true)

@app.run ($rootScope, $http, $timeout) ->
  $rootScope.$on "$viewContentLoaded", (event) ->
    $http.post '/api/save_current_path', { current_path: window.location.pathname }


@app.config ($httpProvider) ->
  $httpProvider.interceptors.push ($rootScope, $q) ->
    {
      responseError: (response) ->        
        location = '/admin' if response.status == 401
        $q.reject(response)
    }
