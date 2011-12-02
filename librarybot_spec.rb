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

describe 'Bot' do
  cont = 0  #Arrumar um jeito melhor pra isso (21..31), por enquanto não descobri como...
  gambiarra = :foo
  livro = 'Livro'

  before do
    cont = cont + 1
    if cont < 2
      @bot = Bot.new
    else
      @bot = gambiarra
    end
  end

  after do
    gambiarra = @bot
  end

  context 'preencher campos' do
    it "ao fornecer senha e matricula (validas), deve estar na pagina de emprestimo" do
      matricula = 'sua matricula'
      senha = 'sua senha'
      @bot.preencher(matricula, senha)
      @bot.session.should have_content 'Nova Consulta'
    end
  end

  context 'na pagina de emprestimo' do
    it "deve conter o livro fonecido" do
      @bot.session.should have_content livro
    end

    it "deveria conter um link para renovar o livro" do
      @bot.contem_livro?(livro).should == true
    end
  end

  context "Renovação" do
    it "deveria retornar o status do livro pedido" do
      @bot.renovar(livro).should == ('Renovado' or "Publicação não renovada")
    end
  end

end
