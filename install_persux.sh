#!/bin/bash

# Script de instalação automatizado para o Persux
# Nome: install_persux.sh
# Autor: Alécio Lopes
# Descrição: Instala e configura o Persux com todas as dependências

# Dar permissão de execução ao próprio script
chmod +x "$0"

echo -e "\n\033[1;36m=== INSTALADOR PERSUX ===\033[0m\n"

echo -e "\033[1;34m[1/4] Atualizando o sistema...\033[0m"
apt upgrade -y && apt update -y
if [ $? -eq 0 ]; then
    echo -e "\033[1;32m✔ Sistema atualizado com sucesso!\033[0m"
else
    echo -e "\033[1;31m✖ Falha na atualização do sistema\033[0m"
    exit 1
fi

echo -e "\n\033[1;34m[2/4] Instalando dependências...\033[0m"
pkg install python -y && pkg install git -y
if [ $? -eq 0 ]; then
    echo -e "\033[1;32m✔ Python e Git instalados com sucesso!\033[0m"
else
    echo -e "\033[1;31m✖ Falha na instalação do Python ou Git\033[0m"
    exit 1
fi

echo -e "\n\033[1;34m[3/4] Baixando Persux...\033[0m"
if [ -d "Persux" ]; then
    echo -e "\033[1;33m⚠ Diretório Persux já existe. Atualizando...\033[0m"
    cd Persux
    git pull
    cd ..
else
    git clone https://github.com/Lursy/Persux
fi

if [ $? -eq 0 ]; then
    echo -e "\033[1;32m✔ Persux baixado/atualizado com sucesso!\033[0m"
else
    echo -e "\033[1;31m✖ Falha ao baixar o Persux\033[0m"
    exit 1
fi

cd Persux

# Verifica se o arquivo existe
if [ -f "Persux.py" ]; then
    echo -e "\n\033[1;34m[4/4] Configuração:\033[0m"
    echo -e "Deseja editar o arquivo Persux.py antes de executar?"
    select yn in "Sim" "Não" "Visualizar"; do
        case $yn in
            Sim )
                echo -e "\nEditando Persux.py..."
                if command -v nano &> /dev/null; then
                    nano Persux.py
                elif command -v vim &> /dev/null; then
                    vim Persux.py
                elif command -v vi &> /dev/null; then
                    vi Persux.py
                else
                    echo -e "\033[1;33m⚠ Nenhum editor de texto encontrado. Instale nano/vim/vi primeiro.\033[0m"
                fi
                break;;
            Não )
                break;;
            Visualizar )
                echo -e "\n\033[1;35m=== CONTEÚDO DO ARQUIVO (primeiras 15 linhas) ===\033[0m"
                head -15 Persux.py
                echo -e "\033[1;35m=============================================\033[0m\n"
                ;;
        esac
    done
    
    echo -e "\n\033[1;34mIniciando Persux...\033[0m"
    python Persux.py
else
    echo -e "\033[1;31m✖ Erro: Arquivo Persux.py não encontrado!\033[0m"
    echo -e "Verifique se o repositório foi clonado corretamente."
    exit 1
fi

echo -e "\n\033[1;36m=== INSTALAÇÃO CONCLUÍDA ===\033[0m"
echo -e "Script por: GitHub\n"
