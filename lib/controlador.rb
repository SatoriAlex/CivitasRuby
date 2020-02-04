# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'operacion_inmobiliaria'
require_relative 'operaciones_juego'
require_relative 'respuestas'
require_relative 'gestiones_inmobiliarias'
require_relative 'salidas_carcel'
require_relative 'civitas_juego'

module Civitas
  class Controlador
    def initialize(juego, vista)
      @juego = juego
      @vista = vista
    end
    
    def juega 
      @vista.civitas_juego(@juego)
      
      while !@juego.final_del_juego
        @vista.actualizar_vista
        @vista.pausa
        
        siguiente_paso = @juego.siguiente_paso
        @vista.mostrar_siguiente_operacion(siguiente_paso)
        
        if siguiente_paso != Operaciones_juego::PASAR_TURNO 
          @vista.mostrar_eventos()
        end
        
        if !@juego.final_del_juego
          case siguiente_paso
          when Operaciones_juego::COMPRAR
            res = @vista.comprar
            
            if (res == Respuestas::SI)
              @juego.comprar
            end
                
            @juego.siguiente_paso_completado(siguiente_paso)
          when Operaciones_juego::GESTIONAR
            @vista.gestionar
            
            gest = @vista.gestion
            ip = @vista.propiedad
            
            gestion = $lista_gestiones[gest]
            
            oi = OperacionInmobiliaria.new(gestion, ip)
            
            if gestion == GestionesInmobiliarias::VENDER
              @juego.vender(ip)
            elsif gestion == GestionesInmobiliarias::HIPOTECAR
              @juego.hipotecar(ip)
            elsif gestion == GestionesInmobiliarias::CANCELAR_HIPOTECA
              @juego.cancelar_hipoteca(ip)
            elsif gestion == GestionesInmobiliarias::CONSTRUIR_CASA
              @juego.construir_casa(ip)
            elsif gestion == GestionesInmobiliarias::CONSTRUIR_HOTEL
              @juego.construir_hotel(ip)
            else
              @juego.siguiente_paso_completado(siguiente_paso)
            end
          when Operaciones_juego::SALIR_CARCEL
            salida = @vista.salir_carcel
            
            if salida == SalidasCarcel::PAGANDO
              @juego.salir_carcel_pagando
            else
              @juego.salir_carcel_tirando
            end
            
            @juego.siguiente_paso_completado(siguiente_paso)
          end
        end
      end
    
      @juego.info_jugador_texto
    end
  end
end
