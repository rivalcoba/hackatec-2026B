# Plantilla Typst para reportes IMRAD

Esta plantilla permite elaborar tareas y reportes académicos de nivel maestría con portada institucional, diseño editorial, estructura IMRAD, índice, tablas, figuras y bibliografía.

## Estructura académica

El documento utiliza la organización IMRAD:

1. Introducción: contexto, antecedentes, problema, objetivo y alcance.
2. Métodos: diseño, datos o materiales, procedimiento y análisis.
3. Resultados: presentación ordenada de hallazgos, tablas y figuras.
4. Discusión: interpretación, comparación, implicaciones y limitaciones.

También incluye resumen, conclusiones, referencias y anexos.

## Requisitos

- Tener una cuenta en Typst Web o instalar Typst localmente.
- Conservar la estructura de carpetas del proyecto.
- Disponer de `assets/Cintillo_Tecnm.png` y `assets/logos.png`.
- Conservar la carpeta `fonts/`, que incluye Montserrat, Inter y Noto Sans.

## Instalación

1. Crea una carpeta llamada `reporte-imrad`.
2. Crea los archivos y subcarpetas indicados en la estructura del proyecto.
3. Copia cada bloque de código en el archivo correspondiente.
4. Guarda las imágenes institucionales con sus nombres exactos dentro de `assets/`.
5. Abre `main.typ` en Typst Web o en un editor compatible.

## Configuración en WSL

Los siguientes pasos están pensados para Ubuntu en WSL 2. Si todavía no tienes una distribución instalada, abre PowerShell en Windows y ejecuta `wsl --install -d Ubuntu`; reinicia Windows si lo solicita y completa la creación del usuario de Ubuntu.

### Instalar Typst

Abre Ubuntu (WSL) y descarga el binario oficial para Linux x86_64 desde las versiones de Typst:

```bash
sudo apt update
sudo apt install -y curl ca-certificates tar xz-utils
mkdir -p "$HOME/.local/bin"
curl -L https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz -o /tmp/typst.tar.xz
tar -xJf /tmp/typst.tar.xz --strip-components=1 -C "$HOME/.local/bin"
```

Agrega el directorio al `PATH` de Bash y confirma la instalación:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
typst --version
```

Si tu WSL usa ARM64, descarga en la página de [versiones de Typst](https://github.com/typst/typst/releases) el archivo correspondiente a `aarch64-unknown-linux-musl` en vez del indicado para x86_64.

### Fuentes del proyecto

Las fuentes necesarias ya están en `fonts/`. No es necesario instalarlas en Ubuntu: los comandos de compilación pasan esa carpeta a Typst con `--font-path fonts`. El archivo `.vscode/settings.json` también configura Tinymist para que use las mismas fuentes en el editor. Conserva la carpeta al mover o clonar el proyecto.

### VS Code y extensiones

Instala [Visual Studio Code](https://code.visualstudio.com/) en Windows y agrega estas extensiones desde Marketplace:

- [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl): conecta VS Code con Ubuntu. Esta extensión se instala en VS Code de Windows.
- [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist): resaltado, diagnósticos, formato y vista previa. Instálala cuando VS Code esté conectado a WSL.
- [vscode-pdf](https://marketplace.visualstudio.com/items?itemName=tomoki1207.pdf): opcional, para abrir el PDF generado dentro de VS Code.

Guarda el repositorio dentro del sistema de archivos de Linux (por ejemplo, `~/proyectos/itgam-assignment-typst`) y no bajo `/mnt/c`, para evitar lentitud en operaciones de archivos. Desde Ubuntu, abre la carpeta con:

```bash
cd ~/proyectos/itgam-assignment-typst
code .
```

En VS Code, confirma que la ventana esté conectada a WSL (indicador `WSL: Ubuntu` en la esquina inferior izquierda). Abre `main.typ` para editar y usa los comandos de Tinymist para previsualizar el documento.

### Compilar en WSL

Desde la raíz del proyecto, genera el PDF y comprueba que Typst detecte las fuentes incluidas:

```bash
typst fonts --font-path fonts
typst compile main.typ reporte-imrad.pdf --font-path fonts
```

Para recompilar automáticamente al guardar cambios:

```bash
typst watch main.typ reporte-imrad.pdf --font-path fonts
```

## Configuración inicial

Edita `data.typ` y sustituye los valores de ejemplo:

- Institución, unidad y programa.
- Tipo, título y subtítulo del documento.
- Asignatura, clave y actividad.
- Nombre, matrícula y correo del estudiante.
- Nombre de la persona docente.
- Ciudad, fecha y periodo académico.

## Edición del contenido

Cada sección se encuentra en `sections/`. Conserva los nombres de archivo o actualiza las instrucciones `#include` de `main.typ`.

- `00-resumen.typ`: resumen y palabras clave.
- `01-introduccion.typ`: contexto, antecedentes, objetivo y alcance.
- `02-metodos.typ`: diseño, datos, procedimiento y análisis.
- `03-resultados.typ`: hallazgos, tablas y figuras.
- `04-discusion.typ`: interpretación, contraste, implicaciones y limitaciones.
- `05-conclusiones.typ`: conclusiones y trabajo futuro.
- `06-anexos.typ`: material complementario.

## Citas y bibliografía

Registra las fuentes en `referencias.bib`. Para citar una entrada, utiliza su clave precedida por `@`, por ejemplo, `@ejemplo-articulo`. La bibliografía se genera automáticamente con estilo APA.

Sustituye las entradas de ejemplo antes de entregar el documento.

## Imágenes institucionales

Conserva estas rutas:

- `assets/logos.png`: composición de logotipos de TecNM Virtual y la Maestría en Inteligencia Artificial.
- `assets/Cintillo_Tecnm.png`: cintillo horizontal institucional.

La portada utiliza `logos.png` en la franja superior y `Cintillo_Tecnm.png` como cierre visual inferior. La paleta del documento retoma azul marino, borgoña y dorado de los recursos proporcionados.

## Compilación

Desde la carpeta raíz del proyecto, ejecuta:

`typst compile main.typ reporte-imrad.pdf --font-path fonts`

Para recompilar automáticamente:

`typst watch main.typ reporte-imrad.pdf --font-path fonts`

En Typst Web, carga todos los archivos respetando la estructura de carpetas y abre `main.typ`.

## Recomendaciones de uso

- Redacta el resumen al finalizar el reporte.
- Mantén la correspondencia entre objetivos, métodos, resultados y discusión.
- Numera y explica todas las tablas y figuras.
- Reporta las limitaciones de manera explícita.
- No presentes interpretaciones extensas dentro de Resultados.
- Verifica todas las citas y elimina las referencias de ejemplo.
- Compila después de cada cambio estructural.