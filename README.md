# asterisk-docker
Repositório da imagem do Asterisk para Docker

Descrição
-----------

Essa imagem foi criada para utilização da imagem do Asterisk nos projetos utilizando Docker

**Necessário Docker instalado na máquina**
Referência para instalação: https://docs.docker.com/install/

**Como usar:**

1) Utilizar o comando run para seu funcionamento:

```
docker run -it --rm leucotron/asterisk:latest
```

**Dicas:**

1) Versionamento:
Verificar as versões disponíveis no DockerHub para especificar a versão através do nome da imagem:

```
docker run -it --rm leucotron/asterisk:16.4.0
```

2) Inicialização:
A imagem possui Entrypoint para execução com um usuário específico, para isso utilize a variável ASTERISK_USER

```
docker run -it --rm -e ASTERISK_USER=nome_do_usuário leucotron/asterisk:latest
```
Referência para Entrypoint: https://docs.docker.com/engine/reference/builder/#entrypoint

Dockerfile disponível em "src" e toda documentação do Docker se encontra em https://docs.docker.com/