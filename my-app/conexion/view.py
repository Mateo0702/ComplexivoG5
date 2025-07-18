import firebase_admin
from firebase_admin import credentials, db
from datetime import datetime
from flask import jsonify
import os
from conexion.conexionBD import connectionBD
from datetime import datetime

# Inicializar Firebase una sola vez
if not firebase_admin._apps:
    cred = credentials.Certificate("static/pisada-3031e-firebase-adminsdk-fbsvc-3c42e42578.json")
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://pisada-3031e-default-rtdb.firebaseio.com'
    })

def guardar_datos_sesion_firebase():
    ref = db.reference("sesiones_pasivas")
    sesiones = ref.get()
    if not sesiones:
        return "No hay sesiones", 404

    # Buscar la última sesión terminada
    sesiones_ordenadas = sorted(sesiones.items(), key=lambda x: x[1]['fechainicio'], reverse=True)
    sesion_final = next((s for s in sesiones_ordenadas if s[1].get('estadosesion') == 'terminada'), None)
    if not sesion_final:
        return "No hay sesión terminada", 404

    id_sesion, data = sesion_final
    nombre_completo = " ".join(data.get("nombrenino", "").strip().split())
    edad = data.get("edad", 0)
    fechainicio_iso = data.get("fechainicio", "")
    fechafin_iso = data.get("fechafin", "")

    try:
        fechainicio = datetime.fromisoformat(fechainicio_iso) if fechainicio_iso else None
    except Exception as e:
        print(f"⚠️ Error al parsear fechainicio: {fechainicio_iso} -> {e}")
        fechainicio = None

    try:
        fechafin = datetime.fromisoformat(fechafin_iso) if fechafin_iso else None
    except Exception as e:
        print(f"⚠️ Error al parsear fechafin: {fechafin_iso} -> {e}")
        fechafin = None

    total_pisadas = data.get("globalpisadas", 0)

    partes = nombre_completo.strip().split(" ", 1)
    nombre = partes[0]
    apellido = partes[1] if len(partes) > 1 else ""

    with connectionBD() as conn:
        cursor = conn.cursor(dictionary=True)

        # Buscar ID del niño
        cursor.execute("""
            SELECT id_nino FROM ninos 
            WHERE nombre_nino=%s AND apellido_nino=%s AND edad=%s LIMIT 1
        """, (nombre, apellido, edad))
        nino = cursor.fetchone()
        if not nino:
            return f"No se encontró el niño: {nombre_completo}", 404
        id_nino = nino['id_nino']

        # Determinar observación global
        cursor.execute("SELECT * FROM umbrales_sesion")
        umbrales_globales = cursor.fetchall()
        observacion_global = "Sin observación"
        for u in umbrales_globales:
            if total_pisadas >= u["minimo"] and (u["maximo"] is None or total_pisadas <= u["maximo"]):
                observacion_global = u["observacion"]
                break

        # Insertar sesión
        cursor.execute("""
            INSERT INTO sesiones_activas_pasivas 
            (id_nino, nombre_nino, edad, fecha_inicio, fecha_fin, total_pisadas, observacion_global)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (id_nino, nombre_completo, edad, fechainicio, fechafin, total_pisadas, observacion_global))
        conn.commit()

        id_sesion_mysql = cursor.lastrowid

        # Cargar umbrales de baldosa
        cursor.execute("SELECT * FROM umbrales_baldosa")
        umbrales_baldosa = cursor.fetchall()

        # Guardar detalle por baldosa
        for i in range(1, 10):
            piso = data.get(f"piso{i}", {})
            total = piso.get(f"totalpisadas{i}", 0)
            logs = piso.get("logs", {})
            marcas = ", ".join(logs.values()) if logs else ""

            observacion = "Sin observación"
            for u in umbrales_baldosa:
                if total >= u["minimo"] and (u["maximo"] is None or total <= u["maximo"]):
                    observacion = u["observacion"]
                    break

            cursor.execute("""
                INSERT INTO detalle_pisadas_baldosa 
                (id_sesion, baldosa, total_pisadas, observacion_baldosa)
                VALUES (%s, %s, %s, %s)
            """, (id_sesion_mysql, i, total, observacion))

        conn.commit()
    print(f"Insertado: {id_sesion_mysql}, Niño: {id_nino}, Inicio: {fechainicio}, Fin: {fechafin}, Total: {total_pisadas}")
    return "Datos guardados correctamente", 200
