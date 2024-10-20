# Configuração de Instância EC2 com Nginx usando Terraform

Este documento descreve o processo para criar uma instância EC2 na AWS utilizando Terraform e configurar o servidor Nginx para servir páginas web.

## Pré-requisitos

1. **Conta AWS**: Certifique-se de que você tem uma conta na AWS.
2. **Chave SSH**: Tenha a chave SSH (`VExpenses-Rafael-key-v4.pem`) pronta para acessar a instância.
3. **Terraform**: Instale o Terraform na sua máquina. [Link para download](https://www.terraform.io/downloads).

## Passos para Configuração

- VPC: Uma Virtual Private Cloud (VPC) é criada com o CIDR block `10.0.0.0/16`.
- Subnetwork: Uma subnet é configurada dentro da VPC, utilizando o CIDR block `10.0.1.0/24` e alocada na zona de disponibilidade `us-east-1a`.
- Internet Gateway: Um Internet Gateway é criado e associado à VPC, permitindo que a instância EC2 tenha acesso à internet.
- Route Table: A Route Table é configurada para rotear o tráfego da subnet através do Internet Gateway.
- Security Group: Um Security Group é criado com as seguintes permissões:
  - Permitir tráfego SSH (porta 22) de qualquer origem.
  - Permitir tráfego HTTP (porta 80) de qualquer origem.
- Key Pair: Um par de chaves SSH (`VExpenses-Rafael-key-v4`) é associado à instância EC2 para permitir acesso seguro.
- Instância EC2: Uma instância EC2 é configurada utilizando a AMI `ami-06b21ccaeff8cd686` Exemplo de AMI, substitua conforme necessário (Amazon Linux 2), que será automaticamente iniciada ao final do provisionamento.

### 1. Arquivo Terraform (main.tf)

### 2. Inicializar e Aplicar o Terraform
Para provisionar a infraestrutura, siga os passos abaixo no terminal:

## 1. Inicialize o Terraform:
    ```bash
    terraform init
    
## 2. Aplique o Terraform para criar a instância EC2:
    ```bash
    terraform apply
Quando solicitado, digite yes para confirmar a criação da infraestrutura.

### 3. Conecte-se à Instância EC2
Após a criação da instância EC2, você receberá o endereço IP público. Use o seguinte comando para conectar-se via SSH à instância:

    ```bash
    ssh -i "VExpenses-Rafael-key-v4.pem" ec2-user@<ec2_public_ip>
    
Exemplo de comando:

    ```bash
    ssh -i "VExpenses-Rafael-key-v4.pem" ec2-user@ec2-3-90-242-17.compute-1.amazonaws.com
    
### 4. Verifique o Nginx no Navegador
Depois de conectar-se e garantir que o Nginx foi iniciado, acesse o endereço IP público da sua instância no navegador:

    ```bash
    http://<ec2_public_ip>
    
Se o Nginx foi instalado corretamente, você verá a página de boas-vindas do Nginx.

### 5. Comandos Úteis

## - Iniciar o Nginx (se necessário):

    ```bash
    sudo systemctl start nginx
    
## - Habilitar o Nginx para iniciar automaticamente:

    ```bash
    sudo systemctl enable nginx
    
## - Verificar o status do Nginx:

    ```bash
    sudo systemctl status nginx
    
## - Ver logs do Nginx:

    ```bash
    sudo tail -f /var/log/nginx/access.log /var/log/nginx/error.log
    
### 6. Ajuste de Permissões SSH no Windows
Certifique-se de ajustar as permissões do arquivo .pem no Windows utilizando Git Bash ou WSL, pois o SSH exige permissões restritas no arquivo de chave privada.]


       ```bash
       chmod 400 VExpenses-Rafael-key-v4.pem

##

### Descrição Técnica - Tarefa 1: Análise Técnica do Código Terraform
O arquivo main.tf providencia a configuração básica para criar e configurar uma instância EC2 na AWS, juntamente com uma VPC, sub-rede, gateway de internet e grupo de segurança. Vamos analisar cada recurso em detalhes:

### 1. VPC (aws_vpc)
- Criação de uma VPC (Virtual Private Cloud) com o CIDR 10.0.0.0/16, que significa que a rede pode conter até 65.536 endereços IP privados.
- DNS e nomes DNS estão habilitados para que as instâncias possam resolver nomes internamente.
### 2. Sub-rede (aws_subnet)
- A sub-rede está associada à VPC criada e contém um bloco de endereços IP específico, 10.0.1.0/24, que permite 256 endereços IP privados.
- Localizada na zona de disponibilidade us-east-1a.
### 3. Internet Gateway (aws_internet_gateway)
- Criação de um gateway de internet que conecta a VPC à internet, permitindo que as instâncias EC2 tenham acesso à rede externa.
### 4. Tabela de Roteamento (aws_route_table e aws_route_table_association)
- Criação de uma tabela de roteamento que direciona todo o tráfego (0.0.0.0/0) para o gateway de internet.
- Associação da tabela de roteamento com a sub-rede.
### 5. Grupo de Segurança (aws_security_group)
- Configuração de regras de segurança que permitem:
- Conexão via SSH (porta 22) de qualquer IP (0.0.0.0/0).
- Conexão HTTP (porta 80) de qualquer IP (0.0.0.0/0).
- Regras de saída permitem todo o tráfego (egress) de qualquer IP (0.0.0.0/0).
### 6. Chave SSH (tls_private_key e aws_key_pair)
- Geração de uma chave privada RSA para acessar a instância EC2 via SSH.
- Registro da chave pública no EC2 usando o recurso aws_key_pair.
### 7. Instância EC2 (aws_instance)
- Criação de uma instância EC2 do tipo t2.micro com a AMI Debian (ami-06b21ccaeff8cd686).
- Associação da instância à sub-rede e ao grupo de segurança.
- Execução de um script de inicialização (user_data) que instala e inicia o servidor Nginx automaticamente.
### 8. Outputs
- Exibe o IP público da instância EC2.
- Exibe a chave privada gerada pelo Terraform (sensível).
### Observações
- Segurança: O grupo de segurança permite conexões de qualquer IP, o que pode representar um risco de segurança. Uma abordagem mais segura seria restringir o acesso SSH a um IP ou faixa de IPs específicos.
- Automação: A configuração já inclui automação da instalação do Nginx, o que facilita o provisionamento do ambiente.

##
  
### Modificação e Melhoria do Código Terraform - Tarefa 2
Nesta seção, foram feitas melhorias de segurança e outras mudanças para tornar o ambiente mais robusto e seguro.

### Melhorias de Segurança Implementadas
1. Restringir o Acesso SSH a um IP Específico
- O acesso SSH foi restringido a um endereço IP específico (ou a um intervalo de IPs) para aumentar a segurança.
- Substitua 0.0.0.0/0 pelo IP específico no bloco ingress da regra SSH no grupo de segurança.
  
      ```hcl
      ingress {
      description = "Permitir SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["123.45.67.89/32"]  # Alterar para seu IP público
      }
  
2. Uso de AMIs Customizadas (Opcional)
- Para aumentar a segurança, poderia-se considerar o uso de AMIs customizadas com configurações de segurança adicionais ou com pacotes atualizados.
  
3. Desabilitar o Acesso Root via SSH (Opcional)
- Modificações podem ser feitas no user_data para desabilitar o acesso root via SSH e aplicar outras políticas de hardening.

Exemplo de desabilitar o root SSH:

    ```bash
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    systemctl reload sshd
    
### Automação da Instalação do Nginx
O user_data já contém a automação necessária para instalar e configurar o Nginx durante o processo de inicialização da instância EC2. O código executa os seguintes comandos:

    ```bash
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
Essa automação garante que o Nginx seja instalado e executado logo após a instância ser provisionada.

### Outras Melhorias

1. Tags em Todos os Recursos
-Adicionei tags para todos os recursos no código para facilitar a identificação no console AWS.
Definir o associate_public_ip_address como true

2. Isso garante que a instância tenha um IP público automaticamente atribuído, permitindo o acesso à web e via SSH.
   ##
### Arquivo main.tf Modificado
    ```hcl
    provider "aws" {
    region = "us-east-1"
    }

    # Criação da VPC
    resource "aws_vpc" "main_vpc" {
      cidr_block           = "10.0.0.0/16"
      enable_dns_support   = true
      enable_dns_hostnames = true

      tags = {
        Name = "VExpenses-VPC"
      }
    }

    # Sub-rede
    resource "aws_subnet" "main_subnet" {
      vpc_id            = aws_vpc.main_vpc.id
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"

      tags = {
        Name = "VExpenses-Subnet"
      }
    }

    # Internet Gateway
    resource "aws_internet_gateway" "main_igw" {
      vpc_id = aws_vpc.main_vpc.id

      tags = {
        Name = "VExpenses-IGW"
      }
    }

    # Tabela de Roteamento
    resource "aws_route_table" "main_route_table" {
      vpc_id = aws_vpc.main_vpc.id

      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_igw.id
      }

      tags = {
        Name = "VExpenses-RouteTable"
      }
    }

    # Associação da tabela de rotas
    resource "aws_route_table_association" "main_association" {
      subnet_id      = aws_subnet.main_subnet.id
      route_table_id = aws_route_table.main_route_table.id
    }

    # Grupo de Segurança
    resource "aws_security_group" "main_sg" {
      name        = "VExpenses-SG"
      description = "Permitir SSH e HTTP"
      vpc_id      = aws_vpc.main_vpc.id

      ingress {
        description = "Permitir SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["123.45.67.89/32"]  # Alterar para seu IP público
      }

      ingress {
        description = "Permitir HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }

      tags = {
        Name = "VExpenses-SG"
      }
    }

    # Gerar uma chave SSH
    resource "tls_private_key" "ec2_key" {
      algorithm = "RSA"
      rsa_bits  = 2048
    }

    # Par de Chaves EC2
    resource "aws_key_pair" "ec2_key_pair" {
      key_name   = "VExpenses-Key"
      public_key = tls_private_key.ec2_key.public_key_openssh
    }

    # Instância EC2
    resource "aws_instance" "debian_ec2" {
      ami                         = "ami-06b21ccaeff8cd686"
      instance_type               = "t2.micro"
      subnet_id                   = aws_subnet.main_subnet.id
      vpc_security_group_ids       = [aws_security_group.main_sg.id]
      key_name                    = aws_key_pair.ec2_key_pair.key_name
      associate_public_ip_address  = true

      user_data = <<-EOF
                  #!/bin/bash
                  sudo apt-get update -y
                  sudo apt-get install nginx -y
                  sudo systemctl start nginx
                  sudo systemctl enable nginx
                  EOF

      tags = {
        Name = "VExpenses-EC2"
      }
    }

    # Output do IP Público da Instância EC2
     output "ec2_public_ip" {
      description = "Endereço IP público da instância EC2"
      value       = aws_instance.debian_ec2.public_ip
    }

    # Output da chave privada gerada
    output "private_key" {
      description = "Chave privada gerada para acesso SSH"
      value       = tls_private_key.ec2_key.private_key_pem
      sensitive   = true
    }


### Conclusão
Este guia explica como provisionar uma instância EC2 na AWS utilizando Terraform e instalar o Nginx automaticamente. Ao final, você poderá acessar sua página Nginx diretamente via IP público.

### Arquivos Incluídos
- main.tf: Arquivo principal contendo o código Terraform para a criação da infraestrutura.
- README.md: Este arquivo, com a documentação completa do projeto e instruções de uso.
### Considerações Finais
Esta implementação segue as melhores práticas para provisionamento de infraestrutura automatizada, utilizando Terraform. Além disso, são garantidos os aspectos de segurança e eficiência, como solicitado no desafio.

![image](https://github.com/user-attachments/assets/e48d38dd-0a12-46a9-b8ce-d543bd104f3d)

