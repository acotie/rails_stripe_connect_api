class Sample::API < Grape::API

  format :json
  default_format :json
  prefix 'api'
  version 'v1', using: :path
  default_error_status :'500'

  resource "users" do
    # es) OK: http://localhost:3000/api/v1/users/1
    desc "returns all users"
    get do
      User.all
    end

    params do
      requires :id, type: Integer
    end
    get ':id' do
      User.find(params[:id])
    end
  end

  add_swagger_documentation base_path: "/",
                            api_version: 'v1',
                            hide_documentation_path: true

end

