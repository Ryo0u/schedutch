class Api::V1::UsersController < ApplicationController
    def create
      event = Event.find_by!(url_token: params[:event_id])
      
      ActiveRecord::Base.transaction do
        user = event.users.create!(user_params)
        
        params[:responses].each do |res_data|
          target_time = res_data[:start_time]
          candidate = event.candidates.find_by("start_time <= ? AND end_time >= ?", target_time, target_time)
          
          if candidate
            user.responses.create!(
              candidate: candidate,
              start_time: target_time,
              status: res_data[:status]
            )
          end
        end
      end
      
      render json: { message: '登録しました' }, status: :created
    end
    
    private
    
      def user_params
        params.require(:user).permit(:name, :password, :comment)
      end
end