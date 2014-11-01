require 'net/http'
require 'open-uri'

class OrganizationsController < ApplicationController
  def new
		@organization = Organization.new
		@project = @organization.projects.build(params[:projects])
	end

	def create
    github_repo = params[:organization][:projects_attributes]["0"][:github_repo]

    if github_url?(github_repo)
      github_details = get_github_details(github_repo)
      params[:organization][:github_org] = github_details[:github_org]
      params[:organization][:projects_attributes]["0"][:github_repo] = github_details[:github_repo]
    end

		@organization = Organization.new(params[:organization])
		@organization.is_public_submission = true

		if @organization.save
			redirect_to root_path, :notice => "Your project has been submitted for approval."
		else
			render :new
		end
	end

  def index
    @featured_orgs = Organization.featured
  end

  def show
    @organization = Organization.find(params[:id])
    @jobs = @organization.jobs.active
    @projects = @organization.projects.featured.includes :technologies, :causes
    @sponsorships = @organization.sponsorships
  end

  # Github URL validation
  GITHUB_URL_REGEX = /\A(http:\/\/|https:\/\/|www.)*github.com\/(\S+)\/(\S+)(.git)*\z/

  def github_url?(url)
    url =~ GITHUB_URL_REGEX
  end

  def valid_url?(url)
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
