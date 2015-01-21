require "spec_helper"

describe Github do
  context "when given a repo" do
    it "find pull requests" do
      VCR.use_cassette("empirical_oct_prs") do
        prs = Github.pull_requests_by_repo("empirical-org", "empirical-core",
                                           Time.parse("2014-10-01"),
                                           Time.parse("2014-10-02"))
        expect(prs.count).to eq(7)
      end
    end

    it "should find commits" do
      VCR.use_cassette("empirical_oct_commits") do
        commits = Github.commits_by_repo("empirical-org", "empirical-core",
                                         Time.parse("2014-10-01"),
                                         Time.parse("2014-10-02"))
        expect(commits.count).to eq(38)
      end
    end

    it "finds issues by repo" do
      VCR.use_cassette("empirical_jan_issues") do
        issues = Github.issues_by_repo("empirical-org", "empirical-core",
                                       Time.parse("2015-01-06"),
                                       Time.parse("2015-01-07"))
        expect(issues.count).to eq(2)
      end
    end

    it "finds forks by repo" do
      VCR.use_cassette("empirical_oct_forks") do
        forks = Github.forks_by_repo("empirical-core",
                                     Time.parse("2014-10-01"),
                                     Time.parse("2014-10-31"))
        expect(forks.count).to eq(14)
      end
    end
  end

  context "when given a user" do
    it "finds pull requests by user" do
      VCR.use_cassette("courte_oct_stats") do
        prs = Github.pull_requests_by_user("courte", Time.parse("2014-10-01"),
                                           Time.parse("2014-10-31"))
        expect(prs.count).to eq(1)
      end
    end

    it "finds commits by user" do
      VCR.use_cassette("courte_oct_stats") do
        commits = Github.commits_by_user("courte", Time.parse("2014-10-01"),
                                         Time.parse("2014-10-31"))
        expect(commits.count).to eq(1)
      end
    end

    it "finds issues by user" do
      VCR.use_cassette("courte_oct_stats") do
        issues = Github.issues_by_user("courte", Time.parse("2014-10-01"),
                                       Time.parse("2014-10-31"))
        expect(issues.count).to eq(0)
      end
    end

    it "finds forks by user" do
      VCR.use_cassette("courte_oct_stats") do
        forks = Github.forks_by_user("courte", Time.parse("2014-10-01"),
                                     Time.parse("2014-10-31"))
        expect(forks.count).to eq(2)
      end
    end
  end

  it "returns the user login when given a uid" do
    VCR.use_cassette("courte_oct_stats") do
      login = Github.get_user_login_by_uid("2766324")
      expect(login).to eq("courte")
    end
  end

  it "formats dates for octokit queries" do
    date1 = Time.new(2012, 12, 12, 13, 14, 15)
    date2 = Time.new(2011, 11, 11, 12, 13, 14)

    dates = Github.set_date_format(date1, date2)
    expect(dates).to eq(["2012-12-12", "2011-11-11"])
  end
end
