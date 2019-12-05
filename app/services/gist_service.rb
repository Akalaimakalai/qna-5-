class GistService

  attr_reader :gist_name, :gist_content

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
      set_data
      set_name
      set_content
    rescue Octokit::NotFound
      404
    end
  end

  def set_data
    @gist_data = @gist.files.first.last
  end

  def set_name
    @gist_name = @gist_data.filename
  end

  def set_content
    @gist_content = @gist_data.content
  end
end
