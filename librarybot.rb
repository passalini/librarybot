require 'capybara'
require 'nokogiri'

class Livro
    def initialize(codigo, data_devolucao, link_para_renovar)
        @codigo, @data_devolucao, @link_para_renovar = codigo, data_devolucao, link_para_renovar
    end

    attr_accessor :codigo, :data_devolucao, :link_para_renovar

end

class Aluno
    def initialize(matricula, senha)
        @matricula, @senha = matricula, senha
        @livros_em_emprestimo = []
    end

    attr_accessor :session, :objeto_procurado

    def visitar(site)
        Capybara.app_host = site
        @session = Capybara::Session.new(:selenium)
    end

    def livros_em_emprestimo

        doc = Nokogiri::HTML(@session.html)
        informacoes_de_livros = doc.xpath('//p')
        links = doc.xpath('//a')
        for livro in 1..(informacoes_de_livros.length) -1
            @livros_em_emprestimo << Livro.new( informacoes_de_livros[livro].to_str.split.first ,
                                                informacoes_de_livros[livro].to_str.split.last ,
                                                links[livro].to_s)
        end
        @livros_em_emprestimo
    end

    def logar
        @session.visit('/')
        @session.fill_in 'matricula', with: @matricula
        @session.fill_in 'senha', with: @senha
        @session.click_button 'Consultar'
      end

    def renovar(livro)
        @session.visit(livro.link_para_renovar)
    end
end

