class InitQueryService
  def self.build(file_id, token_name)
    file = UploadedFile.find(file_id)
    new(file, token_name)
  end

  def initialize(file, token_name)
    @file = file
    @token_name = token_name
  end

  def call
    Vector.elements(Token.uniq_names.sort { |a, b| a <=> b }.map { |t| t.downcase.include?(@token_name.downcase) ? 1 : 0 })
  end
end
