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
        propiedad.actualizarPropietarioPorConversion(self)
      end
    end
    
    def to_s
      salida = "*+++*+++* Jugador Especulador *+++*+++*\n"
      salida += super.to_s

      return salida;
    end
    
    
    def encarcelar(numCasillaCarcel)
        if !super.tieneSalvoconducto()
            if !self.pagarFianza
                self.moverACasilla(numCasillaCarcel);
                self.encarcelado = true;
                Diario.getInstance().ocurreEvento("El jugador ha sido encarcelado");
            end
        end

        return this.encarcelado
    end

    def pagaImpuesto(cantidad)
        salida = false;

        if !this.encarcelado
            salida = this.paga(cantidad/2)
        end

        return salida
    end
    
    private 
    
    def get_casa_max
        super.CasasMax * @@factorEspeculador
    end

    def get_hoteles_max
        super.HotelesMax * @@factorEspeculador
    end
    
    def pagarFianza
        puedePagar = super.puedoGastar(fianza)

        if puedePagar
            modificarSaldo(-fianza)
        end

        return puedePagar
    end

    def puedoEdificarCasa(propiedad)
        puedoEdificarCasa = false

        precio = propiedad.getPrecioEdificar

        if self.puedoGastar(precio) 
            if propiedad.numCasas < self.get_casa_max
                puedoEdificarCasa = true
            end
        end

        return puedoEdificarCasa;
    end

    def puedoEdificarHotel(propiedad)
        puedoEdificarHotel = false;

        precio = propiedad.getPrecioEdificar

        if this.puedoGastar(precio)
            if propiedad.numHoteles < self.get_hoteles_max
                if propiedad.getNumCasas >= Jugador.CasasPorHotel
                    puedoEdificarHotel = true
                end
            end
        end

        return puedoEdificarHotel;
    end
  end
end
