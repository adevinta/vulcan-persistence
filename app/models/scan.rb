# Copyright 2019 Adevinta

class Scan < ApplicationRecord
  include Filterable
  has_many :checks

end
