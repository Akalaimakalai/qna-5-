require 'active_support/concern'

module Comentable
  extend ActiveSupport::Concern

  included do
    has_many :coments, dependent: :destroy, as: :comentable
  end
end
