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

  context 'preencher campos' do
    it "ao fornecer senha e matricula (validas), deve estar na pagina de emprestimo e obter dados dos livros" do
      aluno = Aluno.new('matricula', 'senha')
      aluno.visitar('http://www.bibliotecas.uenf.br/informa/cgi-bin/biblio.dll/emprest?g=geral&bd=&p=GERAL')
      aluno.logar
      aluno.livros_em_emprestimo.first.codigo.should == "codigo_do_primeiro_livro"
      aluno.livros_em_emprestimo.last.link_para_renovar.should == "link_para_renovar_ultino_livro"
      aluno.session.should have_content 'Nova Consulta'
    end
  end


  context "Renovação" do
    it "deve renovar o primeiro livro" do
      aluno = Aluno.new('matricula', 'senha')
      aluno.visitar('http://www.bibliotecas.uenf.br/informa/cgi-bin/biblio.dll/emprest?g=geral&bd=&p=GERAL')
      aluno.logar
      aluno.renovar(aluno.livros_em_emprestimo.first)
      aluno.session.should have_content "Publicação Renovada"
    end
  end

end

