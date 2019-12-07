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
      @mazo = MazoSorpresa.new
      @tablero = Tablero.new(9)
      
      @tablero.aniade_casilla(TituloPropiedad.new("Ronda de Valencia", 35, 0.5, 55, 60, 120));
      @tablero.aniade_casilla(@mazo, "Caja de Comunidad");
      @tablero.aniade_casilla(200, "Impuesto sobre el capital");

      @tablero.aniade_casilla(TituloPropiedad.new("Glorieta cuatro caminos", 55, 0.5, 95, 100, 200));
      @tablero.aniade_casilla(@mazo, "Suerte");
      @tablero.aniade_casilla(TituloPropiedad.new("Calle bravo Murillo", 65, 0.5, 115, 120, 240));

      @tablero.aniade_casilla(TituloPropiedad.new("Glorieta de Bilbao", 75, 0.5, 135, 140, 280));
      @tablero.aniade_casilla(TituloPropiedad.new("Calle Fuencarral", 85, 0.5, 155, 160, 320));
      @tablero.aniade_casilla(TituloPropiedad.new("Avenida Felipe II", 95, 0.5, 175, 180, 360));
      @tablero.aniade_casilla(@mazo, "Caja de Comunidad");
      @tablero.aniade_casilla(TituloPropiedad.new("Calle Serrano", 105, 0.5, 195, 200, 400));
      @tablero.aniade_casilla("Parking Gratuito");

      @tablero.aniade_casilla(TituloPropiedad.new("Avenida de America", 115, 0.5, 215, 220, 440));
      @tablero.aniade_casilla(@mazo, "Suerte");
      @tablero.aniade_casilla(TituloPropiedad.new("Calle de Cea Bermudez", 125, 0.5, 235, 240, 480));
      @tablero.aniade_casilla(TituloPropiedad.new("Avenida de los Reyes Catolicos", 135, 0.5, 255, 260, 520));
      @tablero.aniade_casilla(TituloPropiedad.new("Plaza de Espana", 145, 0.5, 275, 280, 560));
      @tablero.aniadeJuez();

      @tablero.aniade_casilla(TituloPropiedad.new("Puerta del Sol", 155, 0.5, 295, 300, 600));
      @tablero.aniade_casilla(@mazo, "Caja de Comunidad");
      @tablero.aniade_casilla(TituloPropiedad.new("Gran Via", 165, 0.5, 315, 320, 640));
      @tablero.aniade_casilla(@mazo, "Suerte");
      @tablero.aniade_casilla(100, "Impuesto de Lujo");
      @tablero.aniade_casilla(TituloPropiedad.new("Paseo del Prado", 205, 0.5, 395, 400, 800));
    end
    
    def cancelarHipoteca(ip) 
      return self.getJugadorActual.cancelarHipoteca(ip)
    end
    
    def comprar
      jugadorActual = self.getJugadorActual
      casilla = self.getCasillaActual
      titulo = casilla.tituloPropiedad
      res = jugadorActual.comprar(titulo)
      
      if res 
          puts "Lo has comprado"
      else
          puts "No lo has comprado"
      end
      
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
