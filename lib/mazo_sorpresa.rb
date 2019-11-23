# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class MazoSorpresa
    attr_reader :ultimaSorpresa
    
    def initialize(debug = nil)
      @debug = false
        
      unless (debug.nil?)
        @debug = debug
        diario = Diario.instance
      
        if (@debug)
          diario.ocurre_evento("Activado modo debug")
        else
          diario.ocurre_evento("Desactivado modo debug")
        end
      end
      init
    end
  
    private
    
    def init
      @sorpresas = []
      @cartas_especiales = []
      @barajada = false
      @usadas = 0
    end
    
    public
    
    def al_mazo(s)
      unless @barajado
        @sorpresas << s
      end
    end
    
    def siguiente
      if ((!@barajada || @usuadas == @sorpresas.size) && !@debug)
        @sorpresas.shuffle!
        @usadas = 0
        @barajada = true
      end
      
      @usadas += 1
      s = @sorpresas.shift
      @sorpresas << s
      @ultimaSorpresa = s
      
      return s
    end
    
    def inhabilitar_carta_especial(s)
      diario = Diario.instance
      
      if @sorpresas.delete(s)
        @cartas_especiales << s
      end
      
      if (! @sorpresas.include? s and @cartas_especiales.include? s)
        diario.ocurre_evento("Carta sorpresa inhabilitada: " + s)
      end
    end
    
    def habilitar_carta_especial(s)
      diario = Diario.instance
      
      if @cartas_especiales.delete(s)
        @sorpresas << s
      end
      
      if (! @cartas_especiales.include? s and @sorpresas.include? s)
        diario.ocurre_evento("Carta sorpresa habilitada: " + s)
      end
    end
  end
end
