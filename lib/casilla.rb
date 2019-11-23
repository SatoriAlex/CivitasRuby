# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Casilla
    attr_reader :nombre, :tituloPropiedad
    
    def initialize(nombre = nil, titulo = nil, cantidad = nil, num_casilla_carcel = nil, mazo = nil)
      init
      @carcel = num_casilla_carcel unless num_casilla_carcel.nil?
      @importe = cantidad unless cantidad.nil?
      @nombre = nombre unless nombre.nil?
      
      unless titulo.nil?
        @tituloPropiedad = titulo
        @tipo = TipoCasilla::CALLE
      else
        unless mazo.nil?
          @mazo = mazo
          @tipo = TipoCasilla::SORPRESA
        end
      end
    end 
    
    
    private
    
    def informe(actual, todos)
      diario = Diario.instance
      diario.ocurre_evento("Jugador: #{todos[actual]} Casilla: #{self.to_s}")
    end
    
    def init
      @nombre = "Defecto";
      @importe = 0.0;
      @carcel = 1;
    end
        
    def recibeJugador_impuesto(actual, todos) 
      if self.jugadorCorrecto(actual, todos)
        self.informe(actual, todos)
        todos[actual].pagaImpuesto(@importe)
      end
    end
    
    def recibeJugador_juez(actual, todos)
      if self.jugadorCorrecto(actual, todos)
        self.informe(actual, todos)
        todos[actual].encarcelar(@carcel)
      end
    end
    
    def recibeJugador_sorpresa(actual, todos)
      if self.jugadorCorrecto(actual, todos)
        sorpresa = @mazo.siguiente()
        self.informe(actual, todos)
        sorpresa.aplicarAJugador(actual, todos)
      end
    end
    
    def recibeJugador_calle(actual, todos)
      if self.jugadorCorrecto(actual, todos) 
        self.informe(actual, todos)
        jugador = todos[actual]
        
        if !@tituloPropiedad.tienePropietario 
          jugador.puedeComprarCasilla
        else
          @tituloPropiedad.tramitarAlquiler(jugador)
        end
      end
    end
    
    public
    
    def jugadorCorrecto(actual, todos) 
      return ! todos[actual].nil?
    end
    
    def recibeJugador(actual, todos) 
      case @tipo
      when Tipo_casilla::CALLE then self.recibeJugador_calle(actual, todos)
      when Tipo_casilla::IMPUESTO then self.recibeJugador_impuesto(actual, todos)
      when Tipo_casilla::JUEZ then self.recibeJugador_juez(actual, todos)
      when Tipo_casilla::SORPRESA then self.recibeJugador_sorpresa(actual, todos)
      else
        informe(actual, todos)
      end
    end
    
    def to_s
      return "Nombre: #{@nombre}  Importe: #{@importe}"
    end
  end
end
