# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class CasillaImpuesto < Casilla
    def initialize(cantidad, nombre)
      super(nombre)
      @importe = cantidad
    end
    
    def recibe_jugador_impuesto(actual, todos) 
      if self.jugador_correcto(actual, todos)
        self.informe(actual, todos)
        todos[actual].paga_impuesto(@importe)
      end
    end
    
    def to_s
      return "\n   *---* " + @nombre + " *---*"
      + "  *---* Importe: " + @importe + " *---*"
    end
  end
end
