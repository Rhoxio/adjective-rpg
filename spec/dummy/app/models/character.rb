class Character < ApplicationRecord
  include Adjective::Vulnerable
  include Adjective::Imbibable

  after_initialize :init_imbibable
  # def initialize
  #   init_vulnerable
  #   init_imbibable
  # end
  
end