DROP DATABASE IF EXISTS biblioteca_db;
drop user if exists usuario_prueba;
CREATE DATABASE biblioteca_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


create user 'usuario_prueba'@'%' identified by 'Usuar1o_Clave.';

/*Se asignan los prvilegios sobr ela base de datos TechShop al usuario creado */
grant all privileges on biblioteca_db.* to 'usuario_prueba'@'%';
flush privileges;

USE biblioteca_db;

/* Tabla de roles */
CREATE TABLE role (
    rol VARCHAR(20) PRIMARY KEY
);

INSERT INTO role (rol) VALUES 
('ADMIN'), 
('VENDEDOR'), 
('USUARIO');

/* Tabla de usuarios */
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

/* Tabla de asignación de roles (relación muchos a muchos estilo techshop) */
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20),
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Asignación inicial (Admin por defecto)
INSERT INTO usuario (username, password, nombre, apellidos, correo, activo) VALUES
('Francisco', '$2a$12$9EfhFXIBSu0wlDnjmlpOAus4J3OIwiLpOQDdtN9ycf6nB2wX0M/nu', 'Francisco', 'Fuentes', 'admin@biblioteca.com', TRUE),
('vend', '$2a$12$ofSrcbi.dHwX3gKXK6d6k.QN.fuOKUAKW.sBd5Uf7CQDH5Pw3e0BW', 'Vendedor', 'biblio', 'vendedor@biblioteca.com', TRUE),
('user', '$2a$12$LEMHwZYKEcHpX3Ogk6F02.Pr51xIMKxu9jAVLJlV.NR.M2.uQMxD.', 'Usuario', 'biblio', 'usuario@biblioteca.com', TRUE);

INSERT INTO rol (nombre, id_usuario) VALUES
('ADMIN', 1), ('VENDEDOR', 1), ('USUARIO', 1),
('VENDEDOR', 2), ('USUARIO', 2),
('USUARIO', 3);

/* Categorías */
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

INSERT INTO categoria (descripcion, activo) VALUES
('Novela', true), ('Poesía', true), ('Historia', true), ('Ciencia', true), ('Informática', true), ('Filosofía', true);

/* Autores */
CREATE TABLE autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    biografia TEXT,
    fecha_nacimiento DATE,
    nacionalidad VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    UNIQUE (nombre, apellidos)
);

/* Libros */
CREATE TABLE libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    precio	decimal(10,2),
    editorial VARCHAR(100),
    idioma VARCHAR(50),
    existencias INT NOT NULL,
    id_categoria INT NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

/* Relación libros - autores */
CREATE TABLE libro_autor (
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor) ON DELETE CASCADE
);

/* Préstamos */
CREATE TABLE prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_devolucion_esperada DATETIME NOT NULL,
    fecha_devolucion_real DATETIME,
    estado VARCHAR(20) DEFAULT 'PRESTADO', -- en lugar de ENUM para mantener formato
    observaciones TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro)
);

/* Tabla de rutas según roles (similar a techshop) */
CREATE TABLE ruta (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    patron VARCHAR(255) NOT NULL,
    rol_name VARCHAR(50) NOT NULL
);

INSERT INTO ruta (patron, rol_name) VALUES 
('/libro/nuevo', 'ADMIN'),
('/libro/guardar', 'ADMIN'),
('/libro/modificar/**', 'ADMIN'),
('/libro/eliminar', 'ADMIN'),
('/prestamo/nuevo', 'BIBLIOTECARIO'),
('/prestamo/listado', 'BIBLIOTECARIO'),
('/libro/listado', 'BIBLIOTECARIO'),
('/mis-prestamos', 'USUARIO'),
('/catalogo', 'USUARIO');

/* Rutas públicas */
CREATE TABLE ruta_permit (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    patron VARCHAR(255) NOT NULL
);

INSERT INTO ruta_permit (patron) VALUES
('/'),
('/index'),
('/registro'),
('/js/'),
('/css/'),
('/images/');

/* Mensajes de contacto */
CREATE TABLE mensaje_contacto (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    asunto VARCHAR(200) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    leido BOOLEAN DEFAULT FALSE
);

/* Información de biblioteca */
CREATE TABLE info_biblioteca (
    id_info INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    horario TEXT,
    ruta_imagen VARCHAR(1024),
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8)
);

INSERT INTO info_biblioteca (nombre, descripcion, direccion, telefono, correo, horario)
VALUES ('Biblioteca Municipal de San Pedro', 'Biblioteca moderna con acceso a Wi-Fi, computadoras y colecciones digitales', 
'Avenida Las Palmas 456, San Pedro', '987-654-3210', 'contacto@biblio-sanpedro.org', 'Lunes a Viernes: 8:00 - 18:00\nSábados: 9:00 - 13:00\nDomingos: Cerrado');

/* Noticias */
CREATE TABLE noticia (
    id_noticia INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    ruta_imagen VARCHAR(1024),
    publicado BOOLEAN DEFAULT TRUE
);

INSERT INTO libro (titulo, precio, editorial, idioma, existencias, id_categoria) VALUES
('La sombra del viento', 15.99, 'Editorial Sudamericana', 'Español', 50, 1),
('El nombre del viento', 28.00, 'George Allen & Unwin', 'Inglés', 40, 2),
('La casa de los espíritus', 12.75, 'Alianza Editorial', 'Español', 45, 1),
('Percy Jackson y el ladrón del rayo', 20.00, 'Scholastic Press', 'Inglés', 65, 2),
('Rayuela', 19.95, 'Real Academia Española', 'Español', 25, 3),
('El coronel no tiene quien le escriba', 11.50, 'Editorial Norma', 'Español', 55, 1),
('Canción de hielo y fuego', 17.50, 'Houghton Mifflin', 'Inglés', 35, 2),
('La tregua', 14.00, 'Debolsillo', 'Español', 40, 1),
('Fahrenheit 451', 17.60, 'HarperCollins', 'Español', 20, 3),
('Divergente', 13.90, 'RBA Molino', 'Español', 70, 2);
