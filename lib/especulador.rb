# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'jugador'
require_relative 'diario'

module Civitas
  class Especulador < Jugador
    alias :super_tiene_salvoconducto :tiene_salvoconducto
    alias :super_perder_salvoconducto :perder_salvoconducto
    alias :super_puedo_gastar :puedo_gastar
    alias :super_modificar_saldo :modificar_saldo
    
    attr_reader :fianza, :especulador
    
    @@factorEspeculador = 2
    
    def initialize(otro, fianza)
      super(otro)
      @fianza = fianza
      @especulador = true
      
      otro.propiedades.each do |propiedad|
        propiedad.actualizar_propietario_por_conversion(self)
      end
    end
    
    def to_s
      salida = "*+++*+++* Jugador Especulador *+++*+++*\n"
      salida += super

      return salida;
    end
    
    def encarcelar(num_casilla_carcel)
      resultado = false
      
      unless @encarcelado
        if !super_tiene_salvoconducto
          super_perder_salvoconducto
          Diario.instance.ocurre_evento("El jugador #{@nombre} se libra de la cacel y pierde salvoconducto")
        elsif super_puedo_gastar(@fianza)
          super_modificar_saldo(-@fianza)
          Diario.instance.ocurre_evento("El jugador ha pagado la fianza y se libra de la carcel")
        else
          resultado = true
        end
      end
      
      return resultado
    end

    def paga_impuesto(cantidad)
      salida = false;

      if !this.encarcelado
        salida = self.paga(cantidad/2)
        Diario.instance.ocurre_evento("El jugador paga #{cantidad/2} de impuesto")
      end

      return salida
    end
    
    private 
    
    def casa_max
      super.CasasMax * @@factorEspeculador
    end

    def hoteles_max
      super.HotelesMax * @@factorEspeculador
    end
    
    def pagar_fianza
      puede_pagar = super.puedo_gastar(fianza)

      if puede_pagar
        modificar_saldo(-fianza)
        Diario.instance.ocurre_evento("El jugador ha pagado la fianza y se ha librado de la carcel")
      end

      return puede_pagar
    end
  end
end
