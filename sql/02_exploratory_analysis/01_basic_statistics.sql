/*
=========================================================
Proyecto: Home Credit Default Risk
Autor: Yussef Nesme Oceguera
Descripción: Consultas básicas de exploración del dataset utilizando
PostgreSQL como parte del análisis de riesgo crediticio.

Objetivo:
Comprender la distribución de los clientes antes de
construir un modelo de Machine Learning.
=========================================================
*/


-- =====================================================
-- 1. Total de clientes
-- =====================================================

SELECT COUNT(*) AS total_clientes
FROM public.application_train;

/*
Interpretación:

El dataset contiene aproximadamente 307 mil clientes.

Esta consulta permite conocer el tamaño de la población
utilizada para entrenar el modelo de riesgo crediticio.
*/


---------------------------------------------------------


-- =====================================================
-- 2. Distribución del TARGET
-- =====================================================

SELECT
    "TARGET",
    COUNT(*) AS clientes
FROM public.application_train
GROUP BY "TARGET";

/*
Interpretación:

TARGET = 0 representa a los clientes que pagaron correctamente.

TARGET = 1 representa a los clientes que incumplieron el préstamo.

Esta consulta permite conocer la distribución de ambas clases,
información muy importante para detectar si el dataset está
desbalanceado antes de entrenar un modelo.
*/


---------------------------------------------------------


-- =====================================================
-- 3. Porcentaje de incumplimiento
-- =====================================================

SELECT
    COUNT(*) AS clientes_totales,
    SUM("TARGET") AS clientes_incumplidos,
    ROUND(
        SUM("TARGET") * 100.0 / COUNT(*),
        2
    ) AS porcentaje_incumplimiento
FROM public.application_train;

/*
Interpretación:

Aproximadamente el 8% de los clientes incumplieron el préstamo.

Esto indica que el problema presenta desbalance entre clases,
por lo que métricas como Accuracy no serán suficientes para
evaluar futuros modelos de Machine Learning.

Será necesario prestar especial atención a métricas como
Precision, Recall, F1-Score y ROC-AUC.
*/


---------------------------------------------------------


-- =====================================================
-- 4. Incumplimiento por género
-- =====================================================

SELECT
    "CODE_GENDER",
    COUNT(*) AS clientes_totales,
    SUM("TARGET") AS clientes_incumplidos,
    ROUND(
        SUM("TARGET") * 100.0 / COUNT(*),
        2
    ) AS porcentaje_incumplimiento
FROM public.application_train
GROUP BY "CODE_GENDER";

/*
Interpretación:

Las mujeres representan la mayor parte de los clientes del dataset.

Sin embargo, los hombres presentan un porcentaje de incumplimiento
superior.

Este resultado no implica causalidad. Es necesario analizar
otras variables como ingresos, empleo, educación y monto del
crédito antes de concluir que el género influye en el riesgo.
*/


---------------------------------------------------------


-- =====================================================
-- 5. Clasificación de ingresos utilizando CASE
-- =====================================================

SELECT
    "AMT_INCOME_TOTAL" AS ingreso,
    CASE
        WHEN "AMT_INCOME_TOTAL" >
        (
            SELECT AVG("AMT_INCOME_TOTAL")
            FROM public.application_train
        )
        THEN 'alto'
        ELSE 'bajo'
    END AS categoria_ingreso
FROM public.application_train;

/*
Interpretación:

Cada cliente es clasificado según si su ingreso es mayor o menor
al ingreso promedio del dataset.

Esta consulta introduce el uso de CASE y subconsultas,
herramientas fundamentales para realizar segmentaciones de
clientes en SQL.

Más adelante utilizaremos esta clasificación para comparar
las tasas de incumplimiento entre clientes de ingresos altos
e ingresos bajos.
*/