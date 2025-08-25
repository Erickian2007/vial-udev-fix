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
