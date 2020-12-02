class AbstractService
  def self.build(file_id)
    new(file_id)
  end

  def initialize(file_id)
    @file = UploadedFile.find(file_id)
    @text = Nokogiri::HTML(File.open(@file.file.path)).search('p').text
    @sentences = []
  end

  def call
    @sentences = @text.split("\n").map do |paragraph|
      paragraph.split('.').map do |sentence|
        {
          sentence: sentence,
          posd: sentence_position_in_file(sentence),
          posp: sentence_position_in_paragraph(sentence, paragraph),
          score: sentence_score(sentence)
        }
      end
    end.flatten!

    top = @sentences.map { |s| { sentence: s[:sentence], score: (s[:posd] * s[:posp] * s[:score]).abs } }

    file = File.open("#{@file.file_name} - abstract.txt", "w") do |f|
      f.write(top.sort_by { |hsh| -hsh[:score] }.first(10).pluck(:sentence).join('. '))
    end

    binding.pry
  end

  private

  def sentence_position_in_file(sentence)
    1 - (number_of_symbols_in_file_before_sentence(sentence) / @text.delete(' ').length.to_f)
  end

  def sentence_position_in_paragraph(sentence, paragraph)
    1 - (number_of_symbols_in_paragraph_before_sentence(sentence, paragraph) / paragraph.delete(' ').length.to_f)
  end

  def sentence_score(sentence)
    sentence_without_punct(sentence).map do |token|
      token_frequency_in_sentence(token, sentence)
    end.sum
  end

  def number_of_symbols_in_paragraph_before_sentence(sentence, paragraph)
    paragraph.split(sentence)[0].length
  end

  def number_of_symbols_in_file_before_sentence(sentence)
    @text.split(sentence)[0].length
  end

  def sentence_without_punct(sentence)
    sentence.gsub(/[[:punct:]]/, '').split(' ')
  end

  def token_frequency_in_sentence(token, sentence)
    sentence_without_punct(sentence).count(token) / sentence_length(sentence).to_f
  end

  def token_frequency_in_file(token)
    Token.find_by(uploaded_file_id: @file.id, name: token).frequency_in_file
  end

  def sentence_length(sentence)
    sentence_without_punct(sentence).length
  end

  def token_width_in_file(token)
    0.5 * (1 + token_frequency_in_file(token) / Token.where(uploaded_file_id: @file.id).order(:frequency_in_file).last.to_f) * Math::log(UploadedFile.count / Tocken.where(name: token).count.to_f)
  end
end
