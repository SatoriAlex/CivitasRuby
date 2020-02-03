# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'jugador'
require_relative 'casilla'

module Civitas
  class CasillaJuez < Casilla
    alias :super_informe :informe
    
    def initialize (num_casilla_carcel, nombre)
      super(nombre)
      @carcel = num_casilla_carcel
    end
    
    def recibe_jugador(actual, todos)
      super_informe(actual, todos)
      todos[actual].encarcelar(@carcel)
    end
    
    def to_s
      puts "\n   *---* Casilla Juez: #{@nombre} *---*" + 
           "\n  *---* Numero: #{@carcel} *---*" 
    end
  end
end
