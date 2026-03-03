class Api::V1::UsersController < ApplicationController
    def create
      event = Event.find_by!(url_token: params[:event_id])
      
      ActiveRecord::Base.transaction do
        user = event.users.create!(user_params)
        
        all_candidates = event.candidates.to_a
        
        responses_to_insert = params[:responses].map do |res_data|
          target_time = res_data[:start_time]
          
          candidate = all_candidates.find { |c| c.start_time <= target_time && c.end_time >= target_time }
          
          if candidate
            {
              user_id: user.id,
              candidate_id: candidate.id,
              start_time: target_time,
              status: res_data[:status],
              created_at: Time.current,
              updated_at: Time.current
            }
          end
        end.compact
        
        Response.insert_all(responses_to_insert) if responses_to_insert.present?
      end
      
      render json: { message: '登録しました' }, status: :created
    end
    
    def update
      user = User.find(params[:id])
      
      ActiveRecord::Base.transaction do
        user.update!(user_params)
        user.responses.destroy_all
        
        event = user.event
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
      
      render json: { message: '予定を更新しました' }, status: :ok
      
      rescue => e
        render json: { error: '更新に失敗しました', details: e.message }, status: :unprocessable_entity
    end
    
    def authenticate
      user = User.find(params[:id])
      
      if user.authenticate(params[:password])
        render json: {message: '認証完了'}, status: :ok
      else
        render json: {message: 'パスワードが間違っています'}, status: :unauthorized
      end
    end
    
    def destroy
      user = User.find(params[:id])
      
      if user.authenticate(params[:password])
        user.destroy!
        render json: { message: "削除しました" }, status: :ok
      else
        render json: {message: 'パスワードが間違っています'}, status: :unauthorized
      end
    end
    
    private
    
      def user_params
        params.require(:user).permit(:name, :password, :comment)
      end
end