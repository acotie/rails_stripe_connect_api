#unless Rails.env.production?
  GrapeSwaggerRails.options.url      = "/api/v1/swagger_doc"
  GrapeSwaggerRails.options.app_name = 'Sample'
  GrapeSwaggerRails.options.app_url  = '/'
  GrapeSwaggerRails.options.api_key_name = ''
  GrapeSwaggerRails.options.api_key_type = 'query'
  GrapeSwaggerRails.options.before_filter_proc = proc {
    GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
  }
#end
