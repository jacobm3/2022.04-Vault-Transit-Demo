# 20k keys, 10k length

m=''
for n in `seq -w 1 10000`; do 
 m=${m}x
done

set -x
for x in `seq -w 1 20000`; do
  vault kv put secret/$x $m=$m 
done
