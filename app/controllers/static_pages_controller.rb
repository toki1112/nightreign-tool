class StaticPagesController < ApplicationController
  def top
    @q = Boss.ransack(params[:q])
  end
end
