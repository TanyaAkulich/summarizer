class UpdateDictionaryService
  def self.build(all_tokens = [])
    new(all_tokens)
  end

  def initialize(all_tokens)
    @all_tokens = all_tokens
  end

  def call
    UploadedFile.all.map do |file|
      @all_tokens << File.read(file.file.path).downcase.scan(Regexp.new('[а-я]+'))
    end

    @all_tokens.flatten!.uniq!.map { |token| Tokens::InitTokenService.build(token).call }
  end
end
