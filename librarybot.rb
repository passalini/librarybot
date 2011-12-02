# -*- coding: utf-8 -*-
require 'capybara'

class Bot
  attr_accessor :session, :objeto_procurado
  def initialize(*params)
    Capybara.app_host = 'http://www.bibliotecas.uenf.br/informa/cgi-bin/biblio.dll/emprest?g=geral&bd=&p=GERAL'
    @session = Capybara::Session.new(:selenium)
    @session.visit('/')
  end

  def preencher(matricula, senha)
    @session.fill_in 'matricula', with: matricula
    @session.fill_in 'senha', with: senha
    @session.click_button 'Consultar'
  end

  def contem_livro?(livro)
    lista_de_objetos = @session.all('td', text: 'Renovação')

    lista_de_objetos.each do |objeto|
      if objeto.has_content? livro and objeto.has_link? :anyone
        @objeto_procurado = objeto
        return true
      end
    end
  end

  def renovar(livro)
    if contem_livro? livro
      @objeto_procurado.find('a', :text => 'Renovação').click
      if @objeto_procurado.has_content? "Publicação não renovada"
        return "Publicação não renovada"
      else
        return "Renovado"
      end
    end
  end
end
