# exemplo código | introdução ao pyspark

from fastapi import FastAPI
from pyspark.sql import SparkSession
from pydantic import BaseModel
from typing import List

app = FastAPI()

# Configuração do Spark
spark = SparkSession.builder \
    .appName("FastAPI with Spark") \
    .getOrCreate()

# Dados de exemplo
data = [("Java", 20000), ("Python", 100000), ("Scala", 3000)]

# Criar um DataFrame
columns = ["Language", "Users"]
df = spark.createDataFrame(data, schema=columns)

class ProgrammingLanguage(BaseModel):
    Language: str
    Users: int

@app.get("/languages/", response_model=List[ProgrammingLanguage])
def read_languages():
    """
    Retorna uma lista de linguagens de programação com o número de usuários.
    """
    # Converter DataFrame Spark para lista de dicionários Python
    result = df.collect()
    return [{"Language": row["Language"], "Users": row["Users"]} for row in result]

@app.get("/languages/{language_name}", response_model=ProgrammingLanguage)
def read_language(language_name: str):
    """
    Retorna a linguagem de programação pelo nome.
    """
    # Filtrar DataFrame pelo nome da linguagem
    result = df.filter(df["Language"] == language_name).collect()
    if result:
        return {"Language": result[0]["Language"], "Users": result[0]["Users"]}
    return {"Language": "Not Found", "Users": 0}  # Retorna um valor padrão se a linguagem não for encontrada

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
