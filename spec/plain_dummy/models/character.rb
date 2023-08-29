class Character < ApplicationRecord
  include Adjective::Vulnerable
  include Adjective::Imbibable
end
