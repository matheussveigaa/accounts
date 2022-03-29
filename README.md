<div id="top"></div>
<!-- PROJECT LOGO -->
<br />
<div align="center">
<h3 align="center">Code Challenge: Accounts API</h3>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Projeto destinado a criação de uma conta, transferencias, depositos e saques.

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [Elixir](https://elixir-lang.org/)

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Abaixo temos os pré-requisitos para executar a solução e suas dependências.

### Prerequisites

* Docker 2.3 ou versão mais recente.

### Installation
Na raiz do projeto:
1. Docker image buid
   ```sh
   docker image build -t accounts-api -f Dockerfile.dev . 
   ```
2. OU Docker compose up
   ```sh
   docker-compose up --build -d
   ```

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- USAGE EXAMPLES -->
## Usage
### Executando a aplicação:
Após efetuar o build deve ser executado o container de forma interativa para que os inputs sejam processados.
   ```sh
   mix phx.server ou executando via docker compose.
   ```
### Executando os testes unitários:
Entrando no container:
   ```sh
   docker run --rm -it  accounts-api:latest
   ```
Dentro do container basta rodar o comando abaixo para executar os testes unitários:
   ```sh
   mix test --trace --color
   ```
   Percentual de cobertura:
  ```sh
   mix coveralls
   ```
<p align="right">(<a href="#top">back to top</a>)</p>

## Software Design
Foi utilizado uma arquitetura bem semelhante a arquitetura hexagonal junto com DDD para separação das entidades e contextos delimitados.

### Application 
Camada responsável por interagir com o dominio e outros serviços que não tem a ver com o dominio. (Ex: publicação de mensagens, cache e etc.). Também é a camada anticorrupção do nosso dominio.

### Domain
Camada responsável pelo dominio do negócio com os casos de uso onde regras de negócio são aplicadas. Foi utilizado behaviors para não termos acoplamento a nenhum tipo de dependencia externa.

### Infrastructure
Camada responsável pela infra em si, temos as implementações de repositórios e qualquer outra coisa que não deve ser dependencia da nossa aplicação. Também serve como camada anticorrupção entre dominio e qualquer outro serviço externo.
