#encoding:utf-8
require_relative 'operaciones_juego'
require 'io/console'

module Civitas

  class Vista_textual

    def mostrar_estado(estado)
      puts estado
    end

    def pausa
      print "Pulsa una tecla"
      STDIN.getch
      print "\n"
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end


    def menu(titulo,lista)
      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n"+tab+"Elige una opción: ",
                          tab+"Valor erróneo")
      return opcion
    end

    def salir_carcel
      opcion = menu("Elige la forma para intentar salir de la carcel",
        ["Pagando","Tirando el dado"])
  
      return lista_salidas_carcel[opcion]
    end
    
    def comprar
      opcion = menu("¿Quiere comprar la calle?", ["Si", "No"])
      return lista_respuestas[opcion]
    end

    def gestionar
      propiedades = []
       acciones = ["Vender", "Hipotecar", "Cancelar hipoteca", "Construir casa", 
          "Construir hotel", "Terminar"]
        
      opcion = menu("Seleccione gestion inmobiliaria", acciones)
      @i_gestion = opcion
     
      
      if acciones[opcion] != "Terminar"
        @juego_model.jugador_actual.propiedades.each do |propiedad|
          propiedades << propiedad.to_s
        end
        
        @i_propiedad = menu("Cual propiedad quieres " + acciones[opcion] + "?",
                           propiedades)
      end
    end

    def gestion
      return @i_gestion
    end

    def propiedad
      return @i_propiedad
    end

    def mostrar_siguiente_operacion(operacion)
      puts "->>>- Operacion permitida -<<<-"
      puts "    " + operacion.to_s
    end

    def mostrar_eventos
      puts "-++++- Mostrando eventos del Diario -++++-"
      puts Diario.instance.leer_evento while Diario.instance.eventos_pendientes
      puts "-++++- Fin de los eventos -++++-"
    end

    def civitas_juego(civitas)
         @juego_model=civitas
         self.actualizar_vista
    end

    def actualizar_vista
      puts "-***- Info Jugador -***-\n 
           #{@juego_model.jugador_actual.to_s} 
            -***- Casilla Actual -**-\n 
           #{@juego_model.casilla_actual.to_s}\n"
    end

    
  end

end
