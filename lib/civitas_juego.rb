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
      self.inicializarTablero(MazoSorpresa.new())
      self.inicializarMazoSorpresas(Tablero.new(9))
    end
    
    def cancelar_hipoteca(ip) 
      return self.jugador_actual.cancelar_hipoteca(ip)
    end
    
    def comprar
      jugador_actual = self.jugador_actual
      casilla = self.casilla_actual
      titulo = casilla.tituloPropiedad
      res = jugador_actual.comprar(titulo)
      
      if res 
          puts "Lo has comprado"
      else
          puts "No lo has comprado"
      end
      
      return res
    end
    
    def construir_casa(ip) 
      return self.jugador_actual.construir_casa(ip)
    end
    
    def construir_hotel(ip) 
      return self.jugador_actual.construir_hotel(ip)
    end
    
    def final_del_juego
      return self.jugador_actual.en_bancarrota
    end
    
    def casilla_actual 
      return @tablero.get_casilla(self.jugador_actual.num_casilla_actual)
    end
    
    def jugador_actual
      return @jugadores[@indice_jugador_actual]
    end
    
    def hipotecar(ip) 
      return self.jugador_actual.hipotecar(ip)
    end
    
    def infoJugador_texto 
      salida = self.jugador_actual.to_s
      
      if self.final_del_juego
        salida += self.ranking
      end
      
      return salida
    end
    
    def salir_carcel_pagando 
      return self.jugador_actual.salir_carcel_pagando
    end
    
    def salir_carcel_tirando 
      return self.jugador_actual.salir_carcel_tirando
    end
    
    def siguiente_paso 
      jugador_actual = self.jugador_actual
      operacion = @gestorEstados.operaciones_permitidas(jugador_actual, @estado)
      
      if operacion == Operaciones_juego::PASAR_TURNO
        self.pasar_turno
        self.siguiente_paso_completado(operacion)
      elsif operacion == Operaciones_juego::AVANZAR
        avanza_jugador
        self.siguiente_paso_completado(operacion)
      end
      
      return operacion
    end
    
    def siguiente_paso_completado(operacion) 
      @estado = @gestorEstados.siguiente_estado(self.jugador_actual, @estado, operacion)
    end
    
    def vender(ip) 
      return self.jugador_actual.vender(ip)
    end
    
    private
    
    def avanza_jugador 
      jugador_actual = self.jugador_actual
      
      posicion_actual = jugador_actual.num_casilla_actual
      tirada = Dado.instance.tirar
      posicion_nueva = @tablero.nueva_posicion(posicion_actual, tirada)
      
      casilla = @tablero.casilla(posicion_nueva)
      
      contabilizar_pasos_por_salida(jugador_actual)
      
      jugador_actual.mover_casilla(posicion_nueva)
      
      casilla.recibe_jugador(@indiceJugadorActual, @jugadores)
      contabilizar_pasos_por_salida(jugador_actual)
    end
    
    def inicializar_mazo_sorpresas(tablero) 
      @tablero = tablero
      
      @mazo.al_mazo(SorpresaPagarCobrar.new(-200, "Paga el impuesto de lujo"))
      @mazo.al_mazo(SorpresaPagarCobrar.new(200, "Cobra"))

      @mazo.al_mazo(SorpresaCasilla.new(tablero, 3, "Ve a Glorieta cuatro caminos"))
      @mazo.al_mazo(SorpresaCasilla.new(tablero, 12, "Ve Avenida de America"))
      @mazo.al_mazo(SorpresaCasilla.new(tablero, 23, "Ve a Paseo del Prado"))

      @mazo.al_mazo(SorpresaPorCasaHotel.new(-100, "Pagas por cada casa y hotel que poseas"))
      @mazo.al_mazo(SorpresaPorCasaHotel.new(100, "Cobras por cada casa y hotel que poseas"))

      @mazo.al_mazo(SorpresaPorJugador.new(100, "Cada jugador paga el valor"))
      @mazo.al_mazo(SorpresaPorJugador.new(200, "Cada jugador paga el valor"))

      @mazo.al_mazo(SorpresaSalirCarcel.new(@mazo))

      @mazo.al_mazo(SorpresaIrCarcel.new(@tablero))
      
      @mazo.al_mazo(SorpresaJugadorEspeculador.new(1000, "Te conviertes en jugador especulador"))
    end
    
    def inicializar_tablero(mazo) 
      @mazo = mazo
      
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Ronda de Valencia", 35, 0.5, 55, 60, 120)))
      @tablero.aniade_casilla(CasillaSorpresa.new(@mazo, "Caja de Comunidad"))
      @tablero.aniade_casilla(CasillaImpuesto.new(200, "Impuesto sobre el capital"))

      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Glorieta cuatro caminos", 55, 0.5, 95, 100, 200)))
      @tablero.aniade_casilla(CasillaSorpresa.new(@mazo, "Suerte"))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle bravo Murillo", 65, 0.5, 115, 120, 240)))

      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Glorieta de Bilbao", 75, 0.5, 135, 140, 280)))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Fuencarral", 85, 0.5, 155, 160, 320)))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Avenida Felipe II", 95, 0.5, 175, 180, 360)))
      @tablero.aniade_casilla(CasillaSorpresa.new(@mazo, "Caja de Comunidad"))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Serrano", 105, 0.5, 195, 200, 400)))
      @tablero.aniade_casilla(Casilla.new("Parking Gratuito"))

      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Avenida de America", 115, 0.5, 215, 220, 440)))
      @tablero.aniade_casilla(CasillaSorpresa.new(@mazo, "Suerte"))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle de Cea Bermudez", 125, 0.5, 235, 240, 480)))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Avenida de los Reyes Catolicos", 135, 0.5, 255, 260, 520)))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Plaza de Espana", 145, 0.5, 275, 280, 560)))
      @tablero.aniadeJuez()

      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Puerta del Sol", 155, 0.5, 295, 300, 600)))
      @tablero.aniade_casilla(CasillaSorpresa.new(@mazo, "Caja de Comunidad"))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Gran Via", 165, 0.5, 315, 320, 640)))
      @tablero.aniade_casilla(CasillaSorpresa.new(@mazo, "Suerte"))
      @tablero.aniade_casilla(CasillaImpuesto.new(100, "Impuesto de Lujo"))
      @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Paseo del Prado", 205, 0.5, 395, 400, 800)))
    end
    
    def pasar_turno 
      @indiceJugadorActual = @indiceJugadorActual + 1 % @jugadores.size
    end
    
    def ranking
      return @jugadores.sort
    end
    
    def contabilizar_pasos_por_salida(jugador_actual) 
      jugador_actual.pasa_por_salida while @tablero.get_por_salida > 0
    end
  end
end
