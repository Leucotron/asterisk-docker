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
docker run -it --rm leucotron/asterisk:20.9.2
```

2) Inicialização:
A imagem possui Entrypoint para execução com um usuário específico, para isso utilize a variável ASTERISK_USER

```
docker run -it --rm -e ASTERISK_USER=nome_do_usuário leucotron/asterisk:latest
```
Referência para Entrypoint: https://docs.docker.com/engine/reference/builder/#entrypoint

3) Geração de novas versões:
Para gerar uma nova imagem com nova versão de Asterisk, nesse caso do exemplo abaixo, usamos a versão 20.9.1 alterando a ENV ASTERISK_VERSION

```
docker build --progress=plain -t leucotron/asterisk:20.9.2 .
```

Para autenticar seu usuário do Docker Hub

```
docker login
```

Para enviar as modificações para o repositório:

```
docker push leucotron/asterisk:20.9.2
```

Para gerar a versão "latest", basta substituir a TAG de versão por "latest" em todos os comandos apresentados acima. Referência: https://docs.docker.com/docker-hub/repos/

Dockerfile disponível em "src" e toda documentação do Docker se encontra em https://docs.docker.com/
