class StrategyPostsController < ApplicationController
  before_action :require_login
  before_action :set_boss
  before_action :set_strategy_post, only: %i[edit update destroy]
  before_action :authorize_strategy_post!, only: %i[edit update destroy]

  def index
    @strategy_posts = @boss.strategy_posts.order(created_at: :asc)
  end

  def create
    @strategy_post = current_user.strategy_posts.build(strategy_post_params)
    @strategy_post.boss = @boss

    if @strategy_post.save
      redirect_to strategy_posts_index_path, notice: "攻略情報を投稿しました"
    else
      @strategy_posts = @boss.strategy_posts.order(created_at: :asc)
      flash.now[:alert] = "攻略情報を入力してください"
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @strategy_post.update(strategy_post_params)
      redirect_to strategy_posts_index_path, notice: "攻略情報を更新しました"
    else
      flash.now[:alert] = "攻略情報を入力してください"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @strategy_post.destroy!
    redirect_to strategy_posts_index_path, notice: "攻略情報を削除しました"
  end

  private

  def strategy_post_params
    params.require(:strategy_post).permit(:body)
  end

  def set_boss
    @boss = Boss.find(params[:boss_id])
  end

  def set_strategy_post
    @strategy_post = @boss.strategy_posts.find(params[:id])
  end

  def authorize_strategy_post!
    return if current_user.own?(@strategy_post) && @strategy_post.editable?

    redirect_to boss_strategy_posts_path(
      @boss,
      night_lord_id: params[:night_lord_id],
      terrain_change_id: params[:terrain_change_id],
      q: params[:q]&.permit(:name_cont)&.to_h), alert: "編集・削除できるのは投稿から30分以内です"
  end

  def strategy_posts_index_path
    boss_strategy_posts_path(
    @boss,
    night_lord_id: params[:night_lord_id],
    terrain_change_id: params[:terrain_change_id],
    q: params[:q]&.permit(:name_cont)&.to_h
    )
  end
end
