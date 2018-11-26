FROM php:7.1-cli
LABEL maintainer="Fabian"

# Actualizamos el repositorio e instalamos el paquete de unzip
RUN apt-get update && apt-get -y install unzip libicu-dev

# Instalamos librerias necesarias
RUN docker-php-ext-configure intl && \
    docker-php-ext-install intl

# Copiamos todo el contenido de la carpeta demo(proyecto clonado) al container
ADD . /opt/demo

# Buscamos sobre la imagen de composer las rutas definidas a posteriori
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer require nelexa/zip

# Asignamos ruta de trabajo y ejecutamos el comando
WORKDIR /opt/demo
RUN composer install

# Comandos de arranque del servicio en el container
ENTRYPOINT ["/usr/local/bin/php","bin/console","server:run","*:8000"]
