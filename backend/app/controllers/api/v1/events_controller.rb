class Api::V1::EventsController < ApplicationController
  def create
    event = Event.new(event_params)
    if event.save
      render json: event, status: :created
    else
      render json: event.errors,  status: :unprocessable_entity
    end
  end
  
  def show
    event = Event.includes(users: :responses).find_by(url_token: params[:id])
    
    if event
      render json: event.as_json(include: {
        candidates: {},
        users: {
          include: :responses
        }
      })
    else
      render json: { error: "イベントが見つかりませんでした" }, status: :not_found
    end
  end
  
  def destroy
    event = Event.find_by(url_token: params[:id])
    
    if event.authenticate(params[:password])
      event.destroy!
      render json: {message: "削除しました"}, status: :ok
    
    else
      render json: { error: 'パスワードが間違っています' }, status: :unauthorized
    end
  end
  
  private
  
    def event_params
      params.require(:event).permit(:title,
      :description,
      :password,
      :password_confirmation,
      candidates_attributes: [:start_time, :end_time]
      )
    end

end
