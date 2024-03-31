require "rails_helper"

# O describe serve para detalhar a suíte de testes que devem rolar
describe 'books API', type: :request do
  # É legal fazer um describe para cada tipo de rota GET, POST, DELETE etc
  describe 'GET /books' do
    # O bloco "before do" serve para rodar aquele código antes de qualquer outro
    before do
      # O FactoryBot é uma gema que permite criar modelos e podemos reutilizar ao longo dos nossos testes
      # Quando falamos de testes temos um banco de dados a parte só para testes e por isso precisamos do factorybot para criar em cada it
      FactoryBot.create(:book, title: "1984", author: "Geroge Orwell")
      FactoryBot.create(:book, title: "The time machine", author: "H.G Wells")
    end
    # Você utiliza blocos "it" para testar cada ação que deseja
    it "returns all books" do

      # Esse get chama o endpoint
      get "/api/v1/books"

      # Os "expects" são códigos para verificar se o retorno do endpoint retornou aquilo que esperamos
      # O expect abaixo testa o status de retorno do enpooint
      expect(response).to have_http_status(:success)
      # O expect abaixo testa se o tamanho do response que chegou do endpoint é igual a 2 (devido a criação dos dois livros no bloco "before do")
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /books' do
    it "create a new book" do
      # O bloco "expect" abaixo faz um post para o endpoint de criação e passa os parâmetros necessários para criação do livro. ALém disso ele expera que a contagem de livros do banco tenha mudado de 0 para 1 (lembrando que o banco de teste é diferente de dev)
      expect {
        post "/api/v1/books", params: { book: {title: 'The Martian', author: 'Andy Weir'} }
    }.to change{ Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE /books/:id' do
    # O "let" abaixo define a variável book fora do bloco it para que todos os blocos it possam se aproveitar desta variável sem precisar ficar criando toda hora. A variável book fica disponível no bloco de describe inteiro(neste caso o de DELETE)
    let!(:book) { FactoryBot.create(:book, title: "1984", author: "Geroge Orwell") }

    it "deletes a book" do
      expect {
        delete "/api/v1/books/#{book.id}"
    }.to change{ Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end
