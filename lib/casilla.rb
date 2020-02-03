# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'diario'
require_relative 'jugador'


module Civitas 
  class Casilla
    attr_reader :nombre
    
    def initialize(nombre)
      @nombre = nombre
    end 
    
    def informe(actual, todos)
      diario = Diario.instance
      diario.ocurre_evento("Jugador: #{todos[actual]} Casilla: #{self.to_s}")
    end
    
    def jugador_correcto(actual, todos) 
      return !todos[actual].nil?
    end
    
    def recibe_jugador(actual, todos) 
      if jugador_correcto(actual, todos)
        informe(actual, todos)
      end
    end
    
    def to_s
      puts "\n*---* " + @nombre + " *---*"
    end
  end
end
