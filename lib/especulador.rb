# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Especulador < Jugador
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
      salida += super.to_s

      return salida;
    end
    
    
    def encarcelar(num_casilla_carcel)
        if !super.tiene_salvoconducto()
            if !self.pagar_fianza
                self.mover_casilla(num_casilla_carcel);
                self.encarcelado = true;
                Diario.instance.ocurre_evento("El jugador ha sido encarcelado");
            end
        end

        return this.encarcelado
    end

    def paga_impuesto(cantidad)
        salida = false;

        if !this.encarcelado
            salida = this.paga(cantidad/2)
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

    def puedo_edificar_casa(propiedad)
        puedo_edificar_casa = false

        precio = propiedad.precio_edificar

        if self.puedo_gastar(precio) 
            if propiedad.num_casas < self.get_casa_max
                puedo_edificar_casa = true
            end
        end

        return puedo_edificar_casa;
    end

    def puedo_edificar_hotel(propiedad)
        puedo_edificar_hotel = false;

        precio = propiedad.precio_edificar

        if this.puedo_gastar(precio)
            if propiedad.num_hoteles < self.get_hoteles_max
                if propiedad.num_casas >= Jugador.CasasPorHotel
                    puedo_edificar_hotel = true
                end
            end
        end

        return puedo_edificar_hotel;
    end
  end
end
