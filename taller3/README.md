# Taller 3 – Firebase App Distribution


## Descripción de la App

App Flutter con navegación entre tres pantallas desarrollada como ejercicio de distribución móvil mediante Firebase App Distribution.

**Pantallas:**
- **Home** – Pantalla principal con navegación a las demás secciones
- **Detalle** – Lista los pasos del flujo de distribución
- **Acerca de** – Muestra información de la app y versión actual

---

## Flujo de Publicación

```
Generar APK → Firebase App Distribution → Testers → Instalación → Actualización
```

### Paso a paso

1. **Generar APK de release**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```
   El APK queda en: `build/app/outputs/flutter-apk/app-release.apk`

2. **Subir a Firebase App Distribution**
   - Ir a [Firebase Console](https://console.firebase.google.com) → App Distribution → Releases
   - Clic en **Upload** y seleccionar `app-release.apk`
   - Agregar Release Notes con versión, fecha y cambios

3. **Asignar Testers**
   - Ir a **Testers & Groups**
   - Grupo: `QA_Clase`
   - Testers: `dduran@uceva.edu.co`
   - Asignar el grupo al release y clic en **Distribute**

4. **Instalación en dispositivo**
   - El tester recibe un correo de invitación de Firebase
   - Accede al enlace e instala la app en su dispositivo Android físico

5. **Actualización incremental**
   - Modificar `version` en `pubspec.yaml`
   - Generar nuevo APK y subir a App Distribution
   - Distribuir al mismo grupo con nuevas Release Notes

---

## Publicación

### Requisitos previos
- Proyecto registrado en Firebase Console
- Archivo `google-services.json` en `android/app/`

### Permisos necesarios en `AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### Cómo replicar el proceso en el equipo

```bash
# 1. Clonar el repositorio
git clone https://github.com/TU_USUARIO/MovilesTaller.git
cd MovilesTaller

# 2. Instalar dependencias
flutter pub get

# 3. Colocar google-services.json en android/app/

# 4. Generar APK
flutter build apk

# 5. Subir app-release.apk a Firebase App Distribution
```

---

## Versionado

El versionado sigue el formato de Flutter en `pubspec.yaml`:

```yaml
version: versionName+versionCode
```

| Campo | Descripción | Ejemplo |
|---|---|---|
| `versionName` | Versión visible al usuario | `1.0.1` |
| `versionCode` | Número interno, siempre incrementar | `2` |

### Historial de versiones

| Versión | versionCode | Fecha | Cambios |
|---|---|---|---|
| 1.0.0 | 1 | Mayo 2026 | Release inicial – navegación entre 3 pantallas |
| 1.0.1 | 2 | Mayo 2026 | Actualización de versión visible en pantalla Acerca de |

---

## Formato de Release Notes

```
Versión X.X.X - [Mes Año]
- [Descripción del cambio principal]
- [Correcciones o mejoras]
- Responsable: [Nombre]
- Credenciales de prueba: [si aplica]
```

---


**Flujo seguido:**
1. Trabajo en rama `feature/taller3`
2. Pull Request: `feature/taller3` → `dev`
3. Merge a `dev` tras revisión
4. Integración final: `dev` → `main`

