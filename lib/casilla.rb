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
    
    def jugadorCorrecto(actual, todos) 
      return ! todos[actual].nil?
    end
    
    def recibeJugador(actual, todos) 
      if self.instance_of? CasillaCalle self.recibeJugador_calle(actual, todos)
      elsif self.instance_of? CasillaImpuesto self.recibeJugador_impuesto(actual, todos)
      elsif self.instance_of? CasillaJuez self.recibeJugador_juez(actual, todos)
      elsif self.instance_of? CasillaSorpresa self.recibeJugador_sorpresa(actual, todos)
      else
        informe(actual, todos)
      end
    end
    
    def to_s
      return "\n   *---* " + @nombre + " *---*"
    end
  end
end
