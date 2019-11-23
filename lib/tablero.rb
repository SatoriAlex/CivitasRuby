# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require_relative 'casilla'
require_relative 'tipo_casilla'

module Civitas
  class Tablero
    attr_reader :numCasillaCarcel
   
    def initialize(indice = 0) 
      @numCasillaCarcel = indice > 1 ? indice : 1
      casilla = Casilla.new("Salida")
      @casillas = []
      @casillas << casilla
      @porSalida = 0
      @tieneJuez = false
    end
    
    private
    
    def correcto(num_casilla = 0)
      # parametro por defecto 0 porque la casilla salida siempre va estar
      return (!@casillas[num_casilla].nil? && @casillas.size > @numCasillaCarcel && @tieneJuez)
    end
    
    public
    
    def get_por_salida
      valor = @porSalida
      
      if @porSalida > 0
        @porSalida -= 1
      end
      
      return valor
    end
    
    def aniade_casilla(casilla)
      carcel = Casilla.new("Carcel")
      
      if (@casillas.size == @numCasillaCarcel)
        @casillas << carcel
      end
      
      @casillas << casilla
      
      if (@casillas.size == @numCasillaCarcel)
        @casillas << carcel
      end
    end
    
    def aniade_juez
      juez = Casilla.new(Tipo_casilla::JUEZ.to_s)
      
      unless @tieneJuez
        aniade_casilla(juez)
        @tieneJuez = true
      end
    end
    
    def get_casilla(numCasilla)
      return correcto(numCasilla)? @casillas[numCasilla] : nil
    end
    
    def nueva_posicion(actual, tirada)
      posicion = -1
      
      if correcto
        posicion = (actual + tirada) % @casillas.size()
        if (posicion != (actual + tirada))
          @porSalida += 1
        end
      end
      
      return posicion
    end
    
    def calcular_tirada(origen, destino)
      return ((destino - origen) + @casilla.size)
    end
  end
end
