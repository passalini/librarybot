# -*- coding: utf-8 -*-
require 'capybara'
require 'nokogiri'

class Livro
    def initialize(autor, nome, data_devolucao, link_para_renovar)
        @autor = autor
        @nome = nome
        @data_devolucao = data_devolucao
        @link_para_renovar = link_para_renovar
    end

    attr_accessor :autor, :nome, :data_devolucao, :link_para_renovar

end

class Aluno
    def initialize(matricula, senha)
        @matricula, @senha = matricula, senha
        @livros_em_emprestimo = []
    end

    attr_accessor :session, :objeto_procurado, :livros_em_emprestimo

    def visitar
        Capybara.app_host = 'http://www.bibliotecas.uenf.br/informa/cgi-bin/biblio.dll/emprest?g=geral&bd=&p=GERAL'
        @session = Capybara::Session.new(:selenium)
    end

    def obter_livros_em_emprestimo

        doc = Nokogiri::HTML(@session.html)
        informacoes_de_livros = doc.xpath('//p')
        links = doc.xpath('//a')
        for livro in 1...(informacoes_de_livros.length)
            @livros_em_emprestimo << Livro.new( informacoes_de_livros[livro].children[2].to_str ,
                                                informacoes_de_livros[livro].children[3].to_str ,
                                                informacoes_de_livros[livro].children[15].to_str ,
                                                links[livro].attributes.values[0].to_str)
        end
        return @livros_em_emprestimo
    end

    def logar
        @session.visit('/')
        @session.fill_in 'matricula', with: @matricula
        @session.fill_in 'senha', with: @senha
        @session.click_button 'Consultar'
      end

    def renovar(nome_do_livro)
      livros_em_emprestimo.each do |livro|
        @session.visit(livro.link_para_renovar) if livro.nome == nome_do_livro
      end
    end
end
