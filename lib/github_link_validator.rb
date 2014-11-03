require 'net/http'
require 'open-uri'

module GithubLinkValidator
  GITHUB_URL_REGEX = /\A(http:\/\/|https:\/\/|www.)*github.com\/(\S+)\/(\S+)(.git)*\z/

  def github_url?(url)
    url =~ GITHUB_URL_REGEX
  end

  def append_https(url)
    if url.start_with?('https')
      url
    elsif url.start_with?('http')
      url.gsub!(/http:/, 'https:')
    else
      url = 'https://' + url
    end
  end

  def remove_www(url)
    return url.gsub!(/www./, '') if url.match(/www./)
    url
  end

  def valid_url?(url)
    url = append_http(url)
    response = Net::HTTP.get_response(URI(url))
    response.code == 200 || 301
  end

  def parse_github_url(url)
    url =~ GITHUB_URL_REGEX
    github_org = $2
    github_repo = $3

    {github_org: github_org, github_repo: github_repo}
  end

  def get_github_details(url)
    if valid_url?(url) && github_url?(url)
      parse_github_url(url)
    else
      raise "The submitted url is not valid."
    end
  end
end
