# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'jugador'
require_relative 'gestor_estados'
require_relative 'dado'
require_relative 'tablero'
require_relative 'mazo_sorpresa'

module Civitas
  class CivitasJuego
    def initialize(nombres)
      total_jugadores = 4
      
      @jugadores = []
      
      for i in 1..total_jugadores do
        @jugadores.push(Jugador.new(nombres[i]))
      end
      
      @gestorEstados = Gestor_estados.new
      @estado = @gestorEstados.estado_inicial
      @indiceJugadorActual = Dado.instance.quien_empieza(total_jugadores)
      @tablero = Tablero.new(30)
     
      casilla = Casilla.new
      for i in 1..39   
        @tablero.aniade_casilla(casilla)
      end
      
      @tablero.aniade_juez
      
      @mazo = MazoSorpresa.new
    end
    
    def cancelarHipoteca(ip) 
      return self.getJugadorActual.cancelarHipoteca(ip)
    end
    
    def comprar
      jugadorActual = self.getJugadorActual
      casilla = self.getCasillaActual
      titulo = casilla.tituloPropiedad
      res = jugadorActual.comprar(titulo)
      
      return res
    end
    
    def construirCasa(ip) 
      return self.getJugadorActual.construirCasa(ip)
    end
    
    def construirHotel(ip) 
      return self.getJugadorActual.construirHotel(ip)
    end
    
    def finalDelJuego
      return self.getJugadorActual.enBancarrota
    end
    
    def getCasillaActual 
      return @tablero.get_casilla(self.getJugadorActual.numCasillaActual)
    end
    
    def getJugadorActual
      return @jugadores[@indiceJugadorActual]
    end
    
    def hipotecar(ip) 
      return self.getJugadorActual.hipotecar(ip)
    end
    
    def infoJugadorTexto 
      salida = self.getJugadorActual.to_s
      
      if self.finalDelJuego
        salida += self.ranking
      end
      
      return salida
    end
    
    def salirCarcelPagando 
      return self.getJugadorActual.salirCarcelPagando
    end
    
    def salirCarcelTirando 
      return self.getJugadorActual.salirCarcelTirando
    end
    
    def siguientePaso 
      jugadorActual = self.getJugadorActual
      operacion = @gestorEstados.operaciones_permitidas(jugadorActual, @estado)
      
      if operacion == Operaciones_juego::PASAR_TURNO
        self.pasarTurno
        self.siguientePasoCompletado(operacion)
      elsif operacion == Operaciones_juego::AVANZAR
        avanzaJugador
        self.siguientePasoCompletado(operacion)
      end
      
      return operacion
    end
    
    def siguientePasoCompletado(operacion) 
      @estado = @gestorEstados.siguiente_estado(self.getJugadorActual, @estado, operacion)
    end
    
    def vender(ip) 
      return self.getJugadorActual.vender(ip)
    end
    
    private
    
    def avanzaJugador 
      jugador_actual = self.getJugadorActual
      
      posicion_actual = jugador_actual.numCasillaActual
      tirada = Dado.instance.tirar
      posicion_nueva = @tablero.nueva_posicion(posicion_actual, tirada)
      casilla = @tablero.get_casilla(posicion_nueva)
      
      contabilizarPasosPorSalida(jugador_actual)
      
      jugador_actual.moverACasilla(posicion_nueva)
      
      casilla.recibeJugador(@indiceJugadorActual, @jugadores)
      contabilizarPasosPorSalida(jugador_actual)
    end
    
    def inicializarMazoSorpresas(tablero) 
      @tablero = tablero
      @mazo = MazoSorpresa.new 
    end
    
    def inicializarTablero(mazo) 
      @mazo = mazo
      @tablero = Tablero.new(30)
    end
    
    def pasarTurno 
      @indiceJugadorActual = @indiceJugadorActual + 1 % @jugadores.size
    end
    
    def ranking
      return @jugadores.sort
    end
    
    def contabilizarPasosPorSalida(jugadorActual) 
      jugadorActual.pasaPorSalida while @tablero.get_por_salida > 0
    end
  end
end
