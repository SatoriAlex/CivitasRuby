# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaPorCasaHotel < Sorpresa
    def initialize(valor, texto)
      super.init
      @valor = valor
      @texto = texto
    end
    
    def aplicarAJugador_porCasaHotel(actual, todos)
      if (super.jugadorCorrecto(actual, todos))
        super.informe(actual,todos)
        jugador = todos[actual]
        jugador.modificarSaldo(@valor * jugador.cantidadCasasHoteles)
      end
    end
  end
end
