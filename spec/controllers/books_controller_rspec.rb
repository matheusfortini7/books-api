require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  it "Has a max limit of 100" do
    expect(Book).to receive(:limit).with(100).and_call_original

    get :index, params: { limit: 999 }
  end

  context 'missong authorization header (create)' do
    it 'returns a 401' do
      post :create, params: {}

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'missing authorization header (delete)' do
    it 'returns a 401' do
      delete :destroy, params: { id: 1 }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
