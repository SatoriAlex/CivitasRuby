# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaPorJugador < Sorpresa
    def initialize(valor, texto)
      super.init
      @valor = valor
      @texto = texto
    end
    
    def aplicarAJugador_porJugador(actual, todos) 
      if (super.jugadorCorrecto(actual, todos))
        super.informe(actual,todos)
        jugador = todos[actual]
        pago =  SorpresaPagarCobrar.new( -1*@valor, @texto)

        for j in todos
          pago.aplicarAJugador(j, todos) if j != jugador
        end

        cobro =  SorpresaPagarCobrar.new((todos.size-1)*@valor, @texto)
        cobro.aplicarAJugador(actual, todos)
      end
    end
  end
end
