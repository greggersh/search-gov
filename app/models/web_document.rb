class WebDocument
  attr_reader :document, :url

  def initialize(document:, url:)
    @document = document
    @url = url

    post_initialize
  end

  private

  def post_initialize
    #implemented by subclasses
  end
end
