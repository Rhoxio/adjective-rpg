class Enemy < ApplicationRecord
  include Adjective::Vulnerable
  include Adjective::Imbibable
end
