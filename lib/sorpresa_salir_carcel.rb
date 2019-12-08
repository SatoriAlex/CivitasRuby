# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaSalirCarcel < Sorpresa
    def initialize(mazo)
      super.init
      @mazo = mazo
    end
    
    def aplicarAJugador_salirCarcel(actual, todos) 
      if (super.jugadorCorrecto(actual, todos))
        super.informe(actual,todos)
        jugador = todos[actual]

        for j in todos
          if j != jugador
            encontrado = j.tieneSalvoconducto
          end
        end

        unless encontrado
          todos[actual].obtenerSalvoconducto(self)
          self.salirDelMazo
        end
      end
    end
    
    def salirDelMazo
      @mazo.inhabilitarCartaEspecial(self)
    end
    
    def usada
      @mazo.habilitarCartaEspecial(self)
    end
  end
end
