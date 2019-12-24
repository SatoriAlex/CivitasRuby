# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class CasillaSorpresa < Casilla
    def initialize (mazo, nombre)
      super(nombre)
      @mazo = mazo
    end
    
    def recibe_jugador_sorpresa(actual, todos)
      if self.jugador_correcto(actual, todos)
        sorpresa = @mazo.siguiente()
        self.informe(actual, todos)
        sorpresa.aplicar_jugador(actual, todos)
      end
    end
  end
end
