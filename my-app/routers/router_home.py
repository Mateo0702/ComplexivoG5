from controllers.funciones_login import *
from app import app
from flask import render_template, request, flash, redirect, url_for, session,  jsonify
from mysql.connector.errors import Error
from conexion.view import guardar_datos_sesion_firebase
from conexion.activas import guardar_datos_sesion_activa

# Importando cenexión a BD
from controllers.funciones_home import *

@app.route('/lista-de-areas', methods=['GET'])
def lista_areas():
    if 'conectado' in session:
        return render_template('public/usuarios/lista_areas.html', areas=lista_areasBD(), dataLogin=dataLoginSesion())
    else:
        flash('primero debes iniciar sesión.', 'error')
        return redirect(url_for('inicio'))

@app.route("/lista-de-usuarios", methods=['GET'])
def usuarios():
    if 'conectado' in session:
        return render_template('public/usuarios/lista_usuarios.html',  resp_usuariosBD=lista_usuariosBD(), dataLogin=dataLoginSesion(), areas=lista_areasBD(), roles = lista_rolesBD())
    else:
        return redirect(url_for('inicioCpanel'))

@app.route('/lista_ninos', methods=['GET'])
def lista_ninos():
    if 'conectado' in session:
        return render_template('public/usuarios/lista_ninos.html', ninos=lista_ninosBD(), dataLogin=dataLoginSesion())
    else:
        flash('primero debes iniciar sesión.', 'error')
        return redirect(url_for('inicio'))

@app.route('/resultados')
def resultados():
    if 'conectado' in session:
        id_terapeuta = session['conectado']

        with connectionBD() as conexion:
            with conexion.cursor(dictionary=True) as cursor:
                cursor.execute("""
                    SELECT nombre_usuario, apellido_usuario, cedula
                    FROM usuarios
                    WHERE id_usuario = %s
                """, (id_terapeuta,))
                terapeuta = cursor.fetchone()

        return render_template(
            'public/usuarios/resultados.html',
            ninos=lista_ninosBD(),
            terapeuta=terapeuta,
            dataLogin=dataLoginSesion()
        )
    return redirect(url_for('login'))

@app.route('/resultados_activas')
def resultados_activas():
    if 'conectado' in session:
        id_terapeuta = session['conectado']

        with connectionBD() as conexion:
            with conexion.cursor(dictionary=True) as cursor:
                cursor.execute("""
                    SELECT nombre_usuario, apellido_usuario, cedula
                    FROM usuarios
                    WHERE id_usuario = %s
                """, (id_terapeuta,))
                terapeuta = cursor.fetchone()

        return render_template(
            'public/usuarios/resultados_activas.html',
            ninos=lista_ninosBD(),
            terapeuta=terapeuta,
            dataLogin=dataLoginSesion()
        )
    return redirect(url_for('login'))

@app.route('/resultados_datos')
def resultados_datos():
    id_nino = request.args.get('id_nino', type=int)
    fecha_inicio = request.args.get('fecha_inicio')
    fecha_fin = request.args.get('fecha_fin')

    with connectionBD() as conexion_MySQLdb:
        with conexion_MySQLdb.cursor(dictionary=True) as cursor:

            resumen = {}

            if id_nino and not fecha_inicio and not fecha_fin:
                # Última sesión del niño
                cursor.execute("""
                    SELECT id_sesion FROM sesiones_activas_pasivas
                    WHERE id_nino = %s
                    ORDER BY fecha_inicio DESC LIMIT 1
                """, (id_nino,))
                ultima = cursor.fetchone()
                if not ultima:
                    return jsonify({
                        "baldosas": [], "total_global": 0, "sesiones": [], "resumen": {}
                    })
                id_sesion = ultima['id_sesion']

                # Pisadas por baldosa con color, descripción y interpretación
                cursor.execute("""
                    SELECT d.baldosa, d.total_pisadas, u.observacion,
                        b.color, b.descripcion, 
                        a.interpretacion
                    FROM detalle_pisadas_baldosa d
                    LEFT JOIN umbrales_baldosa u
                        ON d.total_pisadas BETWEEN u.minimo AND IFNULL(u.maximo, 999999)
                    LEFT JOIN baldosas_info b
                        ON d.baldosa = b.baldosa
                    LEFT JOIN atracciones_baldosa_color a
                        ON b.color = a.color
                    WHERE d.id_sesion = %s
                    ORDER BY d.baldosa
                """, (id_sesion,))
                baldosas = cursor.fetchall()

                # Total pisadas
                cursor.execute("""
                    SELECT SUM(total_pisadas) AS total_global
                    FROM detalle_pisadas_baldosa
                    WHERE id_sesion = %s
                """, (id_sesion,))
                total = cursor.fetchone()['total_global'] or 0

                # Sesión
                cursor.execute("""
                    SELECT s.id_sesion, s.fecha_inicio, s.fecha_fin, s.total_pisadas, s.observacion_global,
                        n.nombre_nino
                    FROM sesiones_activas_pasivas s
                    INNER JOIN ninos n ON s.id_nino = n.id_nino
                    WHERE s.id_sesion = %s
                """, (id_sesion,))
                sesiones = cursor.fetchall()

                # Resumen
                if baldosas:
                    mas = max(baldosas, key=lambda x: x['total_pisadas'])
                    menos = min(baldosas, key=lambda x: x['total_pisadas'])
                    resumen = {
                        "mas_pisada": {
                            "baldosa": mas['baldosa'],
                            "pisadas": mas['total_pisadas'],
                            "observacion": mas['observacion'],
                            "color": mas['color'],
                            "descripcion": mas['descripcion'],
                            "interpretacion": mas['interpretacion']
                        },
                        "menos_pisada": {
                            "baldosa": menos['baldosa'],
                            "pisadas": menos['total_pisadas'],
                            "observacion": menos['observacion'],
                            "color": menos['color'],
                            "descripcion": menos['descripcion'],
                            "interpretacion": menos['interpretacion']
                        }
                    }

            else:
                # Consulta general (con o sin fechas)
                filtros = []
                valores = []

                if id_nino:
                    filtros.append("s.id_nino = %s")
                    valores.append(id_nino)
                if fecha_inicio and fecha_fin:
                    filtros.append("s.fecha_inicio >= %s AND s.fecha_fin <= %s")
                    valores.extend([fecha_inicio, fecha_fin])

                where_clause = " AND ".join(filtros)
                if where_clause:
                    where_clause = "WHERE " + where_clause

                # Pisadas por baldosa con JOINs completos
                query_baldosas = f"""
                    SELECT res.baldosa, res.total_pisadas, u.observacion,
                        b.color, b.descripcion, 
                        a.interpretacion
                    FROM (
                        SELECT d.baldosa, SUM(d.total_pisadas) AS total_pisadas
                        FROM detalle_pisadas_baldosa d
                        INNER JOIN sesiones_activas_pasivas s ON d.id_sesion = s.id_sesion
                        {where_clause}
                        GROUP BY d.baldosa
                    ) AS res
                    LEFT JOIN umbrales_baldosa u
                        ON res.total_pisadas BETWEEN u.minimo AND IFNULL(u.maximo, 999999)
                    LEFT JOIN baldosas_info b
                        ON res.baldosa = b.baldosa
                    LEFT JOIN atracciones_baldosa_color a
                        ON b.color = a.color
                    ORDER BY res.baldosa
                """
                cursor.execute(query_baldosas, valores)
                baldosas = cursor.fetchall()

                # Total global
                query_total = f"""
                    SELECT SUM(d.total_pisadas) AS total_global
                    FROM detalle_pisadas_baldosa d
                    INNER JOIN sesiones_activas_pasivas s ON d.id_sesion = s.id_sesion
                    {where_clause}
                """
                cursor.execute(query_total, valores)
                total = cursor.fetchone()['total_global'] or 0

                # Sesiones
                query_sesiones = f"""
                    SELECT s.id_sesion, s.fecha_inicio, s.fecha_fin, s.total_pisadas, s.observacion_global,
                        n.nombre_nino
                    FROM sesiones_activas_pasivas s
                    INNER JOIN ninos n ON s.id_nino = n.id_nino
                    {where_clause}
                    ORDER BY s.fecha_inicio DESC
                """
                cursor.execute(query_sesiones, valores)
                sesiones = cursor.fetchall()

                # Resumen
                if baldosas:
                    mas = max(baldosas, key=lambda x: x['total_pisadas'])
                    menos = min(baldosas, key=lambda x: x['total_pisadas'])
                    resumen = {
                        "mas_pisada": {
                            "baldosa": mas['baldosa'],
                            "pisadas": mas['total_pisadas'],
                            "observacion": mas['observacion'],
                            "color": mas['color'],
                            "descripcion": mas['descripcion'],
                            "interpretacion": mas['interpretacion']
                        },
                        "menos_pisada": {
                            "baldosa": menos['baldosa'],
                            "pisadas": menos['total_pisadas'],
                            "observacion": menos['observacion'],
                            "color": menos['color'],
                            "descripcion": menos['descripcion'],
                            "interpretacion": menos['interpretacion']
                        }
                    }

    return jsonify({
        "baldosas": baldosas,
        "total_global": total,
        "sesiones": sesiones,
        "resumen": resumen
    })

@app.route('/resultados_activas_datos')
def resultados_activas_datos():
    id_nino = request.args.get('id_nino', type=int)
    fecha_inicio = request.args.get('fecha_inicio')
    fecha_fin = request.args.get('fecha_fin')

    with connectionBD() as conexion_MySQLdb:
        with conexion_MySQLdb.cursor(dictionary=True) as cursor:
            filtros = []
            valores = []

            if id_nino:
                filtros.append("s.id_nino = %s")
                valores.append(id_nino)
            if fecha_inicio and fecha_fin:
                filtros.append("s.fecha_inicio >= %s AND s.fecha_fin <= %s")
                valores.extend([fecha_inicio, fecha_fin])

            where_clause = "WHERE " + " AND ".join(filtros) if filtros else ""

            # Determinar si se usó solo filtro por niño (última sesión) o también fechas
            extra_clause = ""
            if fecha_inicio and fecha_fin:
                extra_clause = "ORDER BY s.fecha_inicio DESC"
            elif id_nino:
                extra_clause = "ORDER BY s.fecha_inicio DESC LIMIT 1"

            query_sesiones = f"""
                SELECT s.id_sesion, s.fecha_inicio, s.fecha_fin,
                       s.total_aciertos, s.total_errores,
                       s.tiempo_promedio, s.observacion_global,
                       n.nombre_nino
                FROM sesiones_activas s
                INNER JOIN ninos n ON s.id_nino = n.id_nino
                {where_clause}
                {extra_clause}
            """
            cursor.execute(query_sesiones, valores)
            sesiones = cursor.fetchall()

            total_juegos = len(sesiones) * 6
            tiempo_promedio = round(
                sum(s['tiempo_promedio'] for s in sesiones) / len(sesiones), 2
            ) if sesiones else 0

    return jsonify({
        "sesiones": sesiones,
        "total_juegos": total_juegos,
        "tiempo_promedio": tiempo_promedio
    })

@app.route('/configurar_observaciones', methods=['GET', 'POST'])
def configurar_observaciones():
    if 'conectado' not in session:
        return redirect('/login')

    with connectionBD() as conn:
        cursor = conn.cursor(dictionary=True)

        if request.method == 'POST':
            tipo = request.form.get('tipo')
            observaciones = request.form.getlist('observacion[]')
            ids = request.form.getlist('id[]')

            if tipo == 'baldosa':
                for i in range(len(ids)):
                    cursor.execute(
                        "UPDATE umbrales_baldosa SET observacion = %s WHERE id_criterio = %s",
                        (observaciones[i], ids[i])
                    )
            elif tipo == 'sesion':
                for i in range(len(ids)):
                    cursor.execute(
                        "UPDATE umbrales_sesion SET observacion = %s WHERE id_criterio = %s",
                        (observaciones[i], ids[i])
                    )
            elif tipo == 'color':
                for i in range(len(ids)):
                    cursor.execute(
                        "UPDATE atracciones_baldosa_color SET interpretacion = %s WHERE id_atraccion = %s",
                        (observaciones[i], ids[i])
                    )
            elif tipo == 'juego':
                for i in range(len(ids)):
                    cursor.execute(
                        "UPDATE umbrales_juego SET observacion = %s WHERE id = %s",
                        (observaciones[i], ids[i])
                    )

            conn.commit()
            flash('Observaciones actualizadas correctamente', 'success')

        # Obtener los valores actuales
        cursor.execute("SELECT * FROM umbrales_baldosa ORDER BY minimo")
        umbrales_baldosa = cursor.fetchall()

        cursor.execute("SELECT * FROM umbrales_sesion ORDER BY minimo")
        umbrales_sesion = cursor.fetchall()

        cursor.execute("SELECT * FROM atracciones_baldosa_color ORDER BY color")
        atracciones_color = cursor.fetchall()

        cursor.execute("SELECT * FROM umbrales_juego ORDER BY min_aciertos")
        umbrales_juego = cursor.fetchall()


    return render_template(
        "public/usuarios/configurar_observaciones.html",
        umbrales_baldosa=umbrales_baldosa,
        umbrales_sesion=umbrales_sesion,
        atracciones_color=atracciones_color,
        umbrales_juego=umbrales_juego,
        dataLogin=dataLoginSesion()
    )

@app.route('/sesiones-pasivas')
def sesiones_pasivas():
    return render_template('public/usuarios/sesiones_pasivas.html', ninos=lista_ninosBD(), dataLogin=dataLoginSesion())

@app.route('/sesiones-activas')
def sesiones_activas():
    return render_template('public/usuarios/sesiones_activas.html', ninos=lista_ninosBD(), dataLogin=dataLoginSesion())


#Ruta especificada para eliminar un usuario
@app.route('/borrar-usuario/<string:id>', methods=['GET'])
def borrarUsuario(id):
    resp = eliminarUsuario(id)
    if resp:
        flash('El Usuario fue eliminado correctamente', 'success')
        return redirect(url_for('usuarios'))
    
@app.route("/guardar_sesion", methods=["POST"])
def guardar_sesion():
    return guardar_datos_sesion_firebase()

@app.route("/guardar_sesion_activa", methods=["POST"])
def guardar_sesion_activa():
    return guardar_datos_sesion_activa()


from controllers.funciones_home import (
    eliminarUsuario, contar_ninos_a_cargo, obtener_ninos_a_cargo, lista_usuariosBD
)

@app.route('/borrar-usuario/<int:id>', methods=['GET', 'POST'])
def borrar_usuario(id):
    cantidad = contar_ninos_a_cargo(id)
    if cantidad == 0:
        eliminarUsuario(id)
        flash('Usuario eliminado correctamente.', 'success')
        return redirect(url_for('usuarios'))
    else:
        ninos = obtener_ninos_a_cargo(id)
        terapeutas = [u for u in lista_usuariosBD() if u['id_rol'] == 3 and u['id_usuario'] != id]
        return render_template(
            'public/usuarios/reasignar_ninos.html',
            ninos=ninos,
            terapeutas=terapeutas,
            id_terapeuta_actual=id,
            cantidad=cantidad,
            dataLogin=dataLoginSesion()
        )

@app.route('/reasignar-ninos/<int:id_terapeuta_actual>', methods=['POST'])
def reasignar_ninos(id_terapeuta_actual):
    nuevo_terapeuta = request.form.get('nuevo_terapeuta')
    try:
        with connectionBD() as conexion_MySQLdb:
            with conexion_MySQLdb.cursor() as cursor:
                # Reasignar todos los niños
                cursor.execute(
                    "UPDATE ninos SET id_terapeuta=%s WHERE id_terapeuta=%s",
                    (nuevo_terapeuta, id_terapeuta_actual)
                )
                conexion_MySQLdb.commit()
        # Ahora sí, eliminar el usuario
        eliminarUsuario(id_terapeuta_actual)
        flash('Niños reasignados y usuario eliminado correctamente.', 'success')
    except Exception as e:
        flash(f'Error al reasignar o eliminar: {e}', 'error')
    return redirect(url_for('usuarios'))
    
@app.route('/borrar-area/<string:id_area>/', methods=['GET'])
def borrarArea(id_area):
    resp = eliminarArea(id_area)
    if resp:
        flash('El Empleado fue eliminado correctamente', 'success')
        return redirect(url_for('lista_areas'))
    else:
        flash('Hay usuarios que pertenecen a esta área', 'error')
        return redirect(url_for('lista_areas'))


@app.route("/descargar-informe-accesos/", methods=['GET'])
def reporteBD():
    if 'conectado' in session:
        return generarReporteExcel()
    else:
        flash('primero debes iniciar sesión.', 'error')
        return redirect(url_for('inicio'))
    
@app.route("/reporte-accesos", methods=['GET'])
def reporteAccesos():
    if 'conectado' in session:
        userData = dataLoginSesion()
        return render_template('public/perfil/reportes.html',  reportes=dataReportes(),lastAccess=lastAccessBD(userData.get('cedula')), dataLogin=dataLoginSesion())

@app.route("/interfaz-clave", methods=['GET','POST'])
def claves():
    return render_template('public/usuarios/generar_clave.html', dataLogin=dataLoginSesion())
    
@app.route('/generar-y-guardar-clave/<string:id>', methods=['GET','POST'])
def generar_clave(id):
    print(id)
    clave_generada = crearClave()  # Llama a la función para generar la clave
    guardarClaveAuditoria(clave_generada,id)
    return clave_generada
#CREAR AREA
@app.route('/crear-area', methods=['GET','POST'])
def crearArea():
    if request.method == 'POST':
        area_name = request.form['nombre_area']  # Asumiendo que 'nombre_area' es el nombre del campo en el formulario
        resultado_insert = guardarArea(area_name)
        if resultado_insert:
            # Éxito al guardar el área
            flash('El Area fue creada correctamente', 'success')
            return redirect(url_for('lista_areas'))
            
        else:
            # Manejar error al guardar el área
            return "Hubo un error al guardar el área."
    return render_template('public/usuarios/lista_areas')

##ACTUALIZAR AREA
@app.route('/actualizar-area', methods=['POST'])
def updateArea():
    if request.method == 'POST':
        nombre_area = request.form['nombre_area']  # Asumiendo que 'nuevo_nombre' es el nombre del campo en el formulario
        id_area = request.form['id_area']
        resultado_update = actualizarArea(id_area, nombre_area)
        if resultado_update:
           # Éxito al actualizar el área
            flash('El actualizar fue creada correctamente', 'success')
            return redirect(url_for('lista_areas'))
        else:
            # Manejar error al actualizar el área
            return "Hubo un error al actualizar el área."

    return redirect(url_for('lista_areas'))
    