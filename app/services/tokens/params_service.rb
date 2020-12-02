module Tokens
  class ParamsService
    def self.build(token)
      new(token)
    end

    def initialize(token)
      @token = token
      @number_of_repeats_in_files = 1
    end

    def call
      UploadedFile.all.map do |file|
        {
          uploaded_file_id: file.id,
          name: @token,
          frequency_in_file: frequency_in_file(file)
        }
      end
    end

    private

    def frequency_in_file(file)
      (file.text.scan(Regexp.new(@token.downcase + '\b'))&.size || 0).to_f / file.text.split(' ').size
    end
  end
end
