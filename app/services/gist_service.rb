class GistService

  attr_reader :gist

  def initialize
    @client = Octokit::Client.new(:access_token => ENV['OCTOKIT_ACCESS_TOKEN'])
  end

  def gist?(url)
    url.split('/').include?('gist.github.com') && (get_gist(url) != 404)
  end

  private

  def get_gist(url)
    begin
      id = url.split('/').last
      @gist = @client.gist(id)
    rescue Octokit::NotFound
      404
    end
  end
end
