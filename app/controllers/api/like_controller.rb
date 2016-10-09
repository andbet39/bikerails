class Api::LikeController < ApplicationController
  def like
    meeting = Meeting.find(params[:meet_id])
    user = User.find(params[:uid])

    meeting.liked_by user
    render json: "success"

  end

  def dislike
    meeting = Meeting.find(params[:meet_id])
    user = User.find(params[:uid])

    meeting.unliked_by user
    render json: "success"

  end

  def getvotes
  end
end
