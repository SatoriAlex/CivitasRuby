# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa
    def self.init
      @valor = -1
      @tablero = nil
      @mazo = nil
    end
    
    def jugador_correcto(actual, todos) 
      return !todos[actual].nil?
    end
    
    def informe(actual, todos) 
      Diario.instance.ocurre_evento("Aplicando sorpresa: #{@texto} al jugador #{todos[actual].nombre}")
    end
    
    def to_s 
        return @texto;
    end
    
    private_class_method :new
  end
end
