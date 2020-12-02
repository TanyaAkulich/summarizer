class UploadedFile < ApplicationRecord
  has_attached_file :file

  validates_attachment_content_type :file, content_type: %w[text/plain text/html text/xml]

  after_commit :recalculate_all_tokens

  def text
    Nokogiri::HTML(File.open(file.path)).search('p').text.gsub("\n", '').gsub('.', ' ').downcase.gsub(/[[:punct:]]/, '')
  end


  def recalculate_all_tokens
    text.split(' ').uniq.each do |token|
      params = Tokens::ParamsService.build(token).call
      params.each do |param|
        Token.find_or_create_by(uploaded_file_id: param[:uploaded_file_id], name: token).update(param)
      end
    end
  end
end
