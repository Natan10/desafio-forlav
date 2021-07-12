# Desafio Forlav

Essa é uma breve documentação sobre os componentes presentes na solução e sobre como rodar o projeto.

Componentes:

* Rails Application Web
* Rails API
* Postgres
* Docker e Docker-compose
* Testes com RSpec
* Github actions

## Como usar

Primeiramente instale o [docker](https://docs.docker.com/engine/install/ubuntu/) e o [docker-compose](https://docs.docker.com/compose/install/) na sua máquina.  

Após isso execute dentro da pasta do projeto:

~~~cmd
  docker-compose up --build
~~~

Esse comando irá baixar as imagens e as dependências necessárias para rodar o projeto. Após isso rode o comando
abaixo para que as migrations e o banco sejam criados:

~~~cmd
  docker-compose exec app rails db:setup
~~~

## Rails Application Web

Aplicação web com autenticação via devise permite ao usuário criar um manager para gerenciar os usuários, sendo possível criar um usuário, deletar, editar e realizar transações como entradas ou saídas simulando uma carteira digital.

## Rails API

Para a api temos 3 rotas:

1. /api/movements/:user_id/balance
2. /api/movements/:user_id/entries
3. /api/movements/transaction

A primeira rota retorna o balance atual que representa o saldo do usuário.Passamos a consulta dessa forma:

```ruby
curl -X GET http://localhost:3000/api/movements/10/balance
```

Para a segunda rota, temos as entradas e saidas retornas em um período de tempo desejado. Para essa consulta fazemos dessa forma:

```ruby
  curl -X GET http://localhost:3000/api/movements/10/entries \
  -d "start_date=2021-07-10" \
  -d "end_date=2021-07-13"
```

A terceira rota já representa a criação de uma transação. Dessa forma:

Passamos no corpo:

~~~json
  {
    "movement":{
      "wallet_id": "2",
      "status" : "credit" or "debit",
      "value": "5.0"
    }
  }
~~~

E o request fazemos assim:

```ruby
  curl -X POST -H "Content-Type: application/json" \
  -d '{"movement": {"wallet_id": "10","status":"credit","value":"5.0"}}' \
  http://localhost:3000/api/movements/transaction
```

## Postgres

O banco utilizado foi o postgres em conjunto com docker.

## Docker e Dockerfile

Foi utilizado o docker para definição da imagem da aplicação rails e o docker-compose foi utilizado para integração do postgres com a aplicação web. Isso facilita a implantação da aplicação, bem como os testes.

## Testes Com RSpec

Os testes foram feitos utilizando o RSpec e foram testadas
as principais features da aplicação como transaction_controller e o movements_controller e os models. Para auxiliar nos testes foi utilizada a gem "factory-boot-rails" que  nós ajuda a criar factories dos nossos objetos de maneira simples.

## Github Actions

Tomei a liberdade de implementar um pipeline com o github actions, caso fosse preciso uma integração contínua. Nas actions está apenas o estágio de testes, mas também seria possivel adicionar mais estágios afim de garantir um deploy. O pipeline e rodado toda vez que um push e feito, mas também é possivel configurar para uma branch específica ou para um evento específico.
