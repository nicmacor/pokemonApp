from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity

# Inicializar Flask
app = Flask(__name__)

# Configuración de la base de datos
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///pokemon.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = 'supersecretkey'

# Inicializar extensiones
db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
jwt = JWTManager(app)

# Modelo de Usuario con nombre de usuario/contrasena/cedula 
class User(db.Model):
    cedula = db.Column(db.String(10), primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)
    favorites = db.relationship('Favorite', backref='user', lazy=True)

# Modelo de Pokémon Favorito que tiene un id y la foreign key la cedula del usuario
class Favorite(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey('user.cedula'), nullable=False)
    pokemon_name = db.Column(db.String(50), nullable=False)

# Crear la base de datos
with app.app_context():
    db.create_all()


@app.route('/')
def home():
    return "El servidor Flask está funcionando 🚀"

# RUTA 1: Registrar un usuario
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    cedula = data.get('cedula')
    username = data.get('username')
    password = data.get('password')

    # Validar que la cédula tenga 10 dígitos
    if not cedula or len(cedula) != 10 or not cedula.isdigit():
        return jsonify({"error": "Cédula inválida"}), 400
    
    # Verificar si la cédula ya está registrada
    if User.query.get(cedula):
        return jsonify({"error": "La cédula ya está registrada"}), 400
    
    # Verificar que todos los campos esten llenos
    if not username or not password or not cedula:
        return jsonify({"error": "Faltan datos"}), 400

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    user = User(cedula=cedula, username=username, password=hashed_password)

    db.session.add(user)
    db.session.commit()
    return jsonify({"message": "Usuario registrado con éxito"}), 201

# RUTA 2: Iniciar sesión y obtener un token para autenticacion
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    user = User.query.filter_by(username=username).first()
    if not user or not bcrypt.check_password_hash(user.password, password):
        return jsonify({"error": "Credenciales inválidas"}), 401

    access_token = create_access_token(identity=str(user.cedula))
    return jsonify({"token": access_token}), 200

# RUTA 3: Guardar un Pokémon favorito
@app.route('/favorites', methods=['POST'])
@jwt_required()
def add_favorite():
    user_id = get_jwt_identity()
    data = request.get_json()
    pokemon_name = data.get('pokemon_name')

    if not pokemon_name:
        return jsonify({"error": "Debes proporcionar un nombre de Pokémon"}), 400
    
    # Verificar que el pokemon ya no se encuentre entre sus favoritos
    existing_favorite = Favorite.query.filter_by(user_id=user_id, pokemon_name=pokemon_name).first()
    if existing_favorite:
        return jsonify({"error": "Este Pokémon ya está en favoritos"}), 400
    
    favorite = Favorite(user_id=user_id, pokemon_name=pokemon_name)
    db.session.add(favorite)
    db.session.commit()
    return jsonify({"message": f"{pokemon_name} agregado a favoritos"}), 201

# RUTA 4: Obtener Pokémon favoritos del usuario
@app.route('/favorites', methods=['GET'])
@jwt_required()
def get_favorites():
    user_id = get_jwt_identity()
    favorites = Favorite.query.filter_by(user_id=user_id).all()
    favorite_list = [fav.pokemon_name for fav in favorites]

    return jsonify({"favorites": favorite_list}), 200


# RUTA 5: Para ver los datos
@app.route('/data')
def view_data():
    users = User.query.all()
    favorites = Favorite.query.all()

    user_list = [{"id": u.cedula, "username": u.username} for u in users]
    favorite_list = [{"id": f.id, "user_id": f.user_id, "pokemon_name": f.pokemon_name} for f in favorites]

    return jsonify({"usuarios": user_list, "favoritos": favorite_list})


# Iniciar la aplicación
if __name__ == '__main__':
    app.run(debug=True)
