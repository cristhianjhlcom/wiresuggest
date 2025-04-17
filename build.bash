#!/bin/bash

# Este script se utiliza para realizar una actualización completa de la aplicación.
# Asume que se ejecuta dentro del directorio raíz del proyecto.
# /var/www/wiresuggest

# Reestablece el HEAD del repositorio Git al último commit, descartando todos los cambios locales.
git reset --hard HEAD

# Elimina todos los archivos y directorios no rastreados por Git.
# -f: fuerza la eliminación incluso si se han ignorado.
# -d: elimina también los directorios no rastreados.
git clean -fd

# Pone la aplicación en modo de mantenimiento.
# Los usuarios verán una página indicando que la aplicación está en mantenimiento.
php artisan down

# Descarga los últimos cambios del repositorio remoto (generalmente 'origin' y la rama actual).
# --ff (fast-forward): Intenta realizar una fusión rápida si es posible.
git pull --ff

# Instala o actualiza las dependencias de Composer (gestor de paquetes de PHP).
# --no-interaction: Evita cualquier pregunta interactiva durante la instalación.
# --no-progress: Oculta la barra de progreso durante la descarga e instalación.
# --no-suggest: Suprime las sugerencias de paquetes.
# --optimize-autoloader: Optimiza la carga automática de clases para mejorar el rendimiento.
# --prefer-dist: Prefiere descargar los paquetes como distribuciones (archivos zip/tar.gz) si están disponibles.
composer install --no-interaction --no-progress --no-suggest --optimize-autoloader --prefer-dist

# Ejecuta las migraciones de la base de datos.
# --force: Fuerza la ejecución de las migraciones en un entorno de producción sin confirmación.
php artisan migrate --force

# Instala las dependencias de Node.js utilizando el archivo package-lock.json.
# 'ci' (continuous integration) es similar a 'install' pero está diseñado para entornos de integración continua,
# asegurando instalaciones consistentes basadas en el archivo lock.
npm ci

# Ejecuta el script de construcción definido en el archivo package.json.
# Este comando generalmente compila los activos frontend (CSS, JavaScript, etc.).
npm run build

# Limpia la caché generada por el comando 'optimize'.
# Asegura que la próxima optimización se realice sobre una base limpia.
php artisan optimize:clear

# Optimiza la aplicación Laravel para mejorar el rendimiento.
# Esto puede incluir la generación de archivos de caché y la optimización de la carga de clases.
php artisan optimize

# Reinicia el servicio del servidor web Nginx para que los nuevos cambios sean aplicados.
# Esto asegura que la aplicación actualizada sea servida correctamente.
sudo systemctl restart nginx

# Saca la aplicación del modo de mantenimiento, haciéndola accesible a los usuarios nuevamente.
php artisan up