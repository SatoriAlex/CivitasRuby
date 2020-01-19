# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa'

module Civitas
  class SorpresaSalirCarcel < Sorpresa
    alias :super_jugador_correcto :jugador_correcto
    alias :super_informe :informe
    
    def initialize(mazo)
      super()
      @mazo = mazo
      @texto = "Salir de la carcel"
    end
    
    def aplicar_jugador(actual, todos) 
      if (super_jugador_correcto(actual, todos))
        super_informe(actual,todos)
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
    
    def to_s
      puts super
    end
    
    public_class_method :new
  end
end
