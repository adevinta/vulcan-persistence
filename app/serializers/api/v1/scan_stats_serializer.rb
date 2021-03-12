# Copyright 2021 Adevinta

module Api::V1
  class ScanStatsSerializer < ActiveModel::Serializer
    attributes :status, :total
  end
end
