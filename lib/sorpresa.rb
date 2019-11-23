# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa
    def initialize(tipo = nil, tablero = nil, valor = nil, texto = nil, mazo = nil)
      init
      @texto = texto
      @valor = valor unless valor.nil?
      @tipo = tipo
      @tablero = tablero
      @mazo = mazo
    end 
    
    def aplicarAJugador(actual, todos) 
      if (self.jugadorCorrecto(actual, todos))
        self.informe(actual,todos)
        
        if @tipo == Tipo_sorpresa::IRCARCEL
          self.aplicarAJugador_irCarcel(actual, todos);
        elseif @tipo == Tipo_sorpresa::IRCASILLA
          self.aplicarAJugador_irACasilla(actual, todos);
        elseif @tipo == Tipo_sorpresa::PAGARCOBRAR
          self.aplicarAJugador_pagarCobrar(actual, todos);
        elseif @tipo == Tipo_sorpresa::PORCASAHOTEL
          self.aplicarAJugador_porCasaHotel(actual, todos);
        elseif @tipo == Tipo_sorpresa::PORJUGADOR
          self.aplicarAJugador_porJugador(actual, todos);
        elseif @tipo == Tipo_sorpresa::SALIRCARCEL
          self.aplicarAJugador_salirCarcel(actual, todos);
        end
      end
    end
    
    def jugadorCorrecto(actual, todos) 
      return ! todos[actual].nil?
    end
    
    def salirDelMazo
      if @tipo == Tipo_sorpresa.SALIRCARCEL
        @mazo.inhabilitarCartaEspecial(self);
      end
    end
    
    def to_s 
        return @texto;
    end
    
    def usada
      if @tipo == Tipo_sorpresa.SALIRCARCEL
        @mazo.habilitarCartaEspecial(self);
      end
    end
    
    private 
    
    def aplicarAJugador_irACasilla(actual, todos) 
      jugador = todos[actual]
      
      posicion = @tablero.calcularTirada(jugador.getNumCasillaActual, @valor)
      @tablero.nuevaPosicion(jugador.getNumCasillaActual, posicion)
      jugador.moverACasilla(posicion)
      casilla = @tablero.getCasilla(posicion)
      casilla.recibeJugador(actual, todos)
    end
    
    def aplicarAJugador_irCarcel(actual, todos) 
      todos[actual].encarcelar(@tablero.getCarcel());
    end
    
    def aplicarAJugador_pagarCobrar(actual, todos) 
      jugador = todos[actual]
      jugador.modificarSaldo(@valor)
    end
    
    def aplicarAJugador_porCasaHotel(actual, todos) 
      jugador = todos[actual]
      jugador.modificarSaldo(@valor * jugador.cantidadCasasHoteles)
    end
    
    def aplicarAJugador_porJugador(actual, todos) 
      jugador = todos[actual]
      pago = Sorpresa.new(Tipo_sorpresa.PAGARCOBRAR, -1*@valor, @texto)
      
      for j in todos
        pago.aplicarAJugador(j, todos) if j != jugador
      end
      
      cobro = Sorpresa.new(Tipo_sorpresa.PAGARCOBRAR, (todos.size-1)*@valor, @texto)
      cobro.aplicarAJugador(actual, todos)
    end
    
    def aplicarAJugador_salirCarcel(actual, todos) 
      jugador = todos[actual]
      
      for j in todos
        if j != jugador
          encontrado = j.tieneSalvoconducto
        end
      end
      
      unless encontrado
        todos[actual].obtenerSalvoconducto(self)
        self.salirDelMazo
      end
    end
    
    def informe(actual, todos) 
      @diario.ocurre_evento("Aplicando sorpresa: #{@texto} al jugador #{todos[actual].getNombre}")
    end
    
    def init
      @valor = -1
      @tablero = nil
      @mazo = nil
    end
  end
end
