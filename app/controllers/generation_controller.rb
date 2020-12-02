class GenerationController < ApplicationController
  def index; end

  def upload_file
    file = UploadedFile.create(
      file: params.require(:upload)[:datafile].tempfile,
      file_name: params.require(:upload)[:datafile].original_filename
    )
    @abstract = AbstractService.build(file.id).call
  end

  def generate_abstract
    # @token = params[:token]
    # Tokens::InitTokenService.build(@token).call
    @abstract = AbstractService.build(@token).call
  end

  def update_dictionary
    UpdateDictionaryService.build.call
  end
end
