module Tokens
  class InitTokenService
    def self.build(token_name)
      token = Token.find_or_initialize_by(name: token_name)
      new(token)
    end

    def initialize(token)
      @token = token
    end

    def call
      return if @token.id

      Token.create(params)
    end

    private

    def params
      ParamsService.build(@token.name).call
    end
  end
end
