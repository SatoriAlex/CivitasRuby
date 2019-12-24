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
    
    def aplicar_jugador(actual, todos)
      if (super.jugador_correcto(actual, todos))
        super.informe(actual,todos)
        jugador = todos[actual]

        posicion = @tablero.calcular_tirada(jugador.num_casilla_actual, @valor)
        @tablero.nueva_posicion(jugador.num_casilla_actual, posicion)
        jugador.mover_casilla(posicion)
        casilla = @tablero.casilla(posicion)
        casilla.recibe_jugador(actual, todos)
      end
    end
  end
end
