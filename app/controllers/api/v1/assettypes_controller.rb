# Copyright 2019 Adevinta

module Api::V1
  class AssettypesController < ApplicationController
    # GET /assettypes
    def index
      expires_in 2.minutes, public: true
      @assettypes = Assettype.all
      render json: @assettypes
    end
  end
end
