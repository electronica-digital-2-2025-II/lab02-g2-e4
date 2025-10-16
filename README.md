[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/sEFmt2_p)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=20977837&assignment_repo_type=AssignmentRepo)
# Lab02 - Unidad Aritmético-Lógica.

# Integrantes
- Kevin Adrian Guerra Cifuentes (https://github.com/kevinguerra54)
- Juan Pablo Ruiz Sabogal (https://github.com/juruizsa)
- Julián Camilo Casallas Villamil (https://github.com/jcasallasv)

# Informe

Indice:

1. [Diseño implementado](#diseño-implementado)
2. [Simulaciones](#simulaciones)
3. [Implementación](#implementación)
4. [Conclusiones](#conclusiones)
5. [Referencias](#referencias)


---

## Diseño implementado

### Objetivo
Diseñar e implementar una **Unidad Aritmético-Lógica (ALU) de 4 bits**, capaz de ejecutar diversas operaciones aritméticas y lógicas reutilizando los módulos desarrollados en las practicas previas (Multiplicador y Sumador), e incorporando nuevos módulos como Restador, el operador lógico NAND y Corrimiento lógico.

---

### Descripción

La ALU recibe dos operandos de 4 bits (`A` y `B`), junto con una señal de control (`opcode`) de 3 bits que define la operación a ejecutar.  
Las operaciones implementadas son:

| `opcode` | Operación        | Descripción                            |
|:---------:|:-----------------|:---------------------------------------|
| `000`     | **Suma**         | Suma binaria con detección de overflow |
| `001`     | **Resta**        | Resta binaria (borrow como overflow)   |
| `010`     | **Multiplicación** | Producto de 4×4 bits (8 bits)        |
| `011`     | **Corrimiento**  | Desplazamiento lógico izq./der.        |
| `100`     | **NAND**         | Operación lógica bit a bit            |

La salida principal `resultado[7:0]` se actualiza según la operación.  
Además, se activan las banderas:
- `zero` → si el resultado es cero.  
- `overflow` → si ocurre un desbordamiento.  
- `done` → indica que la operación secuencial (multiplicación, NAND o corrimiento) ha finalizado.

---

## Estructura de cada módulo

El diseño de la ALU se desarrolló con un enfoque jerárquico, usando los siguientes módulos:

| Módulo | Descripción |
|--------|--------------|
| `sum1b.v` | Sumador completo de 1 bit |
| `sum4b.v` | Sumador de 4 bits en cascada |
| `rest1b.v` | Restador completo de 1 bit |
| `rest4b.v` | Restador de 4 bits en cascada |
| `multiplicador.v` | Multiplicación secuencial de 4 bits |
| `corrimiento.v` | Corrimiento lógico (izquierda/derecha) |
| `NAND.v` | Operación lógica NAND |
| `ALU.v` | Unidad principal de control |
| `tb_ALU.v` | Banco de pruebas (testbench) |

---

##  Módulo Principal 

El módulo `ALU.v` conecta internamente los bloques aritméticos y lógicos, y selecciona la operación según el código `opcode`.  
Además, detecta condiciones de **zero** y **overflow**.

**Entradas y salidas:**

| Señal | Dirección | Tamaño | Descripción |
|-------|------------|---------|-------------|
| `clk` | Entrada | 1 | Reloj del sistema |
| `rst` | Entrada | 1 | Reset síncrono |
| `start` | Entrada | 1 | Inicio de operación secuencial |
| `A`, `B` | Entrada | 4 | Operandos principales |
| `opcode` | Entrada | 3 | Selección de operación |
| `resultado` | Salida | 8 | Resultado general |
| `overflow` | Salida | 1 | Bandera de desbordamiento |
| `zero` | Salida | 1 | Bandera de cero |
| `done` | Salida | 1 | Operación terminada |

---

## Simulaciones 

El archivo de simulación (`tb_ALU.v`) genera estímulos para todas las operaciones:

### 🔹 Escenarios probados:

| Prueba | Operación | `A` | `B` | `opcode` | Resultado esperado |
|:------:|:-----------|:---:|:---:|:--------:|:------------------:|
| 1 | Suma | 5 | 3 | `000` | 8 (`01000`) |
| 2 | Resta | 6 | 3 | `001` | 6 (`00110`) |
| 3 | Multiplicación | 5 | 2 | `010` | 10 (`00001010`) |
| 4 | Corrimiento izq. | 0101 | — | `011` | 1010 |
| 5 | Corrimiento der. | 1001 | — | `011` | 0100 |
| 6 | NAND | 1010 | 1100 | `100` | 0111 |

---

### Diagrama

![](https://github.com/electronica-digital-2-2025-II/lab02-g2-e4/blob/main/imagenes/simulaci%C3%B3n.png)

Algunos resultados de la simulación se observaron en las siguientes señales principales:
- `overflow`: se activa al producirse un desbordamiento.  
- `zero`: se activa si el resultado es nulo.  
- `done_led`: indica el fin de cada operación secuencial.

---

## Implementación

Asignación de los pines:
   - `A`, `B` → Switches 
   - `opcode` → Botones 
   - `resultado` → LEDs 
   - `start` → Botón 
   - `done`, `overflow`, `zero` → LEDs de estado extra

---

## Conclusiones

- Se implementó una ALU de 4 bits que integra operaciones aritméticas y lógicas.  
- La estructura jerárquica permitió reutilizar módulos de prácticas anteriores.  
- La simulación en Vivado validó el correcto funcionamiento de cada operación antes de la síntesis.  
- El diseño FSM en módulos secuenciales (Multiplicador, NAND y Corrimiento) garantizó control por estados y sincronización con el reloj.  

---

## Referencias


- [1] AMD, *Vivado Design Suite User Guide: Designing with IP (UG896)*, Release 2025.1, Jun. 11, 2025. [Online]. Available: https://docs.amd.com/r/en-US/ug896-vivado-ip/Vivado-Design-Suite-Documentation  
- [2] S. L. Harris y D. Harris, *Digital Design and Computer Architecture: RISC-V Edition*. Morgan Kaufmann / Elsevier, 2021. [Online]. Disponible: https://mrce.in/ebooks/Digital%20Design%20&%20Computer%20Architecture%20RISC-V%20Edition.pdf  
---









