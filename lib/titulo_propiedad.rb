# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class TituloPropiedad
    attr_reader :nombre, :hipotecado, :numCasas, :numHoteles, :precioCompra, :precioEdificar,
                :propietario
    
    def initialize(nom, ab, fr, hb, pc, pe)
      @alquilerBase = ab
      @@factorInteresesHipoteca = 1.1
      @factorRevalorizacion = fr
      @hipotecaBase = hb
      @hipotecado
      @nombre = nom
      @numCasas
      @numHoteles
      @precioCompra = pc
      @precioEdificar = pe
    end

    def actualizarPropietarioPorConversion(jugador)
        @propietario = jugador
    end

    def cancelarHipoteca(jugador) 
      result = false
      
      if @hipotecado
        if self.esEsteElPropietario(jugador)
          @propietario.paga(self.getImporteCancelarHipoteca)
          @hipotecado = false
          result = true
        end
      end
      
      return result
    end

    def cantidadCasasHoteles 
      return @numCasas + @numHoteles
    end

    def comprar(jugador) 
      result = false
      
      unless self.tienePropietario
        if self.esEsteElPropietario(jugador)
          propietario = jugador
          result = true
          propietario.paga(self.precioCompra)
        end
      end
      
      return result
    end

    def construirCasa(jugador) 
      result = false
      
      if self.esEsteElPropietario(jugador)
        @propietario.paga(self.precioEdificar)
        @numCasas += 1
        result = true
      end
      
      return result
    end

    def construirHotel(jugador) 
      result = false
      
      if self.esEsteElPropietario(jugador)
        @propietario.paga(self.precioEdificar)
        @numHoteles += 1
        result = true
      end
      
      return result
    end

    def derruirCasas(n, jugador) 
      salida = false;
      
      if (@numCasas >= n && self.esEsteElPropietario(jugador))
        @numCasas -= n;
        salida = true;
      end
      
      return salida
    end

    def getImporteCancelarHipoteca 
      return self.getImporteHipoteca * @@factorInteresesHipoteca
    end

    def hipotecar(jugador) 
      salida = false
      
      if !@hipotecado && self.esEsteElPropietario(jugador)
        propietario = jugador
        propietario.recibe(self.getImporteHipoteca)
        @hipotecado = true
        salida = true
      end
      
      return salida
    end

    def tienePropietario 
      return @propietario.nil? && !@propietario.propiedades[self].nil?
    end

    def to_s 
      puts "Nombre: #{@nombre} \n
              Alquiler Base: #{@alquilerBase} \n
              Factor Revalorizacion: #{@factorRevalorizacion} \n
              Hipoteca Base: #{@hipotecaBase} \n
              Precio de Compra: #{@precioCompra} \n
              Precio de Edificacion: #{@precioEdificar} \n
              Hipotecado: #{@hipotecado} \n
              No. Casas: #{@numCasas} \n
              No. Hoteles: #{@numHoteles}"
    end

    def tramitarAlquiler(jugador) 
      if (self.tienePropietario && !self.esEsteElPropietario(jugador)) 
        precio = self.getPrecioAlquiler
        
        jugador.pagaAlquiler(precio)
        @propietario.recibe(precio)
      end
    end

    def vender(jugador) 
      salida = false;
      
      if (!@hipotecado && self.esEsteElPropietario(jugador))
        jugador.recibe(self.getPrecioVenta)
        @propietario = nil
        @numCasas = 0;
        @numHoteles = 0;
        salida = true
      end
      
      return salida
    end

    private

    def esEsteElPropietario(jugador) 
      return @propietario == jugador
    end

    def getImporteHipoteca 
      return @hipotecaBase * (1 + (@numCasas * 0.5) + (@numHoteles * 0.5))
    end

    def getPrecioAlquiler 
      valor = 0.0
      
      if (!@hipotecado && !@propietario.isEncarcelado)
        valor = @alquilerBase * (1 + (@numCasas * 0.5) + (@numHoteles * 0.5))
      end
      
      return valor
    end

    def getPrecioVenta 
      return @precioCompra + (@numCasas + @numHoteles * 5) * @precioEdificar * @factorRevalorizacion
    end

    def propietarioEncarcelado 
      if (@propietario.isEncarcelado)
        salida = true
      elsif (!@propietario.isEncarcelado || !self.tienePropietario)
        salida = false
      end
      
      return salida
    end
  end
end
