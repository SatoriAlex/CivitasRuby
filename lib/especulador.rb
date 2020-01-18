# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Especulador < Jugador
    alias :super_tiene_salvoconducto :tiene_salvoconducto
    
    @@factorEspeculador = 2
    
    def initialize(otro, fianza)
      super(otro)
      @fianza = fianza
      
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
        if !super_tiene_salvoconducto && !self.pagar_fianza
          self.mover_casilla(num_casilla_carcel);
          @encarcelado = true;
          Diario.instance.ocurre_evento("El jugador ha sido encarcelado");
        end

        return @encarcelado
    end

    def paga_impuesto(cantidad)
        salida = false;

        if !this.encarcelado
            salida = self.paga(cantidad/2)
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
        end

        return puede_pagar
    end
  end
end
