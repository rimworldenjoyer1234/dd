Te he dejado el autotuner en C y un script de compilación:

[jent_autotune.c](sandbox:/mnt/data/jent_autotune.c)
[build_jent_autotune.sh](sandbox:/mnt/data/build_jent_autotune.sh)
[jent_autotune (binario compilado)](sandbox:/mnt/data/jent_autotune)

Qué hace este programa:

* busca parámetros con **beam search discreto**
* reutiliza **un workspace por worker**, limpiándolo entre evaluaciones
* mantiene **caché de configuraciones ya evaluadas**
* lanza evaluaciones en **paralelo con pthreads**
* usa tu pipeline real:

  * `jitterentropy-hashtime`
  * `validation-restart/processdata.sh`
  * `validation-runtime/processdata.sh`
* optimiza sobre:

  * `osr`
  * `max_mem`
  * `memory_access`
  * `all_caches`

He dejado `hloopcnt` fuera de la búsqueda porque en tu entorno actual el binario local lo está rechazando. Cuando eso quede arreglado, se puede añadir como un eje más sin cambiar la estructura del autotuner.

Para compilar:

```bash
gcc -O2 -Wall -Wextra -pedantic -pthread /mnt/data/jent_autotune.c -lm -o /mnt/data/jent_autotune
```

O directamente:

```bash
bash /mnt/data/build_jent_autotune.sh
```

Para ejecutar:

```bash
/mnt/data/jent_autotune
```

Si quieres ajustar paralelismo o búsqueda:

```bash
MAX_PARALLEL=4 BEAM_WIDTH=4 MAX_ROUNDS=8 PATIENCE=2 FINAL_REPEATS=3 /mnt/data/jent_autotune
```

Si tu árbol está en otra ruta:

```bash
JENT_ROOT=/home/yo/jitterentropy-library /mnt/data/jent_autotune
```

Resultados esperados:

* `~/jitter-campaigns/autotune-.../results/all_results.csv`
* `~/jitter-campaigns/autotune-.../results/finalists.csv`
* `~/jitter-campaigns/autotune-.../results/summary.txt`

Importante: el binario **sí compila**, pero no he ejecutado la búsqueda completa aquí porque depende de tu instalación local de `jitterentropy-library` y de las herramientas NIST en tu máquina.

Si quieres, el siguiente paso útil es una versión 2 donde:

* se añada `hloopcnt` al espacio de búsqueda,
* se permita fijar umbrales mínimos de `H_r` y `H_c`,
* y se guarde automáticamente el mejor perfil en un `.json` o `.ini` para cargarlo luego desde tus aplicaciones.
