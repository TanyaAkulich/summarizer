class Token < ApplicationRecord
  scope :uniq_names, -> { Token.pluck(:name).uniq }
end
