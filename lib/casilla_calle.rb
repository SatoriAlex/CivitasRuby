# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'titulo_propiedad'

module Civitas
  class CasillaCalle < Casilla
    attr_reader :titulo_propiedad
    alias :super_informe :informe
    
    def initialize(titulo_propiedad)
      super(titulo_propiedad.nombre)
      @titulo_propiedad = titulo_propiedad
    end
    
    def recibe_jugador_calle(actual, todos)
      super_informe(actual, todos)
      jugador = todos[actual]

      if !@titulo_propiedad.tiene_propietario 
        jugador.puede_comprar_casilla
      else
        @titulo_propiedad.tramitarAlquiler(jugador)
      end
    end
    
    def to_s 
      puts "\n   *---* Nombre de la propiedad: #{@nombre} *---*"
    end
  end
end
