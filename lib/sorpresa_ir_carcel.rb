# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaIrCarcel < Sorpresa
    def initialize(tablero)
      super.init
      @tablero = tablero
    end
    
    def aplicarAJugador(actual, todos) 
      if (super.jugadorCorrecto(actual, todos))
        super.informe(actual,todos)
        todos[actual].encarcelar(@tablero.getCarcel());
      end
    end
  end
end
