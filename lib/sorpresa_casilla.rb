# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaCasilla < Sorpresa
    def initialize(tablero, valor, texto)
      super.init
      @tablero = tablero
      @valor = valor
      @texto = texto
    end
    
    def aplicarAJugador(actual, todos)
      if (super.jugadorCorrecto(actual, todos))
        super.informe(actual,todos)
        jugador = todos[actual]

        posicion = @tablero.calcularTirada(jugador.getNumCasillaActual, @valor)
        @tablero.nuevaPosicion(jugador.getNumCasillaActual, posicion)
        jugador.moverACasilla(posicion)
        casilla = @tablero.getCasilla(posicion)
        casilla.recibeJugador(actual, todos)
      end
    end
  end
end
