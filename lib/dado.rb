# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'singleton'

require_relative 'Diario'

module Civitas
  class Dado
    include Singleton
    attr_reader :ultimoResultado, :debug
    
    def initialize
      @@SalidaCarcel = 5
      @ultimoResultado = rand(1..6)
      @debug = false
    end
    
    def tirar
      resultado = !@debug? rand(1..6) : 1
      @ultimoResultado = resultado
      
      return resultado
    end
    
    def salgo_de_la_carcel
      return (tirar >= 5)
    end
    
    def quien_empieza(n)
      return rand(0..n-1)
    end
    
    def set_debug(d)
      @debug = d
      
      diario = Diario.instance
      
      if (@debug)
        diario.ocurre_evento("Activado modo debug")
      else
        diario.ocurre_evento("Desactivado modo debug")
      end
    end
  end
end
