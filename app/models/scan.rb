# Copyright 2021 Adevinta

class Scan < ApplicationRecord
  include Filterable
  has_many :checks

end
