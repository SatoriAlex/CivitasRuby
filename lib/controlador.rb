# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Controlador
    def initialize(juego, vista)
      @juego = juego
      @vista = vista
    end
    
    def juega 
      @vista.setCivitasJuego(@juego)
      
      while !@juego.finalDelJuego
        @vista.pausa
        
        siguiente_paso = @juego.siguientePaso()
        @vista.mostrarSiguienteOperacion(siguiente_paso)
        
        if siguiente_paso != Operaciones_juego::PASAR_TURNO 
          @vista.mostrarEventos()
        end
        
        if !@juego.finalDelJuego
          case siguiente_paso
          when Operaciones_juego::COMPRAR
            res = @vista.comprar
            
            if (res == Respuestas::SI)
              @juego.comprar
            end
            
            @juego.siguientePasoCompletado(siguiente_paso)
          when Operaciones_juego::GESTIONAR
            @vista.gestionar
            
            gest = @vista.getGestion
            ip = @vista.getPropiedad
            
            gestion = Civitas::lista_gestiones[gest]
            
            oi = OperacionInmobiliaria.new(gestion, ip)
            
            if gestion == GestionesInmobiliarias::VENDER
              @juego.vender(ip)
            elsif gestion == GestionesInmobiliarias::HIPOTECAR
              @juego.hipotecar(ip)
            elsif gestion == GestionesInmobiliarias::CANCELAR_HIPOTECA
              @juego.cancelarHipoteca(ip)
            elsif gestion == GestionesInmobiliarias::CONSTRUIR_CASA
              @juego.construirCasa(ip)
            elsif gestion == GestionesInmobiliarias::CONSTRUIR_HOTEL
              @juego.construirHotel(ip)
            end
            
            @juego.siguientePasoCompletado(siguiente_paso)
          when Operaciones_juego::SALIR_CARCEL
            salida = @vista.salirCarcel
            
            if salida == SalidasCarcel::PAGANDO
              @juego.salirCarcelPagando
            else
              @juego.salirCarcelTirando
            end
            @juego.siguientePasoCompletado(siguiente_paso)
          end
        end
        
        @vista.actualizarVista
      end
    
      @juego.infoJugadorTexto
    end
  end
end
