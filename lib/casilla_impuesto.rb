# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class CasillaImpuesto < Casilla
    def initialize(cantidad, nombre)
      super(nombre)
      @importe = cantidad
    end
    
    def recibeJugador_impuesto(actual, todos) 
      if self.jugadorCorrecto(actual, todos)
        self.informe(actual, todos)
        todos[actual].pagaImpuesto(@importe)
      end
    end
    
    def to_s
      return "\n   *---* " + @nombre + " *---*"
      + "  *---* Importe: " + @importe + " *---*"
    end
  end
end
