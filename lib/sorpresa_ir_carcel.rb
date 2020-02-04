# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'sorpresa'
require_relative 'tablero'

module Civitas
  class SorpresaIrCarcel < Sorpresa
    alias :super_jugador_correcto :jugador_correcto
    alias :super_informe :informe
    
    def initialize(tablero)
      super()
      @tablero = tablero
      @texto = "Ir a la Carcel"
    end
    
    def aplicar_jugador(actual, todos) 
      if (super_jugador_correcto(actual, todos))
        super_informe(actual,todos)
        todos[actual].encarcelar(@tablero.num_casilla_carcel);
      end
    end
    
    def to_s
      puts super
    end
    
    public_class_method :new
  end
end
