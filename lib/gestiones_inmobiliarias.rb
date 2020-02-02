# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
    module GestionesInmobiliarias
      VENDER = :vender
      HIPOTECAR = :hipotecar
      CANCELAR_HIPOTECA = :cancelar_hipoteca
      CONSTRUIR_CASA = :construir_casa
      CONSTRUIR_HOTEL = :construir_hotel
      TERMINAR = :terminar
    end
    
    $lista_gestiones = [Civitas::GestionesInmobiliarias::VENDER, Civitas::GestionesInmobiliarias::HIPOTECAR, 
        Civitas::GestionesInmobiliarias::CANCELAR_HIPOTECA, Civitas::GestionesInmobiliarias::CONSTRUIR_CASA, 
        Civitas::GestionesInmobiliarias::CONSTRUIR_HOTEL, Civitas::GestionesInmobiliarias::TERMINAR]
end

