import pandas as pd

file_path = "data/application_train.csv"

df = pd.read_csv(file_path, nrows=100)

type_mapping = {
    "int64": "BIGINT",
    "float64": "DOUBLE PRECISION",
    "object": "TEXT"
}

columns = []

for col, dtype in df.dtypes.items():
    sql_type = type_mapping.get(str(dtype), "TEXT")
    columns.append(f'    "{col}" {sql_type}')


columns_sql = ",\n".join(columns)

create_table = f"""CREATE TABLE application_train (
{columns_sql}
);
"""

with open("sql/01_create_application_train.sql", "w", encoding="utf-8") as f:
    f.write(create_table)

print("✅ Archivo SQL generado correctamente.")