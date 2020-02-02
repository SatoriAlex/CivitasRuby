# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'jugador'

module Civitas
  class CasillaImpuesto < Casilla
    alias :super_informe :informe
    
    def initialize(cantidad, nombre)
      super(nombre)
      @importe = cantidad
    end
    
    def recibe_jugador(actual, todos) 
      super_informe(actual, todos)
      todos[actual].paga_impuesto(@importe)
    end
    
    def to_s
      puts super + "  *---* Importe: " + @importe + " *---*"
    end
  end
end
