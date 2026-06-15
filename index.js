const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Ruta base de prueba
app.get('/', (req, res) => {
  res.json({
    status: "online",
    proyecto: "Software de Organización y Gestión de Eventos Académicos",
    modulos: ["Gestión de eventos", "Inscripción", "Acreditación", "Certificados"]
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Servidor de eventos corriendo en el puerto ${PORT}`);
});