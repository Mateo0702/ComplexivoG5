import firebase_admin
from firebase_admin import credentials, db
from datetime import datetime
from flask import jsonify
from conexion.conexionBD import connectionBD

# Inicializar Firebase una sola vez
if not firebase_admin._apps:
    cred = credentials.Certificate("static/pisada-3031e-firebase-adminsdk-fbsvc-3c42e42578.json")
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://pisada-3031e-default-rtdb.firebaseio.com'
    })

def to_num(valor, tipo=int):
    try:
        return tipo(valor)
    except (ValueError, TypeError):
        return 0

def guardar_datos_sesion_activa():
    ref = db.reference("sesiones_activas")
    sesiones = ref.get()
    if not sesiones:
        return "No hay sesiones activas", 404

    sesiones_ordenadas = sorted(sesiones.items(), key=lambda x: x[1].get('fechainicio', ''), reverse=True)
    sesion_final = next((s for s in sesiones_ordenadas if s[1].get('estadosesion') == 'terminada'), None)
    if not sesion_final:
        return "No hay sesión activa terminada", 404

    id_sesion, data = sesion_final
    nombre_completo = data.get("nombrenino", "").strip()
    edad = to_num(data.get("edad"), int)
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
    
    resumen = data.get("resumen", {})
    total_aciertos = to_num(resumen.get("total_aciertos"), int)
    total_errores = to_num(resumen.get("total_errores"), int)
    tiempo_total = to_num(resumen.get("tiempo_total"), float)
    tiempo_promedio = to_num(resumen.get("tiempo_promedio"), float)


    partes = nombre_completo.split(" ", 1)
    nombre = partes[0]
    apellido = partes[1] if len(partes) > 1 else ""

    with connectionBD() as conn:
        cursor = conn.cursor(dictionary=True)

        # Buscar ID del niño
        cursor.execute(
            "SELECT id_nino FROM ninos WHERE nombre_nino=%s AND apellido_nino=%s AND edad=%s LIMIT 1",
            (nombre, apellido, edad)
        )
        nino = cursor.fetchone()
        if not nino:
            return f"No se encontró el niño: {nombre_completo}", 404
        id_nino = nino['id_nino']

        # Calcular el porcentaje de aciertos
        total_intentos = total_aciertos + total_errores
        porcentaje_acierto = (total_aciertos / total_intentos) * 100 if total_intentos > 0 else 0

        # Obtener observaciones del juego activo
        cursor.execute("SELECT * FROM umbrales_juego")
        umbrales_juego = cursor.fetchall()
        observacion_global = "Sin observación"

        for u in umbrales_juego:
            if (
                total_aciertos >= u["min_aciertos"] and
                (u["max_aciertos"] is None or total_aciertos <= u["max_aciertos"]) and
                total_errores >= u["min_errores"] and
                (u["max_errores"] is None or total_errores <= u["max_errores"]) and
                porcentaje_acierto >= u["min_porcentaje_acierto"] and
                (u["max_porcentaje_acierto"] is None or porcentaje_acierto <= u["max_porcentaje_acierto"]) and
                tiempo_promedio >= u["min_tiempo_promedio"] and
                (u["max_tiempo_promedio"] is None or tiempo_promedio <= u["max_tiempo_promedio"])
            ):
                observacion_global = u["observacion"]
                break

        # Insertar sesión activa
        cursor.execute(
            "INSERT INTO sesiones_activas (id_sesion, id_nino, fecha_inicio, fecha_fin, total_aciertos, total_errores, "
            "tiempo_total, tiempo_promedio, observacion_global) "
            "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (id_sesion, id_nino, fechainicio, fechafin, total_aciertos, total_errores,
             tiempo_total, tiempo_promedio, observacion_global)
        )
        conn.commit()

        # Guardar cada intento
        for clave, intento in data.get("eventos", {}).items():
            baldosa = to_num(intento.get("baldosa"), int)
            resultado = intento.get("resultado", "error")
            tiempo = to_num(intento.get("tiempo"), float)
            modo = intento.get("modo", "desconocido")
            timestamp = intento.get("timestamp")

            try:
                timestamp_dt = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S") if timestamp else None
            except:
                timestamp_dt = None

            cursor.execute(
                "INSERT INTO intentos_sesion (id_sesion, baldosa, resultado, modo, tiempo, timestamp) "
                "VALUES (%s, %s, %s, %s, %s, %s)",
                (id_sesion, baldosa, resultado, modo, tiempo, timestamp_dt)
            )

        conn.commit()

    return "Sesión activa guardada correctamente", 200