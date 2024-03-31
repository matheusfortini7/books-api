require "rails_helper"

# O describe serve para detalhar a suíte de testes que devem rolar
describe 'books API', type: :request do
  describe 'GET /books' do
    # Você utilizar blocos "it" para testar cada ação que deseja
    before do
      FactoryBot.create(:book, title: "1984", author: "Geroge Orwell")
      FactoryBot.create(:book, title: "The time machine", author: "H.G Wells")
    end
    it "returns all books" do

      # O FactoryBot é uma gema que permite criar modelos e podemos reutilizar ao longo dos nossos testes
      # Quando falamos de testes temos um banco de dados a parte só para testes e por isso precisamos do factorybot para criar em cada it

      # Esse get chama o endpoint
      get "/api/v1/books"

      # Os "expects" são códigos para verificar se o retorno do endpoint retornou aquilo que esperamos
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /books' do
    it "create a new book" do
      expect {
        post "/api/v1/books", params: { book: {title: 'The Martian', author: 'Andy Weir'} }
    }.to change{ Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)

    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: "1984", author: "Geroge Orwell") }

    it "deletes a book" do
      expect {
        delete "/api/v1/books/#{book.id}"
    }.to change{ Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end
