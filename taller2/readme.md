# Taller: Procesamiento en Segundo Plano en Flutter

Este proyecto demuestra el manejo de asincronía y tareas pesadas en Dart/Flutter. La aplicación está diseñada con un tema oscuro inspirado en GitHub (estilo "Deep Sea") y utiliza fuentes monoespaciadas para un look técnico.

## Tecnologías y Flujos

### 1. Future / async / await
- **Uso:** Consultas simuladas que no bloquean la UI.
- **Detalle Técnico:** Se implementó un `DataService` que introduce un retardo de 2-3s y maneja errores aleatorios (30% de probabilidad) para demostrar el uso de bloques `try-catch`.

### 2. Timer (dart:async)
- **Uso:** Cronómetro con precisión de centésimas de segundo.
- **Detalle Técnico:** Uso de `Timer.periodic` cada 100ms. Se incluye una limpieza estricta en el método `dispose` para evitar fugas de memoria (memory leaks).

### 3. Isolate via `compute()`
- **Uso:** Tareas CPU-bound (cálculos matemáticos pesados).
- **Detalle Técnico:** Se utiliza la función `compute()` para sumar hasta 500 millones de números en nativo. La UI muestra un contador de "UI activa" mientras el cálculo ocurre en otro hilo, demostrando que el hilo principal (Main Isolate) nunca se congela.

##  GitFlow del Proyecto
1. **Rama Base:** `dev`
2. **Feature Branch:** `feature/taller_segundo_plano`
3. **Proceso:** Desarrollo → PR a `dev` → Merge a `main`.

## Estructura de Pantallas
- **HomeScreen:** Dashboard principal.
- **FutureScreen:** Gestión de estados (Idle, Loading, Success, Error).
- **TimerScreen:** Control de tiempo y registro de vueltas.
- **IsolateScreen:** Ejecución de cálculos pesados con monitoreo de respuesta.
