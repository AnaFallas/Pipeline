# Pipeline
Diseño de procesador RISCV implementando pipeline]

##Para porbar los modulos

En este repositorio se cuenta con cuatro carpetas diferentes las cuales se describen a continuación:

###Carpeta de Modulos Reutilizados 
En esta carpeta se encontraran los módulos pertenecientes al procesador uniciclo, el cual cuenta con los testbench de cada uno de los módulos, los cuales se implementaron en el diseño del procesador del pipeline. 

###Carpeta de Registos del Pipeline
En esta carpeta se encuentran los registros intermedios del pipeline cada uno con su testbench.

###Carpeta de Unidades de Riesgos
En esta carpeta se encuentra la lógica de los módulos del Forwarding unit y el Hazard detection, cada uno con su testbench independiente.

###Carpeta de Pipeline Procesador
En esta carpeta se encuentra el top del proyecto junto con su testbench; en esta carpeta se incluyen los módulos de las carpetas anteriores pero en este caso sin sus testbenchs ya que estos se encuentran por separado en cada carpeta.

