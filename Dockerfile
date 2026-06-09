# 1. Usar una imagen oficial liviana de Node.js
FROM node:18-alpine

# 2. Definir el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# 3. Copiar los archivos de configuración de dependencias
COPY package*.json ./

# 4. Instalar las dependencias declaradas
RUN npm install

# 5. Copiar todo el código fuente del proyecto al contenedor
COPY . .

# 6. Exponer el puerto de comunicación de la app
EXPOSE 3000

# 7. Comando para ejecutar la app en desarrollo usando nodemon
CMD ["npm", "run", "dev"]