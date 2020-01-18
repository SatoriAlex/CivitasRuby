# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class CasillaSorpresa < Casilla
    alias :super_informe :informe
    
    def initialize (mazo, nombre)
      super(nombre)
      @mazo = mazo
    end
    
    def recibe_jugador_sorpresa(actual, todos)
      super_informe(actual, todos)
      sorpresa = @mazo.siguiente()
      sorpresa.aplicar_jugador(actual, todos)
    end
    
    def to_s
      puts "\n   *---* Casilla Sorpresa: #{@nombre} *---*";
    end
  end
end
