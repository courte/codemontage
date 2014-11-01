require 'net/http'

module OrganizationsControllerHelper
  GITHUB_URL_REGEX = /\A(http:\/\/www.|https:\/\/www.|www.)*github.com\/(\S+)\/(\S+)(.git)*\z/

  def github_url?(url)
    url =~ GITHUB_URL_REGEX
  end

  def valid_url?(url)
    response = Net::HTTP.get(url)

    if response.code == 200
      github_url?(url)
    else
      false
    end
  end

  def parse_github_url(github_url)
    github_url =~ GITHUB_URL_REGEX
    github_org = $2
    github_repo = $3

    {github_org: github_org, github_repo: github_repo}
  end

  def get_github_details(submitted_url)
    if valid_url?(submitted_url)
      parse_github_url(submitted_url)
    else
      raise "The submitted url is not valid."
    end
  end
end

# { "utf8"=>"✓",
#   "authenticity_token"=>"I8hB/TbqMF2kMs9diOBUA7m7tsFnMXJxFr7VRm0KK8U=",
#   "organization"=>
#     { "projects_attributes"=>
#       {  "0"=>
#         {  "name"=>"Ruby", "github_repo"=>"http://www.github.com/ruby/ruby", "url"=>"", "description"=>"It's ruby."  }
#       },
#       "name"=>"Ruby",
#       "github_org"=>"ruby",
#       "url"=>"",
#       "contact_name"=>"",
#       "contact_role"=>"",
#       "contact_email"=>""
#     },
#   "commit"=>"Submit a Project"
# }
