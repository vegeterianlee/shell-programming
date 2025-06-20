#!/bin/bash

set -e

read -p "작업할 디스크 장치명 (예: sdb): " DISK
DISK_PATH="/dev/$DISK"

if [ ! -b "$DISK_PATH" ]; then
	echo "작업할 디스크 장치명 (예: sdb): " "$DISK_PATH"
	exit 1
fi

read -p "기존 파티션 삭제 및 새 파티션을 생성하시겠습니까? (y/n): " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
	parted -s "$DISK_PATH" mklabel gpt
	parted -s "$DISK_PATH" mkpart primary ext4 0% 100%
	partprobe "$DISK_PATH"
	sleep 2
else
	echo "go to set partition"
fi
	
PARTITION="$DISK_PATH"

read -p "파일 시스템을 생성하시겟습니까? (y/n): " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
	while true; do
		read -p "파일시스템 타입 선택 (1: ext4, 2: xfs): " FS_CHOICE
		case "$FS_CHOICE" in
			1) FS_TYPE="ext4"
				 break ;;
			2) FS_TYPE="xfs"
				break ;;
			*) echo "1,2번 중에 선택해주세요" ;;
		esac
	done
	mkfs."$FS_TYPE" "$PARTITION"
fi

read -p  "마운트할 디렉토리 경로 입력 (예: /mnt/data): " MOUNT_POINT
mkdir -p "$MOUNT_POINT"
mount "$PARTITION" "$MOUNT_POINT"
df -h "$MOUNT_POINT"

UUID=$(blkid -s UUID -o value "$PARTITION")
echo "$UUID $MOUNT_POINT $FS_TYPE defaults 0 2" >> /etc/fstab
echo "THE END"
