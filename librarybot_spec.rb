# -*- coding: utf-8 -*-
require './librarybot'
require 'capybara/rspec'

describe 'Site da biblioteca' do
  Capybara.app_host = 'http://www.bibliotecas.uenf.br/informa/cgi-bin/biblio.dll/emprest?g=geral&bd=&p=GERAL'
  session = Capybara::Session.new(:selenium)
  session.visit('/')

  context "verificacao de campos" do
    it "deveria conter os campos 'matricula' e 'senha'" do
      session.should have_field "matricula"
      session.should have_field 'senha'
    end
  end


end

describe Aluno do
  before  do
    @aluno = Aluno.new('Matricula', 'Senha')
    @aluno.visitar
    @aluno.logar
  end

  context 'preencher campos' do
    it "ao fornecer senha e matricula (validas), deve estar na pagina de emprestimo" do
      @aluno.session.should have_content 'Nova Consulta'
    end
  end

  context "Renovação" do

    it 'deve conter uma lista de livros' do
      @aluno.obter_livros_em_emprestimo
      @aluno.livros_em_emprestimo.length.should_not == 0
    end

    it "deve renovar o livro pedido, pelo nome do livro" do
      @aluno.obter_livros_em_emprestimo
      @aluno.renovar('Nome do livro')
      @aluno.session.should have_content "Publicação Renovada"
    end
  end

end
