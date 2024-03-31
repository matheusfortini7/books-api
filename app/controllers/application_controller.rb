class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed

  private

  # Serve para tratar erro em caso de requisição para o delete não funcionar
  def not_destroyed(e)
    render json: {erros: e.record.errors}, status: :unprocessable_entity
  end
end
