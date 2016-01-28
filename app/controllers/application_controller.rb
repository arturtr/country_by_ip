class ApplicationController < ActionController::API

  def index
    render json: {status: :hello, message: 'Please use the path /api/country_by_ip?ip=123.123.123.123'}
  end
end
