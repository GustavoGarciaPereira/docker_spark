from fastapi import FastAPI
from pyspark.sql import SparkSession
from pydantic import BaseModel
from typing import List
import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import plotly.express as px
import pandas as pd
import certifi
import os

os.environ['REQUESTS_CA_BUNDLE'] = certifi.where()
app = FastAPI()

# Configuração do Spark
spark = SparkSession.builder \
    .appName("FastAPI and Dash with Spark") \
    .getOrCreate()

# Dados de exemplo
data = [("Java", 20000), ("Python", 100000), ("Scala", 3000)]
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
    result = df.collect()
    return [{"Language": row["Language"], "Users": row["Users"]} for row in result]

@app.get("/languages/{language_name}", response_model=ProgrammingLanguage)
def read_language(language_name: str):
    """
    Retorna a linguagem de programação pelo nome.
    """
    result = df.filter(df["Language"] == language_name).collect()
    if result:
        return {"Language": result[0]["Language"], "Users": result[0]["Users"]}
    return {"Language": "Not Found", "Users": 0}

# Dash app
dash_app = dash.Dash(
    __name__,
    server=app,  # Use existing FastAPI server
    routes_pathname_prefix='/dash/'  # Set URL prefix for Dash
)

# Convert Spark DataFrame to Pandas for Dash visualization
pandas_df = df.toPandas()

# Setup the layout of the Dash app
dash_app.layout = html.Div([
    dcc.Graph(id='language-graph'),
    dcc.Interval(
            id='interval-component',
            interval=1*1000,  # in milliseconds
            n_intervals=0
        )
])

@dash_app.callback(
    Output('language-graph', 'figure'),
    [Input('interval-component', 'n_intervals')]
)
def update_graph(n):
    fig = px.bar(pandas_df, x='Language', y='Users', title="User Count by Programming Language")
    return fig

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
