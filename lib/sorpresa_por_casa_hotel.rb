# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SorpresaPorCasaHotel < Sorpresa
    alias :super_jugador_correcto :jugador_correcto
    alias :super_informe :informe
    
    def initialize(valor, texto)
      super
      @valor = valor
      @texto = texto
    end
    
    def aplicar_jugador(actual, todos)
      if (super_jugador_correcto(actual, todos))
        super_informe(actual,todos)
        jugador = todos[actual]
        jugador.modificar_saldo(@valor * jugador.cantidad_casas_hoteles)
      end
    end
    
    def to_s
      puts super + "\n *--* Valor: #{@valor} *--*"
    end
    
    public_class_method :new
  end
end
