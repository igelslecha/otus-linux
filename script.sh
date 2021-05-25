wipefs -a /dev/sd[b-h]
mdadm --create /dev/md10 --level=10 --raid-devices=4 /dev/sd[b-e]
mdadm --create /dev/md5 --level=5 --raid-devices=3 /dev/sd[f-h]
for i in {1..5} ; do 
	sgdisk -n ${i}:0:+20M /dev/md10 ; 
done
sgdisk -R /dev/md5 /dev/md10
mkdir /etc/mdadm/
touch /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
for i in {1..5} ; do
       	mkfs.ext4 /dev/md5p${i} ; 
	mkdir /raid5p${i} ; 
	mount /dev/md5p${i} /raid5p${i} ; 
	echo '/dev/md5p'${i}' /raid5p'${i}' ext4 defaults 1 2' >> /etc/fstab ; 
done


