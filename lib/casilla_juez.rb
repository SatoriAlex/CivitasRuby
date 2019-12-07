# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class CasillaJuez < Casilla
    def initialize (num_casilla_carcel, nombre)
      super(nombre)
      @carcel = num_casilla_carcel
    end
    
    def recibeJugador_juez(actual, todos)
      if self.jugadorCorrecto(actual, todos)
        self.informe(actual, todos)
        todos[actual].encarcelar(@carcel)
      end
    end
  end
end
