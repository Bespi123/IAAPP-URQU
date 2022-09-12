# IAAPP-URQU
El presente informe forma parte del proyecto “Geodesia Espacial para el monitoreo
de Volcanes y Cerros Circundantes de Arequipa para Determinar Deformaci ́on y Riesgos”
que se encuentra financiado por la Universidad Nacional de San Agust ́ın bajo contrato
IBA-0049-2016.
Hist ́oricamente Arequipa, que se encuentra dentro del “cintur ́on de Fuego”, tiene con-
diciones s ́ısmico-tect ́onicas especiales y la presencia del Volc ́an Misti a ̃nade condiciones
s ́ısmico vulcanol ́ogicas. El presente proyecto tiene como objetivo implementar una red de
monitoreo que permita analizar las deformaciones antes, durante y despu ́es de los eventos
s ́ısmicos y vulcanol ́ogicos aplicando t ́ecnicas de Geodesia espacial permitiendo alertar posi-
bles riesgos. Dentro de las t ́ecnicas empleadas para la Geodesia espacial, se tienen la t ́ecni-
ca de GNSS (Global Navigation Satellite System), SLR (Satellite Laser Ranging), VLBI
(Very Long Baseline Interferometry) y DORIS (Doppler Orbitography and Radiopositio-
ning Integrated by Satellite) que permiten realizar mediciones con precisi ́on centim ́etrica
o milim ́etrica tanto en planimetr ́ıa como en altimetr ́ıa. Respecto a mediciones en tierra
se tiene la t ́ecnica de EDM (Electronic Distance Meter ) con una precisi ́on de 0.5–1.0 mm
para distancias entre 1 a 12 km las cuales fueron utilizadas para calcular la deformaci ́on
del Long Valley Caldera al este de Yosemite el a ̃no 2005 en Estados Unidos. [1].
En el presente informe se utiliz ́o la t ́ecnica GNSS para el monitoreo del volc ́an Misti
durante el a ̃no 2021. Dicha t ́ecnica se basa en constelaciones satelitales que utilizan el
algoritmo de triangulaci ́on para determinar la posici ́on y velocidad de un determinado
punto. Entre las constelaciones m ́as famosas tenemos: GPS, GLONASS, BEIDU, GALI-
LEO, etc. En [2] se presentan los fundamentos matem ́aticos empleados por esta t ́ecnica
para obtener las “pseudo-observaciones” necesarias para determinar la posici ́on de un
punto en tres dimensiones. Por otro lado, en [3] se presenta a GAMIT/GLOBK como un
software desarrollado por el MIT que permite estimar las posiciones relativas tridimen-
sionales de estaciones GNSS terrestres,  ́orbitas satelitales, retrasos cenitales atmosf ́ericos
y par ́ametros de orientaci ́on de la Tierra. En [4] se explica que GAMIT es capaz de
reducir el error de las mediciones empleando diversos modelos de correcci ́on ionosf ́ericos,
atmosf ́ericos, meteorol ́ogicos y oce ́anicos con lo que este software permite obtener medicio-
nes diarias (sesiones de 24 horas) con errores milim ́etricos (< 9mm). Actualmente GAMIT
es ampliamente utilizado por instituciones geod ́esicas Internacionales como el “Internatio-
nal GNSS Service” (IGS ) y el “Sistema de Referencia Geoc ́entrico para Las Am ́ericas”
(SIRGAS ) e instituciones nacionales como el “Instituto Geogr ́afico Nacional” (IGN ) y el
1

