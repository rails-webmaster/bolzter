# Bolzter

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bolzter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bolzter

## Usage

1. Setting API key
	Bolzter::Bolzter.set_credentials("YOUR_USERNAME", "YOUR_API_KEY")

	Output
	=> {:username=>"YOUR_USERNAME", :api_key=>"YOUR_API_KEY"}

2. Getting users
	Bolzter::Bolzter.users

	Output
	=> {"meta"=>{"limit"=>20, "next"=>nil, "offset"=>0, "previous"=>nil, "total_count"=>1}, "objects"=>[{"email"=>"user@example.com", "first_name"=>"Test", "id"=>12, "last_login"=>"2014-07-14T12:15:22", "last_name"=>"User", "resource_uri"=>"/api/v2.1/user/12/"}]}

3. Getting a user
	Bolzter::Bolzter.user(id)

4. Getting campaigns
	Bolzter::Bolzter.campaigns

5. Getting a campaign
	Bolzter::Bolzter.campaign

6. Getting persons
	Bolzter::Bolzter.persons

7. Getting a person
	Bolzter::Bolzter.person(id)

8. Updating a person
	params = {
				"first_name" 	=> "NewFName",
				"last_name" 	=> "NewLName",
				...
			}
	Bolzter::Bolzter.update_person(id, params)

9. Deleting a person
	Bolzter::Bolzter.delete_person(id)

10. Creating a lead
	params = {
				"first_name" 	=> "fName",
				"last_name" 	=> "lName",
				"email"			=> "fname.lname@example.com",
				"campaign"		=> campaign_id,	# Or campaign resource. For example /api/v2.1/campaign/42/
				...
			}
	Bolzter::Bolzter.create_lead(params)

	Output:
	=> #<Net::HTTPCreated 201 CREATED readbody=true>
## Contributing

1. Fork it ( https://github.com/rails-webmaster/bolzter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
