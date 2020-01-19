# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa'

module Civitas
  class SorpresaCasilla < Sorpresa
    alias :super_jugador_correcto :jugador_correcto
    alias :super_informe :informe
    
    def initialize(tablero, valor, texto)
      super()
      @tablero = tablero
      @valor = valor
      @texto = texto
    end
    
    def aplicar_jugador(actual, todos)
      if (super_jugador_correcto(actual, todos))
        super_informe(actual,todos)
        jugador = todos[actual]

        posicion = @tablero.calcular_tirada(jugador.num_casilla_actual, @valor)
        @tablero.nueva_posicion(jugador.num_casilla_actual, posicion)
        jugador.mover_casilla(posicion)
        casilla = @tablero.casilla(posicion)
        casilla.recibe_jugador(actual, todos)
      end
    end
    
    def to_s
      puts super + "\n *--* Valor: #{@valor} *--*"
    end
    
    public_class_method :new
  end
end
