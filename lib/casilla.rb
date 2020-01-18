# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

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
      return ! todos[actual].nil?
    end
    
    def recibe_jugador(actual, todos) 
      if self.jugador_correcto(actual, todos)       
        if self.instance_of? CasillaCalle self.recibe_jugador_calle(actual, todos)
        elsif self.instance_of? CasillaImpuesto self.recibe_jugador_impuesto(actual, todos)
        elsif self.instance_of? CasillaJuez self.recibe_jugador_juez(actual, todos)
        elsif self.instance_of? CasillaSorpresa self.recibe_jugador_sorpresa(actual, todos)
        else self.informe(actual, todos)
        end
      end
    end
    
    def to_s
      puts "\n   *---* " + @nombre + " *---*"
    end
  end
end
