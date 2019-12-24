# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaSalirCarcel < Sorpresa
    def initialize(mazo)
      super.init
      @mazo = mazo
    end
    
    def aplicar_jugador_salir_carcel(actual, todos) 
      if (super.jugador_correcto(actual, todos))
        super.informe(actual,todos)
        jugador = todos[actual]

        for j in todos
          if j != jugador
            encontrado = j.tiene_salvoconducto
          end
        end

        unless encontrado
          todos[actual].obtener_salvoconducto(self)
          self.salir_del_mazo
        end
      end
    end
    
    def salir_del_mazo
      @mazo.inhabilitar_carta_especial(self)
    end
    
    def usada
      @mazo.habilitar_carta_especial(self)
    end
  end
end
