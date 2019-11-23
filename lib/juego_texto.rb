# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'vista_textual'
require_relative 'civitas_juego'
require_relative 'controlador'

module Civitas
  class JuegoTexto
    def main
      vista = Vista_textual.new
      civitas = CivitasJuego.new(["Paco", "Pepe", "MJ", "Fernando"])
      controlador = Controlador.new(civitas, vista)
      Dado.instance.set_debug(true)
      
      puts "Comience el juego"
      controlador.juega
    end
  end
  
  juego = JuegoTexto.new
  juego.main
end
