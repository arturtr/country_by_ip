class Api::BaseController < ApplicationController
  def country_by_ip
    ip = IPAddr.new(params[:ip]).to_s
    country = CountryIpRange.find_country_by_ip(ip)
    if country.present?
      render json: {country: country, ip: ip}
    else
      render status: :not_found, json: {ip: ip}
    end
  rescue ArgumentError => e
    render status: :internal_server_error, json: {error: e.message}
  end
end
