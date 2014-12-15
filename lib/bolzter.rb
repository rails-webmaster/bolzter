require "bolzter/version"
require 'uri'
require 'net/http'
require 'json'
require 'yaml'

module Bolzter
	class Bolzter
		# Class level variables
		@@api_root = "https://social.bolzter.com/api/v2.1/"
		@@username = ""
		@@api_key = ""
		@@end_point = "user"

		# => Set credential. It should be called before call APIs.
		def self.set_credentials(username, api_key)
			@@username = username
			@@api_key = api_key
			{:username => username, :api_key => api_key}
		end

		def self.set_credentials
			conf_file = File.join(Rails.root, 'config', 'bolzter.yml').to_s
			if File.exists?(conf_file)
				config = YAML.load_file(conf_file)
				@@username = config["username"]
				@@api_key = config["api_key"]
				{:username => @@username, :api_key => @@api_key}
			else
				puts "conf/bolzter.yml file does not exist. Please copy bolzter.yml.example file."
			end
		end

		# => Creating uri path
		def self.make_uri(end_point)

			@@api_root + end_point + "/?username=" + @@username + "&api_key=" + @@api_key
		end

		# => Getting api root uri
		def self.api_root

			@@api_root
		end

		# => Getting username. It will be email address.
		def self.username

			@@username
		end

		# => Getting api_key. It can be found in your Bolzter account page.
		def self.api_key

			@@api_key
		end

		# => Getting all users
		# => A list of your users, actually there is 1 user in the list (id, first_name, last_name, email, last_login).
		def self.users
			uri = URI.parse(make_uri("user"))
			Net::HTTP.start(uri.host, uri.port,
							:use_ssl => uri.scheme == 'https', 
							:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Get.new uri.request_uri

				@response = http.request request # Net::HTTPResponse object
			end

			JSON.parse @response.body
		end

		# => Getting a user from user Identity
		# => A list of your users, actually there is 1 user in the list (id, first_name, last_name, email, last_login).
		def self.user id
			uri = URI.parse(make_uri("user/" + id.to_s))
			Net::HTTP.start(uri.host, uri.port,
							:use_ssl => uri.scheme == 'https', 
							:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Get.new uri.request_uri

				@response = http.request request # Net::HTTPResponse object
			end

			JSON.parse @response.body
		end

		# => Campaign resources of a user.
		# => Response: List of campaigns of a user (id, name, description, start_date, end_date, status).
		def self.campaigns
			uri = URI.parse(make_uri("campaign"))
			Net::HTTP.start(uri.host, uri.port,
							:use_ssl => uri.scheme == 'https', 
							:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Get.new uri.request_uri

				@response = http.request request # Net::HTTPResponse object
			end

			JSON.parse @response.body
		end

		# => Response: Properties of a campaign object identified by {id} (id, name, description, start_date, end_date, status).
		def self.campaign id
			uri = URI.parse(make_uri("campaign/" + id.to_s))
			Net::HTTP.start(uri.host, uri.port,
							:use_ssl => uri.scheme == 'https', 
							:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Get.new uri.request_uri

				@response = http.request request # Net::HTTPResponse object
			end

			JSON.parse @response.body
		end

		# => Person resources of a user.
		# => Response: List of person belongs to the user's campaigns (id, first_name, last_name, email, birthday, gender, phone, converted).
		def self.persons
			uri = URI.parse(make_uri("person"))
			Net::HTTP.start(uri.host, uri.port,
							:use_ssl => uri.scheme == 'https', 
							:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Get.new uri.request_uri

				@response = http.request request # Net::HTTPResponse object
			end

			JSON.parse @response.body
		end

		# => Response: Properties of a person object identified by {id} (id, first_name, last_name, email, birthday, gender, phone, converted).
		def self.person id
			uri = URI.parse(make_uri("person/" + id.to_s))
			Net::HTTP.start(uri.host, uri.port,
							:use_ssl => uri.scheme == 'https', 
							:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Get.new uri.request_uri

				@response = http.request request # Net::HTTPResponse object
			end

			JSON.parse @response.body
		end

		# => Response: Properties of a person object identified by {id} (id, first_name, last_name, email, birthday, gender, phone, converted).
		# => Request: The required changes must be in JSON encoded format and don't forget to set the content type to 'application/json' (eg. {“converted”: true}).
		# => Response: The proper HTTP code according to the success of the request.
		def self.update_person(id, params)
			uri = URI.parse(make_uri("person/" + id.to_s))
			Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Patch.new(uri.request_uri)
				request.add_field('Content-Type', 'application/json')
				request.body = JSON.dump(params)

				@response = http.request request
			end
		end

		# => Response: The proper HTTP status code.
		def self.delete_person(id)
			uri = URI.parse(make_uri("person/" + id.to_s))
			Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Delete.new(uri.request_uri)

				@response = http.request request
			end
		end

		# => Creating Person object and register it for the appropriate Campaign in one step.
		# => Field name				Required			Description
		# => first_name					yes			First name in max. 75 length
		# => last_name					yes			Last name in max. 75 length
		# => email						yes			Valid email address in max. 100 length
		# => campaign					yes			Campaign resource identifier which can be a numeric ID or a resource URI (eg. /api/v2.1/campaign/42/)
		# => phone						no			Phone number in max. 100 length
		# => birthday					no			Birthday in form YYYY-MM-DD
		# => country					no			Country name according to ISO-3166 in max. 50 length
		# => state						no			State of the country in max. 50 length
		# => city						no			City name in max. 100 length
		# => facebook_access_token		no			Valid Facebook User Access Token which is given by the user. Pay attention that the FB App which requested the permission must be the same as set for the campaign in Bolzter.
		# => tracking_cookie			no			For such cases when the user's activities are tracked in browsers and the registration process is not going through a web page but the API. In order to be able to associate this tracked history to the lead we need the tracking cookie (bolzter_premarker).
		def self.create_lead(params)
			uri = URI.parse(make_uri("lead"))
			Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

				request = Net::HTTP::Post.new(uri.request_uri)
				request.add_field('Content-Type', 'application/json')
				request.body = JSON.dump(params)

				@response = http.request request
			end
		end
	end
end