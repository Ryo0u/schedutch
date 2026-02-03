class Api::V1::TestsController < ApplicationController
  def index
    render json: { message: "成功！これはRailsからの返信です！" }
  end
end
