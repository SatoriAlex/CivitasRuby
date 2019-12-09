# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Jugador
    attr_reader :numCasillaActual, :puedeComprar, :encarcelado, :nombre, 
                :propiedades, :saldo, :CasasMax, :HotelesMax, :CasasPorHotel,
                :PrecioLibertad, :PasoPorSalida
    
    def initialize (nombre = nil, otro = nil)
      @@CasasMax = 4
      @@CasasPorHotel = 4
      @@HotelesMax = 4
      @@PasoPorSalida = 1000
      @@PrecioLibertad = 200
      @@SaldoInicial = 7500
      @numCasillaActual = 0
      @saldo = @@SaldoInicial
      
      unless otro.nil?
        @encarcelado = otro.encarcelado
        @nombre = otro.nombre
        @numCasillaActual = otro.numCasillaActual
        @puedeComprar = otro.puedeComprar
        @saldo = otro.saldo
      end
      
      @nombre = nombre unless nombre.nil?
    end
   
    def cancelarHipoteca(ip) 
      result = false
      
      if @encarcelado
        return result
      end
      
      if self.existeLaPropiedad(ip)
        propiedad = @propiedades[ip]
        cantidad = propiedad.getImporteCancelarHipoteca
        puedo_gastar = self.puedoGastar(cantidad)
        
        if puedo_gastar
          result = propiedad.cancelarHipoteca(self)
          
          if result
            Diario.instance.ocurre_evento("El jugador #{@nombre} cancela la hipoteca de la propiedad #{@ip}")
          end
        end
      end
      
      return result
    end
    
    def cantidadCasasHoteles
      cantidad = 0
      
      @propiedades.each do |propiedad|
        cantidad += propiedad.cantidadCasasHoteles
      end
      
      return cantidad
    end
    
    def <=>(otro) 
      return @saldo <=> otro.saldo
    end
    
    def comprar(titulo) 
      result = false
      
      if @encarcelado
        return result
      end
      
      if @puedeComprar
        precio = titulo.precioCompra
        
        if self.puedoGastar(precio)
          result = titulo.comprar(jugador)
          
          if result
            @propiedades << titulo
            Diario.instance.ocurre_evento("El jugador #{@nombre} compra la propiedad #{titulo.to_s}")
          end
          
          @puedeComprar = false
        end
      end
      
      return result
    end
    
    def construirCasa(ip) 
      result = false
      
      if @encarcelado
        return result
      end
      
      if self.existeLaPropiedad(ip)
        propiedad = @propiedades[ip]
        puedoEdificarCasa = self.puedoEdificarCasa(propiedad)
        
        if puedoEdificarCasa
          result = propiedad.construirCasa(self)
          
          if result
            Diario.instance.ocurre_evento("El jugador #{@nombre} construye casa en la propiedad #{ip}")
          end
        end
      end
    end
    
    def construirHotel(ip) 
      result = false
      
      if @encarcelado
        return result
      end
      
      if self.existeLaPropiedad(ip) 
        propiedad = @propiedades[ip]
        puedo_edificar_hotel = self.puedoEdificarHotel(propiedad)
        
        if puedo_edificar_hotel
          result = propiedad.construirHotel(self)
          
          casasPorHotel = self.CasasPorHotel
          propiedad.derruirCasas(casasPorHotel, self)
          Diario.instance.ocurre_evento("El jugador #{@nombre} construye hotel en la propiedad #{ip}")
        end
      end
      
      return result
    end
    
    def enBancarrota
      return @saldo <= 0
    end
    
    def encarcelar(numCasillaCarcel) 
      if self.debeSerEncarcelado
        self.moverACasilla(numCasillaCarcel)
        @encarcelado = true
        Diario.instance.ocurre_evento("El jugador ha sido encarcelado")
      end
      
      return @encarcelado
    end
    
    def hipotecar(ip) 
      result = false
      
      if @encarcelado
        return result
      end
      
      if self.existeLaPropiedad(ip)
        propiedad = @propiedades[ip]
        result = propiedad.hipotecar(self)
      end
      
      if result
        Diario.instance.ocurre_evento("El jugador #{nombre} hipoteca la propiedad #{ip}")
      end
      
      return result
    end
    
    def modificarSaldo(cantidad) 
      @saldo += cantidad
      Diario.instance.ocurre_evento("Se ha modificado el saldo")
      
      return true
    end
    
    def moverACasilla(numCasilla) 
      salida = false
      
      if !@encarcelado
        @numCasillaActual = numCasilla
        @puedoComprar = false
        Diario.instance.ocurre_evento("Se ha movido el jugador #{numCasilla} casillas")
        salida = true
      end
      
      return salida
    end
    
    def obtenerSalvoconducto(sorpresa) 
        salida = false
        
      if !@encarcelado
        salida = true
        @salvoconducto = sorpresa
      end
      
      return salida
    end
    
    def paga(cantidad) 
      return self.modificarSaldo(-1*cantidad)
    end
    
    def pagaAlquiler(cantidad) 
      salida = false
      
      if !@encarcelado
        salida = self.paga(cantidad)
      end
      
      return salida
    end
    
    def pagaImpuesto(cantidad) 
      salida = false
      
      if !@encarcelado
        salida = self.paga(cantidad)
      end
      
      return salida
    end
    
    def pasaPorSalida 
      self.modificarSaldo(1000)
      Diario.instance.ocurre_evento("El jugador ha pasado por la salida")
      
      return true
    end
    
    def puedeComprarCasilla 
      @puedeComprar = !@encarcelado
      
      return @puedeComprar
    end
    
    def recibe(cantidad) 
      salida = false
      
      if !@encarcelado
        salida = self.modificarSaldo(cantidad)
      end
      
      return salida
    end
    
    def salirCarcelPagando
      salida = false
      
      if !@encarcelado && self.puedeSalirCarcelPagando()
        salida = true
        self.paga(200)
        @encarcelado = false
        Diario.instance.ocurre_evento("El jugador ha salido de la carcel")
      end
      
      return salida
    end
    
    def salirCarcelTirando 
      salida = false
      
      if !@encarcelado
        @encarcelado = false
        Diario.instance.ocurre_evento("El jugador ha salido de la carcel")
      end
      
      return salida
    end
    
    def tieneAlgoQueGestionar 
      return !@propiedades.empty?
    end
    
    def tieneSalvoconducto 
      return !@salvoconducto.nil?
    end
    
    def vender(ip) 
      salida = false
      
      if !@encarcelado
        salida = self.modificarSaldo(cantidad)
      end
      
      return salida
    end
    
    def to_s() 
      return "Nombre: #{@nombre}" 
    end
    
    protected
    
    def debeSerEncarcelado 
      salida = false
      
      if !@encarcelado && !self.tieneSalvoconducto
        salida = true
      elsif self.tieneSalvoconducto
        self.perderSalvoconducto
        Diario.instance.ocurre_evento("El jugador se ha librado de la carcel")
      end
      
      return salida
    end
    
    def puedoGastar(precio) 
      salida = false
      
      if !@encarcelado
        salida = (@saldo >= precio)
      end
      
      return salida
    end
    
    private
    
    def existeLaPropiedad(ip) 
      return !@propiedades[ip].nil?
    end
    
    def perderSalvoconducto 
      @salvoconducto.usuada
      @salvoconducto = nil
    end
    
    def puedeSalirCarcelPagando 
      return @saldo >= 200
    end
    
    def puedoEdificarCasa(propiedad) 
      puedo_edificar_casa = false
      
      precio = propiedad.precioEdificar
      
      if self.puedoGastas(precio)
        if propiedad.numCasas < self.CasasMax
          puedo_edificar_casa = true
        end
      end
      
      return puedo_edificar_casa
    end
    
    def puedoEdificarHotel(propiedad)
      puedo_edificar_hotel = false
      
      precio = propiedad.precioEdificar
      
      if self.puedoGastar(precio)
        if propiedad.numHoteles < self.HotelesMax
          if propiedad.numCasas >= self.CasasPorHotel
            puedo_edificar_hotel = true
          end
        end
      end
      
      return puedo_edificar_hotel
    end
  end
end
