Proyecto Final — Sistema Web Orquestado con Docker Swarm

📌 Descripción General

Este proyecto implementa una arquitectura de microservicios utilizando contenedores Docker y orquestación con Docker Swarm.

El sistema está compuesto por:

Reverse Proxy con Nginx

Backend API desarrollado con FastAPI

Base de datos relacional MySQL

Redes overlay personalizadas

Volumen persistente

Gestión segura de credenciales mediante Docker Secrets

El despliegue se realiza como un stack en Docker Swarm, simulando un entorno de producción.

🏗 Arquitectura del Sistema
4
Flujo de comunicación

Cliente
⬇
Routing Mesh (Ingress)
⬇
Nginx (2 réplicas)
⬇
Backend API (2 réplicas)
⬇
MySQL (1 réplica + volumen persistente)

🧱 Tecnologías Utilizadas

Docker

Docker Swarm

Nginx

FastAPI

MySQL

Python 3.11

Linux

🌐 Redes Implementadas

Se definieron dos redes overlay para segmentación de tráfico:

Red	Propósito
frontend_net	Comunicación Nginx ↔ Backend
backend_net	Comunicación Backend ↔ MySQL

Esto permite separar capas y evitar accesos innecesarios.

💾 Persistencia de Datos

Se implementa un volumen Docker:

volumes:
  mysql_data:

Este volumen garantiza que los datos de MySQL se mantengan aunque los contenedores sean reiniciados o recreados.

🔐 Gestión de Seguridad — Docker Secrets

Para evitar el uso de credenciales en texto plano dentro del stack.yaml, se implementó Docker Secrets.

Creación del secret
echo "rootpassword" | docker secret create mysql_root_password -
Definición en el stack
secrets:
  mysql_root_password:
    external: true
Uso en el servicio MySQL
services:
  mysql:
    secrets:
      - mysql_root_password
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/mysql_root_password

Con este enfoque:

La contraseña no aparece en texto plano en el YAML

No es visible mediante docker inspect

Se almacena cifrada en el nodo manager

Se monta de forma segura en /run/secrets

Esto alinea el proyecto con buenas prácticas actuales en entornos Docker Swarm (2026).

🔁 Alta Disponibilidad

Se configuraron múltiples réplicas para servicios críticos:

deploy:
  replicas: 2
  restart_policy:
    condition: on-failure

Nginx → 2 réplicas

Backend → 2 réplicas

MySQL → 1 réplica

Docker Swarm gestiona automáticamente:

Balanceo de carga interno

Reprogramación de tareas fallidas

Reconstrucción automática de contenedores

📂 Estructura del Proyecto
dockerProject/
│
├── backend/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app/
│       └── backend.py
│
├── frontend/
│   ├── Dockerfile
│   └── nginx.conf
│
└── stack.yaml
🚀 Proceso de Despliegue
1️⃣ Inicializar Docker Swarm
docker swarm init
2️⃣ Construir imágenes
docker build -t backend_image ./backend
docker build -t nginx_image ./frontend
3️⃣ Crear secret
echo "rootpassword" | docker secret create mysql_root_password -
4️⃣ Desplegar el stack
docker stack deploy -c stack.yaml sistema
5️⃣ Verificar estado
docker service ls
docker service ps sistema_backend
docker service logs sistema_backend
📊 Resultado Final

El sistema queda disponible en:

http://localhost

Con:

Balanceo automático

Segmentación de red

Persistencia de datos

Gestión segura de credenciales

Orquestación mediante Docker Swarm

🎓 Competencias Demostradas

Diseño de arquitectura en capas

Uso de redes overlay

Persistencia con volúmenes

Resolución de errores (502 Bad Gateway, fallos ASGI)

Implementación de Docker Secrets

Despliegue de aplicaciones en entorno orquestado