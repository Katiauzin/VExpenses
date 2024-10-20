# Desafio DevOps - VExpenses

Este repositório contém a solução para o desafio de estágio em DevOps da VExpenses. A seguir, estão descritos os detalhes técnicos do código Terraform, as modificações feitas, e as instruções para sua execução.

## Descrição Técnica

O arquivo `main.tf` foi criado para configurar a seguinte infraestrutura na AWS utilizando Terraform:

- **VPC**: Uma Virtual Private Cloud (VPC) é criada com o CIDR block `10.0.0.0/16`.
- **Subnetwork**: Uma subnet é configurada dentro da VPC, utilizando o CIDR block `10.0.1.0/24` e alocada na zona de disponibilidade `us-east-1a`.
- **Internet Gateway**: Um Internet Gateway é criado e associado à VPC, permitindo que a instância EC2 tenha acesso à internet.
- **Route Table**: A Route Table é configurada para rotear o tráfego da subnet através do Internet Gateway.
- **Security Group**: Um Security Group é criado com as seguintes permissões:
  - Permitir tráfego SSH (porta 22) de qualquer origem.
  - Permitir tráfego HTTP (porta 80) de qualquer origem.
- **Key Pair**: Um par de chaves SSH (`VExpenses-Rafael-key-v4`) é associado à instância EC2 para permitir acesso seguro.
- **Instância EC2**: Uma instância EC2 é configurada utilizando a AMI `ami-06b21ccaeff8cd686` Exemplo de AMI, substitua conforme necessário (Amazon Linux 2), que será automaticamente iniciada ao final do provisionamento.

### Observações Técnicas

- O código é estruturado para ser reutilizável com variáveis de projeto e nome do candidato.
- O grupo de segurança foi configurado com permissões para SSH e HTTP para garantir acesso e funcionamento do Nginx.
- A chave privada não está sendo gerada pelo Terraform, mas sim reutilizada uma chave existente no sistema.

## Modificações e Melhorias

### Medidas de Segurança

- **Uso de Security Groups**: Foi configurado um Security Group que limita as portas abertas apenas para o tráfego essencial (SSH e HTTP).
- **Chave SSH Segura**: A chave SSH utilizada foi previamente configurada e é reutilizada para garantir que o acesso à instância seja seguro e controlado.

### Automação de Instalação do Nginx

- Foi implementado o uso de `user_data` no bloco da instância EC2 para automatizar a instalação e inicialização do servidor web Nginx. O script faz:
  - Atualização dos pacotes.
  - Instalação do Nginx.
  - Início automático do serviço Nginx e configuração para iniciar no boot.

### Outras Melhorias

- **Modularização**: O código foi estruturado para ser facilmente adaptável a novos cenários, com o uso de variáveis que permitem fácil modificação para outros projetos e candidatos.

## Instruções de Uso

### Pré-requisitos

- **Terraform**: Certifique-se de ter o Terraform instalado na máquina. Versão utilizada: `>= 1.9.8`.
- **Chave SSH**: Já deve existir uma chave SSH configurada para acessar a instância EC2.

### Inicializando o Projeto

1. Clone este repositório:
   ```bash
   git clone https://github.com/SeuUsuario/VExpenses.git
   cd VExpenses
2. Edite as variáveis do projeto conforme necessário no arquivo main.tf, especialmente se houver necessidade de personalização.

3. Inicialize o Terraform:
   ```bash
   terraform init

4. Aplique o código para provisionar a infraestrutura:
   ```bash
   terraform apply
   
Quando solicitado, digite yes para confirmar a criação da infraestrutura.

### Verificando a Instalação do Nginx
Após a execução bem-sucedida, o IP público da instância EC2 será exibido na saída do Terraform. Use este IP para acessar o servidor Nginx via navegador, por exemplo:

    ```bash
    http://<ec2_public_ip>
    
### Destruindo a Infraestrutura
Quando quiser remover todos os recursos criados, execute:

    ```bash
    terraform destroy

### Arquivos Incluídos
- main.tf: Arquivo principal contendo o código Terraform para a criação da infraestrutura.
- README.md: Este arquivo, com a documentação completa do projeto e instruções de uso.
### Considerações Finais
Esta implementação segue as melhores práticas para provisionamento de infraestrutura automatizada, utilizando Terraform. Além disso, são garantidos os aspectos de segurança e eficiência, como solicitado no desafio.

![image](https://github.com/user-attachments/assets/e48d38dd-0a12-46a9-b8ce-d543bd104f3d)

