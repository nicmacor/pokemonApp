# 🌟 Pokemon App - Flutter & Flask

Una aplicación móvil desarrollada en **Flutter** que consume datos de **PokeAPI**, permite autenticación de usuarios, la gestión de favoritos y la evolución de Pokémon. El backend está desarrollado en **Flask** con autenticación JWT y una base de datos SQLite.

---

## ✨ Características Principales

✅ Listar Pokémon desde la API de PokeAPI  
✅ Ver detalles de cada Pokémon (tipos, habilidades, estadísticas, evolución)  
✅ Registrar usuarios y autenticarse  
✅ Guardar Pokémon favoritos  
✅ Evolucionar Pokémon  

---

## 📂 Estructura del Proyecto

```
pokemonApp/               # 📂 Repositorio principal
│── backend/               # 📂 Backend en Flask
│   ├── app.py             # 🔥 Archivo principal del backend
│   ├── instances
│      ├── pokemon.db
│   ├── requirements.txt            
│── pokemon_app/           # 📂 Aplicación Flutter
│   ├── lib/               # 📂 Código de la app
│   ├── pubspec.yaml       # 📝 Dependencias de Flutter
│   ├── android/           # 📂 Configuración de Android
│   ├── ios/               # 📂 Configuración de iOS
│   ├── assets/            # 📂 Imágenes u otros recursos
│   ├── .gitignore         # 📝 Ignorar archivos innecesarios
│   ├── README.md          # 📝 Documentación del frontend
│
│── .gitignore             # 📝 Ignorar archivos innecesarios globales
│── README.md              # 📝 Documentación general del proyecto
```

---

## ⚙️ **Instrucciones de Instalación y Ejecución**

### 🏢 **Backend (Flask)**
🔹 **Clona el repositorio:**
```bash
git clone https://github.com/nicmacor/pokemonApp.git
```
🔹 **Accede a la carpeta del backend:**
```bash
cd pokemonApp/backend
```
🔹 **Instala las dependencias:**
```bash
pip install -r requirements.txt
```
🔹 **Ejecuta el servidor Flask:**
```bash
python app.py
```
🔹 **La API estará disponible en:**  
   📍 `http://127.0.0.1:5000/`

---

### 📱 **Frontend (Flutter)**
🔹 **Accede a la carpeta del frontend:**
```bash
cd ../pokemon_app
```
🔹 **Instala las dependencias de Flutter:**
```bash
flutter pub get
```
🔹 **Ejecuta la aplicación en un emulador o dispositivo físico:**
```bash
flutter run
```
📌 **Nota:** Asegúrate de que tu emulador esté activo o que tu dispositivo esté conectado.

---

## 🔐 **Dependencias del Proyecto**

### **📌 Backend (Flask)**
- `Flask`
- `Flask-JWT-Extended`
- `Flask-SQLAlchemy`
- `bcrypt`
- `requests`

Para instalarlas:
```bash
pip install -r requirements.txt
```

---

### **📌 Frontend (Flutter)**
- `provider`
- `dio`
- `shared_preferences`

Para instalarlas:
```bash
flutter pub get
```
---

## 🚀 **¡Listo para Usar!**
🔥 Ahora puedes clonar, instalar y ejecutar la aplicación sin problemas.  
🚀 ¡Gracias por revisar este proyecto!  

