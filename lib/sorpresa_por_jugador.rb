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
    
    def aplicar_jugador_por_jugador(actual, todos) 
      if (super.jugador_correcto(actual, todos))
        super.informe(actual,todos)
        jugador = todos[actual]
        pago = SorpresaPagarCobrar.new(-1 * @valor, @texto)

        for j in todos
          pago.aplicar_jugador(j, todos) if j != jugador
        end

        cobro = SorpresaPagarCobrar.new((todos.size-1) * @valor, @texto)
        cobro.aplicar_jugador(actual, todos)
      end
    end
  end
end
