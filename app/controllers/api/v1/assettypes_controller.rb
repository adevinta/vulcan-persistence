# Copyright 2021 Adevinta

module Api::V1
  class AssettypesController < ApplicationController
    # GET /assettypes
    def index
      @assettypes = Assettype.all
      render json: @assettypes
    end
  end
end
