# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaIrCarcel < Sorpresa
    def initialize(tablero)
      super.init
      @tablero = tablero
    end
    
    def aplicar_jugador(actual, todos) 
      if (super.jugador_correcto(actual, todos))
        super.informe(actual,todos)
        todos[actual].encarcelar(@tablero.carcel);
      end
    end
  end
end
