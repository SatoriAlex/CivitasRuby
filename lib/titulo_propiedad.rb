# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class TituloPropiedad
    attr_reader :nombre, :hipotecado, :num_casas, :num_hoteles, :precio_compra, :precio_edificar,
                :propietario
    
    def initialize(nom, ab, fr, hb, pc, pe)
      @alquiler_base = ab
      @@factor_intereses_hipoteca = 1.1
      @factor_revalorizacion = fr
      @hipoteca_base = hb
      @hipotecado
      @nombre = nom
      @num_casas
      @num_hoteles
      @precio_compra = pc
      @precio_edificar = pe
      @propietario = nil
    end

    def actualizar_propietario_por_conversion(jugador)
        @propietario = jugador
    end

    def cancelar_hipoteca(jugador) 
      result = false
      
      if @hipotecado && self.es_este_el_propietario(jugador)
        @propietario.paga(self.importe_cancelar_hipoteca)
        @hipotecado = false
        result = true
      end
      
      return result
    end

    def cantidad_casas_hoteles 
      return @num_casas + @num_hoteles
    end

    def comprar(jugador) 
      result = false
      
      unless self.tiene_propietario
          @propietario = jugador
          result = true
          @propietario.paga(@precio_compra)
      end
      
      return result
    end

    def construir_casa(jugador) 
      result = false
      
      if self.es_este_el_propietario(jugador)
        @propietario.paga(@precio_edificar)
        @num_casas += 1
        result = true
      end
      
      return result
    end

    def construir_hotel(jugador) 
      result = false
      
      if self.es_este_el_propietario(jugador)
        @propietario.paga(@precio_edificar)
        @num_hoteles += 1
        result = true
      end
      
      return result
    end

    def derruir_casas(n, jugador) 
      salida = false;
      
      if (@num_casas >= n && self.es_este_el_propietario(jugador))
        @num_casas -= n;
        salida = true;
      end
      
      return salida
    end

    def importe_cancelar_hipoteca 
      return self.importe_hipoteca * @@factor_intereses_hipoteca
    end

    def hipotecar(jugador) 
      salida = false
      
      if !@hipotecado && self.es_este_el_propietario(jugador)
        propietario = jugador
        propietario.recibe(self.importe_hipoteca)
        @hipotecado = true
        salida = true
      end
      
      return salida
    end

    def tiene_propietario
      return !@propietario.nil? && !@propietario.propiedades[self].nil?
    end

    def to_s 
      puts "Nombre: #{@nombre} \n
              Alquiler Base: #{@alquiler_base} \n
              Factor Revalorizacion: #{@factor_revalorizacion} \n
              Hipoteca Base: #{@hipoteca_base} \n
              Precio de Compra: #{@precio_compra} \n
              Precio de Edificacion: #{@precio_edificar} \n
              Hipotecado: #{@hipotecado} \n
              No. Casas: #{@num_casas} \n
              No. Hoteles: #{@num_hoteles}"
    end

    def tramitar_alquiler(jugador) 
      if (self.tiene_propietario && !self.es_este_el_propietario(jugador)) 
        precio = self.precio_alquiler
        
        jugador.paga_alquiler(precio)
        @propietario.recibe(precio)
      end
    end

    def vender(jugador) 
      salida = false;
      
      if (!@hipotecado && self.es_este_el_propietario(jugador))
        jugador.recibe(self.precio_venta)
        @propietario = nil
        @num_casas = 0;
        @num_hoteles = 0;
        salida = true
      end
      
      return salida
    end

    private

    def es_este_el_propietario(jugador) 
      return @propietario == jugador
    end

    def importe_hipoteca 
      return @hipoteca_base * (1 + (@num_casas * 0.5) + (@num_hoteles * 2.5))
    end

    def precio_alquiler 
      valor = 0.0
      
      if (!@hipotecado && !@propietario.is_encarcelado)
        valor = @alquiler_base * (1 + (@num_casas * 0.5) + (@num_hoteles * 2.5))
      end
      
      return valor
    end

    def precio_venta 
      return @precio_compra + (@num_casas + @num_hoteles * 5) * @precio_edificar * @factor_revalorizacion
    end

    def propietario_encarcelado 
      salida = false
      
      if (self.tiene_propietario)
        salida = @propietario.is_encarcelado
      end
      
      return salida
    end
  end
end
