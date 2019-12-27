class OktokitImitator
  def gist(id)
    return 404 if id != '52052829173db67ca71032268fd65e84'
    FakeData.new
  end

  FakeData = Struct.new(:status, :id, :html_url) do
    def files
      [ ["", FakeGist.new], "" ]
    end

    def id
      '52052829173db67ca71032268fd65e84'
    end
  end

  FakeGist = Struct.new(:status, :id, :html_url) do

    attr_reader :filename, :content

    def initialize
      @filename = "TestFilename"
      @content = "TestContent"
    end
  end
end
