# Subdomains

This gem makes it easy to parse a string and return the subdomains of the [domain name](https://en.wikipedia.org/wiki/Domain_name#Domain_name_syntax) found in the string. Domains names are composed of the [root domain](https://en.wikipedia.org/wiki/Root_name_server#Root_domain), a [top-level domain](https://en.wikipedia.org/wiki/Top-level_domain), a [second-level domain](https://en.wikipedia.org/wiki/Second-level_domain), and may include [lower-level domains](https://en.wikipedia.org/wiki/Domain_name#Second-level_and_lower_level_domains). Multiple methods are defined to customize the output.

The goal of this gem is to allow the parsing of any string for a domain name and to return the domain name and its components without raising an exception; if a string cannot be parsed then the library returns `nil`. If exceptions are required, a bang method is available that will raise an exception.

Other gems may parse and validate domains in other ways, but none make it simple to return the TLD and SLD from any string without raising an exception.

## Dependencies

This gem relies on the [Ruby URI class](http://ruby-doc.org/stdlib-2.3.1/libdoc/uri/rdoc/URI.html) and the [DomainName gem](https://github.com/knu/ruby-domain_name) to do some of the heavy lifting.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'subdomains'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install subdomains

## Usage

### Parsing valid domain names

```ruby
string = "https://www.example.com/example/example?example=example"
subdomains = Subdomains.parse(string)
#<Subdomains::Parser:0x007fd6211a4ba0 @string="https://www.example.com/example/example?example=example", @domain="www.example.com", @root_domain="example.com", @tld="com", @sld="example">
subdomains.domain
"www.example.com"
subdomains.root_domain
"example.com"
subdomains.tld
"com"
subdomains.sld
"example"
```

### Parsing invalid domain names

```ruby
string = "This string does not contain any parseable domain names"
subdomains = Subdomains.parse(string)
#<Subdomains::Parser:0x007fd6211a4ba0 @string="https://www.example.com/example/example?example=example", @domain="www.example.com", @root_domain="example.com", @tld="com", @sld="example">
subdomains.domain
"www.example.com"
subdomains.root_domain
"example.com"
subdomains.tld
"com"
subdomains.sld
"example"

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/subdomains.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

