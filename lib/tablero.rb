# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require_relative 'casilla'
require_relative 'casilla_juez'
require_relative 'tipo_casilla'

module Civitas
  class Tablero
    attr_reader :num_casilla_carcel
   
    def initialize(indice) 
      @num_casilla_carcel = indice > 1 ? indice : 1
      casilla = Casilla.new("Salida")
      @casillas = []
      @casillas << casilla
      @por_salida = 0
      @tiene_juez = false
    end
    
    private
    
    def correcto(num_casilla = 0)
      # parametro por defecto 0 porque la casilla salida siempre va estar
      return true
      return (!@casillas[num_casilla].nil? && @casillas.size > @num_casilla_carcel && @tiene_juez)
    end
    
    public
    
    def por_salida
      valor = @por_salida
      
      if @por_salida > 0
        @por_salida -= 1
      end
      
      return valor
    end
    
    def aniade_casilla(casilla)
      carcel = Casilla.new("Carcel")
      
      if (@casillas.size == @num_casilla_carcel)
        @casillas << carcel
      end
      
      @casillas << casilla
      
      if (@casillas.size == @num_casilla_carcel)
        @casillas << carcel
      end
    end
    
    def aniade_juez
      juez = CasillaJuez.new(@num_casilla_carcel, "Ve a la carcel")
      
      unless @tiene_juez
        aniade_casilla(juez)
        @tiene_juez = true
      end
    end
    
    def casilla(num_casilla)
      return correcto(num_casilla)? @casillas[num_casilla] : nil
    end
    
    def nueva_posicion(actual, tirada)
      posicion = -1
      
      if correcto
        posicion = (actual + tirada) % @casillas.size()
        if (posicion != (actual + tirada))
          @por_salida += 1
        end
      end
      
      return posicion
    end
    
    def calcular_tirada(origen, destino)
      valor = (destino - origen)
      
      if valor < 0
        valor += @casillas.size
      end
      
      return valor
    end
  end
end
