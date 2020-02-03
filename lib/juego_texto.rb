# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'vista_textual'
require_relative 'civitas_juego'
require_relative 'controlador'
require_relative 'dado'

module Civitas
  class JuegoTexto
    def main
      vista = Vista_textual.new
      civitas = CivitasJuego.new(["Fernando"])
      controlador = Controlador.new(civitas, vista)
      Dado.instance.set_debug(true)
      
      puts "*-*-*-*-*-*-*-*-*Bienvenido al juego*-*-*-*-*-*-*-*-*"
      puts "   _____ _       _ _            \n"       +
                        "  / ____(_)     (_) |           \n"        +
                        " | |     ___   ___| |_ __ _ ___ \n"        +
                        " | |    | \\ \\ / / | __/ _` / __|\n"      +
                        " | |____| |\\ V /| | || (_| \\__ \\\n"     +
                        "  \\_____|_| \\_/ |_|\\__\\__,_|___/\n"    +
                        "                                \n"        +
                        "                                "
      controlador.juega
    end
  end
  
  juego = JuegoTexto.new
  juego.main
end
