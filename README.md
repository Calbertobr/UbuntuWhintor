Este projeto tem como principio ajudara quem queira instalar o Winthor da TOVUS no Ubuntu.

Es processo e dividido em duas partes:
  Um script que faz as perguntas sobre a empresa para configuraçã.
  Um pacode criado para a plataforma de pacotes originarios do debian.

Estrutura:

Deve ser montado uma maquina facilitadora do processo com ubuntu 20 ou superior:
  Não presisa ambiente grafico.
  Precisa ter o Apache instalado para publicar os arquivos nescessarios.




---------------------------------------------------------------------------------------------
Chaves SSH:
  Servidor:
    - Deve ser criada chave ssh no usuario root para conexão com o servidor de compartilhamento de arquivos.
    - Pois esta chave sera utilizadas sempre que for feita alguma alteração particular no processo.
    - Na maquina de manutenção do processo deve se criar a chave ssh e colocar a chave publica na maqauina responsavel pela serviço web.
  Clientes
    - Na maquina que tem o serviço Apache deve ser criada chave ssh para esta se tornar a maquina de atualização do parque.
    - Esta chave permite que esta tenha acesso a todo o parque e com isso possa efetuar atualizações sem depender do colaborador que a utiliza.

Arquivo:
  - GeraCompactados.sh
  - Local: Linux64Usuarios
    Ação:
      Deve ser alterada a variavel "IP_SITE" com endereço do Servidor web que disponibiliza os arquivos para instalação.

  - authorized_keys
  - Local: Linux64Usuarios/winthor-user/var/
    Ação:
      Incluir neste arquivo a chave criada no servidor web para incluir como liberados nas estações dos colaboradores.

  - Install.sh
  - Local: Linux64Usuarios/winthor-user/home/user/
    Ação:
      Alterar a letra do drive de acordo com a instalação do Winthor.

  - tnsnames.ora
  - Local: Linux64Usuarios/winthor-user/home/user/.wine/drive_?/InstantClient/
    Ação:
      Alterar os campos
        IP_SERVER = Ip do servidor do banco oracle
        PORT_SERVER = Porta de conexão do banco oracle
        SERVICE_NAME_SERVER = Service name do banco.

  - Diretorio drive_?
  - Local: Linux64Usuarios/winthor-user/home/user/.wine/dosdevices/
    Ação:
      Criar o alias referente o drive criado apontando para a o diretorio nomeado drive_?.

  - Launcher Aplicação
  - Local: Linux64Usuarios/winthor-user/home/user/.local/share/applications
    Arquivos:  Arquivos Winthor.desktop
    Ação:
      Alterar nestes arquivos os endereços do mapeamento colocados em ? para letra de mapeamento.

  - Launcher Aplicação
  - Local: Linux64Usuarios/winthor-user/home/user/.local/share/applications
    Arquivos:  Arquivos WinthorRemoto.desktop, WinthorRemotoLocal.desktop
    Ação: Alterar nestes arquivos 
      DOMINIO = Dominio do terminal server
      PASSWORD = Senha do usuario do terminal server.
      URL_TERMINAL_EXT = Endereço, url de conexão server. 
  


  

  
