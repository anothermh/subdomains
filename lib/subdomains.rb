require "subdomains/version"
require "subdomains/exceptions"
require "domain_name"

module Subdomains

  # Call this helper method to parse a string for a domain name
  # 
  # The string may be something like:
  #   - "http://example.com/example/example?example=example"
  #   - "example.com"
  #   - "www.example.com"
  #   - "https://www.example.com"
  #   - "💩"
  #   - "The URL is: ftp://ftp.example.com"
  #   - "example.com ftp.example.com www.example.com"
  #   - any combination of the above
  #
  # This method will take the string, find the first domain name it can find, parse
  # out all the subdomains, and then return a Subdomains::Parser object
  def self.parse(string)
    return Subdomains::Parser.new(string)
  end

  # This method is the same as the parse method, but will raise an exception if the 
  # string could not be parsed
  def self.parse!(string)
    domain = Subdomains::Parser.new(string)
    domain.parsed ? (return domain) : (raise Subdomains::ParseError, "Unable to parse the string for a domain name")
  end

  # The Parser class handles all the logic for parsing the string into a usable object
  class Parser
    # The parser class will return several attributes to allow for easy extraction of 
    # the relevant parts of a domain name:
    # 
    # - string      (string) The original string supplied by the caller ("https://www.example.com/")
    # - root_domain (string) The SLD and TLD only ("example.com")
    # - tld         (string) The TLD (top-level domain) only ("com")
    # - sld         (string) The SLD (second-level domain) only ("example")
    # - llds        (array)  All LLDs (lower-level domains) as an array ([ "www", "example", "com"])
    # - lld_count   (int)    The total count of LLDs
    # - parsed      (bool)   If true, then the domain name was successfully parsed
    attr_reader :string,
                :root_domain,
                :tld,
                :sld,
                :llds,
                :lld_count,
                :parsed

    def initialize(string)
      @string = string.freeze
      @domain = domain

      # If the domain method returns nil then don't try to parse further and return nil
      if @domain
        @root_domain = @domain.split(".")[-2..-1].join(".")
        @tld         = @domain.split(".")[-1]
        @sld         = @domain.split(".")[-2]
        @llds        = @domain.split(".")
        @lld_count   = @domain.split(".").count
        @parsed      = true
      else
        @root_domain = nil
        @tld         = nil
        @sld         = nil
        @llds        = Array.new
        @lld_count   = 0
        @parsed      = false
      end
    end

    private

    # We accept any `string` and then do our goddamned best to return a simple string consisting of 
    # the first domain name found in the string; e.g., if the string supplied is:
    # 
    #   "We have two new websites: https://www1.example.com/site1 and https://www2.example.com/site2/"
    #   
    # Then this method will return:
    # 
    #   "www1.example.com"
    #   
    # This value can then be parsed further to return other attributes of the domain name
    # 
    # If a domain name cannot be found with a TLD and at least one SLD then this method returns nil, 
    # otherwise this method returns a string
    def domain
      # Don't mess with strings that aren't strings
      return nil unless @string.is_a?(String)

      # Step 1 - parse the string to find the first substring that we can parse as a domain name
      @string.split.select { |substring| substring.include?(".") }.each do |substring|
        # Step 2 - use the URI class to parse the string
        uri_string = parse_string_for_uri(substring)

        # Step 3 - use the DomainName gem to parse the string returned by the URI class
        domain_string = parse_string_for_domain(uri_string)

        # Step 4 - if this has been confirmed as a good domain name then return it, else continue parsing
        if domain_string
          @domain = domain_string
          break
        end
      end

      @domain ||= nil
    end

    # Once we have what we assume must be either a domain name or URI, 
    # we pass it to the URI class to see if it can parse it out and answer 
    # these things for us.
    def parse_string_for_uri(substring)
      begin
        uri_string = URI.parse(substring).host
      rescue URI::BadURIError, URI::Error, URI::InvalidComponentError, URI::InvalidURIError
        uri_string = nil
      end

      # Do not return nil; if there's a problem, just return the original substring
      uri_string ||= substring
    end

    def parse_string_for_domain(uri_string)
      # String cannot start with a period; raises an exception in the DomainName gem
      uri_string.gsub!(/^\./, '')

      begin
        domain_string = DomainName(uri_string).domain
      rescue TypeError, ArgumentError, NoMethodError => e
        domain_string = nil
      end

      return domain_string
    end
  end

end
