class BossesController < ApplicationController
  def index
    @q = Boss.ransack(params[:q])
    @bosses = @q.result(distinct: true)
  end
end
