# Vial Udev Fix for Linux

Um utilitário simples para corrigir problemas de reconhecimento de teclados compatíveis com Vial no Linux (Ubuntu e derivados).

## Problema

No Linux, alguns teclados com firmware Vial (como o Corne v4) podem não ser reconhecidos pelo Vial GUI, aparecendo como `"foostan"` ou não aparecendo.  
Isso acontece porque o sistema precisa de **permissões udev** para acessar dispositivos HIDRAW.

## Solução

Este script cria automaticamente a regra udev correta para seu teclado, recarrega o udev e permite que o Vial detecte o dispositivo corretamente.

---

## Como usar

1. Clone este repositório:

```bash
git clone https://github.com/SEU_USUARIO/vial-udev-fix.git
cd vial-udev-fix/scripts
```

2. Dê permissão de execução ao script:
```bash
chmod +x setup-vial-udev.sh
```
3. Rode o script:
```bash
./setup-vial-udev.sh
```
⚠️ Pode ser necessário digitar sua senha para sudo, pois o script adiciona regras no /etc/udev/rules.d.

4. Desconecte e reconecte seu teclado. Abra o Vial GUI e veja se o dispositivo foi reconhecido.

Script
O script detecta automaticamente o VendorID e ProductID do teclado conectado e cria a regra udev correspondente:
```bash
#!/bin/bash
# setup-vial-udev.sh
# Script para adicionar regras udev para teclados compatíveis com Vial
# Autor: Erick Ian

echo "🔍 Procurando dispositivo USB conectado..."
DEVICE=$(lsusb | grep -i "foostan\|Corne\|Keyboard")

if [ -z "$DEVICE" ]; then
    echo "❌ Nenhum teclado encontrado! Conecte seu teclado e rode de novo."
    exit 1
fi

VID=$(echo $DEVICE | awk '{print $6}' | cut -d: -f1)
PID=$(echo $DEVICE | awk '{print $6}' | cut -d: -f2)

echo "✅ Teclado detectado: VID=$VID, PID=$PID"

RULE="KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"$VID\", ATTRS{idProduct}==\"$PID\", MODE=\"0660\", GROUP=\"users\", TAG+=\"uaccess\", TAG+=\"udev-acl\""

echo "⚙️ Criando regra em /etc/udev/rules.d/92-vial.rules..."
echo $RULE | sudo tee /etc/udev/rules.d/92-vial.rules > /dev/null

echo "🔄 Recarregando udev..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "🎉 Pronto! Desplugue e plugue seu teclado. Agora o Vial deve reconhecer corretamente."
```

Licença
MIT License – livre para uso, cópia e modificação.

Contribuição
Contribuições são bem-vindas!

Teste o script com outros modelos de teclados Vial.

Abra issues ou pull requests se houver melhorias ou novos ajustes de compatibilidade.
