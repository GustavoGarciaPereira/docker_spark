# docker_spark
#### Descrição

Este repositório contém os arquivos necessários para configurar um ambiente Docker com Apache Spark, permitindo a execução de scripts Python que utilizam o Spark para processamento de dados. O ambiente é construído sobre uma imagem Docker baseada em Python 3.8 e Debian Bullseye, com instalações de Java e Apache Spark.

#### Estrutura do Repositório

-   `Dockerfile`: Define a imagem Docker para a aplicação, configurando todas as dependências necessárias.
-   `comandos`: Lista de comandos úteis para construir e executar o container Docker.
-   `start-spark.sh`: Script para iniciar os serviços do Spark dentro do container.
-   `your_script.py`: Script Python de exemplo que utiliza o Spark para criar e mostrar um DataFrame.

#### Pré-requisitos

-   Docker
-   Python 3.8
-   Acesso à internet para download das dependências

#### Configuração e Uso

1.  **Construção do Container**:
    

    
    ```bash
    docker build -t spark-local .
    ```
    
    Este comando constrói a imagem Docker utilizando o `Dockerfile` no diretório atual e a nomeia como `spark-local`.
    
2.  **Execução do Container**:
    ```bash
    docker run -it --rm -p 8080:8080 -p 4040:4040 spark-local
    ```
    
    Este comando executa o container, mapeando as portas necessárias e removendo o container ao terminar a execução.
    
3.  **Iniciar o Spark**: Dentro do container, execute o script para iniciar o Spark:
    

    
    ```bash
    /app/start-spark.sh
    ```
    
    Isso inicializa o mestre e o trabalhador do Spark.
    
4.  **Executar o Script Python**: Após o Spark estar ativo, você pode executar o `your_script.py` para processar seus dados:
    

    
    ```bash
    python your_script.py`
    ```